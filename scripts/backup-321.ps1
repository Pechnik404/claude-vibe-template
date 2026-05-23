<#
.SYNOPSIS
    Бэкап по правилу 3-2-1: 3 копии, 2 разных носителя, 1 вне дома.

.DESCRIPTION
    Копия 1: код в GitHub (через git push --all для всех репозиториев в SourceDir)
    Копия 2: архив в облачное хранилище (через rclone — нужна предварительная настройка)
    Копия 3: локальный архив на втором ПК (через SMB-шару или внешний диск)

    Запускать вручную или через scheduled-task раз в неделю.

.PARAMETER SourceDir
    Папка с проектами. По умолчанию C:\HOMEHOMEHOME.

.PARAMETER ArchiveDir
    Куда складывать локальный архив. По умолчанию D:\Backups (на втором диске).

.PARAMETER RcloneRemote
    Имя rclone remote для облака (например, "selectel:backups", "yadisk:backups").
    Если не задано — облачная копия пропускается.

.PARAMETER NtfyUrl
    URL ntfy-топика для уведомления о результате (опционально).

.EXAMPLE
    pwsh scripts\backup-321.ps1
.EXAMPLE
    pwsh scripts\backup-321.ps1 -RcloneRemote "yadisk:backups" -NtfyUrl "https://ntfy.sh/my-topic"
#>
param(
    [string]$SourceDir = "C:\HOMEHOMEHOME",
    [string]$ArchiveDir = "D:\Backups",
    [string]$RcloneRemote = "",
    [string]$NtfyUrl = ""
)

$ErrorActionPreference = "Continue"

# Принудительно UTF-8 для русских символов в любой версии PowerShell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

$Timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$ArchiveName = "homehomehome_$Timestamp.zip"
$ArchivePath = Join-Path $ArchiveDir $ArchiveName

$Errors = @()

function Send-Ntfy {
    param([string]$Message, [string]$Priority = "default")
    if ($NtfyUrl) {
        try {
            Invoke-RestMethod -Method Post -Uri $NtfyUrl -Body $Message -Headers @{ "Priority" = $Priority } | Out-Null
        } catch {
            Write-Warning "Не удалось отправить ntfy: $_"
        }
    }
}

Write-Host "=== BACKUP 3-2-1 ===" -ForegroundColor Cyan
Write-Host "Источник: $SourceDir"
Write-Host "Архив:    $ArchivePath"
Write-Host ""

# === Копия 1: git push --all по всем репозиториям ===
Write-Host "[1/3] Git push --all по всем репозиториям..." -ForegroundColor Yellow
$repos = Get-ChildItem -Path $SourceDir -Directory | Where-Object { Test-Path (Join-Path $_.FullName ".git") }
foreach ($repo in $repos) {
    Push-Location $repo.FullName
    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) {
            git push --all origin 2>&1 | Out-Null
            git push --tags origin 2>&1 | Out-Null
            Write-Host "      ✓ $($repo.Name) (branch: $branch)"
        }
    } catch {
        $Errors += "git push failed for $($repo.Name): $_"
    }
    Pop-Location
}

# === Копия 2: rclone в облако (если remote задан) ===
if ($RcloneRemote) {
    Write-Host "[2/3] rclone copy в $RcloneRemote..." -ForegroundColor Yellow
    $rcloneExists = $null -ne (Get-Command rclone -ErrorAction SilentlyContinue)
    if ($rcloneExists) {
        try {
            rclone copy $SourceDir $RcloneRemote --exclude "**/node_modules/**" --exclude "**/__pycache__/**" --exclude "**/.venv/**" --exclude "**/.env" --transfers 4 --checkers 8
            Write-Host "      ✓ rclone завершён"
        } catch {
            $Errors += "rclone failed: $_"
        }
    } else {
        $Errors += "rclone не установлен — пропускаю облачную копию"
        Write-Warning "rclone не установлен"
    }
} else {
    Write-Host "[2/3] Облачная копия пропущена (не задан -RcloneRemote)" -ForegroundColor Yellow
}

# === Копия 3: локальный zip-архив ===
Write-Host "[3/3] Локальный zip-архив..." -ForegroundColor Yellow
if (-not (Test-Path $ArchiveDir)) {
    New-Item -ItemType Directory -Path $ArchiveDir -Force | Out-Null
}
try {
    Compress-Archive -Path "$SourceDir\*" -DestinationPath $ArchivePath -CompressionLevel Optimal -Force
    $Size = (Get-Item $ArchivePath).Length / 1MB
    Write-Host ("      ✓ {0} ({1:N1} MB)" -f $ArchivePath, $Size)
} catch {
    $Errors += "Compress-Archive failed: $_"
}

# === Ротация старых архивов (оставляем последние 4 еженедельных) ===
Write-Host "[+] Ротация — оставляю 4 последних архива..." -ForegroundColor Yellow
$oldArchives = Get-ChildItem -Path $ArchiveDir -Filter "homehomehome_*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -Skip 4
foreach ($old in $oldArchives) {
    Remove-Item $old.FullName
    Write-Host "      удалён старый: $($old.Name)"
}

# === Итог ===
Write-Host ""
if ($Errors.Count -eq 0) {
    Write-Host "=== УСПЕХ ===" -ForegroundColor Green
    Send-Ntfy "✅ Backup 3-2-1 успешен: $ArchiveName" "default"
    exit 0
} else {
    Write-Host "=== С ОШИБКАМИ ===" -ForegroundColor Red
    $Errors | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    Send-Ntfy ("⚠️ Backup 3-2-1 с ошибками ({0} шт): см. лог" -f $Errors.Count) "high"
    exit 1
}
