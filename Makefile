# ================================
# Attack Framework Root Makefile
# ================================

.DEFAULT_GOAL := help

# -------------------------------
# Docker Targets
# -------------------------------

docker-up:
	$(MAKE) -C docker up

docker-down:
	$(MAKE) -C docker down

docker-restart:
	$(MAKE) -C docker restart

docker-logs:
	$(MAKE) -C docker logs

docker-ps:
	$(MAKE) -C docker ps

docker-health:
	$(MAKE) -C docker health

docker-env:
	$(MAKE) -C docker env

# -------------------------------
# Kubernetes Targets (placeholder)
# -------------------------------

k8s-up:
	$(MAKE) -C k8s up

k8s-down:
	$(MAKE) -C k8s down

# -------------------------------
# Help
# -------------------------------

help:
	@echo ""
	@echo "Available targets:"
	@echo ""
	@echo "  docker-up           Start Docker containers"
	@echo "  docker-down         Stop Docker containers"
	@echo "  docker-restart      Restart Docker containers"
	@echo "  docker-logs         Tail Docker logs"
	@echo "  docker-ps           Show Docker container status"
	@echo "  docker-health       Check OpenSearch cluster health"
	@echo "  docker-env          Show resolved .env"
	@echo ""
	@echo "  k8s-up              (placeholder) Start K8s resources"
	@echo "  k8s-down            (placeholder) Tear down K8s resources"
	@echo ""
	@echo "Usage:"
	@echo "  make docker-up"
	@echo "  make k8s-up"
	@echo ""
