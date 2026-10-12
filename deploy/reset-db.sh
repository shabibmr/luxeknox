#!/usr/bin/env bash
# DESTRUCTIVE: drops and recreates the LuxeKnox database, then re-applies every migration and the seed.
#
# Use only on servers with no real data. Needed after migrations that were edited in place
# (e.g. 0006_memberships.sql, 0020_personal_training.sql): migrate.ts tracks applied migrations
# by file name, so an edited file is never re-run against a DB that already applied it.
#
# Steps: stop pm2 app -> mysqldump backup -> DROP/CREATE DB -> db:migrate -> db:seed -> db:check -> start pm2 app.
#
# Reads DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_ADMIN_USER, DB_ADMIN_PASSWORD, BOOTSTRAP_ADMIN_* from
# $API_ENV_FILE (default $API_DEPLOY_DIR/.env). DB_ADMIN_* must be able to DROP/CREATE DATABASE and GRANT.
#
# Usage:  deploy/reset-db.sh            # asks you to type the DB name to confirm
#         deploy/reset-db.sh --yes      # no prompt (CI / scripted use)
# Env overrides: API_DEPLOY_DIR (default /var/www/luxeknox-api), API_ENV_FILE, PM2_APP_NAME (default
#                luxeknox-api), BACKUP_DIR (default ~/luxeknox-db-backups), SKIP_BACKUP=1, SKIP_PM2=1
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

API_DEPLOY_DIR="${API_DEPLOY_DIR:-/var/www/luxeknox-api}"
API_ENV_FILE="${API_ENV_FILE:-$API_DEPLOY_DIR/.env}"
PM2_APP_NAME="${PM2_APP_NAME:-luxeknox-api}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/luxeknox-db-backups}"

[ -f "$API_ENV_FILE" ] || { echo "error: env file not found: $API_ENV_FILE" >&2; exit 1; }

# Exported so migrate/seed (dotenv does not override existing vars) use the server's values.
set -a
# shellcheck disable=SC1090
. "$API_ENV_FILE"
set +a

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
: "${DB_NAME:?DB_NAME missing in $API_ENV_FILE}"
: "${DB_ADMIN_USER:?DB_ADMIN_USER missing in $API_ENV_FILE}"
: "${DB_ADMIN_PASSWORD:?DB_ADMIN_PASSWORD missing in $API_ENV_FILE}"

if [[ ! "$DB_NAME" =~ ^[A-Za-z0-9_]+$ ]]; then
  echo "error: DB_NAME must match [A-Za-z0-9_]+ (got: $DB_NAME)" >&2
  exit 1
fi

# Password via env, not argv, so it does not show up in `ps`.
export MYSQL_PWD="$DB_ADMIN_PASSWORD"
MYSQL_ARGS=(-h "$DB_HOST" -P "$DB_PORT" -u "$DB_ADMIN_USER")

echo "About to DROP and recreate database '$DB_NAME' on $DB_HOST:$DB_PORT (admin user: $DB_ADMIN_USER)."
echo "ALL DATA IN IT WILL BE LOST."
if [ "${1:-}" != "--yes" ]; then
  read -r -p "Type the database name to confirm: " CONFIRM
  [ "$CONFIRM" = "$DB_NAME" ] || { echo "Aborted." >&2; exit 1; }
fi

# Recreate with the same charset/collation the DB has now; fall back to the migrations' locked pair.
CHARSET="$(mysql "${MYSQL_ARGS[@]}" -N -B -e \
  "SELECT DEFAULT_CHARACTER_SET_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='$DB_NAME'" 2>/dev/null || true)"
COLLATION="$(mysql "${MYSQL_ARGS[@]}" -N -B -e \
  "SELECT DEFAULT_COLLATION_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='$DB_NAME'" 2>/dev/null || true)"
CHARSET="${CHARSET:-utf8mb4}"
COLLATION="${COLLATION:-utf8mb4_0900_ai_ci}"

if [ "${SKIP_PM2:-0}" != "1" ] && command -v pm2 >/dev/null 2>&1 && pm2 describe "$PM2_APP_NAME" >/dev/null 2>&1; then
  echo "==> Stopping $PM2_APP_NAME"
  pm2 stop "$PM2_APP_NAME"
  RESTART_PM2=1
else
  RESTART_PM2=0
fi

if [ "${SKIP_BACKUP:-0}" != "1" ]; then
  mkdir -p "$BACKUP_DIR"
  BACKUP_FILE="$BACKUP_DIR/${DB_NAME}-$(date +%Y%m%d-%H%M%S).sql"
  echo "==> Backing up to $BACKUP_FILE"
  if mysqldump "${MYSQL_ARGS[@]}" --single-transaction --routines --triggers "$DB_NAME" > "$BACKUP_FILE" 2>/dev/null; then
    echo "    ok ($(wc -c < "$BACKUP_FILE") bytes)"
  else
    rm -f "$BACKUP_FILE"
    echo "    database not found or not dumpable; continuing without a backup"
  fi
fi

echo "==> Dropping and recreating $DB_NAME ($CHARSET / $COLLATION)"
mysql "${MYSQL_ARGS[@]}" -e "DROP DATABASE IF EXISTS \`$DB_NAME\`; CREATE DATABASE \`$DB_NAME\` CHARACTER SET $CHARSET COLLATE $COLLATION;"

echo "==> Running migrations"
pnpm --filter api db:migrate

echo "==> Seeding"
pnpm --filter api db:seed

echo "==> Checking schema drift"
pnpm --filter api db:check

if [ "$RESTART_PM2" = "1" ]; then
  echo "==> Starting $PM2_APP_NAME"
  pm2 start "$PM2_APP_NAME"
fi

echo "==> Reset complete. Log in with the BOOTSTRAP_ADMIN_* credentials from $API_ENV_FILE."
