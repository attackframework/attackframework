#!/bin/bash
docker compose \
  -f ./opensearch/docker-compose.yml \
  -f ./opensearch-dashboards/docker-compose.yml \
  ps
