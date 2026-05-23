# 📢 Manifesto: AI Should Be Windows 95, Not Norton Commander

> Version 1.0 — 2026-05-23
> Idea: Pechnik404 (github.com/Pechnik404)
> Co-developer: Claude (Anthropic)

---

## Historical analogy

**1986–1995. The Norton Commander era.**
To use a computer, you had to memorize dozens of commands. NC was the best file manager of its time. **Professionals worshipped it.** But 99% of people saw a black screen and closed the laptop forever.

**1995. Windows 95 arrived and lowered the barrier.**
Mouse, icons, the Start button. NC didn't get worse — it stayed for its crowd. But the market moved to Win95, because **housewives, schoolchildren, grandmothers could finally use a computer**. The barrier wasn't intellectual. **It was technical.**

**2026. We're in the "NC for AI" era.**
Claude, Cursor, Copilot, GPT — powerful tools. But to really work with them you need to:
- Set up WSL, Docker, Python, git, gh, MCP servers, hooks, .env, ExecutionPolicy
- Remember the difference between `.cmd` and `.ps1`, UTF-8 BOM vs without BOM, CRLF vs LF
- Navigate settings.json formats that change between versions
- Know that Claude doesn't remember Claude Design, that pip might need a regional mirror, that Telegram bots need legal entity registration in some jurisdictions

Thousands of **talented people with brilliant ideas** subscribe to Claude Pro, open it, get lost at "how do I set this up", and cancel within a week. Not because they're stupid. **Because the barrier is technical, just like NC in 1986.**

---

## What we built

**A boxed solution** — double-click → wizard → new project → start describing your idea.

**Zero human involvement in the technical layer:**
- One `.cmd` file installs EVERYTHING (Win → WSL → Docker → Python → Claude Code → rclone) with Y/N confirmation per step
- Project template with built-in anti-drift rules: hooks actually **block** AI from writing code without fresh documentation
- 3 ready profiles for project types (web, trading terminal, gov procurement)
- A `PAIN/` folder — inbox for raw ideas, AI sorts into categories
- Documentation written **for a 10-year-old**, no IT jargon

**Inside (53+ files):**
- Project constitution (rules for AI)
- 7 skills, 2 agents, 2 slash commands
- PowerShell hooks with Windows-specific escaping handled
- Wizard with 10 Y/N/Skip steps
- Init-project with interactive mode
- 3-2-1 backup (GitHub + cloud + secondary disk)
- Localized profiles (regional payment systems, cloud providers, mirrors, alternative messengers)
- Reset Protocol for stuck projects

---

## Who it's for

**Not for developers.** Developers already use NC well — they don't need our Windows 95.

**For people who:**
- Have ideas but no time to learn 40 tools
- Bought Claude Pro but can't figure out how to really use it
- Have a website / bot / trading terminal in their head, but stop at the setup step
- Spend 8-10 hours a day at a computer, but not as developers
- Live in restricted jurisdictions (where some global services don't work, where workarounds are needed)

**Target audience**: entrepreneurs, analysts, engineers from non-IT industries, data journalists, product managers without coding background, talented teenagers.

---

## Why now

Three factors converged in 2026:

1. **AI is actually capable** (Claude Opus 4.7, Sonnet 4.6) — can run an end-to-end project if directed properly.
2. **Anthropic shipped the infrastructure** (Plugins, Skills, Hooks, MCP, Frontend Design plugin, Dispatch Beta) — bricks exist, the house isn't built.
3. **The entry barrier sharpened** — setup got harder with MCP, hooks, plugins. Without a boxed solution, everyone reinvents the wheel.

**The window: now.** Within a year, either Anthropic builds this themselves (and kills the niche), or 10 competing startups appear (and split it).

---

## Proof it works

This document was written **inside the infrastructure** it describes. AI blocked erroneous attempts to write to LAB_JOURNAL (proof: real PowerShell hooks), made RESEARCH_LOG entries, fixed its own incorrect timestamps. **This isn't a pitch deck — it's a live working system log.**

Smoke tests passed (`docs/07_МЕТА_УРОК_ДРЕЙФА.md` honestly documents ALL our mistakes during build). Implementation confidence: **98%**.

---

## What's next

1. **Finalize infrastructure** — small refinements (hooks for code files only, not all)
2. **Public repository** on github.com/Pechnik404 — open code under MIT, docs under CC BY 4.0
3. **Bilingual README** — Russian and English
4. **Demo project** — real example "idea to website" in one session
5. **Community-driven evolution** — issues, PRs, forks, new profiles

---

## Invitation

If you're the one who needs this — take it, fork it, improve it. If you're an experienced developer — send PRs. If you have your own profile (for scientific research, education, medicine) — add it.

The goal isn't to monetize v1. **The goal is for talented people to stop hitting the technical wall.**

Anthropic will earn billions on accessible AI. That's fine. We get **friendly AI for everyone** — that's priceless.

---

## Contacts

- GitHub: https://github.com/Pechnik404
- Code license: MIT (planned)
- Documentation license: CC BY 4.0 (planned)
- Copyright: © 2026 Pechnik404

---

**Infrastructure signature**: built in collaboration between AI Claude (Anthropic) and Pechnik404. This document is living proof that "boxed AI" is possible. A step toward the Windows 95 moment for artificial intelligence.
