ENV = local
SECRETS_DIR ?= $(HOME)/.config/car_agent
SECRETS_FILE := $(SECRETS_DIR)/$(ENV).env

COMPOSE := docker compose -f compose.yaml -f compose.$(ENV).yaml \
	--env-file envs/$(ENV).env $(if $(wildcard $(SECRETS_FILE)),--env-file $(SECRETS_FILE))

.DEFAULT_GOAL := help
.PHONY: help config up down ps logs sh test lint fmt

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-10s %s\n", $$1, $$2}'

config: ## Validate compose files for ENV
	$(COMPOSE) config -q

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

test: ## Run tests
	@echo "test: not configured yet" >&2; exit 1

lint: ## Run linters and static analysis
	@echo "lint: not configured yet" >&2; exit 1

fmt: ## Format code
	@echo "fmt: not configured yet" >&2; exit 1
