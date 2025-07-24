@echo off
setlocal enabledelayedexpansion

:: Load .env variables
for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
  set "%%a=%%b"
)

:: Run Docker Compose with those env vars
docker compose ^
  -f opensearch\docker-compose.yml ^
  -f opensearch-dashboards\docker-compose.yml ^
  up -d --build
