# Skill: ritual-git

> **Назначение**: алгоритмизация git-операций с защитой от человеческого фактора.

## Принципы

- **Trunk-based**: одна основная ветка `main`, фичи — короткоживущие `feat/*`, `fix/*`, `chore/*`, `docs/*`
- **Conventional Commits**: `<type>(<scope>): <subject>` — например `feat(api): add /health endpoint`
- **Squash-merge** по умолчанию
- **Никогда** не `git push --force` в `main`
- **Никогда** не auto-merge — пользователь нажимает Merge сам

## Алгоритм ship (новая фича)

1. **Проверка чистоты**:
   - `git status` — нет неотслеживаемых файлов кроме `.env` и временных
   - На `main`: `git pull --rebase origin main` для актуальности

2. **Создание ветки**:
   - `git checkout -b feat/<short-name>` (kebab-case, ≤30 символов)

3. **Работа в ветке**:
   - Маленькие commits с conventional-формулировкой
   - НЕ коммитим: `.env`, `*.db`, `node_modules/`, `__pycache__/`, секреты любого вида

4. **Перед push — Escalating Test Pyramid** (skill `escalating-test-pyramid`)

5. **Pre-push hook проверки**:
   - Branch не равен `main`/`master` — иначе **БЛОК**
   - `detect-secrets-hook` прошёл — иначе **БЛОК**
   - Нет файлов > 1 МБ — иначе предупреждение и подтверждение

6. **Push + PR**:
   ```
   git push origin <branch>
   gh pr create --base main --head <branch> \
     --title "<conv-commit-style title>" \
     --body-file .github/PR_TEMPLATE.md
   ```

7. **Ссылка на PR** — в чат пользователю. **Не мержить.**

## Алгоритм rollback (если что-то пошло не так)

Сценарий А — коммит ещё локальный:
- `git reset --soft HEAD~1` — откатить commit, оставить изменения

Сценарий Б — коммит уже push в feature-ветку:
- `git revert <commit-hash>` + push новый commit. История сохраняется.

Сценарий В — что-то страшное в main (не должно случаться):
- СТОП. Никаких самостоятельных действий. Отчёт пользователю с предложением 2-3 вариантов.

## PR Template (`.github/PR_TEMPLATE.md`)

```markdown
## Что сделано
<одно-два предложения>

## Зачем
<bus value или техническая необходимость>

## Как тестировал
- [ ] Unit-тесты прошли
- [ ] Integration-тесты прошли
- [ ] Smoke-тест локально
- [ ] Миграции (если есть) применены и откатываются

## Чек-лист
- [ ] Conventional commits
- [ ] RESEARCH_LOG.md содержит запись по этой задаче
- [ ] Нет секретов в diff
- [ ] CHANGELOG.md обновлён (если ready-for-merge)
- [ ] Документация обновлена (если изменилось API)

## Confidence
<%>

## Ссылки
- RESEARCH_LOG раздел: <якорь>
- DECISIONS.md: ADR-XXX (если новое решение)
```
