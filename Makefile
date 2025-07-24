# ================================
# Attack Framework Docker Targets
# ================================

# Config
COMPOSE_OPENSEARCH=docker-compose -f ./opensearch/docker-compose.yml
COMPOSE_DASHBOARDS=docker-compose -f ./opensearch-dashboards/docker-compose.yml
COMPOSE_ALL=$(COMPOSE_OPENSEARCH) -f ./opensearch-dashboards/docker-compose.yml

# -------------------------------
# Primary Targets
# -------------------------------

up:
	./scripts/start.sh

down:
	./scripts/stop.sh

restart:
	./scripts/restart.sh

logs:
	./scripts/logs.sh

ps:
	./scripts/status.sh

health:
	./scripts/health.sh

env:
	cat .env
