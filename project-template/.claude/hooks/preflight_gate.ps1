# Hook: preflight_gate
# Назначение: блокировать Write/Edit > 50 строк без свежей записи в RESEARCH_LOG.md.
# Защита от дрейфа (CLAUDE.md §1). Формат Claude Code 2.x: stdin JSON, блок через stdout JSON.

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Читаем stdin как JSON
$rawInput = [Console]::In.ReadToEnd()
try {
    $data = $rawInput | ConvertFrom-Json
} catch {
    exit 0  # битый JSON — не блокируем, дадим Claude работать
}

# Контент: для Write — content, для Edit — new_string
$content = ""
if ($data.tool_name -eq "Write") {
    $content = $data.tool_input.content
} elseif ($data.tool_name -eq "Edit") {
    $content = $data.tool_input.new_string
} else {
    exit 0
}

if ([string]::IsNullOrEmpty($content)) { exit 0 }

# Проверка расширения файла — блокируем ТОЛЬКО код-файлы
# Текст / markdown / конфиги / данные — не требуют preflight (research не нужен)
$filePath = $data.tool_input.file_path
if ([string]::IsNullOrEmpty($filePath)) { exit 0 }

$codeExtensions = @(
    '.py', '.js', '.ts', '.jsx', '.tsx', '.mjs',
    '.go', '.rs', '.java', '.kt', '.scala',
    '.cpp', '.c', '.h', '.hpp', '.cs',
    '.rb', '.php', '.swift', '.m',
    '.sh', '.bash', '.ps1', '.psm1',
    '.sql', '.graphql', '.proto'
)

$ext = [System.IO.Path]::GetExtension($filePath).ToLower()
$isCode = $codeExtensions -contains $ext

# Не код — пропускаем независимо от размера
if (-not $isCode) { exit 0 }

$lineCount = ($content -split "`n").Count

# Код, но меньше порога — разрешаем
if ($lineCount -le 50) { exit 0 }

# Ищем свежую запись в RESEARCH_LOG.md (за 60 минут)
$researchLog = Join-Path $env:CLAUDE_PROJECT_DIR "RESEARCH_LOG.md"
$hasRecent = $false

if (Test-Path $researchLog) {
    $text = Get-Content $researchLog -Raw -Encoding UTF8
    $matches = [regex]::Matches($text, '\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2})\]')
    if ($matches.Count -gt 0) {
        $lastStr = $matches[$matches.Count - 1].Groups[1].Value
  