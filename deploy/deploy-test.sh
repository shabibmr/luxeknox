#!/usr/bin/env bash
# Deploys a git branch to the TEST area:
#   app: https://app.luxeknox.com/test/   api: https://api.luxeknox.com/test/   db: luxeknox_test
# Usage: deploy/deploy-test.sh <branch|tag|sha> [--api-only|--app-only]
# Env:   SEED=1 runs `db:seed` after migrating; RESET_DB=1 drops+recreates luxeknox_test first.
#
# Works on a dedicated clone ($TEST_DIR), never the production checkout.
# The test API's env lives at $TEST_API_DIR/.env (never overwritten).
# The app is built with ENV=staging: it reads Firestore config/app `API_BASE_URL_DEBUG`
# (falling back to the --dart-define URL below). Branches need that code (merge main).
set -euo pipefail

REF="${1:?usage: deploy/deploy-test.sh <branch|tag|sha> [--api-only|--app-only]}"
TARGET="${2:-all}"

TEST_DIR="${TEST_DIR:-/home/luxe/luxeknox-test}"
TEST_API_DIR="${TEST_API_DIR:-/var/www/luxeknox-api-test}"
TEST_APP_DIR="${TEST_APP_DIR:-/var/www/html/luxeknox-app-test}"
TEST_API_PORT="${TEST_API_PORT:-3011}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[ -f "$TEST_API_DIR/.env" ] || { echo "error: $TEST_API_DIR/.env missing" >&2; exit 1; }
grep -q '^DB_NAME=luxeknox_test$' "$TEST_API_DIR/.env" || { echo "error: $TEST_API_DIR/.env must use DB_NAME=luxeknox_test" >&2; exit 1; }

cd "$TEST_DIR"
echo "==> Checking out $REF"
git fetch --prune origin
git reset -q --hard
if git rev-parse -q --verify "refs/remotes/origin/$REF" >/dev/null; then
  git checkout -q -B "$REF" "origin/$REF"
else
  git checkout -q --detach "$REF"
fi
git log --oneline -1

if [ "$TARGET" != "--app-only" ]; then
  echo "==> Building API"
  pnpm install --frozen-lockfile
  pnpm --filter api build

  cp "$TEST_API_DIR/.env" apps/api/.env
  if [ "${RESET_DB:-0}" = "1" ]; then
    echo "==> Resetting luxeknox_test"
    (set -a; . "$TEST_API_DIR/.env"; set +a
     mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_ADMIN_USER" -p"$DB_ADMIN_PASSWORD" \
       -e "DROP DATABASE IF EXISTS luxeknox_test; CREATE DATABASE luxeknox_test CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci")
  fi
  echo "==> Migrating luxeknox_test"
  pnpm --filter api db:migrate
  if [ "${SEED:-0}" = "1" ]; then
    echo "==> Seeding luxeknox_test"
    pnpm --filter api db:seed
  fi

  echo "==> Syncing API to $TEST_API_DIR"
  STAGE_DIR="$(mktemp -d)/api"
  trap 'rm -rf "$(dirname "$STAGE_DIR")"' EXIT
  pnpm --filter api deploy --prod "$STAGE_DIR"
  rsync -a --delete --exclude '/.env' "$STAGE_DIR/" "$TEST_API_DIR/"

  echo "==> Restarting test API via pm2"
  if pm2 describe luxeknox-api-test >/dev/null 2>&1; then
    pm2 reload luxeknox-api-test --update-env
  else
    TEST_API_DEPLOY_DIR="$TEST_API_DIR" TEST_API_PORT="$TEST_API_PORT" pm2 start "$SCRIPT_DIR/ecosystem.test.config.js"
  fi
  pm2 save
fi

if [ "$TARGET" != "--api-only" ]; then
  command -v flutter >/dev/null || { echo "error: flutter not found on PATH" >&2; exit 1; }
  echo "==> Building Flutter web (base /test/, API https://api.luxeknox.com/test)"
  pushd app >/dev/null
  flutter pub get
  flutter build web --release --base-href /test/ \
    --dart-define=API_BASE_URL=https://api.luxeknox.com/test \
    --dart-define=ENV=staging
  popd >/dev/null

  echo "==> Syncing web build to $TEST_APP_DIR"
  mkdir -p "$TEST_APP_DIR"
  rsync -a --delete app/build/web/ "$TEST_APP_DIR/"
  chown -R www-data:www-data "$TEST_APP_DIR"
fi

echo "==> Test deploy complete ($REF)"
echo "    App: https://app.luxeknox.com/test/   API: https://api.luxeknox.com/test/v1/"
