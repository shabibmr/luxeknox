# M0-05 — Nest package skeleton

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-04 |
| **Files** | 6 |

## Files

- `apps/api/package.json`
- `apps/api/tsconfig.json`
- `apps/api/tsconfig.build.json`
- `apps/api/nest-cli.json`
- `apps/api/vitest.config.ts`
- `apps/api/.env.example`

## Work

Add Nest, Pino, zod, drizzle-orm, mysql2, argon2, `@nestjs/swagger`.

Do not add `jsonwebtoken` or `@nestjs/jwt`.

## Done when

`pnpm --filter api typecheck` succeeds on empty `src`.
