COMPOSE?=docker compose
PROJECT?=

.PHONY: up down ps logs build health check clean reset

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down -v

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f --tail=200

build:
	$(COMPOSE) build --no-cache

health:
	curl -s http://api.localhost/healthz | jq . || true
	curl -s http://api.localhost/db | jq . || true
	curl -s http://api.localhost/cache | jq . || true

check:
	sh scripts/check.sh

clean:
	@PROJECT=$(PROJECT) COMPOSE=$(COMPOSE) sh scripts/clean.sh

reset: clean up

