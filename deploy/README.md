# Deploying LuxeKnox

Targets (matches the pm2 + Apache reverse-proxy pattern already used on this host):

- **API** — NestJS (`apps/api`), run under pm2 as `luxeknox-api` on `127.0.0.1:3010`, proxied by Apache at `https://api.luxeknox.com`.
- **App** — Flutter web (`app/`), built to static files and served by Apache at `https://app.luxeknox.com` from `/var/www/html/luxeknox-app`.

`luxeknox.com` itself is a separate, unrelated static site and is not touched by these scripts.

## One-time server setup

1. Point DNS `A` records for `api.luxeknox.com` and `app.luxeknox.com` at this host.
2. Create `apps/api/.env` on the server (not committed — copy from `apps/api/.env.example`), using
   production DB credentials and setting `TRUST_PROXY=1` (the API sits behind Apache).
3. Install the Apache vhosts and issue certs:
   ```bash
   sudo cp deploy/apache/api.luxeknox.com.conf /etc/apache2/sites-available/
   sudo cp deploy/apache/app.luxeknox.com.conf /etc/apache2/sites-available/
   sudo mkdir -p /var/www/html/luxeknox-app && sudo chown www-data:www-data /var/www/html/luxeknox-app
   sudo a2ensite api.luxeknox.com app.luxeknox.com
   sudo systemctl reload apache2
   sudo certbot --apache -d api.luxeknox.com
   sudo certbot --apache -d app.luxeknox.com
   ```
4. Ensure `mkdir -p /var/log/pm2` exists (pm2 log target in `deploy/ecosystem.config.js`).

## Build

```bash
deploy/build.sh            # builds API + Flutter web
deploy/build.sh --api-only # API only
deploy/build.sh --app-only # Flutter web only
```

## Deploy

```bash
deploy/deploy.sh
```

Pulls latest `main`, builds, runs `pnpm --filter api db:migrate`, syncs `app/build/web/` to
`/var/www/html/luxeknox-app`, and (re)starts the API under pm2.

Env overrides: `API_PORT` (default `3010`), `APP_DEPLOY_DIR` (default `/var/www/html/luxeknox-app`),
`PM2_APP_NAME` (default `luxeknox-api`), `SKIP_MIGRATE=1`, `SKIP_APP=1` (API-only deploy, e.g. for a
backend-only hotfix).

## Operating the API process

```bash
pm2 describe luxeknox-api
pm2 logs luxeknox-api
pm2 reload luxeknox-api --update-env
```
