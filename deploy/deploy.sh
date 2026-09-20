#!/usr/bin/env bash
# Deploys LuxeKnox: pulls latest, builds API + Flutter web, runs migrations,
# syncs the web build to Apache's docroot, and (re)starts the pm2 process.
#
# Requires: pnpm, flutter, pm2, rsync, sudo rights for the www-data sync/reload steps.
# Env overrides: API_PORT (default 3010), APP_DEPLOY_DIR (default /var/www/html/luxeknox-app),
#                PM2_APP_NAME (default luxeknox-api), SKIP_MIGRATE=1, SKIP_APP=1
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

API_PORT="${API_PORT:-3010}"
APP_DEPLOY_DIR="${APP_DEPLOY_DIR:-/var/www/html/luxeknox-app}"
PM2_APP_NAME="${PM2_APP_NAME:-luxeknox-api}"

echo "==> Pulling latest changes"
git pull --ff-only

if [ "${SKIP_APP:-0}" = "1" ]; then
  "$ROOT_DIR/deploy/build.sh" --api-only
else
  "$ROOT_DIR/deploy/build.sh"
fi

if [ "${SKIP_MIGRATE:-0}" != "1" ]; then
  echo "==> Running database migrations"
  pnpm --filter api db:migrate
fi

echo "==> Restarting API via pm2"
if pm2 describe "$PM2_APP_NAME" >/dev/null 2>&1; then
  API_PORT="$API_PORT" pm2 reload "$PM2_APP_NAME" --update-env
else
  API_PORT="$API_PORT" pm2 start "$ROOT_DIR/deploy/ecosystem.config.js"
fi
pm2 save

if [ "${SKIP_APP:-0}" != "1" ]; then
  echo "==> Syncing Flutter web build to $APP_DEPLOY_DIR"
  sudo mkdir -p "$APP_DEPLOY_DIR"
  sudo rsync -a --delete "$ROOT_DIR/app/build/web/" "$APP_DEPLOY_DIR/"
  sudo chown -R www-data:www-data "$APP_DEPLOY_DIR"
fi

echo "==> Reloading Apache"
sudo apache2ctl configtest
sudo systemctl reload apache2

echo "==> Deploy complete"
echo "    API:  pm2 describe $PM2_APP_NAME"
echo "    Logs: pm2 logs $PM2_APP_NAME"
