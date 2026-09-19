#!/usr/bin/env bash
# Wraps build_runner for the Flutter app.
#
# Usage:
#   bash tool/gen.sh          # one-shot build
#   bash tool/gen.sh --watch  # watch mode
#   bash tool/gen.sh watch    # watch mode (alt form)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$SCRIPT_DIR/../app"

mode="${1:-build}"

cd "$APP_DIR"

case "$mode" in
  --watch|-w|watch)
    echo "Running build_runner in watch mode..."
    dart run build_runner watch --delete-conflicting-outputs
    ;;
  build|--build|"")
    echo "Running build_runner in one-shot mode..."
    dart run build_runner build --delete-conflicting-outputs
    ;;
  *)
    echo "Unknown mode: $mode" >&2
    echo "Usage: bash tool/gen.sh [build|--watch]" >&2
    exit 1
    ;;
esac
