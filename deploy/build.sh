#!/usr/bin/env bash
# Builds the API (apps/api) and the Flutter web app (app/) for production.
# Usage: deploy/build.sh [--api-only|--app-only]
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TARGET="${1:-all}"

build_api() {
  echo "==> Installing workspace dependencies"
  pnpm install --frozen-lockfile

  echo "==> Building API (apps/api)"
  pnpm --filter api build
}

build_app() {
  if ! command -v flutter >/dev/null 2>&1; then
    echo "error: flutter not found on PATH" >&2
    exit 1
  fi

  echo "==> Building Flutter web app (app/)"
  pushd app >/dev/null
  flutter pub get
  flutter build web --release
  popd >/dev/null
}

case "$TARGET" in
  --api-only)
    build_api
    ;;
  --app-only)
    build_app
    ;;
  all)
    build_api
    build_app
    ;;
  *)
    echo "unknown argument: $TARGET (expected --api-only, --app-only, or no argument)" >&2
    exit 1
    ;;
esac

echo "==> Build complete"
