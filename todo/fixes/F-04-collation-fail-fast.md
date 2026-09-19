# F-04 — Fail fast on unsupported collation

| | |
| :--- | :--- |
| **Status** | todo |
| **Severity** | medium |
| **Depends** | F-03 |
| **Files** | 2 |

## Why

`todo/README.md` locks `utf8mb4_0900_ai_ci`, and ADR-0002 credits the FR-API-014 accent/case-insensitive search guarantee to it specifically.

`migrate.ts:128-133` catches MySQL errno 1273 (unknown collation), rewrites the migration SQL to `utf8mb4_unicode_ci`, and re-runs it behind a `console.warn`. A server that does not support the locked collation therefore gets a schema with **different comparison semantics** than the one that was reviewed, and the only signal is a warning line that CI discards. `utf8mb4_unicode_ci` sorts and compares differently from `0900_ai_ci`; search results and unique-index collisions diverge silently.

The locked decision is a requirement, not a preference. A server that cannot honour it is the wrong server.

## Files

- `apps/api/src/platform/db/migrate.ts`
- `apps/api/src/platform/db/migrate.spec.ts` (new, if no spec file exists yet)

## Steps

1. Delete the fallback branch at `migrate.ts:129-132` — the whole `if (err.errno === 1273 && ...)` arm, including the `statement.replace(...)` and its re-`query`.
2. The remaining `catch` should keep the existing error log and rethrow, so the whole loop body collapses to:
   ```ts
   try {
     await connection.query(statement);
   } catch (err: any) {
     console.error(`[Migrate] Error executing statement in ${file}:\n${statement}\nError: ${err.message}`);
     throw err;
   }
   ```
   `statement` no longer needs to be mutable — change `for (let statement of statements)` to `for (const statement of statements)`.
3. Add an explicit preflight check before the migration loop (after `ensureMigrationsTable`), so the failure names the real cause instead of surfacing as a confusing DDL error:
   ```ts
   const [collations] = await connection.query<any[]>(
     "SELECT 1 FROM information_schema.COLLATIONS WHERE COLLATION_NAME = 'utf8mb4_0900_ai_ci' LIMIT 1;",
   );
   if (collations.length === 0) {
     throw new Error(
       'Server does not support utf8mb4_0900_ai_ci. MySQL 8.0+ is required (see ADR-0002 and todo/README.md locked decisions).',
     );
   }
   ```
4. Add a unit test for `splitSqlStatements` if `migrate.spec.ts` does not exist, and assert the collation string never appears rewritten:
   ```
   rg "utf8mb4_unicode_ci" apps/api   # must return nothing
   ```

## Done when

- `rg "utf8mb4_unicode_ci" apps/api` returns nothing.
- `pnpm --filter api db:migrate` against compose MySQL 8.4 still succeeds.
- Pointing `DB_HOST` at a MySQL 5.7 server (or any server lacking the collation) aborts with the explicit "MySQL 8.0+ is required" message and applies no statements.
