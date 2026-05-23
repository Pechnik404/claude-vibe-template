# 🚀 claude-vibe-template

> **Boxed AI development infrastructure for non-developers.**
> Talented people with ideas should stop hitting the technical wall.

[Русская версия →](README.ru.md) · [📢 Manifesto](MANIFESTO_EN.md) · [Manifesto (RU)](MANIFESTO_RU.md)

---

## The 30-second pitch

If you've ever:
- Bought Claude Pro / Cursor / Copilot, opened it, and got lost at "how do I set this up"
- Have a brilliant idea for a website / bot / trading terminal but can't get past the configuration
- Watched AI write code that drifts from reality because it skipped reading current documentation

This repository is for you.

**What it gives you:**
- One double-click installs all required tools (WSL, Docker, Python, git, Claude Code) with Y/N confirmation per step
- Project template with built-in **anti-drift hooks** that physically block AI from writing code without fresh documentation research
- 3 ready-to-use profiles (web app, trading terminal, government data bot)
- Documentation written for a 10-year-old, no jargon
- All Windows quirks handled (UTF-8 BOM, CRLF, `.cmd` vs `.ps1`, ExecutionPolicy)

**What it doesn't do:**
- Write your business idea for you
- Pretend to replace human judgment on architecture, security, or product decisions
- Make you a developer (it makes the developer step optional)

---

## Quick start (5 minutes)

### Step 1. Get this repo

```bash
git clone https://github.com/<YOUR_USERNAME>/claude-vibe-template.git
cd claude-vibe-template
```

### Step 2. Run the wizard

**Double-click** on `scripts/setup-wizard.cmd` (on Windows).

The wizard walks through 10 steps, asks Y/N/Skip for each, explains WHAT and WHY. Already-installed tools are auto-skipped.

### Step 3. Create your first project

**Double-click** on `scripts/init-project.cmd`.

It asks 3 questions:
- Project name (e.g. `my-first-bot`)
- Profile (web-app / trading-terminal / gov-44fz-bot / base)
- GitHub username (optional, for auto-remote)

You get `C:\HOMEHOMEHOME\<your-name>\` with full template, git initialized, ready to open in Claude Code.

### Step 4. Open and start

```bash
cd C:\HOMEHOMEHOME\<your-name>
claude .
```

Tell Claude your idea. The hooks will ensure it does research before coding. Pull requests get created for your review — you click Merge.

---

## What's inside

```
claude-vibe-template/
├── 📦 project-template/         Bootstrap for every new project
│   ├── CLAUDE.md                Constitution / rules for AI
│   ├── .claude/                 Skills, agents, hooks, slash-commands
│   ├── .mcp.json                MCP server configurations
│   ├── docker-compose.yml       Postgres + app
│   ├── pyproject.toml           Python dependencies + tooling
│   └── .github/workflows/ci.yml CI pipeline
│
├── 🎯 profiles/                 Type-specific overlays
│   ├── web-app.md
│   ├── trading-terminal.md
│   └── gov-44fz-bot.md
│
├── ⚙️ cowork-config/            Claude Desktop configuration
│   ├── customize-global.md
│   ├── scheduled-tasks.md
│   ├── mcp-setup.md
│   └── notifications-setup-ntfy.md
│
├── 📚 docs/                     Russian-language guides for non-IT users
│   ├── 00_БЫСТРЫЙ_СТАРТ.md
│   ├── 02_PREFLIGHT_ГЛАВНОЕ.md  ← the core idea, MUST READ
│   ├── 06_КАК_ДЛЯ_РЕБЁНКА.md    ← explanations as if to a 10-year-old
│   └── 07_МЕТА_УРОК_ДРЕЙФА.md   ← honest log of our own mistakes
│
├── 🔧 scripts/
│   ├── setup-wizard.cmd         ← Windows-friendly entry point
│   ├── init-project.cmd
│   └── backup-321.cmd
│
├── 📢 MANIFESTO_EN.md           Why this project exists
└── 📢 MANIFESTO_RU.md
```

---

## The core idea: anti-drift hooks

The killer feature isn't the wizard — it's the hooks.

When AI tries to write a code file >50 lines without fresh research, a PowerShell hook returns:
```json
{"hookSpecificOutput": {
  "permissionDecision": "deny",
  "permissionDecisionReason": "preflight_gate: attempted to create/edit a code file > 50 lines without a recent entry in RESEARCH_LOG.md (last 60 min). Run skill 'preflight-research' or /preflight."
}}
```

Claude Code blocks the Write tool. The AI then has two paths:
1. Run real research (WebSearch + Context7 docs lookup) and record findings in RESEARCH_LOG.md
2. Argue with the user

Both paths are better than silent drift.

**Read [docs/02_PREFLIGHT_ГЛАВНОЕ.md](docs/02_PREFLIGHT_ГЛАВНОЕ.md) (in Russian) for the full philosophy.**

---

## 🌟 Join us — make AI friendlier for everyone

This project lives or dies on community input. If you:

- 💢 **Have a pain point** with Claude / Cursor / Copilot that should be solved → [open an issue](https://github.com/Pechnik404/claude-vibe-template/issues/new/choose)
- 🛠 **Have a working solution / profile / skill** that helps non-developers → send a PR
- 📖 **Have a story** of how the technical wall stopped you → share in Discussions
- ❤️ **Just resonate with the idea** → star the repo, that's the signal we matter
- 🌍 **Want to translate** docs to your language → PRs especially welcome

**No experience required.** The whole point of this project is that **you shouldn't need to be a developer** to help build it. Issues in plain English (or any language) are welcome — AI can translate.

**Let's make the world a little better — and a little friendlier — for everyone with ideas.**

---

## Compatibility

| Platform | Status |
|---|---|
| Windows 10/11 (1903+) | ✅ Primary target, fully tested |
| macOS | ⏳ Scripts need `.command` equivalents (PRs welcome) |
| Linux | ⏳ Most things work, wizard needs adaptation (PRs welcome) |

**Claude Code version**: tested on 2.1.150. Format may change in future Claude Code releases — see CHANGELOG.

---

## Project status

- Version: **v0.1.0** (initial public release)
- Smoke-tested end-to-end on Windows 11 25H2
- Hooks proven working (preflight_gate, git_push_guard, journal_append)
- Russian-language regional adaptations included (mirrors, payment systems, alternative messengers)

This is **early-stage software**. Expect rough edges. PRs welcome.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

Quick guide:
- Bug? Open an issue with reproduction steps
- New profile (e.g. for ML research, education, medicine)? Open a PR with `profiles/<your-domain>.md`
- macOS / Linux support? PRs especially welcome
- Translation of docs/ to English? PRs welcome
- Improvement to hooks or skills? PR with explanation

---

## License

- **Code** (scripts, hooks, configs): [MIT](LICENSE)
- **Documentation** (.md files): [CC BY 4.0](LICENSE-docs)

Copyright © 2026 [Pechnik404](https://github.com/Pechnik404)

---

## Acknowledgements

- **Anthropic** for building Claude, Claude Code, MCP, Skills, Plugins — the building blocks this project assembles
- **Inspired by** the historical moment when Windows 95 made personal computing accessible to billions
- **Co-developed** with Claude itself in a series of Cowork sessions (with all the mistakes honestly logged in `docs/07_МЕТА_УРОК_ДРЕЙФА.md`)
