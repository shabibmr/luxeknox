#!/usr/bin/env bash
# Deploys LuxeKnox: pulls latest, builds API + Flutter web, runs migrations,
# syncs the API (dist + prod deps) to its deploy dir, syncs the web build to
# Apache's docroot, and (re)starts the pm2 process from the API deploy dir.
#
# Requires: pnpm, flutter, pm2, rsync, sudo rights for the www-data sync/reload steps.
# Env overrides: API_PORT (default 3010), API_DEPLOY_DIR (default /var/www/luxeknox-api),
#                APP_DEPLOY_DIR (default /var/www/html/luxeknox-app),
#                PM2_APP_NAME (default luxeknox-api), SKIP_MIGRATE=1, SKIP_APP=1
# The API's production .env must exist at $API_DEPLOY_DIR/.env (never overwritten by deploys).
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

API_PORT="${API_PORT:-3010}"
API_DEPLOY_DIR="${API_DEPLOY_DIR:-/var/www/luxeknox-api}"
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

echo "==> Syncing API to $API_DEPLOY_DIR"
sudo mkdir -p "$API_DEPLOY_DIR"
sudo chown "$(id -u):$(id -g)" "$API_DEPLOY_DIR"
if [ ! -f "$API_DEPLOY_DIR/.env" ]; then
  echo "error: $API_DEPLOY_DIR/.env is missing; create it (see apps/api/.env.example) and re-run" >&2
  exit 1
fi
STAGE_DIR="$(mktemp -d)/api"
trap 'rm -rf "$(dirname "$STAGE_DIR")"' EXIT
pnpm --filter api deploy --prod "$STAGE_DIR"
rsync -a --delete --exclude '/.env' "$STAGE_DIR/" "$API_DEPLOY_DIR/"

echo "==> Restarting API via pm2"
export API_PORT API_DEPLOY_DIR
# pm2 keeps a process's original cwd across reloads, so recreate it if the deploy dir changed.
if pm2 describe "$PM2_APP_NAME" >/dev/null 2>&1; then
  CURRENT_CWD="$(pm2 jlist | node -e "const l=JSON.parse(require('fs').readFileSync(0,'utf8'));const p=l.find(x=>x.name==='$PM2_APP_NAME');console.log(p?p.pm2_env.pm_cwd:'')")"
  if [ "$CURRENT_CWD" = "$API_DEPLOY_DIR" ]; then
    pm2 reload "$PM2_APP_NAME" --update-env
  else
    pm2 delete "$PM2_APP_NAME"
    pm2 start "$ROOT_DIR/deploy/ecosystem.config.js"
  fi
else
  pm2 start "$ROOT_DIR/deploy/ecosystem.config.js"
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
