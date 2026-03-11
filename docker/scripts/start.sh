#!/bin/bash
set -e

# Hardcoded path to repo-root .env (relative to docker/ when run via make docker-up)
ENV_FILE="../.env"

# Load .env and export for docker compose (Bash path; other shells may not persist exports)
if [ -n "$BASH_VERSION" ]; then
  while IFS='=' read -r key value || [ -n "$key" ]; do
    key="$(echo "$key" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    value="$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    [[ -z "$key" || "$key" =~ ^# ]] && continue
    export "$key=$value"
  done < "$ENV_FILE"
else
  echo "Start script expects Bash (e.g. Git Bash on Windows)."
  exit 1
fi

# Ensure persistent dirs exist
CERTS_DIR="${DATA_VOLUME_ROOT}/certs"
DATA_DIR="${DATA_VOLUME_ROOT}/opensearch/data"
mkdir -p "$CERTS_DIR"
mkdir -p "$DATA_DIR"

# First start = OpenSearch data dir has not been initialized yet.
# This is a better signal for password bootstrap than cert presence.
FIRST_START=false
if [ ! -d "${DATA_DIR}/nodes" ]; then
  FIRST_START=true
fi

# Console colors (yellow prompts stand out in noisy startup logs)
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

print_prompt() {
  echo -e "${YELLOW}$1${RESET}"
}

print_error() {
  echo -e "${RED}$1${RESET}"
}

read_password_with_asterisks() {
  local pw=""
  local char=""
  while true; do
    IFS= read -r -s -n 1 char || true
    case "$char" in
      $'\n'|$'\r'|'')
        echo ""
        PASSWORD_INPUT="$pw"
        return 0
        ;;
      $'\177'|$'\b')
        if [ -n "$pw" ]; then
          pw="${pw%?}"
          echo -ne "\b \b"
        fi
        ;;
      *)
        pw+="$char"
        echo -n "*"
        ;;
    esac
  done
}

wait_opensearch_reachable() {
  # Poll quickly and proceed immediately when reachable.
  local max_wait=90
  local interval=1
  local elapsed=0
  local code=""
  while [ $elapsed -lt $max_wait ]; do
    code="$(curl -sk --connect-timeout 2 --max-time 4 -o /dev/null -w '%{http_code}' "https://${OPENSEARCH_PUBLISH_HOST}:${OPENSEARCH_PORT:-9200}/_cluster/health" || true)"
    if [ "$code" = "200" ] || [ "$code" = "401" ]; then
      return 0
    fi
    sleep $interval
    elapsed=$((elapsed + interval))
  done
  return 1
}

prompt_password() {
  local prompt_msg="$1"
  while true; do
    print_prompt "$prompt_msg"
    read_password_with_asterisks
    if [ -n "$PASSWORD_INPUT" ]; then
      return 0
    fi
    print_error "Password cannot be empty. Try again."
  done
}

validate_admin_password() {
  local pw="$1"
  local code
  code=$(curl -sk -u "admin:${pw}" -o /dev/null -w '%{http_code}' "https://${OPENSEARCH_PUBLISH_HOST}:${OPENSEARCH_PORT:-9200}/_cluster/health")
  [ "$code" = "200" ]
}

cleanup_runtime_passwords() {
  unset OPENSEARCH_INITIAL_ADMIN_PASSWORD
  unset OPENSEARCH_DASHBOARDS_PASSWORD
}
trap cleanup_runtime_passwords EXIT

if [ "$FIRST_START" = true ]; then
  prompt_password "First run detected. Enter initial OpenSearch admin password (save this for future runs):"
  export OPENSEARCH_INITIAL_ADMIN_PASSWORD="$PASSWORD_INPUT"
  export OPENSEARCH_DASHBOARDS_PASSWORD="$PASSWORD_INPUT"
  print_prompt "OpenSearch stores only the hash. Dashboards authenticates to OpenSearch using this credential."
  print_prompt "Change password docs: https://opensearch.org/docs/latest/security/access-control/users-passwords/#change-passwords"

  docker compose \
    -f ./opensearch/docker-compose.yml \
    -f ./opensearch-dashboards/docker-compose.yml \
    up -d --build opensearch

  print_prompt "Waiting for OpenSearch to become reachable..."
  if ! wait_opensearch_reachable; then
    print_error "OpenSearch did not become reachable in time."
    exit 1
  fi

  if ! validate_admin_password "$OPENSEARCH_INITIAL_ADMIN_PASSWORD"; then
    print_error "Initial password validation failed after bootstrap. Aborting start."
    exit 1
  fi

  docker compose \
    -f ./opensearch/docker-compose.yml \
    -f ./opensearch-dashboards/docker-compose.yml \
    up -d --build opensearch-dashboards
else
  docker compose \
    -f ./opensearch/docker-compose.yml \
    -f ./opensearch-dashboards/docker-compose.yml \
    up -d --build opensearch

  print_prompt "Waiting for OpenSearch to become reachable..."
  if ! wait_opensearch_reachable; then
    print_error "OpenSearch did not become reachable in time."
    exit 1
  fi

  MAX_PASSWORD_ATTEMPTS="${MAX_PASSWORD_ATTEMPTS:-3}"
  ATTEMPT=1
  while [ "$ATTEMPT" -le "$MAX_PASSWORD_ATTEMPTS" ]; do
    prompt_password "Enter OpenSearch admin password for this run:"
    if validate_admin_password "$PASSWORD_INPUT"; then
      export OPENSEARCH_DASHBOARDS_PASSWORD="$PASSWORD_INPUT"
      break
    fi
    if [ "$ATTEMPT" -lt "$MAX_PASSWORD_ATTEMPTS" ]; then
      print_error "Invalid password. Please try again. (${ATTEMPT}/${MAX_PASSWORD_ATTEMPTS})"
    else
      print_error "Invalid password. Reached max attempts (${MAX_PASSWORD_ATTEMPTS}). Aborting start."
      exit 1
    fi
    ATTEMPT=$((ATTEMPT + 1))
  done

  docker compose \
    -f ./opensearch/docker-compose.yml \
    -f ./opensearch-dashboards/docker-compose.yml \
    up -d --build opensearch-dashboards
fi
