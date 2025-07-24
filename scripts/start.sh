#!/bin/bash
set -e

# Detect platform/shell and export .env variables accordingly
if [ -n "$BASH_VERSION" ]; then
  # Bash-compatible (Linux, macOS, WSL, Git Bash)
  while IFS='=' read -r key value || [ -n "$key" ]; do
    key="$(echo "$key" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    value="$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

    # Skip blank lines or comments
    [[ -z "$key" || "$key" =~ ^# ]] && continue

    export "$key=$value"
  done < .env

elif [ -n "$PSModulePath" ] && [ "$(uname -o 2>/dev/null)" != "GNU/Linux" ]; then
  # PowerShell on Windows detected
  powershell.exe -NoProfile -Command "& {
    Get-Content .env | ForEach-Object {
      if (\$_ -match '^\s*([A-Z0-9_]+)=(.*)$') {
        \$name = \$matches[1]
        \$value = \$matches[2] -replace '\"', ''
        [System.Environment]::SetEnvironmentVariable(\$name, \$value, 'Process')
      }
    }
  }"

elif [ "$(uname -s | cut -c1-5)" = "MINGW" ] && [ -n "$COMSPEC" ]; then
  # cmd.exe via MSYS Git Bash
  cmd.exe /C 'for /f "tokens=1,* delims==" %a in (.env) do set "%a=%b"'

else
  echo "Unsupported shell. Please run this script from Bash, PowerShell, or cmd.exe (via Git Bash)."
  exit 1
fi

# Run Docker Compose
docker compose \
  -f ./opensearch/docker-compose.yml \
  -f ./opensearch-dashboards/docker-compose.yml \
  up -d --build
