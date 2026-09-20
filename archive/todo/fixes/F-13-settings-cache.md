# F-13 — Settings cache coherence

| | |
| :--- | :--- |
| **Status** | completed |
| **Severity** | low |
| **Depends** | — |
| **Files** | 2 |

## Why

`SettingsService` has two ways to read the same table and they disagree about the cache (`settings.service.ts:53-60`):

- `getSetting(key)` — if `this.cache` is null, it queries that one row by key and **does not populate the cache**.
- `getAllSettings()` — if `this.cache` is null, it calls `refreshCache()` and populates everything.

So a process that serves `GET /v1/settings/public` first (two `getSetting` calls, one query each, cache still null) behaves differently from one that served `GET /v1/settings` first (one query, cache warm). Every subsequent `getSetting` in the first process keeps hitting the database, and the two code paths can observe different snapshots of `gym_settings` within one request.

Settings are invariant in Module 0, so nothing is broken today. The point is to have one caching rule instead of two.

## Files

- `apps/api/src/sys/settings.service.ts`
- `apps/api/src/sys/settings.service.spec.ts`

## Steps

1. Make the cache the only read path. Replace `getSetting` (lines 53-60) with:
   ```ts
   async getSetting(key: string): Promise<string | null> {
     if (!this.cache) {
       await this.refreshCache();
     }
     return this.cache!.get(key) ?? null;
   }
   ```
2. `getAllSettings` (lines 66-73) now duplicates that warm-up. Simplify it to:
   ```ts
   async getAllSettings(): Promise<Record<string, string>> {
     if (!this.cache) {
       await this.refreshCache();
     }
     return Object.fromEntries(this.cache!.entries());
   }
   ```
3. Delete the now-unused `findByKey` from `SettingsRepository` if nothing else calls it (`rg "findByKey" apps/api`). One full-table read of a handful of rows replaces every single-key query, so the by-key lookup no longer earns its place.
4. In `settings.service.spec.ts`, add a test that pins the rule — this is the behaviour that regressed silently before:
   ```ts
   it('warms the whole cache on the first read and queries once', async () => {
     await service.getSetting('timezone');
     await service.getSetting('currency');
     await service.getDefaultPageSize();
     expect(repository.findAll).toHaveBeenCalledTimes(1);
   });
   ```
5. Leave `refreshCache()` public. Module 0 has no settings mutation, but the method is the documented way to drop the cache and will be needed by the first writer.

## Done when

- `getSetting` and `getAllSettings` both read exclusively from the cache after a single `findAll`.
- Three different setting reads in one process issue exactly one database query.
- `pnpm --filter api test` passes, including the existing settings e2e cases.
