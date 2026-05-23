# RESEARCH_LOG

> Append-only журнал preflight-проверок. Каждая запись — результат skill `preflight-research`.
>
> **Без свежей записи здесь hook `preflight_gate` блокирует создание файлов > 50 строк.** Это защита от дрейфа (CLAUDE.md §1).

---

## Шаблон записи

```markdown
## [YYYY-MM-DD HH:MM] Preflight: <название задачи>

### Prior art
- repo1 (★1200, last 2 мес, MIT) — ✅ используем как библиотеку
- repo2 (★800, last 4 мес, Apache) — ⚠️ вдохновляемся
- repo3 (★450, last 1 мес, MIT) — ❌ не покрывает наш кейс

### Docs loaded (через Context7)
- FastAPI: dependency-injection, lifespan events
- httpx: async client, retries
- alembic: autogenerate, batch_alter

### UI approach (если применимо)
- HTMX + базовая стилизация через shadcn-style классы

### Решение
<кратко: что именно реализуем и почему>

### Confidence
<%> — <одна фраза почему>
```

---

<!-- ЗАПИСИ ИДУТ НИЖЕ. Не редактируйте существующие — это append-only журнал. -->
