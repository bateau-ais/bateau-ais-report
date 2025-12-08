.PHONY: help sync install test lint format clean docker-build docker-up docker-down

# Couleurs pour l'affichage
BLUE := \033[0;34m
NC := \033[0m # No Color

help: ## Affiche cette aide
	@echo "$(BLUE)Commandes disponibles:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(BLUE)%-20s$(NC) %s\n", $$1, $$2}'

sync: ## Synchronise les dépendances avec uv (dev)
	uv sync --all-extras

install: ## Synchronise les dépendances de production uniquement
	uv sync --no-dev

lock: ## Met à jour le fichier uv.lock
	uv lock

test: ## Lance les tests
	uv run pytest

test-cov: ## Lance les tests avec couverture
	uv run pytest --cov=app --cov-report=html --cov-report=term

lint: ## Lance le linting (ruff + mypy)
	uv run ruff check app/
	uv run mypy app/

format: ## Formate le code avec Black et Ruff
	uv run ruff check --fix app/
	uv run ruff format app/

clean: ## Nettoie les fichiers temporaires
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
	rm -rf build/ dist/ htmlcov/ .coverage .venv/

docker-build: ## Build l'image Docker de production
	docker build --target prod -t bateau-ais-module:latest .

docker-build-dev: ## Build l'image Docker de développement
	docker build --target dev -t bateau-ais-module:dev .

docker-up: ## Démarre les conteneurs avec docker-compose
	docker compose up

docker-up-d: ## Démarre les conteneurs en arrière-plan
	docker compose up -d

docker-down: ## Arrête les conteneurs
	docker compose down

docker-logs: ## Affiche les logs des conteneurs
	docker compose logs -f

run: ## Lance le module localement
	uv run python -m app.main
