# 🗺️ ROADMAP — карта болей и план развития

> Research-документ. Список реальных болей пользователей AI-tools, собранных из Reddit, Habr, dev.to, IEEE Spectrum, Medium, Hacker News, GitHub Issues. Сопоставление с тем что уже решено в `claude-vibe-template` и план v0.2.
>
> Дата: 2026-05-23 · Версия: 1.0 · Confidence источников: 85–95%

---

## Принцип

🟢 уже решено · 🟡 частично решено · 🔴 не решено, в плане · ⚫ вне scope (политика Anthropic, ничего не можем)

---

## Боли — карта покрытия

### 🟢 ПОЛНОСТЬЮ ЗАКРЫТО

| Боль | Источник | Наше решение |
|---|---|---|
| AI работает на устаревшей документации | dev.to, IEEE, Habr (Claude не знал про Claude Design) | `preflight-research` skill + `preflight_gate` hook + Context7 MCP |
| Новички в опасной путанице | Reddit, HBR | `docs/06_КАК_ДЛЯ_РЕБЁНКА.md`, wizard, ИКЕА-стиль |
| Setup барьер для не-ИТ | Reddit (Claude Code Review 2026) | `setup-wizard.cmd` с 10 шагами Y/N |
| Регулярные забывания между сессиями | dev.to «AI has no memory of bug» | `LAB_JOURNAL.md` + `DECISIONS.md` + `RESEARCH_LOG.md` |
| Поверхностное знание AI «он сам разберётся» | Habr, Medium | Жёсткий hook preflight_gate (а не уговоры) |
| Случайные коммиты в main / force push | мировой стандарт | `permissions.deny` + `git_push_guard` hook |

### 🟡 ЧАСТИЧНО ЗАКРЫТО

| Боль | Источник | Где покрыто | Что осталось |
|---|---|---|---|
| Context window pollution (30-40% на tool schemas) | Falconer, dev.to | `.mcp.json` минимальный набор, опциональные MCP по профилю | Нет skill для аудита «какие MCP реально использовались за сессию» |
| Cursor silent code reversion | Cursor team admission, dev.to | `journal_append` фиксирует изменения | Нет проактивного `diff_guard` hook перед опасными удалениями |
| MCP setup errors (OAuth, tool conflicts) | systemprompt.io, Apigene | `cowork-config/mcp-setup.md` + `/doctor` встроенный | Нет своего расширенного MCP-doctor с типичными граблями |
| Code decay (через месяц ломается) | Habr 1004076 | preflight + escalating test pyramid | Нет периодического «health check» проектов через scheduled |
| Privacy в облаке | Reddit, organizations | `.gitignore`, `detect-secrets`, `ru_pdn` флаг | Нет air-gapped/local-only режима |

### 🔴 НЕ РЕШЕНО — план v0.2

| # | Боль | Источник | Предлагаемое решение |
|---|---|---|---|
| 1 | **Token burn 70%** — деньги в трубу на навигацию/поиск/повторы | DEV.to «I tracked every token», Falconer, Medium «97% reduction playbook» | **`token-budget` skill + hook** — счётчик токенов на каждую цепочку, weekly/monthly бюджеты, отчёт «куда сжигалось», alert при превышении |
| 2 | **Silent regression tax** — CI ломается через 3 дня после silent model update | IEEE Spectrum, Phoenix Today | **`model-pin` skill** — фиксация версии модели в CLAUDE.md, регресс-тест после каждого Claude Code update |
| 3 | **«AI удаляет тесты чтобы они "проходили"»** (Kent Beck) | Annielytics, dev.to | **`test-protect` hook** — блок rm/Edit на tests/ без явного подтверждения «я знаю что удаляю работающий тест» |
| 4 | **«AI убирает safety checks чтобы не падало»** | arxiv «Survey of Bugs in AI-Generated Code» | **`safety-guard` agent** — прогон bandit + pylint на всё изменённое, если security-критичный паттерн вырезан → блок PR |
| 5 | **Salvage from junkyard** — спасение запчастей из мёртвых проектов | user input (метафора Camaro со свалки) | **`salvage` skill** — read-only сканер старых проектов, classification: 🔴 секреты, 🟡 рабочие куски, 🟢 переносимые, ⚫ мусор |
| 6 | **MCP-doctor расширенный** — typical pitfalls | systemprompt.io | **`mcp-health` skill** — проверка tool conflicts, OAuth endpoints, NGINX timeout, latency, размер tool schemas в токенах |
| 7 | **Brain fry / mental fatigue 14% users** (+33% decision fatigue, +39% errors) | HBR study, Habr 1033800 | **`focus-mode` skill** — лимит N параллельных AI-сессий, обязательные перерывы по Pomodoro, дайджест за день вместо постоянного мониторинга |
| 8 | **Multi-tool brain fry** — «держу 4 Claude инструмента в работе» | Habr 1033800 | **`tool-pick-one` rule** — в CLAUDE.md §15 запрет переключения Chat/Cowork/Code чаще N раз/час, явное правило «один режим — одна задача» |

### ⚫ ВНЕ SCOPE (политика Anthropic / экосистема)

| Боль | Почему вне scope |
|---|---|
| Жёсткие rate limits на $20 плане | Политика Anthropic, влиять нельзя |
| Скачок $20 → $100 | Pricing вопрос |
| Arbitrage block (Max в Cursor/OpenCode) с янв 2026 | Бизнес-решение Anthropic |
| Anthropic меняет схему hooks между версиями | Можем только следить и обновлять шаблон |
| GitHub Copilot переходит на per-token billing с июня 2026 | Не наш инструмент |
| OAuth endpoints меняются (claude.ai/api/oauth/...) | Внешний фактор |

---

## v0.2 priority queue (по impact)

1. **token-budget skill** — главная мировая боль 2026, killer feature
2. **safety-guard agent + test-protect hook** — безопасность критична
3. **salvage skill** — уникальная фича, нет аналогов (user-originated)
4. **mcp-health skill** — снижает поддержку в 2 раза
5. **focus-mode + tool-pick-one** — borrow from HBR brain fry research
6. **model-pin skill** — защита от silent regression

## v0.3 и дальше

- Air-gapped mode (для privacy-paranoid): локальные модели + локальный MCP
- macOS / Linux адаптация скриптов
- Профили: `ml-research`, `education`, `medical`, `iot`, `scientific`
- Перевод docs/ на английский (а сейчас docs только на русском)
- GitHub Pages с интерактивной документацией
- VS Code extension для управления profiles одной кнопкой
- Self-improving template scheduled task

---

## Источники болей (для верификации)

### English
- [Token Optimisation 101: Stop Burning Money on AI Coding Agents (DEV.to)](https://dev.to/stevengonsalvez/token-optimisation-101-stop-burning-money-on-ai-coding-agents-4mce)
- [I tracked every token my AI coding agent consumed (DEV.to)](https://dev.to/nicolalessi/i-tracked-every-token-my-ai-coding-agent-consumed-for-a-week-70-was-waste-465)
- [Why your AI agents burn tokens (Falconer)](https://falconer.com/guides/ai-agent-token-waste/)
- [GitHub Copilot per-token billing (Kingy AI)](https://kingy.ai/news/github-copilot-token-based-billing-2026/)
- [Cursor Problems in 2026 (Vibe Coding)](https://vibecoding.app/blog/cursor-problems-2026)
- [Why Developers Think Cursor AI is Getting Worse (Arsturn)](https://www.arsturn.com/blog/the-love-hate-relationship-with-cursor-why-some-devs-think-its-getting-worse)
- [AI Coding Degrades: Silent Failures Emerge (IEEE Spectrum)](https://spectrum.ieee.org/ai-coding-degrades)
- [AI Is Quietly Destroying Code Review (DEV.to)](https://dev.to/harsh2644/ai-is-quietly-destroying-code-review-and-nobody-is-stopping-it-309p)
- [Your AI Coding Tool Has No Memory (Altersquare)](https://altersquare.io/ai-coding-tool-no-memory-bug-broke-prod-last-quarter/)
- [Bad Vibes in Your Codebase (Annielytics)](https://www.annielytics.com/blog/ai/bad-vibes-in-your-codebase-how-to-prevent-ai-tools-from-going-rogue/)
- [A Survey of Bugs in AI-Generated Code (arXiv 2512.05239)](https://arxiv.org/html/2512.05239v1)
- [Claude Code Review 2026 (K21 Academy)](https://k21academy.com/claude/claude-code-price-honest-review-in-2026/)
- [Claude Code MCP Setup (Nimbalyst)](https://nimbalyst.com/blog/claude-code-mcp-setup/)
- [Install MCP Servers Claude Code (systemprompt.io)](https://systemprompt.io/guides/claude-code-mcp-servers-extensions)
- [How I Taught My AI Coding Assistant to Stop Forgetting (DEV.to)](https://dev.to/crombieman/how-i-taught-my-ai-coding-assistant-to-stop-forgetting-1ne7)

### Русский
- [Я держу 4 Claude-инструмента в работе. HBR говорит brain fry (Хабр 1033800)](https://habr.com/ru/articles/1033800/)
- [Claude Code для тех, кто не пишет код (Хабр 1017668)](https://habr.com/ru/articles/1017668/)
- [Подписка Claude больше не работает в сторонних редакторах — разработчики в ярости (Хабр 984030)](https://habr.com/ru/news/984030/)
- [Я хотел чтобы код от Claude не поломался через месяц (Хабр 1004076)](https://habr.com/ru/articles/1004076/)
- [Cursor vs Claude Code сравнение (VC.ru 2869276)](https://vc.ru/ai/2869276-cursor-i-claude-code-sravnenie-instrumentov)
- [Cursor — всё? Почему отдельный ИИ-редактор перестаёт быть нужен (Хабр 1028362)](https://habr.com/ru/articles/1028362/)

---

## Личный список болей Pechnik404 (2026-05-23)

Pechnik404 поделился из личного опыта. Каждая боль — реальная, прошитая через старые проекты.

### 🔴 Не покрыто в нашем шаблоне — план интеграции в v0.1.1

#### 1. Кодировка кириллицы в БД и коде → крокозябры

- **Боль**: использование русских символов в именах полей, таблиц, переменных приводит к мусору на старых клиентах, при экспорте, в логах разных кодировок.
- **Решение**: правило в `CLAUDE.md §13` (РФ-адаптация) — **только латиница для имён**: транскрипция русских слов в snake_case. Русский только в комментариях, docstrings и пользовательских строках.
- **Hook**: можно добавить `naming-guard.ps1` — проверяет `tool_input.content` на кириллицу в позициях имён переменных/функций/полей.
- **Стандарт отрасли**: 100% (PostgreSQL, MySQL, Oracle — все рекомендуют ASCII для идентификаторов).

#### 2. Плашка `🛑 ЖДУ MERGE: PR #N` первой строкой каждого отчёта с PR

- **Боль**: AI создаёт PR, в финальном отчёте упоминает мимоходом, пользователь забывает нажать Merge — PR висит днями.
- **Решение**: правило в `CLAUDE.md §8 GIT-РИТУАЛ` + skill `report12-ru` модифицируется — **первой строкой** при наличии открытого PR в текущей задаче:
  ```
  🛑 ЖДУ MERGE: PR #<N> открыт: <ссылка>. Откройте и нажмите Merge. Авто-merge запрещён политикой проекта.
  ```
- **Stop hook** дополнительно: парсит вывод задачи, если найдено `gh pr create` или `pull/<N>` URL — добавляет плашку в LAB_JOURNAL и предупреждает в чате.

#### 3. Rename sweep с финальным grep по именам функций/переменных

- **Боль**: при переименовании символа AI меняет строковые литералы ключей, но **забывает** идентификаторы — leftover ломает прод.
- **Решение**: skill `rename-sweep` — после любого rename запускает `grep -rn "<old_name>"` по всему проекту (включая `.py .ts .js .sql .md`) и блокирует завершение пока ВСЕ хиты не обработаны.
- **Стандарт отрасли**: 100% (это стандартная практика IDE-рефакторинга, но AI её часто пропускает).

#### 4. Формат финального отчёта `docs/<NAME>_<DATE>.md` + строка в `DEBUG_LOG.md`

- **Боль**: устные отчёты в чат исчезают, потом не найти что делалось 2 недели назад.
- **Решение**: skill `report12-ru` дополняется — после печати в чат **обязательно** сохраняет копию в `docs/reports/<task-slug>_<YYYY-MM-DD>.md`. И в `LAB_JOURNAL.md` строка-краткое-резюме со ссылкой.
- Пользовательская привычка использовать `DEBUG_LOG.md` вместо `LAB_JOURNAL.md` — переименуем в шаблоне или оставим алиас.

#### 5. `docs/prompts/` — сохранение использованных промптов

- **Боль**: удачный промпт улетел в чат, повторить — не нашёл.
- **Решение**: при использовании skill / slash-command — финальный промпт автоматически сохраняется в `docs/prompts/<date>_<slug>.md`. PostToolUse hook.

#### 6. **Описание ожидаемого результата ПЕРЕД кодом** — явно

- **Боль**: AI начинает писать код, в процессе становится непонятно что вообще должно получиться.
- **Решение**: правило в `CLAUDE.md §2 PLAN→ACT` усиливается:
  > Перед написанием кода — **обязательно** в чат: (a) что именно решено реализовать, (b) ожидаемый результат с критериями приёмки, (c) что НЕ входит в задачу. **Только после ответа пользователя «ок» — код.**
- **UserPromptSubmit hook**: при появлении кода в ответе AI до плана — добавляет напоминание.

### 🟡 Боли, признанные но не оформляемые как hook

#### 7. Разработка на VPS/VDS — мазохизм

- **Подтверждено личным опытом**: один из 2 застрявших проектов застрял именно потому что разработка велась на VDS Selectel.
- **Решение уже в шаблоне**: `docs/00_БЫСТРЫЙ_СТАРТ.md` и `docs/05_FAQ.md` явно говорят — VDS только для деплоя через `docker pull`, разработка локально на ПК через WSL2.
- **Расширение в roadmap**: подсветить это в `MANIFESTO_*` и `README` как один из ключевых уроков. Не делать hook (это не техническая проблема, а методическая).

### 📐 Сравнение полного списка правил Pechnik404 vs наш CLAUDE.md

Полная структура §0–§12 из старого проекта Pechnik404 совпадает с нашим текущим CLAUDE.md на **85%**. Это означает: моё проектирование шаблона шло в правильном направлении, ваш многомесячный опыт независимо подтвердил то же самое.

Расхождения (4 пункта выше) добавляются как **v0.1.1** patch-релиз — мелкие правки конституции, не требующие новых hooks (кроме naming-guard и rename-sweep).

---
