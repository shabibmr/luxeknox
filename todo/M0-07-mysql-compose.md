# M0-07 — MySQL 8.4 compose

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-04 |
| **Files** | 3 |

## Files

- `docker-compose.yml`
- `apps/api/docker/mysql.cnf`
- `README.md`

## Work

Compose MySQL 8.4. Config: `time_zone = +00:00`, `transaction_isolation = READ-COMMITTED`, `utf8mb4`. README compose section.

## Done when

`docker compose up -d` is healthy. Session `time_zone` is `+00:00`.
