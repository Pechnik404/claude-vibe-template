# Slash-command: /ship

> **Назначение**: одной командой провести фичу от готового кода до открытого PR.

## Что делает

1. Проверяет что вы в feature-ветке (не main)
2. Проверяет наличие записи в `RESEARCH_LOG.md` за последние 24 часа
3. Запускает Escalating Test Pyramid (skill `escalating-test-pyramid`) — ступени 1-5
4. Если всё зелёное — `git push origin <branch>`
5. Создаёт PR через `gh pr create` с заполненным `.github/PR_TEMPLATE.md`
6. Запускает `code-reviewer-ru` агента, прикрепляет рецензию комментарием к PR
7. Печатает отчёт по skill `report12-ru` с ссылкой на PR
8. **НЕ нажимает Merge.** Это вы делаете сами в UI GitHub.

## Аргументы (необязательные)

- `--skip-tests` — пропустить тесты (только в экстренных случаях, требует подтверждения)
- `--draft` — создать PR как draft (не готов к ревью)
- `--no-review` — пропустить автоматическое ревью

## Стоп-условия

- Ветка = main/master → СТОП
- Нет записи в RESEARCH_LOG → СТОП + подсказка запустить `/preflight`
- Любая ступень Pyramid упала → СТОП + отчёт об ошибке
- `detect-secrets` нашёл секрет → СТОП + список найденного

## Пример успешного выполнения

```
/ship
[1/8] ✅ Ветка feat/users-list
[2/8] ✅ Research-запись найдена (2026-05-23 14:30)
[3/8] ⏳ Escalating Test Pyramid...
       ✅ ruff/mypy
       ✅ unit 47 passed
       ✅ smoke OK
       ✅ migrations N/A
       ✅ integration 12 passed
[4/8] ✅ Push в origin/feat/users-list
[5/8] ✅ PR #42 создан
[6/8] ⏳ Code review...
       🟡 2 рекомендации, 0 блокеров
[7/8] Отчёт report12-ru:
       <см. ниже>
[8/8] PR https://github.com/.../pull/42 готов к merge
       Вы нажимаете Merge сами в UI.
```
