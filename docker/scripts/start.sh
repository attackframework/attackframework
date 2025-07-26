#!/bin/bash
set -e

# Hardcoded path to repo-root .env
ENV_FILE="../.env"

# Detect platform and export env vars
if [ -n "$BASH_VERSION" ]; then
  # Bash-compatible (Linux, macOS, WSL, Git Bash)
  while IFS='=' read -r key value || [ -n "$key" ]; do
    key="$(echo "$key" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    value="$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    [[ -z "$key" || "$key" =~ ^# ]] && continue
    export "$key=$value"
  done < "$ENV_FILE"

elif [ -n "$PSModulePath" ]; then
  # PowerShell
  powershell.exe -NoProfile -Command "& {
    Get-Content '../.env' | ForEach-Object {
      if (\$_ -match '^\s*([A-Z0-9_]+)=(.*)$') {
        \$name = \$matches[1]
        \$value = \$matches[2] -replace '\"', ''
        [System.Environment]::SetEnvironmentVariable(\$name, \$value, 'Process')
      }
    }
  }"

elif [ -n "$COMSPEC" ]; then
  # cmd.exe
  cmd.exe /C 'for /f "tokens=1,* delims==" %a in (../.env) do set "%a=%b"'

else
  echo "Unsupported shell. Please run from Bash, PowerShell, or cmd.exe"
  exit 1
fi

# Run Docker Compose
docker compose \
  -f ./opensearch/docker-compose.yml \
  -f ./opensearch-dashboards/docker-compose.yml \
  up -d --build
