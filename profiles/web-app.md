# Профиль: web-app

> **Когда выбирать**: сайт / веб-сервис / админка / SaaS-MVP.
> **Соответствует**: первому застрявшему проекту (если это был сайт).

## Накладывается поверх project-template

### Дополнения к pyproject.toml

```
dependencies (добавить):
  - python-multipart  # формы
  - itsdangerous       # подпись сессий
  - python-jose[cryptography]  # JWT, если нужна auth
  - bcrypt             # хеш паролей
  - email-validator    # Pydantic EmailStr
```

### Дополнения к docker-compose.yml

```
redis:
  image: redis:7-alpine
  ports: ["6379:6379"]
  description: для сессий, кеша, фоновых задач (опц.)

nginx:
  image: nginx:alpine
  ports: ["80:80", "443:443"]
  description: только в production-overlay, локально не нужен
```

### Структура src/

```
src/
  main.py            # FastAPI app, middleware, lifespan
  config.py          # pydantic-settings
  db.py              # SQLAlchemy async engine, sessionmaker
  models/            # ORM-модели
  schemas/           # Pydantic схемы запросов/ответов
  routers/           # APIRouter по доменам
  templates/         # Jinja2 .html
  static/            # CSS, JS (минимум), картинки
  services/          # бизнес-логика
  deps.py            # Depends-функции (auth, db session)
tests/
  unit/
  integration/
```

### Дополнения к .mcp.json

- Без изменений (базового набора достаточно)

### Дополнения к CLAUDE.md

Раздел §15 добавить:

```markdown
## §15. Web-app специфика
- UI — HTMX + Jinja2. Никакого React/Vue без явной необходимости.
- Перед написанием своих компонент — проверить shadcn / Tailwind UI / DaisyUI.
- Auth — JWT в HttpOnly cookie, не localStorage.
- CSRF-защита на POST/PUT/DELETE формах.
- Rate limiting через slowapi или nginx.
```

## Скилл prefligh-research дополнительно проверит

- shadcn компоненты по теме
- Tailwind UI / DaisyUI компоненты
- Awesome FastAPI список (github.com/mjhea0/awesome-fastapi)
- HTMX patterns book (htmx.org/examples)

## Рекомендуемые библиотеки (мировой стандарт 2026)

| Задача | Библиотека | Альтернатива |
|---|---|---|
| ORM | SQLAlchemy 2.x async | SQLModel |
| Миграции | Alembic | — |
| Auth | python-jose + bcrypt | authlib |
| Формы | Pydantic + python-multipart | — |
| Тесты | pytest + httpx | — |
| Email | fastapi-mail | aiosmtplib |
| Фоновые задачи | ARQ (Redis-based) | Celery (тяжелее) |
| Админка | sqladmin | starlette-admin |

## Стоп-условия (специфичные)

- Хочется SPA-фронт → переключиться на профиль `web-app-react` (создать при необходимости)
- Нужен realtime → подумать о WebSocket в FastAPI + Redis pub/sub

## Деплой (РФ)

- Yandex Cloud Serverless Containers (стартовая опция, оплата за фактический траффик)
- Selectel VPS + docker compose (если нужен постоянный процесс)
- nginx с Let's Encrypt сертификатом (certbot)
