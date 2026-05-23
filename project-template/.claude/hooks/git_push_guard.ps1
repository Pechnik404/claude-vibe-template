# Hook: git_push_guard
# Назначение: блокировать опасные git-команды (push в main/master, --force).
# Формат Claude Code 2.x: stdin JSON, блок через stdout JSON.

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$rawInput = [Console]::In.ReadToEnd()
try {
    $data = $rawInput | ConvertFrom-Json
} catch {
    exit 0
}

$cmd = $data.tool_input.command
if ([string]::IsNullOrEmpty($cmd)) { exit 0 }

$denyPatterns = @(
    'git\s+push\s+\S+\s+main(\s|$)',
    'git\s+push\s+\S+\s+master(\s|$)',
    'git\s+push\s+--force',
    'git\s+push\s+-f(\s|$)'
)

foreach ($pat in $denyPatterns) {
    if ($cmd -match $pat) {
        $response = @{
            hookSpecificOutput = @{
                hookEventName = "PreToolUse"
                permissionDecision = "deny"
                permissionDecisionReason = "git_push_guard: запрещено пушить в main/master или с --force. Используйте feature-ветку (feat/*, fix/*, chore/*) и 'gh pr create'. См. CLAUDE.md §3, §8."
            }
        } | ConvertTo-Json -Depth 3 -Compress
        Write-Output $response
        exit 0
    }
}

exit 0
