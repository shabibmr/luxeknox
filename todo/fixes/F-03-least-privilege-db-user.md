# F-03 — Least-privilege DB user + real audit-log immutability

| | |
| :--- | :--- |
| **Status** | completed |
| **Severity** | blocker |
| **Depends** | F-01 |
| **Blocks** | F-04, F-14 |
| **Files** | 7 |

## Why

M0-11 done-when: "`UPDATE audit_logs` as the app user fails." It does not fail. Three separate reasons, all of which must be fixed together:

1. **The REVOKE cannot work as written.** `docker-compose.yml:7-9` sets `MYSQL_DATABASE` + `MYSQL_USER`, so the MySQL entrypoint grants `luxeknox`@`%` privileges at the **database** level (`mysql.db`). MySQL has no way to revoke a table-level slice of a database-level grant — `REVOKE UPDATE, DELETE ON luxeknox.audit_logs` raises error **1147**. `0002_grants.sql:16` declares `CONTINUE HANDLER FOR 1147` and swallows it. The migration reports success having changed nothing.
2. **In CI the procedure body never runs at all.** `0002_grants.sql:21` gates on `WHERE user = 'luxeknox'`, but `.github/workflows/api.yml` provisions `user2grey` (a value that leaks from the hardcoded fallback at `client.ts:33-34`). The `IF EXISTS` is false and the whole block is skipped.
3. **The test that should have caught this cannot fail.** `test/settings.e2e.spec.ts:85-94` wraps the UPDATE in `try { await ... } catch (err) { expect(...) }`. When the UPDATE succeeds — today's behaviour — the `catch` never runs and the test passes green.

There is also a chicken-and-egg problem to resolve: `migrate.ts:99` connects with `createConnectionPool()`, i.e. as the app user, and needs DDL rights. Once the app user is reduced to DML, migrations must run as someone else.

## Decisions

- **Privileges, not triggers.** Triggers would work regardless of grants, but the app user currently holds `DROP`/`TRIGGER` at database level, so a trigger would not be a real boundary. Fixing the grant fixes both.
- **Two identities.** `DB_ADMIN_USER`/`DB_ADMIN_PASSWORD` (root in dev/CI) runs migrations, grants and DDL. `DB_USER`/`DB_PASSWORD` runs the app and holds DML on each table, minus `UPDATE`/`DELETE` on `audit_logs`.
- **Grants are repeatable, not numbered.** Per-table grants must be re-issued whenever a migration adds a table, so the grants script moves to `drizzle/repeatable/` and runs on every migrate.
- **No credential fallbacks.** `user2grey` disappears; missing credentials throw.

## Files

- `apps/api/drizzle/0002_grants.sql` (delete)
- `apps/api/drizzle/repeatable/grants.sql` (new)
- `apps/api/src/platform/db/client.ts`
- `apps/api/src/platform/db/migrate.ts`
- `apps/api/test/settings.e2e.spec.ts`
- `.env.example`
- `.github/workflows/api.yml`

## Steps

### 1. Split the credentials in `client.ts`

Add a fail-fast helper and an admin pool factory; delete the `user2grey` fallbacks.

```ts
function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}
```

- Line 33: `user: options.user || requireEnv('DB_USER'),`
- Line 34: `password: options.password || requireEnv('DB_PASSWORD'),`
- Leave `DB_NAME`'s `'luxeknox'` default and the `DATABASE_URL` branch as they are.
- Append an admin factory. It passes `host` and `user` explicitly so the `DATABASE_URL` branch at line 19 is **not** taken — the admin pool must never silently connect as the app user:
  ```ts
  export function createAdminConnectionPool(): Pool {
    return createConnectionPool({
      host: process.env.DB_HOST || '127.0.0.1',
      port: Number(process.env.DB_PORT) || 3306,
      user: requireEnv('DB_ADMIN_USER'),
      password: requireEnv('DB_ADMIN_PASSWORD'),
      database: process.env.DB_NAME || 'luxeknox',
    });
  }
  ```

### 2. Write `apps/api/drizzle/repeatable/grants.sql`

`${DB_USER}` and `${DB_NAME}` are substituted by the runner in step 3. The revoke is wrapped in a nested block with a handler for **only** 1141/1147 ("no such grant"), so re-running is idempotent while every other error still surfaces.

```sql
-- Repeatable migration: apply least-privilege grants to the application user.
-- Runs as DB_ADMIN_USER on every migrate, after all numbered migrations.
-- audit_logs is append-only (NFR-003, ADR-0002): SELECT + INSERT, never UPDATE/DELETE.

DELIMITER $$

DROP PROCEDURE IF EXISTS `apply_app_grants`$$

CREATE PROCEDURE `apply_app_grants`(IN app_user VARCHAR(64), IN db_name VARCHAR(64))
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE tbl VARCHAR(64);
  DECLARE cur CURSOR FOR
    SELECT TABLE_NAME
      FROM information_schema.TABLES
     WHERE TABLE_SCHEMA = db_name
       AND TABLE_TYPE = 'BASE TABLE';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  -- 1. Drop the database-level grant created by the MySQL entrypoint.
  --    1141/1147 mean it is already gone; any other error is real and must propagate.
  BEGIN
    DECLARE CONTINUE HANDLER FOR 1141, 1147 BEGIN END;
    SET @sql := CONCAT('REVOKE ALL PRIVILEGES ON `', db_name, '`.* FROM ''', app_user, '''@''%''');
    PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;
  END;

  -- 2. Re-issue DML per table. audit_logs is the exception.
  OPEN cur;
  grant_loop: LOOP
    FETCH cur INTO tbl;
    IF done = 1 THEN LEAVE grant_loop; END IF;

    IF tbl = 'audit_logs' THEN
      SET @sql := CONCAT('GRANT SELECT, INSERT ON `', db_name, '`.`', tbl,
                         '` TO ''', app_user, '''@''%''');
    ELSE
      SET @sql := CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE ON `', db_name, '`.`', tbl,
                         '` TO ''', app_user, '''@''%''');
    END IF;
    PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;
  END LOOP;
  CLOSE cur;
END$$

CALL `apply_app_grants`('${DB_USER}', '${DB_NAME}')$$

DROP PROCEDURE IF EXISTS `apply_app_grants`$$

DELIMITER ;
```

Then `git rm apps/api/drizzle/0002_grants.sql`.

> Existing dev databases: the old `0002_grants.sql` row is still in `__drizzle_migrations`. It is harmless (the file is gone, the loop only looks at files on disk), but the database-level grant is still in place until the new repeatable step runs once.

### 3. Teach `migrate.ts` to use the admin pool and run repeatables

- Line 4: import `createAdminConnectionPool` instead of `createConnectionPool`; line 99 becomes `const pool = createAdminConnectionPool();`.
- After the numbered-migration loop finishes (after line 147, before the final log), add a repeatable pass:
  ```ts
  const repeatableFolder = path.join(migrationsFolder, 'repeatable');
  if (fs.existsSync(repeatableFolder)) {
    const appUser = requireSafeIdentifier(process.env.DB_USER, 'DB_USER');
    const dbName = requireSafeIdentifier(process.env.DB_NAME || 'luxeknox', 'DB_NAME');

    for (const file of fs.readdirSync(repeatableFolder).filter((f) => f.endsWith('.sql')).sort()) {
      console.log(`[Migrate] Applying repeatable ${file}...`);
      const sql = fs
        .readFileSync(path.join(repeatableFolder, file), 'utf-8')
        .replace(/\$\{DB_USER\}/g, appUser)
        .replace(/\$\{DB_NAME\}/g, dbName);

      for (const statement of splitSqlStatements(sql)) {
        await connection.query(statement);
      }
    }
  }
  ```
- Repeatable files are deliberately **not** recorded in `__drizzle_migrations` — they must re-run every time so tables added by later migrations get their grants.
- Add the substitution guard in the same file. String interpolation into SQL is only safe because the value is constrained here:
  ```ts
  function requireSafeIdentifier(value: string | undefined, name: string): string {
    if (!value || !/^[A-Za-z0-9_]+$/.test(value)) {
      throw new Error(`${name} must be set and match /^[A-Za-z0-9_]+$/ (got: ${value ?? 'undefined'})`);
    }
    return value;
  }
  ```

### 4. Make the e2e test able to fail

Replace `test/settings.e2e.spec.ts:85-94` entirely. The point is that the UPDATE **must** throw:

```ts
it('rejects audit log UPDATE mutations at the database level', async () => {
  await expect(
    testApp.db.execute(sql`UPDATE audit_logs SET action = 'tampered' WHERE id = 1`),
  ).rejects.toThrow(/command denied/i);
});

it('rejects audit log DELETE mutations at the database level', async () => {
  await expect(
    testApp.db.execute(sql`DELETE FROM audit_logs WHERE id = 1`),
  ).rejects.toThrow(/command denied/i);
});

it('still allows audit log INSERT and SELECT', async () => {
  await expect(testApp.db.execute(sql`SELECT COUNT(*) FROM audit_logs`)).resolves.toBeDefined();
});
```

MySQL raises **1142** `ER_TABLEACCESS_DENIED_ERROR`, whose message contains "command denied to user". Never re-introduce a bare `try`/`catch` here: if the assertion only lives in the `catch`, a successful UPDATE passes the test.

### 5. Align the environments

`.env.example` — add the admin pair next to the existing block, and document the split:

```
# App runtime credentials: DML only. Cannot UPDATE or DELETE audit_logs.
DB_USER=luxeknox
DB_PASSWORD=luxeknox_secret

# Migration/DDL credentials. Used only by `pnpm db:migrate`, never by the running API.
DB_ADMIN_USER=root
DB_ADMIN_PASSWORD=root_secret
```

`.github/workflows/api.yml` — the CI database user must be the same one the grants script targets:
- service `env`: `MYSQL_USER: luxeknox`, `MYSQL_PASSWORD: luxeknox_secret` (was `user2grey`).
- job `env`: `DB_USER: luxeknox`, `DB_PASSWORD: luxeknox_secret`, `DATABASE_URL: mysql://luxeknox:luxeknox_secret@127.0.0.1:3306/luxeknox`, plus `DB_ADMIN_USER: root` and `DB_ADMIN_PASSWORD: root_secret`.

`docker-compose.yml` needs no change — the entrypoint still creates `luxeknox` with a database-level grant, and step 2 replaces it.

## Done when

- `pnpm --filter api db:migrate` against compose MySQL succeeds and prints `Applying repeatable grants.sql`.
- Connected as the **app** user:
  ```sql
  SHOW GRANTS FOR CURRENT_USER();          -- table-level rows, no `luxeknox`.* line
  UPDATE audit_logs SET action='x';        -- ERROR 1142 ... command denied
  DELETE FROM audit_logs;                  -- ERROR 1142 ... command denied
  INSERT INTO audit_logs (...) VALUES (...); -- succeeds
  UPDATE users SET status='active' WHERE id=1; -- succeeds
  ```
- Running `db:migrate` a second time succeeds (the revoke is idempotent) and grants are unchanged.
- `pnpm --filter api seed` still succeeds as the app user.
- The two new e2e assertions fail if you temporarily comment out the grants step — verify this once, then restore.
- `rg "user2grey" .` returns nothing.
