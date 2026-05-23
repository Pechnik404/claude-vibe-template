# MCP Setup — как подключать коннекторы

> MCP = Model Context Protocol = способ дать AI доступ к внешним сервисам (GitHub, Postgres, Slack, Notion и т.д.).
>
> **В Cowork и Claude Code MCP подключаются по-разному** (вы это сами заметили).

---

## Claude Desktop / Cowork — UI-подключение

### Базовый набор (поставить один раз глобально)

1. Открыть Claude Desktop
2. Слева — `Customize` → `Connectors`
3. Подключить:

| MCP | Зачем | Авторизация |
|---|---|---|
| **GitHub** | Issues, PR, CI, репозитории | OAuth через github.com |
| **Filesystem** | Доступ к выбранным папкам | Авто, через `Cowork → Folders` |
| **Context7** | Актуальная документация библиотек | Без авторизации, бесплатно |
| **Sequential-thinking** | Пошаговое рассуждение | Без авторизации |
| **MCP Registry** | Поиск новых коннекторов | Авто |

### Дополнительные (по типу проекта)

| MCP | Когда подключать | Профиль |
|---|---|---|
| **Postgres** | При наличии БД | все (есть в шаблоне как read-only) |
| **Chrome** | Тестирование UI вашего проекта, скриншоты, парсинг веб-страниц | web-app, gov-44fz-bot |
| **Notion** | Если используете Notion для документации | по желанию |
| **Slack** | Если есть Slack workspace | команда |
| **Linear** | Если задачи в Linear | команда |
| **Datadog** | Production monitoring | trading-terminal |
| **PagerDuty** | On-call alerts | trading-terminal |
| **Atlassian** (Jira/Confluence) | Корпоративная среда | редко |
| **Amplitude / Hex / BigQuery** | Аналитика данных | data-проекты |

---

## ⚠️ Важно: Chrome MCP ≠ Claude Design

Часто путают. Это **разные инструменты для разных задач**.

| | Claude Design | Chrome MCP |
|---|---|---|
| **Что делает** | Генерирует UI-компоненты (HTML/React/CSS) по описанию | Управляет реальным браузером (клики, ввод, скриншоты, чтение страниц) |
| **Когда нужен** | Когда вы ПИШЕТЕ интерфейс | Когда вам нужно ВЗАИМОДЕЙСТВОВАТЬ с уже существующим сайтом |
| **Пример** | «Сделай мне дашборд с графиком» → код | «Зайди на zakupki.gov.ru, найди тендеры по ОКПД 71.12, верни список» |
| **Где живёт** | claude.ai/design + Frontend Design plugin | `@anthropic/chrome-mcp` |
| **Аналог** | Дизайнер, который рисует и пишет CSS | Робот, который умеет пользоваться браузером как человек |

**Они НЕ заменяют друг друга** — могут использоваться в одном проекте:
- Claude Design → генерирует UI вашего нового сайта
- Chrome MCP → потом этот UI тестирует в браузере, делает скриншоты, проверяет что кнопки работают

### Project-level vs Global

- **Global connectors** — видны во ВСЕХ projects
- **Project-level** — только в одном Project (Cowork → Projects → ваш проект → Connectors)

**Рекомендация**: GitHub, Filesystem, Context7 — глобально. Postgres конкретного проекта — project-level.

---

## Claude Code (CLI) — файловое подключение

В Code MCP подключаются через файлы:

### Глобально

`~/.claude/.mcp.json` (Linux/Mac) или `%USERPROFILE%\.claude\.mcp.json` (Windows)

### Per-project

`.mcp.json` в корне репо (наш project-template уже его содержит).

### Через команду

```
claude mcp add <name> <command> [-- args]
```

Пример (вместо ручного редактирования):
```
claude mcp add github -- npx -y @modelcontextprotocol/server-github
```

### Авторизация

OAuth-MCP (GitHub, Slack, Notion) — при первом вызове открывается браузер, проходите OAuth. Токен кешируется локально.

Token-MCP (Postgres, Context7) — переменные окружения из `.env` (см. `.env.example`).

---

## Разница Desktop vs Code — кратко

| Аспект | Cowork | Claude Code |
|---|---|---|
| UI подключения | Да | Нет (только конфиг) |
| OAuth | Встроено в Desktop | Через системный браузер |
| Scope | Global / Project | Global / Per-repo |
| Конфиг | Хранится Desktop | `.mcp.json` |
| Команда подключения | UI кликами | `claude mcp add` |

Это объясняет ваше наблюдение «отличается». Оба механизма используют один и тот же протокол MCP, но способы их «привязки» к среде разные.

---

## Поиск новых MCP

В Cowork — встроенный `mcp__mcp-registry__search_mcp_registry`. Просто: «найди MCP для X».

Внешние реестры:
- modelcontextprotocol.io
- github.com/modelcontextprotocol/servers
- mcp.so
- glama.ai/mcp/servers

При выборе — критерии preflight: звёзды, last commit, актив issues, не слишком новый (< 1 месяц = риск багов).
