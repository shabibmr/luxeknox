#!/usr/bin/env bash
# Run Flutter on Microsoft Edge and write logs to a temporary file

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$SCRIPT_DIR/pubspec.yaml" ]]; then
  APP_DIR="$SCRIPT_DIR"
elif [[ -f "$SCRIPT_DIR/../app/pubspec.yaml" ]]; then
  APP_DIR="$(cd "$SCRIPT_DIR/../app" && pwd)"
elif [[ -f "$SCRIPT_DIR/app/pubspec.yaml" ]]; then
  APP_DIR="$(cd "$SCRIPT_DIR/app" && pwd)"
else
  APP_DIR="$(pwd)"
fi

TEMP_LOG="$(mktemp -t flutter_edge_XXXXXX.log 2>/dev/null || mktemp "${TMPDIR:-/tmp}/flutter_edge_XXXXXX.log" 2>/dev/null || echo "${TEMP:-/tmp}/flutter_edge_$(date +%Y%m%d_%H%M%S).log")"
touch "$TEMP_LOG"

echo "=================================================="
echo " Starting Flutter app on device: Edge"
echo " Working Directory: $APP_DIR"
echo " Temp Log File:     $TEMP_LOG"
echo "=================================================="

cd "$APP_DIR"

echo "==== flutter run started at $(date -u +%Y-%m-%dT%H:%M:%SZ) ====" >> "$TEMP_LOG"

# Run flutter app and stream stdout & stderr to both terminal and temp log file
flutter run -d Edge "$@" 2>&1 | tee -a "$TEMP_LOG"

echo ""
echo "Logs saved to: $TEMP_LOG"
