# 🚀 claude-vibe-template

> **Готовая «коробка» для разработки с AI — для тех, кто не программист.**
> Талантливые люди с идеями должны перестать разбиваться о технический барьер.

[English version →](README.md) · [📢 Манифест](MANIFESTO_RU.md) · [Manifesto (EN)](MANIFESTO_EN.md)

---

## Презентация за 30 секунд

Если вы когда-нибудь:
- Купили Claude Pro / Cursor / Copilot, открыли — и потерялись на этапе «как настроить»
- Имеете гениальную идею (сайт, бот, торговый терминал), но не можете пройти этап конфигурации
- Видели, как AI пишет код, который дрейфит от реальности, потому что не прочитал свежую документацию

Этот репозиторий для вас.

**Что даёт:**
- Двойной клик ставит все нужные инструменты (WSL, Docker, Python, git, Claude Code) — с подтверждением Y/N на каждом шаге
- Шаблон проекта со встроенными **anti-drift hooks** — они физически блокируют AI от написания кода без свежей документации
- 3 готовых профиля под типы проектов (веб, торговый терминал, госзакупки 44-ФЗ)
- Документация на русском, **для 10-летнего ребёнка**, без жаргона
- Все Windows-нюансы учтены (UTF-8 BOM, CRLF, `.cmd` vs `.ps1`, ExecutionPolicy)

**Чего НЕ делает:**
- Не придумает за вас бизнес-идею
- Не заменит человеческое суждение по архитектуре, безопасности, продукту
- Не сделает из вас программиста (а делает шаг программиста опциональным)

---

## Быстрый старт (5 минут)

### Шаг 1. Клонировать репо

```
git clone https://github.com/<YOUR_USERNAME>/claude-vibe-template.git
cd claude-vibe-template
```

### Шаг 2. Запустить мастер

**Двойной клик** на `scripts/setup-wizard.cmd`.

Мастер проходит 10 шагов, на каждом — Y/N/Skip, объясняет ЧТО и ЗАЧЕМ. Уже установленные инструменты пропускаются автоматически.

### Шаг 3. Создать первый проект

**Двойной клик** на `scripts/init-project.cmd`.

Задаст 3 вопроса:
- Имя проекта (например `my-first-bot`)
- Профиль (web-app / trading-terminal / gov-44fz-bot / base)
- GitHub-логин (опционально, для auto-remote)

Получите `C:\HOMEHOMEHOME\<имя-проекта>\` с полным шаблоном, git инициализирован, готов к открытию в Claude Code.

### Шаг 4. Открыть и начать

```
cd C:\HOMEHOMEHOME\<имя-проекта>
claude .
```

Расскажите AI свою идею. Hooks гарантируют, что он сначала делает research, потом код. Pull-request'ы создаются на ваш просмотр — вы нажимаете Merge.

---

## Что внутри

```
claude-vibe-template/
├── 📦 project-template/         Болванка для нового проекта
│   ├── CLAUDE.md                Конституция / правила для AI
│   ├── .claude/                 Skills, agents, hooks, slash-commands
│   ├── .mcp.json                Конфиг MCP-серверов
│   ├── docker-compose.yml       Postgres + app
│   ├── pyproject.toml           Python-зависимости + тулинг
│   └── .github/workflows/ci.yml CI-пайплайн
│
├── 🎯 profiles/                 Адаптации под тип проекта
│   ├── web-app.md
│   ├── trading-terminal.md
│   └── gov-44fz-bot.md
│
├── ⚙️ cowork-config/            Настройки Claude Desktop
│   ├── customize-global.md
│   ├── scheduled-tasks.md
│   ├── mcp-setup.md
│   └── notifications-setup-ntfy.md
│
├── 📚 docs/                     Документация на русском для не-ИТ
│   ├── 00_БЫСТРЫЙ_СТАРТ.md
│   ├── 02_PREFLIGHT_ГЛАВНОЕ.md  ← КЛЮЧЕВАЯ ИДЕЯ, читать обязательно
│   ├── 06_КАК_ДЛЯ_РЕБЁНКА.md    ← объяснения как 10-летнему
│   └── 07_МЕТА_УРОК_ДРЕЙФА.md   ← честный лог наших же ошибок
│
├── 🔧 scripts/
│   ├── setup-wizard.cmd         ← Windows-friendly точка входа
│   ├── init-project.cmd
│   └── backup-321.cmd
│
├── 📢 MANIFESTO_RU.md           Зачем этот проект существует
└── 📢 MANIFESTO_EN.md
```

---

## Главная идея — anti-drift hooks

Killer-фича не wizard, а hooks.

Когда AI пытается написать код-файл >50 строк без свежего research, PowerShell-hook возвращает:
```json
{"hookSpecificOutput": {
  "permissionDecision": "deny",
  "permissionDecisionReason": "preflight_gate: попытка создать/изменить код-файл > 50 строк без свежей записи в RESEARCH_LOG.md (за 60 мин). Запустите skill 'preflight-research' или /preflight."
}}
```

Claude Code блокирует Write. AI может пойти двумя путями:
1. Реальный research (WebSearch + Context7 для актуальной документации), запись в RESEARCH_LOG.md
2. Спорить с пользователем

Оба пути лучше, чем молчаливый дрейф.

**Прочтите [docs/02_PREFLIGHT_ГЛАВНОЕ.md](docs/02_PREFLIGHT_ГЛАВНОЕ.md) — полная философия.**

---

## Совместимость

| Платформа | Статус |
|---|---|
| Windows 10/11 (1903+) | ✅ Основная цель, полностью протестировано |
| macOS | ⏳ Скриптам нужны `.command`-эквиваленты (PR welcome) |
| Linux | ⏳ Большая часть работает, мастер нуждается в адаптации (PR welcome) |

**Версия Claude Code**: протестировано на 2.1.150. Формат может меняться в будущих релизах — см. CHANGELOG.

---

## Статус проекта

- Версия: **v0.1.0** (первый публичный релиз)
- End-to-end smoke-тестирование на Windows 11 25H2
- Hooks доказали работу (preflight_gate, git_push_guard, journal_append)
- РФ-адаптация включена (зеркала, ЮKassa, GitVerse, ntfy.sh вместо Telegram-бота)

Это **ранняя стадия**. Ожидайте rough edges. PR-ы приветствуются.

---

## Контрибьютинг

См. [CONTRIBUTING.md](CONTRIBUTING.md).

Кратко:
- Баг? Откройте issue с шагами воспроизведения
- Новый профиль (для ML-исследований, образования, медицины)? PR с `profiles/<your-domain>.md`
- Поддержка macOS / Linux? PR-ы особенно ждём
- Перевод docs/ на английский? PR welcome
- Улучшение hooks или skills? PR с объяснением

---

## Лицензия

- **Код** (скрипты, hooks, конфиги): [MIT](LICENSE)
- **Документация** (.md файлы): [CC BY 4.0](LICENSE-docs)

Копирайт © 2026 [Pechnik404](https://github.com/Pechnik404)

---

## Благодарности

- **Anthropic** — за Claude, Claude Code, MCP, Skills, Plugins. Это кирпичи, из которых собран проект.
- **Вдохновение** — исторический момент, когда Windows 95 сделал персональный компьютер доступным миллиардам людей.
- **Со-разработчик** — сам Claude, в серии Cowork-сессий (со всеми ошибками честно зафиксированными в `docs/07_МЕТА_УРОК_ДРЕЙФА.md`).
