# Changelog

All notable changes to this project will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
versioning follows [Semantic Versioning](https://semver.org/).

## [0.1.0] — 2026-05-23

### Initial public release

#### Added
- **project-template/** — bootstrap for new Python+FastAPI+Postgres projects
  - `CLAUDE.md` constitution (14 sections + meta-rules)
  - 7 skills (preflight-research, escalating-test-pyramid, ritual-git, report12-ru, reset-protocol, environment-precheck, sort-pain)
  - 2 agents (git-gatekeeper, code-reviewer-ru)
  - 2 slash-commands (/ship, /security-pass)
  - 4 hooks in PowerShell (preflight_gate, git_push_guard, journal_append, preflight_reminder)
  - `.mcp.json` with Context7, GitHub, Postgres, Filesystem, Sequential-thinking, Chrome (optional)
  - Docker compose + pyproject.toml + .github/workflows/ci.yml + .gitattributes
  - Empty templates: RESEARCH_LOG.md, LAB_JOURNAL.md, DECISIONS.md, TODO.md

- **profiles/** — 3 type-specific overlays
  - `web-app.md` (FastAPI + HTMX + Postgres)
  - `trading-terminal.md` (T-Invest/MOEX + websocket + risk management)
  - `gov-44fz-bot.md` (zakupki.gov.ru parser + ntfy.sh alerts)

- **cowork-config/** — Claude Desktop setup
  - `customize-global.md` (user-level Custom Instructions)
  - `scheduled-tasks.md` (6 recommended cron tasks)
  - `mcp-setup.md` (with explanation Chrome MCP ≠ Claude Design)
  - `notifications-setup-ntfy.md` (5-min setup guide for non-IT)

- **docs/** — Russian-language guides
  - `00_БЫСТРЫЙ_СТАРТ.md` (IKEA-style quick start)
  - `01_РОЛИ_РЕЖИМОВ.md` (Chat / Cowork / Code roles)
  - `02_PREFLIGHT_ГЛАВНОЕ.md` (the core anti-drift philosophy)
  - `03_ПРОТОКОЛ_АДАПТАЦИИ.md` (how to adapt template per project)
  - `04_RESET_PROTOCOL.md` (for stuck legacy projects)
  - `05_FAQ.md` (common issues including Windows-specific)
  - `06_КАК_ДЛЯ_РЕБЁНКА.md` (10-year-old level explanations)
  - `07_МЕТА_УРОК_ДРЕЙФА.md` (honest log of mistakes during build)

- **scripts/** — Windows-friendly entry points
  - `setup-wizard.cmd` + `.ps1` (10-step interactive install with Y/N/Skip)
  - `init-project.cmd` + `.ps1` (interactive new project creation)
  - `backup-321.cmd` + `.ps1` (3-2-1 backup rule)

- **Top-level**
  - `MANIFESTO_EN.md` + `MANIFESTO_RU.md` (the why)
  - `README.md` + `README.ru.md`
  - `CONTRIBUTING.md`
  - `LICENSE` (MIT for code)
  - `LICENSE-docs` (CC BY 4.0 for documentation)

### Tested on
- Windows 11 Pro 25H2 (build 26200.8457)
- Claude Code 2.1.150
- PowerShell 7.x
- Docker Desktop with WSL2 backend
- Hooks confirmed working end-to-end

### Known limitations
- Windows-first. macOS/Linux support is incomplete (community PRs welcome).
- Hooks format tied to Claude Code 2.1.x schema. Future versions may require updates.
- Some MCP servers (Chrome MCP) require external installation steps not yet automated.
- БОЛЬ/ folder (raw idea inbox) was removed from public template — was personal-only feature in original infrastructure.

### Acknowledgements
- Built collaboratively with Claude (Anthropic) in a series of Cowork sessions
- All mistakes during build documented honestly in `docs/07_МЕТА_УРОК_ДРЕЙФА.md` as living proof the infrastructure self-audits
