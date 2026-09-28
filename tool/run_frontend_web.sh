#!/usr/bin/env bash
# Runs the Flutter frontend app on Chrome with the local backend URL and redirects logs.
#
# Usage:
#   bash tool/run_frontend_web.sh                       # Runs on port 8080, logs to app/logs/frontend-web.log
#   bash tool/run_frontend_web.sh --port 8080           # Custom web port
#   bash tool/run_frontend_web.sh --api-url http://...  # Custom backend URL
#   bash tool/run_frontend_web.sh --detach              # Run in background
#   bash tool/run_frontend_web.sh --log-file PATH       # Custom log file path

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="$ROOT_DIR/app"

WEB_PORT=8080
API_BASE_URL="http://localhost:3000/v1"
DETACH=0
LOG_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --port|-p)
      WEB_PORT="$2"
      shift 2
      ;;
    --api-url|-u)
      API_BASE_URL="$2"
      shift 2
      ;;
    --detach|-d)
      DETACH=1
      shift
      ;;
    --log-file|-l)
      LOG_FILE="$2"
      shift 2
      ;;
    --help|-h)
      sed -n '2,10p' "$0"
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      echo "Usage: bash tool/run_frontend_web.sh [--port PORT] [--api-url URL] [--detach] [--log-file PATH]" >&2
      exit 1
      ;;
  esac
done

if ! command -v flutter >/dev/null 2>&1; then
  echo "error: flutter not found on PATH" >&2
  exit 1
fi

LOG_DIR="$APP_DIR/logs"
mkdir -p "$LOG_DIR"

if [[ -z "$LOG_FILE" ]]; then
  LOG_FILE="$LOG_DIR/frontend-web.log"
elif [[ "$LOG_FILE" != /* ]]; then
  LOG_FILE="$ROOT_DIR/$LOG_FILE"
fi

mkdir -p "$(dirname "$LOG_FILE")"

cd "$APP_DIR"

echo "=========================================================="
echo " Starting Flutter Web App"
echo " Web Port:    $WEB_PORT (http://localhost:$WEB_PORT)"
echo " Backend URL: $API_BASE_URL"
echo " Log File:    $LOG_FILE"
echo " Watch logs:  tail -f \"$LOG_FILE\""
echo "=========================================================="

echo "==== flutter run started at $(date -u +%Y-%m-%dT%H:%M:%SZ) ====" >> "$LOG_FILE"

FLUTTER_CMD=(
  flutter run
  -d chrome
  --web-port="$WEB_PORT"
  --dart-define="API_BASE_URL=$API_BASE_URL"
)

if [[ "$DETACH" -eq 1 ]]; then
  nohup "${FLUTTER_CMD[@]}" >> "$LOG_FILE" 2>&1 &
  PID=$!
  echo "Started in background with PID: $PID"
  echo "To watch logs:"
  echo "  tail -f \"$LOG_FILE\""
  echo "To stop:"
  echo "  kill $PID"
else
  # Foreground mode: tee output to console and log file
  "${FLUTTER_CMD[@]}" 2>&1 | tee -a "$LOG_FILE"
fi
