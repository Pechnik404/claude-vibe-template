# Hook: preflight_reminder
# Назначение: мягкое напоминание про preflight на новых задачах.
# UserPromptSubmit, никогда не блокирует.

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$rawInput = [Console]::In.ReadToEnd()
try {
    $data = $rawInput | ConvertFrom-Json
} catch {
    exit 0
}

$prompt = ""
if ($data.prompt) { $prompt = $data.prompt.ToString().ToLower() }

if ([string]::IsNullOrEmpty($prompt)) { exit 0 }

$keywords = @(
    "новая задача",
    "давай сделаем",
    "хочу реализовать",
    "новый проект",
    "новая идея",
    "new task",
    "let's build",
    "implement",
    "build a",
    "create a"
)

foreach ($kw in $keywords) {
    if ($prompt -match [regex]::Escape($kw)) {
        [Console]::Error.WriteLine("preflight_reminder: похоже на новую задачу. Запустите skill 'preflight-research' до написания кода.")
        break
    }
}

exit 0
