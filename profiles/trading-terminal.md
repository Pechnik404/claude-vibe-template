# Профиль: trading-terminal

> **Когда выбирать**: торговый терминал, котировки, ордера, риск-менеджмент.
> **Особенность**: latency-critical, реальные деньги — повышенные требования к надёжности и тестированию.

## ⚠️ Особые предостережения

1. **НЕ ПОДКЛЮЧАТЬ боевой счёт сразу**. Сначала — sandbox/демо API.
2. **Risk-limits первичны** — стоп-лосс, дневной максимум потерь должны быть в коде, не в голове.
3. **Идемпотентность ордеров** — каждый ордер с уникальным client-id, повторный запрос не создаёт второй ордер.
4. **Полное логирование сделок** — JSON-lines в S3-совместимое хранилище (Yandex Object Storage / Selectel S3) для аудита.

## Накладывается поверх project-template

### Дополнения к pyproject.toml

```
dependencies:
  - tinkoff-investments  # T-Invest API (бывший Тинькофф)
  - aiogram  # ОПЦ: если нужен Telegram-бот для алертов (НЕ для production без юрлица; см. ntfy.sh)
  - websockets
  - aiokafka или nats-py  # message bus для развязки приёма котировок и стратегии
  - apache-airflow  # ОПЦ: для backtesting и периодических задач
  - pandas, numpy, ta-lib  # анализ
  - matplotlib или plotly  # графики

[project.optional-dependencies]
trading-test = [
  "pytest-vcr",  # запись реальных API-ответов для повторяемых тестов
  "freezegun",   # подмена времени в тестах
]
```

### Дополнения к docker-compose.yml

```
nats:
  image: nats:2-alpine
  ports: ["4222:4222"]
  description: лёгкий message bus

redis:
  image: redis:7-alpine
  description: кеш котировок, throttling
```

### Структура src/

```
src/
  market_data/       # клиенты бирж (T-Invest, MOEX ISS, ...)
  strategies/        # торговые стратегии (изолированные классы)
  risk/              # лимиты, кругозор позиций
  execution/         # отправка ордеров с retry и идемпотентностью
  storage/           # запись сделок в Postgres + S3
  monitoring/        # health checks, метрики
  cli.py             # CLI для ручных операций
```

### Дополнения к .mcp.json

```
"postgres-tradelog": {
  "command": "npx",
  "args": [
    "@modelcontextprotocol/server-postgres",
    "${POSTGRES_TRADELOG_READONLY_URL}"
  ],
  "description": "read-only доступ к журналу сделок для AI-анализа"
}
```

### Дополнения к CLAUDE.md (§15 trading-specific)

```markdown
## §15. Trading-terminal специфика

ЖЁСТКИЕ ПРАВИЛА:
- Любая стратегия проходит **backtesting** на минимум 12 месяцев исторических данных до live.
- Live торговля **только после паперtrade** ≥ 2 недель с положительным результатом.
- Лимит дневных потерь — конфиг + код, никаких ручных «исключений сегодня».
- Каждый ордер — с `client_order_id = uuid()` для идемпотентности.
- Конфликт между API и локальным состоянием — приоритет API, локальный state пересинхронизировать.
- Отключение интернета → автоматический режим «только закрытие позиций», новых ордеров не создаём.

ЗАПРЕТЫ:
- Жёсткая блокировка `git push` если в diff есть строки с реальным API-токеном или счётом
- Запрет `--reload` в production (могут пропадать колбеки)
- Запрет ORM-update сделок (только append через миграции/триггеры)
```

## Прочитать перед стартом (preflight обязательно)

- T-Invest API docs (`tinkoff.github.io/investAPI/`)
- MOEX ISS API (`iss.moex.com/iss/reference/`)
- Книга «Algorithmic Trading» Ernest Chan
- Awesome quant repos на GitHub: `github.com/wilsonfreitas/awesome-quant`
- Risk-management patterns: position sizing (Kelly criterion, fixed fractional)

## Тестирование (расширение Escalating Pyramid)

Дополнительная **ступень 0** перед всеми:
- **Backtest**: на исторических данных
- **Paper-trade**: на sandbox API
- **Live с минимальным лотом**: ≤1% от капитала

## РФ-специфика

- T-Invest = бывший Тинькофф Инвестиции = доступен резидентам РФ, токены для песочницы выдаются мгновенно
- MOEX ISS = открытый API Московской биржи для котировок (бесплатно для personal use)
- Налоги: автоматический брокер-расчёт (для физлица). Для ИП — отдельная история, не лезть в шаблон.
