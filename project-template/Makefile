.PHONY: help install up down test lint typecheck security preflight ship clean

help:
	@echo "Команды project-template:"
	@echo "  make install      — установить зависимости (pip install -e .[dev])"
	@echo "  make up           — поднять Postgres + app через docker compose"
	@echo "  make down         — остановить контейнеры"
	@echo "  make test         — прогнать Escalating Test Pyramid (ступени 1-5)"
	@echo "  make lint         — ruff check"
	@echo "  make typecheck    — mypy strict"
	@echo "  make security     — bandit + detect-secrets + pip-audit"
	@echo "  make preflight    — напоминание: skill preflight-research перед кодом"
	@echo "  make ship         — /ship через Claude Code (push + PR)"
	@echo "  make clean        — почистить кеши"

install:
	pip install -e ".[dev]"

up:
	docker compose up -d
	@echo "Postgres готов на localhost:5432"
	@echo "Приложение на http://localhost:8000"

down:
	docker compose down

test: lint typecheck
	pytest tests/unit/ -v
	pytest tests/integration/ -v

lint:
	ruff check .
	ruff format --check .

typecheck:
	mypy src/

security:
	bandit -r src/
	detect-secrets scan --baseline .secrets.baseline
	pip-audit

preflight:
	@echo "Запустите skill 'preflight-research' в Claude Code перед написанием кода."
	@echo "Без свежей записи в RESEARCH_LOG.md hook заблокирует Write/Edit > 50 строк."

ship:
	@echo "Запустите /ship в Claude Code — он сделает Pyramid + push + PR."

clean:
	rm -rf __pycache__ .pytest_cache .mypy_cache .ruff_cache htmlcov .coverage
	find . -type d -name __pycache__ -exec rm -rf {} +
