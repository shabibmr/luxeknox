#!/usr/bin/env bash
# Builds the Nest API backend (apps/api), then starts it in the foreground.
#
# Usage:
#   bash tool/build_backend.sh              # build, then pnpm --filter api start:dev
#   bash tool/build_backend.sh --install    # frozen-lockfile install, build, then start:dev
#   bash tool/build_backend.sh --build-only # build only (no start)
#   bash tool/build_backend.sh --typecheck
#   bash tool/build_backend.sh --log-file PATH
#
# Build stdout/stderr are tee'd to apps/api/logs/backend-<mode>-<timestamp>.log
# (or --log-file). Equivalent build-only: pnpm backend:build | deploy/build.sh --api-only

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DO_INSTALL=0
MODE=run
LOG_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --install|-i)
      DO_INSTALL=1
      shift
      ;;
    --build-only|-b)
      MODE=build
      shift
      ;;
    --typecheck|-t)
      MODE=typecheck
      shift
      ;;
    --log-file)
      if [[ $# -lt 2 || "$2" == -* ]]; then
        echo "error: --log-file requires a path argument" >&2
        exit 1
      fi
      LOG_FILE="$2"
      shift 2
      ;;
    --log-file=*)
      LOG_FILE="${1#--log-file=}"
      shift
      ;;
    --help|-h)
      sed -n '2,13p' "$0"
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      echo "Usage: bash tool/build_backend.sh [--install] [--build-only] [--typecheck] [--log-file PATH]" >&2
      exit 1
      ;;
  esac
done

if ! command -v pnpm >/dev/null 2>&1; then
  echo "error: pnpm not found on PATH" >&2
  exit 1
fi

LOG_DIR="$ROOT_DIR/apps/api/logs"
mkdir -p "$LOG_DIR"

if [[ -z "$LOG_FILE" ]]; then
  stamp="$(date +%Y%m%d-%H%M%S)"
  LOG_FILE="$LOG_DIR/backend-${MODE}-${stamp}.log"
elif [[ "$LOG_FILE" != /* ]]; then
  LOG_FILE="$ROOT_DIR/$LOG_FILE"
fi

mkdir -p "$(dirname "$LOG_FILE")"

run_logged() {
  {
    echo "==== $(date -u +%Y-%m-%dT%H:%M:%SZ) :: $*"
    "$@"
  } 2>&1 | tee -a "$LOG_FILE"
  return "${PIPESTATUS[0]}"
}

{
  echo "==== backend $MODE start $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "cwd: $ROOT_DIR"
  echo "log: $LOG_FILE"
  echo "install: $DO_INSTALL"
} | tee "$LOG_FILE"

status=0

if [[ "$DO_INSTALL" -eq 1 ]]; then
  echo "==> Installing workspace dependencies (frozen lockfile)" | tee -a "$LOG_FILE"
  if ! run_logged pnpm install --frozen-lockfile; then
    status=$?
  fi
fi

if [[ "$status" -eq 0 ]]; then
  case "$MODE" in
    typecheck)
      echo "==> Typechecking API (apps/api)" | tee -a "$LOG_FILE"
      if ! run_logged pnpm --filter api typecheck; then
        status=$?
      fi
      ;;
    build)
      echo "==> Building API (apps/api)" | tee -a "$LOG_FILE"
      if ! run_logged pnpm --filter api build; then
        status=$?
      fi
      ;;
    run)
      echo "==> Building API (apps/api)" | tee -a "$LOG_FILE"
      if ! run_logged pnpm --filter api build; then
        status=$?
      else
        echo "==> Starting API (start:dev) on :3000" | tee -a "$LOG_FILE"
        echo "    health: http://127.0.0.1:3000/v1/health" | tee -a "$LOG_FILE"
        # Foreground; Ctrl+C stops the server. Tee keeps the same log file.
        if ! run_logged pnpm --filter api start:dev; then
          status=$?
        fi
      fi
      ;;
  esac
fi

if [[ "$status" -eq 0 ]]; then
  echo "==> Backend $MODE complete" | tee -a "$LOG_FILE"
  if [[ "$MODE" == build || "$MODE" == run ]] && [[ -f apps/api/dist/main.js ]]; then
    echo "    output: apps/api/dist/" | tee -a "$LOG_FILE"
  fi
else
  echo "==> Backend $MODE failed (exit $status)" | tee -a "$LOG_FILE" >&2
fi

echo "    log: $LOG_FILE" | tee -a "$LOG_FILE"
exit "$status"
