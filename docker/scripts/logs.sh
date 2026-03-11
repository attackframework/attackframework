#!/bin/bash
set -e

ENV_FILE="../.env"
while IFS='=' read -r key value || [ -n "$key" ]; do
  key="$(echo "$key" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  value="$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  [[ -z "$key" || "$key" =~ ^# ]] && continue
  export "$key=$value"
done < "$ENV_FILE"

docker compose \
  -f ./opensearch/docker-compose.yml \
  -f ./opensearch-dashboards/docker-compose.yml \
  logs -f
