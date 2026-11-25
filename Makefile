ENV = local
SECRETS_DIR ?= envs/secrets
SECRETS_FILE := $(SECRETS_DIR)/$(ENV).env
export SECRETS_DIR

COMPOSE := docker compose -f compose.yaml -f compose.$(ENV).yaml \
	--env-file envs/$(ENV).env $(if $(wildcard $(SECRETS_FILE)),--env-file $(SECRETS_FILE))

PHPSTAN = $(COMPOSE) run --rm --no-deps app vendor/bin/phpstan analyse --memory-limit=1G

.DEFAULT_GOAL := help
.PHONY: help config build up down ps logs sh artisan composer test lint phpstan psalm format pre-commit hooks sync

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-10s %s\n", $$1, $$2}'

config: ## Validate compose files for ENV
	$(COMPOSE) config -q

build: ## Build images
	$(COMPOSE) build

up: ## Start services in the background
	$(COMPOSE) up -d

down: ## Stop services
	$(COMPOSE) down

ps: ## List services
	$(COMPOSE) ps

logs: ## Follow service logs
	$(COMPOSE) logs -f

sh: ## Open a shell in the app container
	$(COMPOSE) exec app sh

artisan: ## Run an artisan command: make artisan CMD="route:list"
	$(COMPOSE) exec app php artisan $(CMD)

composer: ## Run a Composer command: make composer CMD="require vendor/package"
	$(COMPOSE) run --rm --no-deps app composer $(CMD)

test: ## Run tests (stack must be up): make test ARGS="--filter=Health"
	$(COMPOSE) exec app vendor/bin/pest $(ARGS)

lint: ## Check code style (Pint) and run static analysis (PHPStan)
	$(COMPOSE) run --rm --no-deps app vendor/bin/pint --test
	$(PHPSTAN)

phpstan: ## Run PHPStan alone: make phpstan ARGS="app/Models --error-format=raw"
	$(PHPSTAN) $(ARGS)

psalm: ## Run Psalm, the second analyser (not part of lint): make psalm ARGS="--show-info=true"
	$(COMPOSE) run --rm --no-deps app vendor/bin/psalm $(ARGS)

format: ## Format code: make format FILES="app/Models/User.php" (default: whole project)
	$(COMPOSE) run --rm --no-deps app vendor/bin/pint $(FILES)

pre-commit: ## Run the pre-commit hook by hand: format staged PHP files, then lint
	.githooks/pre-commit

hooks: ## Enable the git hooks from .githooks (once per clone)
	git config core.hooksPath .githooks

sync: ## After a PR is merged: update main, delete local branches whose remote is gone
	git switch main
	git pull --ff-only --prune
	@git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads \
		| awk '$$2 == "[gone]" {print $$1}' \
		| while read -r branch; do \
			echo "Deleting $$branch (was $$(git rev-parse --short "$$branch"))"; \
			git branch -D "$$branch"; \
		done
