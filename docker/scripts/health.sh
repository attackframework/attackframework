#!/bin/bash
set -e

ENV_FILE="../.env"
while IFS='=' read -r key value || [ -n "$key" ]; do
  key="$(echo "$key" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  value="$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  [[ -z "$key" || "$key" =~ ^# ]] && continue
  export "$key=$value"
done < "$ENV_FILE"

# OpenSearch is served over HTTPS (Phase 1). -k accepts self-signed cert.
# For secured clusters, unauthenticated health returns 401 (service reachable).
OS_CODE="$(curl -sk -o /dev/null -w '%{http_code}' "https://${OPENSEARCH_PUBLISH_HOST}:${OPENSEARCH_PORT:-9200}/_cluster/health" || true)"
if [ "$OS_CODE" != "200" ] && [ "$OS_CODE" != "401" ]; then
  echo "OpenSearch health check failed (HTTP ${OS_CODE:-000})."
  exit 1
fi
echo "OpenSearch reachable (HTTP ${OS_CODE})."

# Dashboards reachability check (no auth assumption here).
DB_CODE="$(curl -sk -o /dev/null -w '%{http_code}' "https://${OPENSEARCH_PUBLISH_HOST}:${OPENSEARCH_DASHBOARDS_PORT:-5601}" || true)"
if [ "$DB_CODE" != "200" ] && [ "$DB_CODE" != "302" ] && [ "$DB_CODE" != "401" ]; then
  echo "Dashboards check failed (HTTP ${DB_CODE:-000})."
  echo "Tip: if Dashboards is still starting, retry in a few seconds."
  exit 1
fi
echo "Dashboards reachable (HTTP ${DB_CODE})."
