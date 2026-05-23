# FAQ — частые вопросы и проблемы

---

## Установка и старт

### Q: Что ставить на ПК перед первым проектом?

**Минимум (один раз, ~30 минут)**:
1. **Windows 11** (или 10 свежий) с включённой виртуализацией в BIOS
2. **WSL2** + Ubuntu 22.04 — `wsl --install -d Ubuntu-22.04` в PowerShell от админа
3. **Docker Desktop** для Windows — скачать с docker.com (он сам подцепится к WSL2)
4. **Git for Windows** — git-scm.com
5. **GitHub CLI** — `winget install --id GitHub.cli`
6. **VS Code** + расширение Remote-WSL — code.visualstudio.com
7. **PowerShell 7** (не Windows PowerShell 5) — `winget install Microsoft.PowerShell`
8. **Python 3.11+** в WSL: `sudo apt install python3.11 python3.11-venv python3-pip`
9. **Claude Desktop** — скачать с claude.ai/download
10. **Claude Code** (опционально, через npm): `npm install -g @anthropic-ai/claude-code`

### Q: Как создать первый проект?

**Простой способ (двойной клик)**:
1. Открыть `C:\HOMEHOMEHOME\ClaudeCombine\ИНФРАСТРУКТУРА\scripts\`
2. **Двойной клик** на `init-project.cmd` (с **cmd** на конце!)
3. Скрипт спросит имя проекта, тип, GitHub-логин — ответить
4. Готово, папка создана в `C:\HOMEHOMEHOME\<имя>\`

**Способ с параметрами (для опытных)**:
```
pwsh C:\HOMEHOMEHOME\ClaudeCombine\ИНФРАСТРУКТУРА\scripts\init-project.ps1 -Name my-first-app -Profile web-app
```

### Q: Дважды кликнул на .ps1 — открылся редактор, не запустилось.

Это особенность Windows: `.ps1` файлы по умолчанию не исполняются по клику для безопасности. Используйте **`.cmd` версию того же скрипта** — она лежит рядом, отличается только расширением (`setup-wizard.cmd`, `init-project.cmd`, `backup-321.cmd`). На `.cmd` двойной клик работает.

Если ОЧЕНЬ нужно запустить `.ps1` напрямую:
- ПКМ на файле → «Запустить с помощью PowerShell»
- Или открыть PowerShell вручную: `pwsh -ExecutionPolicy Bypass -File <путь>`

### Q: Открылось чёрное окно и сразу закрылось — не успел прочитать.

Проблема в самом скрипте — упал с ошибкой. Чтобы увидеть текст ошибки:
1. Открыть командную строку (Win+R → `cmd` → Enter)
2. Перейти в папку: `cd C:\HOMEHOMEHOME\ClaudeCombine\ИНФРАСТРУКТУРА\scripts`
3. Запустить: `setup-wizard.cmd` (или другой нужный)
4. Ошибка останется в окне — скопировать текст и кинуть в Cowork «вот ошибка, разбери»

### Q: Где хранятся проекты?

Рекомендую: `C:\HOMEHOMEHOME\<имя-проекта>\` для каждого. ClaudeCombine — для инфраструктуры/шаблонов, не для самих проектов.

---

## Работа с AI

### Q: AI начал делать не то, что я хотел. Что делать?

1. Сразу СТОП в чате: «AI, остановись.»
2. Попросите показать `RESEARCH_LOG.md` и план, по которому он работает
3. Если план неверный → скорректируйте → пусть начнёт с нуля
4. Если план верный, но реализация ушла в сторону → попросите вернуться к чек-листу плана

### Q: AI игнорирует мои предпочтения (стиль, краткость).

Проверьте Cowork → Customize → ваши Custom instructions содержат блок из `cowork-config/customize-global.md`. Если нет — скопируйте заново.

### Q: AI обещает «потом проверю» — но не проверяет.

Это известный анти-паттерн. Запретите его прямо в чате: «Не используй формулировки 'позже проверю / потом доделаю / в следующей итерации'. Делай сейчас или явно скажи 'не делаю, потому что X'.»

### Q: AI слишком многословный, длинные ответы.

Проверьте Customize. Можно дополнительно в чате: «На все ответы — план из 3-5 пунктов, потом ответ под планом. Без воды.»

---

## Hooks и блокировки

### Q: Hook блокирует то, что не должен. Срочно нужно работать.

Временно выключить ВСЕ hooks: переименовать `.claude/settings.json` → `.claude/settings.json.disabled`. Через несколько секунд hooks выключатся. После работы — переименовать обратно.

### Q: preflight_gate сработал — RESEARCH_LOG требует записи. А я только чиню маленький баг.

Откройте RESEARCH_LOG.md, добавьте короткую запись вручную:
```markdown
## [2026-05-23 14:30] Hotfix: <описание бага>
### Решение
Точечный fix без новых зависимостей. Preflight не требуется.
### Confidence: 95%
```

Hook увидит свежую запись — разблокирует.

### Q: git_push_guard не даёт мне сделать важный push в main.

Это ПО ДИЗАЙНУ. Создайте feature-ветку, push туда, потом PR. Если 100% уверены что нужен прямой push в main — временно отключите settings.json (но это плохая практика).

---

## MCP и подключения

### Q: Context7 показывает «no docs found» для библиотеки X.

Возможные причины:
- Имя библиотеки неточное → попробуйте `resolve-library-id` сначала
- Библиотека слишком новая → загляните на её GitHub README через WebSearch
- Библиотека редкая → WebSearch + чтение исходников

### Q: GitHub MCP не подключается.

1. Перепройти OAuth: Cowork → Customize → Connectors → GitHub → Reconnect
2. Если на корпоративном GH — нужен Personal Access Token с правами `repo`, `workflow`, `read:user`
3. В крайнем случае — `claude mcp add github` через CLI с явным токеном

### Q: Postgres MCP не видит БД.

Проверьте `.env` → `POSTGRES_READONLY_URL`. Формат: `postgresql://user:pass@host:port/db`.
Создайте отдельного `readonly` пользователя:
```sql
CREATE USER readonly WITH PASSWORD 'xxx';
GRANT CONNECT ON DATABASE appdb TO readonly;
GRANT USAGE ON SCHEMA public TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;
```

---

## Уведомления (ntfy.sh)

### Q: Пуши не приходят на телефон.

1. Проверить интернет на телефоне
2. Проверить что в приложении ntfy подписаны на ТОЧНО ваш topic
3. Проверить не выключены ли уведомления в системе для приложения ntfy
4. Тест: `curl -d "test" $NTFY_TOPIC_URL` с ПК — должно прийти за 1-2 сек
5. Проверить логи скрипта/scheduled-задачи — может быть, ошибка отправки

### Q: Слишком много уведомлений, надоедают.

Поднимите порог приоритета. Например, в scheduled-задаче: «слать только priority=high и выше».

---

## Безопасность

### Q: Случайно закоммитил .env с реальным ключом. Что делать?

1. **СРАЗУ** отзовите ключ в сервисе (GitHub, Anthropic, etc.)
2. Создайте новый ключ
3. Очистите git history: `git filter-repo --invert-paths --path .env` (или BFG Repo-Cleaner)
4. Force-push: `git push origin --force --all` (если уже было push)
5. Уведомите всех контрибьюторов о ребейзе
6. Включите `detect-secrets` в pre-commit hooks навсегда

### Q: detect-secrets ругается на legitimate-вещи (например, test fixtures).

Добавьте в `.secrets.baseline` через `detect-secrets scan --update .secrets.baseline`.

---

## Стоимость

### Q: Сколько это всё стоит?

- **Claude Desktop**: ваша подписка (фикс/мес)
- **Anthropic API в проектах** (если AI-фичи): по токенам, контроль через usage logging
- **GitHub**: бесплатно для private repos (есть лимит на minutes для Actions)
- **Yandex Cloud / Selectel**: pay-as-you-go, обычно < 1000 руб/мес для МVP
- **ntfy.sh**: бесплатно (или self-hosted на вашем VDS)
- **Context7**: бесплатно
- **Notion**: бесплатно для одного пользователя

Совет: **поставьте billing alerts** в Yandex Cloud / Selectel на сумму, которую готовы потерять (например, 2000 руб/мес).

---

## Адаптация и развитие

### Q: Мне не нравится какое-то правило в CLAUDE.md.

Отредактируйте `project-template/CLAUDE.md` (для всех будущих проектов) или конкретный `CLAUDE.md` проекта (только для него). Это **ваш файл**, никто не запрещает менять.

После изменения — пометьте новую версию в шапке файла.

### Q: Я хочу добавить новый профиль.

1. Скопируйте любой существующий `profiles/*.md` как шаблон
2. Адаптируйте под свой тип проектов
3. Зафиксируйте в `docs/03_ПРОТОКОЛ_АДАПТАЦИИ.md` → реестр профилей
4. Используйте через `init-project.ps1 -Profile <new-name>`

### Q: Шаблон устарел / появились новые best practices.

scheduled-задача **«Self-improving template»** (см. `cowork-config/scheduled-tasks.md` #5) раз в месяц предлагает улучшения. Также вы можете вручную попросить AI: «Просмотри project-template на актуальность best practices 2026, предложи апдейт».

---

## Что-то ещё

### Q: Не нашёл ответа на свой вопрос.

Спросите в Cowork chat. AI знает всю эту инфраструктуру (видит файлы) и ответит конкретно. Если ответ полезный — попросите дописать в этот FAQ.
