# Hook: journal_append
# Назначение: запись в LAB_JOURNAL.md о действии AI.
# PostToolUse (с аргументом "edit") + Stop (с аргументом "stop").

param([string]$EventType = "unknown")

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$rawInput = [Console]::In.ReadToEnd()
$data = $null
try {
    $data = $rawInput | ConvertFrom-Json
} catch {}

$labJournal = Join-Path $env:CLAUDE_PROJECT_DIR "LAB_JOURNAL.md"

if (-not (Test-Path $labJournal)) {
    @"
# LAB_JOURNAL

| Дата/Время | Событие | Файлы | Результат | Confidence |
|---|---|---|---|---|
"@ | Out-File -FilePath $labJournal -Encoding utf8
}

$ts = Get-Date -Format "yyyy-MM-dd HH:mm"

if ($EventType -eq "edit") {
    $filePath = "—"
    if ($data -and $data.tool_input -and $data.tool_input.file_path) {
        $filePath = $data.tool_input.file_path
    }
    $row = "| $ts | Edit/Write | $filePath | OK | — |"
} elseif ($EventType -eq "stop") {
    $row = "| $ts | Stop (конец цепочки) | — | OK | — |"
} else {
    $row = "| $ts | $EventType | — | — | — |"
}

Add-Content -Path $labJournal -Value $row -Encoding utf8
exit 0
