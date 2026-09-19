# LuxeKnox Platform

LuxeKnox backend spine and core platform services.

## Prerequisites

- Node.js >= 20.x
- pnpm >= 9.x
- Docker & Docker Compose

## Database (MySQL 8.4 LTS)

The backend uses MySQL 8.4 LTS configured with UTC datetime (`time_zone = '+00:00'`), `READ-COMMITTED` transaction isolation, and `utf8mb4_0900_ai_ci` collation.

### Starting MySQL via Docker Compose

To start the database container in detached mode:

```bash
docker compose up -d
```

To view logs:

```bash
docker compose logs -f mysql
```

To stop the database:

```bash
docker compose down
```

### Database Credentials

Default credentials for local development (as configured in `docker-compose.yml` and `.env.example`):

- **Host**: `localhost` (or `127.0.0.1`)
- **Port**: `3306`
- **Database**: `luxeknox`
- **Username**: `luxeknox`
- **Password**: `luxeknox_secret`
- **Root Password**: `root_secret`
- **Database URL**: `mysql://luxeknox:luxeknox_secret@localhost:3306/luxeknox`

### Verifying Timezone and Isolation

You can verify that the custom configuration was applied by connecting via the MySQL CLI inside the container:

```bash
docker compose exec mysql mysql -u luxeknox -pluxeknox_secret luxeknox -e "SELECT @@global.time_zone, @@session.time_zone, @@global.transaction_isolation, @@session.transaction_isolation;"
```

Expected output:
- `@@global.time_zone`: `+00:00`
- `@@session.time_zone`: `+00:00`
- `@@global.transaction_isolation`: `READ-COMMITTED`
- `@@session.transaction_isolation`: `READ-COMMITTED`

## API Server

The API server runs NestJS with global prefix `/v1` and interactive Swagger / OpenAPI documentation served at `/v1/docs`.

### Install Dependencies

```bash
pnpm install
```

### Development

Run the API service in watch mode:

```bash
pnpm api:dev
# or
pnpm --filter api start:dev
```

The server listens on `http://localhost:3000` (or the configured `PORT` environment variable).

### Interactive API Documentation

Once started, the OpenAPI documentation is accessible at:
- **Swagger UI**: [http://localhost:3000/v1/docs](http://localhost:3000/v1/docs)
- **OpenAPI JSON specification**: [http://localhost:3000/v1/docs-json](http://localhost:3000/v1/docs-json)

### Build & Typecheck

```bash
pnpm api:typecheck
# or
pnpm --filter api typecheck

pnpm api:build
# or
pnpm --filter api build
```

