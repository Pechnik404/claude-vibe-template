# Contributing to claude-vibe-template

Thank you for considering contributing! This project lives or dies on community input.

## Ways to help

### 🐛 Report bugs

Open an issue with:
- Your OS and version (`winver` on Windows)
- Claude Code version (`claude --version`)
- Exact reproduction steps
- Expected vs actual behavior
- If applicable, the full error text (not a screenshot)

### 💡 Suggest features

Open an issue with the `enhancement` label. Describe:
- What you tried
- What you wanted to happen
- Why this would benefit non-IT users specifically

### 📦 Add a profile

The project has 3 profiles (web-app, trading-terminal, gov-44fz-bot). Many domains are missing:
- `profiles/ml-research.md`
- `profiles/education.md`
- `profiles/medical.md`
- `profiles/scientific-computing.md`
- ...

Use existing profiles as template. PR with the new file + README mention.

### 🌍 Localize

- Russian → English translation of `docs/` (PR welcome)
- Other languages — open a discussion first

### 🖥️ Cross-platform

- macOS support: scripts need `.command` equivalents, paths use forward slashes, wizard needs Homebrew detection
- Linux: wizard needs apt/yum/pacman detection
- Both: hooks already use PowerShell — should work on macOS/Linux with `pwsh` installed, but needs testing

### ⚙️ Improve hooks/skills

The current hooks (`preflight_gate`, `git_push_guard`, `journal_append`, `preflight_reminder`) are minimal. Ideas:
- Hook to enforce CHANGELOG.md updates before merging
- Hook to require human approval for irreversible DB migrations
- Skill for automated competitor analysis on new projects

### 📚 Documentation

- More examples in `docs/`
- Video walkthroughs (link from README)
- Architecture diagrams (PR with PNG/SVG)

## Process

1. **Fork** the repository
2. **Branch**: `feat/your-feature`, `fix/issue-N`, `docs/topic`, `profile/domain-name`
3. **Commit** using [Conventional Commits](https://www.conventionalcommits.org/): `feat(profiles): add ml-research profile`
4. **PR** with description following `.github/PR_TEMPLATE.md` (which is inside `project-template/`)
5. We use squash-merge

## Code style

- PowerShell: 4-space indent, comment-based help for non-trivial scripts
- Python (in `.claude/hooks/`, if any): PEP 8, ruff-formatted, type hints
- Markdown: GitHub-flavored, headings hierarchy, line length ~100
- File line endings: managed by `.gitattributes` (don't fight it)

## Testing

Before submitting a PR:
- Run the wizard end-to-end if you changed scripts
- Test the hook on a real test-project if you changed hooks
- Verify any new .ps1 file has UTF-8 BOM and CRLF line endings
- For new profiles, add a one-paragraph "When to choose" section

## Code of Conduct

Be kind. Assume good intent. The goal is to help non-developers use AI — keep critique constructive and accessible.

## License

By contributing, you agree your contributions will be licensed under:
- MIT for code
- CC BY 4.0 for documentation

See [LICENSE](LICENSE) and [LICENSE-docs](LICENSE-docs).
