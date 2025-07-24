#!/bin/bash
set -e
source .env

docker compose \
  -f ./opensearch/docker-compose.yml \
  -f ./opensearch-dashboards/docker-compose.yml \
  down
