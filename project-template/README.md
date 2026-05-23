# Шаблон проекта (project-template)

Базовый Python-проект с встроенной AI-инфраструктурой против дрейфа.

## Что внутри

- **`CLAUDE.md`** — конституция (System Prompt для AI). Версия 1.0.
- **`.claude/`** — skills, agents, slash-commands, hooks (`settings.json`)
- **`.mcp.json`** — MCP-серверы (Context7, GitHub, Postgres, Filesystem, Sequential-thinking)
- **`docker-compose.yml`** — FastAPI + Postgres + (опц.) Redis
- **`pyproject.toml`** — ruff + mypy + pytest + coverage
- **`.env.example`** — шаблон секретов (копировать в `.env`, в git не идёт)
- **`.github/workflows/ci.yml`** — статика + тесты на каждый PR
- **`RESEARCH_LOG.md`** — журнал preflight-проверок (главное против дрейфа)
- **`LAB_JOURNAL.md`** — журнал действий AI
- **`DECISIONS.md`** — архитектурные решения (ADR-стиль)
- **`TODO.md`** — задачи (если не GitHub Issues)

## Как создать новый проект

```
pwsh scripts/init-project.ps1 -Name my-new-app -Profile web-app
```

Параметр `-Profile`:
- `web-app` — FastAPI + HTMX + Postgres
- `trading-terminal` — добавляет MOEX/Tinkoff Invest SDK, websocket, очереди
- `gov-44fz-bot` — добавляет zakupki.gov.ru парсер, ntfy.sh уведомления

Без параметра — базовый шаблон.

## Первый запуск (после init)

1. Скопировать `.env.example` → `.env`, заполнить
2. `docker compose up -d` — поднимает Postgres
3. `pip install -e ".[dev]"` — зависимости
4. `pytest` — проверка что всё работает
5. Открыть в Claude Code: `claude .`

## Главное правило (читай CLAUDE.md §1)

**Никакого кода без preflight-research.** Это не уговор — это hook, который блокирует Write/Edit без свежей записи в `RESEARCH_LOG.md`.

Причина — в `docs/02_PREFLIGHT_ГЛАВНОЕ.md`.
