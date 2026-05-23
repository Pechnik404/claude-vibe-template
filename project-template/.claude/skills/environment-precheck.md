# Skill: environment-precheck

> **Назначение**: проверить что компьютер и сеть готовы к разработке проекта ДО первого `pip install` или `docker compose up`.
>
> **Зачем**: ваш конкретный кейс — T-Bank Invest API (gRPC + protobuf) требует Python 3.12, не работает с 3.14. Дебиан-образ скачивается только с зеркала Яндекс. И т.д. Хочется узнать ЭТО ДО, а не после полудня отладки.

---

## Когда срабатывает

- Slash-command `/precheck`
- Автоматически после `init-project.ps1` (первый запуск)
- Перед добавлением новой внешней зависимости (опционально)

---

## Проверки (8 ступеней)

### Ступень 1. Версия Python

Прочитать из `pyproject.toml` поле `requires-python` (например, `>=3.11,<3.13`).
Сравнить с `python --version`.

❌ Несовместимо → СТОП, отчёт «нужно Python X.Y, у вас X.Z. Установите через `pyenv` или `winget install Python.Python.3.12`».

### Ступень 2. Системные пакеты

Проверить наличие в PATH:
- `git`
- `docker` + `docker compose`
- `gh` (GitHub CLI)
- `pwsh` (PowerShell 7, не 5)

❌ Отсутствует → указать команду установки (`winget install ...`).

### Ступень 3. Docker daemon работает

`docker info` должен вернуть успех.

❌ Не работает → «Запустите Docker Desktop. Иконка китика в трее».
❌ Daemon не запущен в WSL → инструкция включения WSL integration.

### Ступень 4. Network — внешние сервисы

Проверить доступность (HEAD-запрос с таймаутом 5 сек):
- `https://github.com` — для git push/pull
- `https://pypi.org` или зеркало → выбрать рабочее
- `https://api.anthropic.com` — если есть AI-функционал
- API из профиля (см. ниже)

❌ Недоступно → конкретные инструкции:
- pypi → переключить на `pypi.yandex.ru` (`pip config set global.index-url https://pypi.yandex.ru/simple/`)
- Docker Hub → переключить на зеркало Cloud.ru или Yandex (`daemon.json`)
- GitHub — если упал, временные ограничения, проверить позже

### Ступень 5. Docker registry mirror (для РФ)

Проверить `daemon.json` (Windows: `%USERPROFILE%\.docker\daemon.json`):

```json
{
  "registry-mirrors": [
    "https://cr.yandex/mirror",
    "https://mirror.gcr.io"
  ]
}
```

Если нет — предложить добавить (с подтверждением Y/N).

### Ступень 6. API проекта (по профилю)

В зависимости от профиля проверить:

| Профиль | API | Проверка |
|---|---|---|
| `trading-terminal` | T-Invest | GET `https://invest-public-api.tinkoff.ru/rest/...` с песочным токеном |
| `trading-terminal` | MOEX ISS | GET `https://iss.moex.com/iss/index.json` (публичный, без токена) |
| `gov-44fz-bot` | ЕИС zakupki | GET `https://zakupki.gov.ru/epz/main/...` |

Версии SDK сверить с pyproject.toml:
- `tinkoff-investments` — НЕ совместим с Python 3.14 (по состоянию на 2026-05; проверить актуально через WebSearch)
- ...

### Ступень 7. Место на диске

Минимум **10 ГБ свободно** на диске с проектом. Docker-образы много весят.

❌ Меньше → предупреждение + команда очистки `docker system prune`.

### Ступень 8. .env заполнен

Проверить что `.env` (не `.env.example`) существует и не содержит плейсхолдеры `change_me`, `xxxxx`.

❌ Не заполнен → список переменных, которые нужно заполнить.

---

## Формат отчёта

```
🔍 ENVIRONMENT PRECHECK
Профиль: <name>
Дата: 2026-XX-XX HH:MM

✅ 1. Python: 3.12.3 (требуется >=3.11,<3.13) — OK
✅ 2. CLI: git, docker, gh, pwsh — все на месте
✅ 3. Docker daemon: работает
🟡 4. Network:
       github.com         ✅
       pypi.org           ❌ → используем pypi.yandex.ru
       api.anthropic.com  ✅ (через VPN?)
       invest-public-api.tinkoff.ru ✅
🟡 5. Docker mirror: не настроен → предлагаю добавить cr.yandex
✅ 6. API проекта: T-Invest sandbox отвечает, MOEX ISS отвечает
✅ 7. Диск: 247 ГБ свободно
❌ 8. .env: не существует, скопируйте из .env.example

ВЕРДИКТ: 🟡 Требуется внимание перед стартом.

Действия по приоритету:
1. ❌ → скопируйте .env.example в .env и заполните
2. 🟡 → разрешить добавить registry-mirror? [Y/n]
3. 🟡 → переключить pip на yandex mirror? [Y/n]

После исправления — `/precheck` ещё раз.
```

---

## Базовые знания о РФ-зеркалах (2026)

- **PyPI mirror**: `https://pypi.yandex.ru/simple/`
- **Docker Hub mirror**: `https://cr.yandex/mirror` (Yandex), `https://mirror.gcr.io` (Google, обычно доступен)
- **Debian/Ubuntu mirror**: `https://mirror.yandex.ru/debian/`, `https://mirror.yandex.ru/ubuntu/`
- **NPM**: `https://npm.yandex.ru/` (если есть JS)
- **Go modules**: `https://goproxy.cn` (если есть Go)

Команды переключения — в FAQ `docs/05_FAQ.md`.

---

## Известные несовместимости (поддерживаем список)

| Библиотека | Python | Альтернатива |
|---|---|---|
| `tinkoff-investments` | требует 3.10-3.12 (на 2026-05; проверять актуально) | пин Python в pyproject |
| `ta-lib` | требует C-компилятор + libta-lib | в Docker — `apt-get install ta-lib-dev` |
| `tensorflow` | требует 3.10-3.11 | использовать pytorch если возможно |

(Список обновляется при обнаружении новых случаев.)
