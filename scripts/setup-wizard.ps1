<#
.SYNOPSIS
    Мастер первоначальной настройки компьютера для работы с инфраструктурой.
    Идёт шагами, на каждом спрашивает Y/N/Skip, объясняет ЗАЧЕМ.

.DESCRIPTION
    Подходит для НЕ-ИТ пользователей. Каждый шаг:
    1. Что устанавливаем (простыми словами)
    2. Зачем нужно
    3. Сколько времени займёт
    4. Будет ли что-то меняться в системе
    Только после Y запускается установка.

.EXAMPLE
    pwsh setup-wizard.ps1
#>

$ErrorActionPreference = "Continue"

# Принудительно UTF-8 для русских символов в любой версии PowerShell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

function Show-Banner {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║   SETUP WIZARD — настройка ПК для работы с AI    ║" -ForegroundColor Cyan
    Write-Host "║   Идём по шагам. На каждом — Y/N/Skip.           ║" -ForegroundColor Cyan
    Write-Host "║   Вы НИЧЕГО не сломаете — каждый шаг с согласия. ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Ask-Step {
    param(
        [string]$Title,
        [string]$Why,
        [string]$Time,
        [string]$Changes,
        [scriptblock]$Action,
        [scriptblock]$Check
    )

    Write-Host "─────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "📦 $Title" -ForegroundColor Yellow

    # Если уже установлено — пропустить
    if ($Check) {
        $alreadyOK = & $Check
        if ($alreadyOK) {
            Write-Host "   ✅ Уже установлено — пропускаю." -ForegroundColor Green
            Write-Host ""
            return "skip"
        }
    }

    Write-Host ""
    Write-Host "Зачем:    $Why"
    Write-Host "Время:    $Time"
    Write-Host "Изменит:  $Changes"
    Write-Host ""
    $ans = Read-Host "Установить? [Y]es / [N]o (выйти) / [S]kip (пропустить)"
    Write-Host ""

    switch ($ans.ToLower()) {
        "y" {
            try {
                & $Action
                Write-Host "✅ Готово." -ForegroundColor Green
            } catch {
                Write-Host "❌ Ошибка: $_" -ForegroundColor Red
                Write-Host "Можно попробовать вручную, инструкция выше."
            }
        }
        "n" {
            Write-Host "Выхожу. Запустите wizard позже когда будете готовы."
            exit 0
        }
        default {
            Write-Host "Пропустил. Можно вернуться позже."
        }
    }
    Write-Host ""
}

Show-Banner

# ───── Шаг 1. winget ─────
Ask-Step `
    -Title "Шаг 1/10: проверить winget (магазин программ для Windows)" `
    -Why "winget — это как магазин приложений Microsoft. С его помощью одной командой ставится всё остальное." `
    -Time "5 секунд (просто проверка)" `
    -Changes "Ничего не меняет. Только проверяет наличие." `
    -Check { $null -ne (Get-Command winget -ErrorAction SilentlyContinue) } `
    -Action {
        throw "winget не найден. Откройте Microsoft Store, установите 'App Installer'. Потом запустите wizard заново."
    }

# ───── Шаг 2. PowerShell 7 ─────
Ask-Step `
    -Title "Шаг 2/10: PowerShell 7 (современная командная строка)" `
    -Why "Windows встроенный PowerShell 5 устарел. Семёрка нужна для всех скриптов инфраструктуры." `
    -Time "~2 минуты" `
    -Changes "Добавит pwsh в Пуск. Старый PowerShell тоже останется." `
    -Check { $null -ne (Get-Command pwsh -ErrorAction SilentlyContinue) } `
    -Action {
        winget install --id Microsoft.PowerShell -e --accept-source-agreements --accept-package-agreements
    }

# ───── Шаг 3. Git ─────
Ask-Step `
    -Title "Шаг 3/10: Git (история ваших файлов)" `
    -Why "Git — машина времени для проектов. Каждое изменение сохраняется, можно откатиться." `
    -Time "~2 минуты" `
    -Changes "Добавит команду git в командную строку." `
    -Check { $null -ne (Get-Command git -ErrorAction SilentlyContinue) } `
    -Action {
        winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements
    }

# ───── Шаг 4. GitHub CLI ─────
Ask-Step `
    -Title "Шаг 4/10: GitHub CLI (gh) — управление GitHub из терминала" `
    -Why "Чтобы AI мог автоматически создавать pull-request'ы (PR — это запрос на проверку изменений)." `
    -Time "~2 минуты" `
    -Changes "Добавит команду gh." `
    -Check { $null -ne (Get-Command gh -ErrorAction SilentlyContinue) } `
    -Action {
        winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements
        Write-Host "После установки запустите 'gh auth login' для авторизации." -ForegroundColor Yellow
    }

# ───── Шаг 5. WSL2 ─────
Ask-Step `
    -Title "Шаг 5/10: WSL2 (Linux внутри Windows)" `
    -Why "Python и Docker работают лучше под Linux. WSL2 даёт настоящий Linux в окошке Windows, без виртуалки." `
    -Time "~10 минут (одна перезагрузка возможна)" `
    -Changes "Включит компонент Windows. Скачает Ubuntu 22.04. Возможен перезапуск." `
    -Check {
        try {
            $wsl = wsl --status 2>&1
            return $LASTEXITCODE -eq 0
        } catch { return $false }
    } `
    -Action {
        Write-Host "Запускаю установку WSL2 + Ubuntu... (нужны права администратора)" -ForegroundColor Yellow
        Start-Process pwsh -Verb RunAs -Wait -ArgumentList "-Command", "wsl --install -d Ubuntu-22.04"
        Write-Host "Возможно потребуется перезагрузка." -ForegroundColor Yellow
    }

# ───── Шаг 6. Docker Desktop ─────
Ask-Step `
    -Title "Шаг 6/10: Docker Desktop (контейнеры — изолированные программы)" `
    -Why "Контейнер — это как герметичная коробочка с программой и всем нужным внутри. База данных, веб-сервер — каждый в своей коробке." `
    -Time "~10 минут (скачивание ~600 МБ)" `
    -Changes "Поставит Docker Desktop. Иконка китика в трее. Включит интеграцию с WSL2." `
    -Check { $null -ne (Get-Command docker -ErrorAction SilentlyContinue) } `
    -Action {
        winget install --id Docker.DockerDesktop -e --accept-source-agreements --accept-package-agreements
        Write-Host "После установки запустите Docker Desktop из меню Пуск." -ForegroundColor Yellow
    }

# ───── Шаг 7. VS Code ─────
Ask-Step `
    -Title "Шаг 7/10: Visual Studio Code (редактор кода)" `
    -Why "Современный редактор от Microsoft. Чтобы открывать и читать файлы проекта, видеть подсветку синтаксиса." `
    -Time "~2 минуты" `
    -Changes "Установит VS Code. Не обязателен — можно работать через Claude Code в терминале." `
    -Check { $null -ne (Get-Command code -ErrorAction SilentlyContinue) } `
    -Action {
        winget install --id Microsoft.VisualStudioCode -e --accept-source-agreements --accept-package-agreements
    }

# ───── Шаг 8. Python в WSL ─────
Ask-Step `
    -Title "Шаг 8/10: Python 3.12 внутри WSL Ubuntu" `
    -Why "Сам язык программирования. 3.12 — самая совместимая версия на сегодня (T-Bank SDK не работает с 3.14)." `
    -Time "~3 минуты" `
    -Changes "Установит python3.12 в Ubuntu (внутри WSL). Не влияет на Windows-Python." `
    -Check {
        try {
            $v = wsl -e python3.12 --version 2>&1
            return $LASTEXITCODE -eq 0
        } catch { return $false }
    } `
    -Action {
        wsl -e bash -c "sudo apt-get update && sudo apt-get install -y python3.12 python3.12-venv python3-pip"
    }

# ───── Шаг 9. Claude Code ─────
Ask-Step `
    -Title "Шаг 9/10: Claude Code (CLI-помощник)" `
    -Why "Командная строка для AI-помощника. Запускается в папке проекта, делает работу." `
    -Time "~1 минута" `
    -Changes "Установит npm-пакет глобально." `
    -Check { $null -ne (Get-Command claude -ErrorAction SilentlyContinue) } `
    -Action {
        $hasNode = $null -ne (Get-Command node -ErrorAction SilentlyContinue)
        if (-not $hasNode) {
            Write-Host "Сначала ставлю Node.js (нужен для npm)..." -ForegroundColor Yellow
            winget install --id OpenJS.NodeJS.LTS -e --accept-source-agreements --accept-package-agreements
        }
        npm install -g @anthropic-ai/claude-code
    }

# ───── Шаг 10. rclone (для бэкапов) ─────
Ask-Step `
    -Title "Шаг 10/10: rclone (для бэкапов в облако)" `
    -Why "Для копирования файлов в Яндекс.Диск / Selectel / любое S3. Нужно для backup-321.ps1." `
    -Time "~1 минута" `
    -Changes "Установит rclone. После установки запустите 'rclone config' для подключения вашего облака." `
    -Check { $null -ne (Get-Command rclone -ErrorAction SilentlyContinue) } `
    -Action {
        winget install --id Rclone.Rclone -e --accept-source-agreements --accept-package-agreements
        Write-Host "После установки запустите 'rclone config' и следуйте мастеру для подключения облака." -ForegroundColor Yellow
    }

# ───── Финал ─────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ГОТОВО                                          ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Следующие шаги:" -ForegroundColor Cyan
Write-Host "  1. Перезагрузите ПК, если устанавливали WSL"
Write-Host "  2. Запустите Docker Desktop — иконка китика должна стать зелёной"
Write-Host "  3. В терминале: gh auth login → войдите в GitHub"
Write-Host "  4. Создайте первый проект — ДВОЙНОЙ КЛИК на:"
Write-Host "     C:\HOMEHOMEHOME\ClaudeCombine\ИНФРАСТРУКТУРА\scripts\init-project.cmd"
Write-Host "     (он спросит имя и тип проекта, отвечайте по подсказкам)"
Write-Host ""
Write-Host "Если что-то не получилось — гляньте docs/05_FAQ.md или нап