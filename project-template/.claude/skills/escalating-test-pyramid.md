# Skill: escalating-test-pyramid

> **Назначение**: проверять код по нарастающей строгости, fail-fast на каждой ступени, без авто-push в main.

---

## Когда срабатывает

- Перед `git commit` в feature-ветке
- Перед `git push origin <branch>`
- Slash-command `/test-pyramid` вручную

---

## Ступени (строго по порядку)

### Ступень 1. Статический анализ (15 секунд)

```
ruff check .
ruff format --check .
mypy src/
```

Fail → СТОП, отчёт пользователю с конкретными файлами и строками. **Не переходить к ступени 2.**

### Ступень 2. Mock pytest (1–3 минуты)

```
pytest tests/unit/ -v --tb=short
```

Все внешние зависимости (БД, API) — замоканы. Только логика.

Fail → СТОП, отчёт, не переходить дальше.

### Ступень 3. Live smoke (10–30 секунд)

Минимальный реальный вызов:
- `/health` endpoint работает
- `SELECT 1` к Postgres проходит
- Hello-world запрос к внешнему API (если используется) возвращает 200

Fail → СТОП. Часто означает проблему с `.env` или сетью.

### Ступень 4. Миграции (если применимо)

```
alembic upgrade head  # на тест-БД
alembic downgrade -1
alembic upgrade head  # проверка идемпотентности
```

Fail → СТОП. Откатить миграцию, починить, повторить.

### Ступень 5. Integration tests (3–10 минут)

```
pytest tests/integration/ -v
```

Полный сценарий end-to-end с реальной (тест-) БД и (мок- или живыми) внешними API.

Fail → СТОП.

### Ступень 6. Git push в feature-ветку

```
git push origin <feature-branch>
```

После успешных 1–5. **Никогда** не в `main`/`master`.

### Ступень 7. gh pr create

```
gh pr create --base main --head <feature-branch> --title "<conv-commit>" --body-file .github/PR_TEMPLATE.md
```

Pull request создан. **НЕ мержим автоматически.** Пользователь нажимает Merge сам в UI GitHub.

---

## Артефакт работы

После прогона — короткий отчёт в чат (НЕ в `LAB_JOURNAL.md`, туда автоматически Stop hook):

```
Ступени:
✅ 1 ruff/mypy — clean
✅ 2 unit — 47 passed, 0 failed
✅ 3 smoke — все эндпоинты 200
✅ 4 миграции — не применимо
✅ 5 integration — 12 passed, 0 failed
✅ 6 push — feat/users-api → GitHub
✅ 7 PR — #42 https://github.com/.../pull/42

Confidence: 90%
Готово к ревью.
```

---

## Что делать при fail на любой ступени

1. **Не продолжать** к следующей ступени
2. Краткий отчёт в чат: ступень, файл, строка, текст ошибки
3. Предложить 2–3 варианта починки с trade-offs
4. Ждать решения пользователя
5. После починки — **прогон ВСЕХ ступеней с начала** (не «с места падения»)
