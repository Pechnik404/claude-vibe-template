<#
.SYNOPSIS
    Инициализация нового проекта из project-template + выбранного профиля.

.DESCRIPTION
    Копирует project-template/ в новую папку, накатывает изменения профиля,
    заменяет плейсхолдеры на реальные имена, делает git init.

.PARAMETER Name
    Имя нового проекта (kebab-case). Например: pechnik404-site, trade-terminal.

.PARAMETER Profile
    Тип проекта. Допустимые: web-app, trading-terminal, gov-44fz-bot, base (без профиля).

.PARAMETER Target
    Куда создать. По умолчанию C:\HOMEHOMEHOME\<Name>.

.PARAMETER GitHubUser
    Имя пользователя GitHub для remote (опционально).

.EXAMPLE
    pwsh scripts\init-project.ps1 -Name pechnik404-site -Profile web-app
.EXAMPLE
    pwsh scripts\init-project.ps1 -Name trade-bot -Profile trading-terminal -GitHubUser <YOUR_USERNAME>
#>
param(
    [string]$Name = "",
    [ValidateSet("web-app","trading-terminal","gov-44fz-bot","base","")] [string]$Profile = "",
    [string]$Target = "C:\HOMEHOMEHOME",
    [string]$GitHubUser = ""
)

$ErrorActionPreference = "Stop"

# Принудительно UTF-8 для русских символов в любой версии PowerShell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

# ──── Интерактивный режим, если параметры не переданы ────
if ([string]::IsNullOrWhiteSpace($Name)) {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║   Создание нового проекта                  ║" -ForegroundColor Cyan
    Write-Host "║   Сейчас спрошу 2-3 вопроса.               ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    do {
        $Name = Read-Host "Имя проекта (латиницей, через дефис, без пробелов. Пример: my-trading-bot)"
        if ($Name -notmatch "^[a-z0-9-]+$") {
            Write-Host "  ❌ Только маленькие латинские буквы, цифры и дефис. Попробуйте ещё." -ForegroundColor Red
            $Name = ""
        }
    } while ([string]::IsNullOrWhiteSpace($Name))
}

if ([string]::IsNullOrWhiteSpace($Profile)) {
    Write-Host ""
    Write-Host "Выберите тип проекта (профиль):" -ForegroundColor Yellow
    Write-Host "  1) web-app          - сайт или веб-сервис (FastAPI + HTMX + Postgres)"
    Write-Host "  2) trading-terminal - торговый терминал (T-Bank/MOEX + websocket)"
    Write-Host "  3) gov-44fz-bot     - бот мониторинга госзакупок 44-ФЗ"
    Write-Host "  4) base             - голый базовый шаблон без специфики"
    Write-Host ""

    do {
        $choice = Read-Host "Введите 1, 2, 3 или 4"
        switch ($choice) {
            "1" { $Profile = "web-app" }
            "2" { $Profile = "trading-terminal" }
            "3" { $Profile = "gov-44fz-bot" }
            "4" { $Profile = "base" }
            default {
                Write-Host "  ❌ Введите 1, 2, 3 или 4" -ForegroundColor Red
                $Profile = ""
            }
        }
    } while ([string]::IsNullOrWhiteSpace($Profile))
}

if ([string]::IsNullOrWhiteSpace($GitHubUser)) {
    Write-Host ""
    $githubInput = Read-Host "Имя пользователя GitHub (пусто = пропустить создание remote)"
    if (-not [string]::IsNullOrWhiteSpace($githubInput)) {
        $GitHubUser = $githubInput
    }
}

$InfraRoot = Split-Path -Parent $PSScriptRoot
$TemplateDir = Join-Path $InfraRoot "project-template"
$ProfilesDir = Join-Path $InfraRoot "profiles"
$NewProjectPath = Join-Path $Target $Name

Write-Host "=== INIT PROJECT ===" -ForegroundColor Cyan
Write-Host "Name:    $Name"
Write-Host "Profile: $Profile"
Write-Host "Target:  $NewProjectPath"
Write-Host ""

if (Test-Path $NewProjectPath) {
    throw "Папка $NewProjectPath уже существует. Удалите или выберите другое имя."
}

# 1. Копируем шаблон
Write-Host "[1/6] Копирую project-template..." -ForegroundColor Yellow
Copy-Item -Recurse -Path $TemplateDir -Destination $NewProjectPath
Write-Host "      OK"

# 2. Замена плейсхолдеров в pyproject.toml и docker-compose
Write-Host "[2/6] Замена плейсхолдеров..." -ForegroundColor Yellow
$PyProject = Join-Path $NewProjectPath "pyproject.toml"
(Get-Content $PyProject) -replace "PROJECT_NAME_PLACEHOLDER", $Name | Set-Content $PyProject
Write-Host "      pyproject.toml обновлён"

# 3. Применение профиля (только напоминание — реальные изменения делает AI после клона)
if ($Profile -ne "base") {
    $ProfileFile = Join-Path $ProfilesDir "$Profile.md"
    if (Test-Path $ProfileFile) {
        Write-Host "[3/6] Профиль $Profile найден" -ForegroundColor Yellow
        Copy-Item $ProfileFile (Join-Path $NewProjectPath "PROFILE.md")
        Write-Host "      Скопирован в PROFILE.md — AI должен накатить изменения при первом старте"
    } else {
        Write-Warning "Профиль $Profile не найден в $ProfilesDir. Пропускаю."
    }
} else {
    Write-Host "[3/6] Профиль не выбран (base)" -ForegroundColor Yellow
}

# 4. Git init
Write-Host "[4/6] git init..." -ForegroundColor Yellow
Push-Location $NewProjectPath
git init -q
git add .
git commit -q -m "chore: bootstrap from project-template (profile: $Profile)"
git branch -M main
Write-Host "      OK"

# 5. GitHub remote (опционально)
if ($GitHubUser) {
    Write-Host "[5/6] Создание GitHub remote $GitHubUser/$Name..." -ForegroundColor Yellow
    $hasGh = $null -ne (Get-Command gh -ErrorAction SilentlyContinue)
    if ($hasGh) {
        gh repo create "$GitHubUser/$Name" --private --source=. --remote=origin --push
        Write-Host "      Remote создан, push выполнен"
    } else {
        Write-Warning "gh не установлен. Создайте репо вручную: gh repo create $GitHubUser/$Name --private --source=. --push"
    }
} else {
    Write-Host "[5/6] GitHub remote не запрошен (не передан -GitHubUser)" -ForegroundColor Yellow
}

Pop-Location

# 6. Следующие шаги
Write-Host "[6/6] ГОТОВО" -ForegroundColor Green
Write-Host ""
Write-Host "=== СЛЕДУЮЩИЕ ШАГИ ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Скопировать .env.example в .env и заполнить:"
Write-Host "   cd $NewProjectPath"
Write-Host "   copy .env.example .env"
Write-Host ""
Write-Host "2. Поднять Postgres через docker compose:"
Write-Host "   docker compose up -d"
Write-Host ""
Write-Host "3. Установить зависимости (в WSL2 или venv):"
Write-Host "   pip install -e `".[dev]`""
Write-Host ""
Write-Host "4. Открыть в Claude Code:"
Write-Host "   claude $NewProjectPath"
Write-Host ""
Write-Host "5. В Claude Code сказать:"
Write-Host "   'Прочитай CLAUDE.md и PROFILE.md, накати изменения профиля.'"
Write-Host ""
Write-Host "Удачи." -ForegroundColor Green
