#!/bin/sh
set -e
TEMPLATE="${OPENSEARCH_DASHBOARDS_CONFIG_TEMPLATE:-/templates/opensearch_dashboards.yml}"
CONF_DIR="/usr/share/opensearch-dashboards/config"

# Substitute env vars from .env so no hardcoded bind/ports in the file
envsubst < "$TEMPLATE" > "$CONF_DIR/opensearch_dashboards.yml"

cd /usr/share/opensearch-dashboards
exec ./opensearch-dashboards-docker-entrypoint.sh "$@"
