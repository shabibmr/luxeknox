# F-14 — Close M0-24 gaps: schema check, OpenAPI artifact, test isolation

| | |
| :--- | :--- |
| **Status** | completed |
| **Severity** | medium |
| **Depends** | F-03 |
| **Files** | 5 |

## Why

Three items M0-24 specifies are not actually in place. The Spec review flagged M0-24 as "not verified in depth"; here is what the verification found.

1. **`drizzle-kit check` is not in CI.** M0-24: "CI: lint, typecheck, unit, e2e, `drizzle-kit check`." `.github/workflows/api.yml` runs the first four. `drizzle-kit` is not a dependency of `apps/api` or the workspace root at all, even though `apps/api/drizzle.config.ts` exists. Nothing verifies that the hand-authored SQL in `drizzle/` still matches the Drizzle schema in `src/platform/db/schema/` — which is precisely the drift M0-09/M0-10/M0-11 split across three tasks invites.
2. **`v1.json` is an orphaned side-dump, not the contract.** `docs/openapi/README.md` is explicit: `v1.yaml` **is** "the shared HTTP contract for the Nest API and the Flutter client. Implement against this file." It is hand-authored, contract-first, and already covers every MVP module (`x-status: mvp`), not just what Module 0 built — `tool/gen_api.sh` and `packages/api_client` are generated straight from it. `scripts/dump-openapi.ts:38-40` separately writes **`v1.json`**, a raw `@nestjs/swagger` dump of whatever routes actually exist. Nothing diffs the two, so `v1.json` drifting (or vanishing) from `v1.yaml` — or the reverse, real routes drifting from the authored contract — currently passes silently. CI runs `openapi:dump` but never checks anything against it.
   >  An earlier version of this finding proposed deleting `v1.yaml` and keeping only `v1.json`. That is wrong and must not be done: `v1.yaml` is the larger file *because* it is the forward-looking contract for modules not yet built (see `docs/adr/0007-first-delivery-vertical.md`, now Accepted, and `todo/vertical-1/`), and the Flutter Exercise Library work already generated its API client from it. Deleting it would break that pipeline and discard the only committed spec for anything past Module 0.
3. **E2E has no isolation story.** M0-24: "Testcontainers MySQL 8.4." `test/helpers/mysql.ts` does not use testcontainers — it boots Nest against whatever `DB_HOST` points at. Locally that is the developer's compose instance, with whatever state previous runs left in it.

## Decisions

**On item 3, do not adopt testcontainers.** The GitHub service container in `api.yml` already gives CI a clean, pinned MySQL 8.4 per run, which is the isolation the spec was reaching for; testcontainers would add a dependency and ~20s of container start-up to every run to reproduce something CI already has. Amend the spec to match reality instead, and close the real gap — that the e2e suite does not reset state between runs.

**On item 2, keep `v1.yaml` as the contract; make `v1.json` prove the API matches it, or stop committing it.** Two viable shapes, pick one during implementation:
- **(a) Parity check (preferred).** Dump `v1.json` in CI (uncommitted, `.gitignore`d) and assert every `operationId` tagged `x-status: module-0` or already shipped (e.g. `/exercises` once `todo/vertical-1/V1-11-openapi-parity.md` lands) exists in the dump with a matching method/path. A byte-for-byte diff will not work — `@nestjs/swagger`'s output shape does not match hand-authored YAML structurally — so this has to be an operationId/path presence check, not `diff`.
- **(b) Drop `v1.json` entirely.** If (a) is more than F-14's budget, stop writing `v1.json` to `docs/openapi/` at all (dump to a build/tmp path or skip the step) rather than committing a file nobody reads and nothing verifies. Do not delete `v1.yaml` under any version of this decision.

## Files

- `.github/workflows/api.yml`
- `apps/api/package.json`
- `apps/api/scripts/dump-openapi.ts`
- `apps/api/test/helpers/mysql.ts`
- `todo/M0-24-e2e-openapi-ci.md`

## Steps

1. **Add the schema check.**
   - `pnpm --filter api add -D drizzle-kit`
   - Add a script to `apps/api/package.json`: `"db:check": "drizzle-kit check"`
   - Confirm `drizzle.config.ts` points `schema` at `src/platform/db/schema` and `out` at `drizzle`, and that `dialect` is `mysql`. Run `pnpm --filter api db:check` locally and fix whatever drift it reports **before** wiring it into CI — a check that fails on its first CI run teaches everyone to ignore it.
   - Add a CI step after `Typecheck`:
     ```yaml
     - name: Schema check
       run: pnpm --filter api db:check
     ```
2. **Make the dump prove parity with the contract instead of sitting unread.** `v1.yaml` stays committed and authoritative (`docs/openapi/README.md` already says so — do not edit that file to say otherwise). Implement option (a) or (b) from Decisions above:
   - (a): add a small script (`apps/api/scripts/check-openapi-parity.ts` or similar) that loads the live-dumped document and `docs/openapi/v1.yaml`, and fails if any `x-status: module-0` (or later, shipped-vertical) `operationId` in the YAML is missing from the dump, or present with a different method/path. Wire it into CI after `openapi:dump`.
   - (b): change `dump-openapi.ts`'s `outDir` to a non-committed path (or drop the CI step) and remove `v1.json` from the repo (`git rm docs/openapi/v1.json`). Nothing else references `v1.json` today (confirm with `rg "openapi/v1.json"` before deleting) other than `.gitignore`, which would need a line added.
   Either way, `docs/openapi/v1.yaml` is untouched by this task.
3. **Give e2e a clean slate.** In `test/helpers/mysql.ts`, add a reset used by both suites' `beforeAll`, so a rerun cannot pass on rows an earlier run left behind:
   ```ts
   /** Clears per-test rows. Does not touch seeded roles, permissions or settings. */
   export async function resetTestData(db: DrizzleDb<any>): Promise<void> {
     await db.execute(sql`DELETE FROM sessions`);
     await db.execute(sql`DELETE FROM users WHERE email LIKE 'e2e_%@luxeknox.test'`);
   }
   ```
   Do **not** add `audit_logs` to that list — after F-03 the app user has no `DELETE` on it, and the failure would look like a broken helper rather than the working control it is. If a suite needs audit rows gone, that is a job for the admin connection.
4. **Amend the spec** so it describes what is actually built. In `todo/M0-24-e2e-openapi-ci.md`:
   - "Testcontainers MySQL 8.4" → "MySQL 8.4 from compose locally, GitHub service container in CI. `resetTestData()` isolates runs."
   - Add a line to **Done when**: "CI fails if a shipped operation drifts from `docs/openapi/v1.yaml`" (option a) or "`v1.json` is no longer committed" (option b) — whichever was implemented.
   Record the testcontainers decision in one line under Work, so the next reader does not re-open it.

## Done when

- `pnpm --filter api db:check` passes locally and runs in CI.
- Editing a Drizzle schema file without adding a migration makes CI fail on the schema-check step.
- `docs/openapi/v1.yaml` is unchanged and still the file `docs/openapi/README.md` and `tool/gen_api.sh` point at.
- Either CI fails when a `module-0`/shipped operation in `v1.yaml` has no matching route in the live dump (option a), or `docs/openapi/v1.json` is no longer generated/committed (option b).
- Running `pnpm --filter api test:e2e` twice in a row against the same database passes both times.
- `todo/M0-24-e2e-openapi-ci.md` describes the implementation that exists.
