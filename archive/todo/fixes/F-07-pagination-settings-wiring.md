# F-07 — Wire `PaginationHelper` to `SettingsService`

| | |
| :--- | :--- |
| **Status** | completed |
| **Severity** | high |
| **Depends** | — |
| **Blocks** | F-12 |
| **Files** | 3 |

## Why

M0-18 work item: "Cursor on `(created_at, id)` and offset. **Default limit from SettingsService.**"

`PaginationHelper` declares `@Optional() private readonly settingsService?: SettingsService` (`pagination.ts:97-100`) and `PlatformModule` (`platform.module.ts:11-28`) neither imports `SysModule` nor provides `SettingsService`. The optional dependency therefore resolves to `undefined` on every boot, `resolveLimit` falls through to the hardcoded `DEFAULT_PAGE_SIZE` at line 119, and the `default_page_size` row that M0-12 seeds into `gym_settings` is never read by anything.

The `@Optional()` is what hides it: without it, Nest would have failed to start and the miswiring would have been caught at M0-18.

## Files

- `apps/api/src/platform/platform.module.ts`
- `apps/api/src/platform/http/pagination.ts`
- `apps/api/src/platform/http/pagination.spec.ts`

## Steps

1. In `platform.module.ts`, import the module that owns settings:
   ```ts
   import { SysModule } from '../sys/sys.module';
   ```
   and add it to `imports`: `imports: [EventEmitterModule.forRoot(), SysModule],`
   `SysModule` already exports `SettingsService` (`sys.module.ts:10`) and imports nothing, so there is no cycle. Leave `SysModule` itself untouched.
2. In `pagination.ts`, make the dependency required:
   ```ts
   constructor(private readonly settingsService: SettingsService) {}
   ```
   Delete the `@Optional()` decorator and drop `Optional` from the `@nestjs/common` import.
3. Simplify `resolveLimit` (lines 106-120). The `if (this.settingsService)` guard and the trailing `return DEFAULT_PAGE_SIZE;` both go — `SettingsService.getDefaultPageSize()` already falls back to 20 when the row is missing or unparseable (`settings.service.ts:40-47`), so a second fallback here is a second source of truth:
   ```ts
   async resolveLimit(requestedLimit?: number): Promise<number> {
     if (requestedLimit !== undefined && requestedLimit !== null) {
       if (requestedLimit <= 0) {
         throw new BadRequestError('Limit must be greater than 0');
       }
       return Math.min(requestedLimit, MAX_PAGE_SIZE);
     }
     const defaultLimit = await this.settingsService.getDefaultPageSize();
     return Math.min(defaultLimit, MAX_PAGE_SIZE);
   }
   ```
4. If `DEFAULT_PAGE_SIZE` now has no readers (`rg "DEFAULT_PAGE_SIZE" apps/api/src`), delete the constant. Keep `MAX_PAGE_SIZE` — it is a real cap, not a default.
5. In `pagination.spec.ts`, construct the helper with a stub and add a test that proves the wiring, not just the arithmetic:
   ```ts
   const settingsService = { getDefaultPageSize: vi.fn().mockResolvedValue(37) } as unknown as SettingsService;
   const helper = new PaginationHelper(settingsService);

   it('takes the default limit from SettingsService', async () => {
     await expect(helper.resolveLimit(undefined)).resolves.toBe(37);
     expect(settingsService.getDefaultPageSize).toHaveBeenCalled();
   });

   it('caps the settings-provided default at MAX_PAGE_SIZE', async () => {
     vi.mocked(settingsService.getDefaultPageSize).mockResolvedValue(5000);
     await expect(helper.resolveLimit(undefined)).resolves.toBe(MAX_PAGE_SIZE);
   });
   ```
   A test asserting `resolveLimit(undefined) === 20` would have passed against the broken wiring — that is the test to replace.

## Done when

- `rg "@Optional" apps/api/src/platform/http/pagination.ts` returns nothing.
- Booting the app with `default_page_size` set to a non-default value in `gym_settings` makes `resolveLimit(undefined)` return that value.
- `pnpm --filter api test` passes and `pnpm --filter api start` boots without an unresolved-dependency error.
