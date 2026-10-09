# Member Health History Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the single-row, upsert-only `member_health` record into an append-only history: every save creates a new dated row, the latest row is "current", and a new detail screen lets a user page backward/forward through a member's dated health records.

**Architecture:** Backend: drop the unique-per-member constraint on `member_health`, add a `recorded_at` column, and replace the `GET/PUT members/:id/health` upsert pair with `GET/POST members/:id/health/history` (list sorted `recorded_at` desc, create-only — no update/delete). Frontend: replace the single-record `HealthInfoCubit`/`HealthInfoScreen` with a `HealthHistoryCubit` that holds the desc-sorted list plus a `currentIndex`, and a `HealthDetailScreen` with Previous/Next buttons; saving always calls "create", never "update".

**Tech Stack:** NestJS + Drizzle ORM + MySQL 8 (backend, `apps/api`), Flutter + flutter_bloc(Cubit)/freezed + injectable/get_it + go_router + fpdart `Either` (frontend, `app`), openapi-generator-cli `dart-dio` for the generated `packages/api_client`.

**Spec:** User request (this conversation): add Member Health History with a date field like Membership History / Workout History; the latest-dated record is the member's current health info; add a Member Health Detail View page showing the current record by default with Previous/Next buttons gated on record availability; every edit-and-save writes a brand-new dated record instead of mutating the one being viewed.

## Global Constraints

- Local MySQL is a native instance at `localhost:3308` (MySQL 8.4) — not Docker. Migrations run via `pnpm --filter api db:migrate` (`apps/api/src/platform/db/migrate.ts`), which applies hand-numbered SQL files in `apps/api/drizzle/*.sql` in order.
- Migration SQL files are generated with `npx drizzle-kit generate` from inside `apps/api`, then the output file + `drizzle/meta/*_snapshot.json` are renamed to the next sequential `NNNN_name.sql`/`NNNN_snapshot.json`, and `drizzle/meta/_journal.json` gets a matching new entry appended (`idx`, `version`, `when`, `tag`, `breakpoints: true`). Next number after `0021_employee_gender.sql` is `0022`.
- `docs/openapi/v1.yaml` is the **hand-authored** OpenAPI contract fed to the Dart client generator (`tool/gen_api.sh`, which runs `openapi-generator-cli generate -i docs/openapi/v1.yaml -g dart-dio -o packages/api_client`). `docs/openapi/v1.json` is **auto-dumped** from live Nest decorators via `pnpm --filter api openapi:dump` and is never hand-edited; it exists only so `pnpm --filter api openapi:check` can diff coverage against the hand-authored yaml.
- Every yaml operation needs `x-status: mvp`, `x-parity: required`, and an `x-permission` of an existing permission key. Reuse the existing `health.read` / `health.update` permission keys — do not invent new ones.
- Keep the existing backend class/file names (`MemberHealthController`, `MemberHealthService`, `MemberHealthRepository`, `member-health.dto.ts`) so `apps/api/src/people/people.module.ts`'s existing provider/controller registration does not need to change.
- Flutter codegen: `freezed` state classes and `injectable`'s `injector.config.dart` are generated via `dart run build_runner build --delete-conflicting-outputs` run from `app/`.
- Reuse `BaseRepository`'s `create`/`update`/`findOne` helpers (see `member-health.repository.ts` / `medical-history.repository.ts`) rather than hand-rolling new Drizzle query plumbing.
- No endpoint here needs to survive as "the single current row" — grep confirms `getMemberHealth`/`putMemberHealth`/`MemberHealth`/`MemberHealthWrite` are referenced only by the files this plan touches, so the old GET/PUT pair can be fully replaced, not kept as a compatibility alias.

## Review Focus

- A member who has never had a health record saved: `list` returns an empty page, and the detail screen must still render an editable blank form (not a spinner or crash) with Previous/Next both disabled. (Task 9, Task 12)
- Two saves landing in the same millisecond must still produce a stable, deterministic order (latest-first) so Previous/Next don't jump unpredictably — order by `recorded_at` desc **then `id` desc** as a tiebreaker. (Task 3, Task 9)
- Saving while viewing an older record (after pressing Previous) must create a new row and must never call an update/patch path against the historical record being viewed. (Task 11, Task 12)
- Non-numeric text left in the height/weight fields on save must resolve to `null` the same way the current form already does (`double.tryParse` returning `null`), not throw or silently keep a stale value. (Task 12)
- A member with more history rows than one fetched page: the "current" record is still correct (it's row 0 of a desc-sorted first page), but Previous must disable at the end of the loaded page rather than erroring — this plan intentionally fetches one page sized generously (`limit: 100`) and does not implement incremental pagination inside the detail view. (Task 9, Task 12)

---

## Task 1: Backend schema — append-only `member_health`

**Files:**
- Modify: `apps/api/src/platform/db/schema/member-health.ts`

**Interfaces:**
- Produces: `memberHealth` table with columns `id, member_id, blood_group, height_cm, baseline_weight_kg, allergies, dietary_preferences, physician_name, physician_phone, recorded_at (datetime(3) NOT NULL), created_at (datetime(3) NOT NULL)` — no `updated_at`, no unique index on `member_id`, plain index `member_health_member_id_idx` on `member_id` (copy the `index(...)` pattern from `medical-histories.ts`).
- Produces: exported types `MemberHealth = typeof memberHealth.$inferSelect`, `NewMemberHealth = typeof memberHealth.$inferInsert` (same names as today, new shape).

- [ ] **Step 1:** Edit `member-health.ts`: remove `updated_at`, remove the `uniqueIndex(...)` table-config function and `uniqueIndex` import, add `recorded_at: utcDatetime('recorded_at').notNull()` column, add `index('member_health_member_id_idx').on(table.member_id)` (import `index` instead of `uniqueIndex`), matching `medical-histories.ts`'s table-config style.
- [ ] **Step 2: Run typecheck**
  Run: `pnpm --filter api typecheck`
  Expected: fails only in files Task 2–4 haven't updated yet (repository/service/controller still reference removed fields) — confirms the schema edit took effect. Do not fix those yet.
- [ ] **Step 3: Commit**
  ```bash
  git add apps/api/src/platform/db/schema/member-health.ts
  git commit -m "feat(api): make member_health schema append-only"
  ```

## Task 2: Backend migration

**Files:**
- Create: `apps/api/drizzle/0022_member_health_history.sql`
- Create: `apps/api/drizzle/meta/0022_snapshot.json`
- Modify: `apps/api/drizzle/meta/_journal.json`

**Interfaces:**
- Consumes: the schema from Task 1.
- Produces: a migration that, against the current `member_health` table (unique index on `member_id`, has `updated_at`, no `recorded_at`), ends up matching Task 1's schema. Must backfill `recorded_at` from existing `created_at` for any pre-existing rows before dropping the old unique index (so no row is ever ambiguous about its date).

- [ ] **Step 1:** From `apps/api/`, run `npx drizzle-kit generate` with Task 1's schema in place; it will emit a new numbered file/snapshot in `drizzle/` using drizzle-kit's own auto-generated tag.
- [ ] **Step 2:** Rename the generated `.sql` file to `0022_member_health_history.sql` and its paired snapshot in `drizzle/meta/` to `0022_snapshot.json`; append the matching entry (`idx`, incrementing `version`, a new `when` timestamp, `tag: "0022_member_health_history"`, `breakpoints: true`) to `drizzle/meta/_journal.json`, following the existing entries' shape.
- [ ] **Step 3:** Open the renamed `.sql` file and, if drizzle-kit emitted a `DROP COLUMN updated_at` before backfilling `recorded_at`, reorder/insert an `UPDATE member_health SET recorded_at = created_at WHERE recorded_at IS NULL` statement (with `--> statement-breakpoint` separators matching the file's existing style) so it runs after `recorded_at` is added but before any `NOT NULL` constraint would reject existing rows.
- [ ] **Step 4: Run the migration against local MySQL**
  Run: `pnpm --filter api db:migrate`
  Expected: completes without error; `apps/api/scripts/check-schema-drift.ts` run via `pnpm --filter api db:check` reports no drift.
- [ ] **Step 5: Commit**
  ```bash
  git add apps/api/drizzle/0022_member_health_history.sql apps/api/drizzle/meta/0022_snapshot.json apps/api/drizzle/meta/_journal.json
  git commit -m "feat(api): migrate member_health to append-only history"
  ```

## Task 3: Backend repository — list + create, no upsert

**Files:**
- Modify: `apps/api/src/people/member-health.repository.ts`
- Test: `apps/api/src/people/member-health.repository.spec.ts` (new — there is no existing repository-level spec for this file today; `medical-history.repository.ts` also has none, so skip a dedicated repository test and cover this through the service spec in Task 5, matching existing test density.)

**Interfaces:**
- Consumes: `memberHealth`, `MemberHealth`, `NewMemberHealth` from Task 1.
- Produces (for Task 4): `findManyByMemberId(memberId: number, options: { limit: number; offset: number }): Promise<{ rows: MemberHealth[]; total: number }>` ordered by `desc(memberHealth.recorded_at), desc(memberHealth.id)`; `insertRecord(values: NewMemberHealth): Promise<number>`; `findByIdAndMemberId(id: number, memberId: number): Promise<MemberHealth | null>`.

- [ ] **Step 1:** Remove `findByMemberId` and `upsertForMember`. Add the three methods above, copying `medical-history.repository.ts`'s `findManyByMemberId`/`findByIdAndMemberId`/`insertHistory` bodies verbatim except: order by `[desc(memberHealth.recorded_at), desc(memberHealth.id)]` instead of `desc(medicalHistories.id)`, and query/filter on `memberHealth` instead of `medicalHistories`. Import `desc` alongside the existing `and, count, eq` from `drizzle-orm`.
- [ ] **Step 2: Run typecheck**
  Run: `pnpm --filter api typecheck`
  Expected: fails only in `member-health.service.ts` (not yet updated) — confirms repository compiles standalone.
- [ ] **Step 3: Commit**
  ```bash
  git add apps/api/src/people/member-health.repository.ts
  git commit -m "feat(api): replace member health upsert with list+create repository methods"
  ```

## Task 4: Backend DTOs — record read/write shape with `recorded_at`

**Files:**
- Modify: `apps/api/src/people/member-health.dto.ts`

**Interfaces:**
- Produces: `memberHealthWriteSchema` (unchanged fields/validation, keep the name — it's reused as the create-body schema) and its inferred `MemberHealthWriteDto` type; a new exported class `MemberHealthRecordDto` with `@ApiProperty`/`@ApiPropertyOptional` fields `id: number`, `member_id: number`, `blood_group: string | null`, `height_cm: number | null`, `baseline_weight_kg: number | null`, `allergies: string | null`, `dietary_preferences: string | null`, `physician_name: string | null`, `physician_phone: string | null`, `recorded_at: string` (ISO date-time, required, not nullable) — modeled on `MedicalHistoryDto` in `medical-history.dto.ts`.

- [ ] **Step 1:** Keep `memberHealthWriteSchema`/`MemberHealthWriteDto` as-is (no `recorded_at` in the write body — the server always sets it). Add `MemberHealthRecordDto` as specified above.
- [ ] **Step 2: Run typecheck**
  Run: `pnpm --filter api typecheck`
  Expected: still fails only in service/controller (not yet updated).
- [ ] **Step 3: Commit**
  ```bash
  git add apps/api/src/people/member-health.dto.ts
  git commit -m "feat(api): add MemberHealthRecordDto for history responses"
  ```

## Task 5: Backend service — `list`/`create`, TDD

**Files:**
- Modify: `apps/api/src/people/member-health.service.ts`
- Test: `apps/api/src/people/member-health.service.spec.ts` (new)

**Interfaces:**
- Consumes: `MemberHealthRepository` (Task 3), `MemberHealthRecordDto`/`MemberHealthWriteDto` (Task 4), `PaginationHelper`/`createPaginatedResponse`/`PaginatedResponse` from `../platform/http/pagination` (same imports `medical-history.service.ts` uses), `AuditService`, `MemberRepository`, `requireScopedMember`.
- Produces: `MemberHealthService.toDto(row: MemberHealth): MemberHealthRecordDto`; `list(memberId: number, query: Record<string, unknown>, actor: AuthenticatedUser): Promise<PaginatedResponse<MemberHealthRecordDto>>`; `create(memberId: number, dto: MemberHealthWriteDto, actor: AuthenticatedUser): Promise<MemberHealthRecordDto>` (always inserts a new row with `recorded_at: new Date()`; audit action `'member_health.recorded'`, `entityName: 'member_health'`).

- [ ] **Step 1: Write the failing tests** in `member-health.service.spec.ts`, copying `medical-history.service.spec.ts`'s structure (mock `repository`, `memberRepository`, `auditService`, `paginationHelper`; `ADMIN_USER`/`MEMBER_USER` fixtures):
  ```ts
  describe('list', () => {
    it('returns paginated health history for member', async () => { /* repository.findManyByMemberId resolves {rows:[...one row with recorded_at...], total:1}; assert result.data[0].recorded_at matches, result.meta.total === 1 */ });
    it('rejects access for an unscoped member', async () => { /* same requireScopedMember rejection pattern as medical-history's "rejects unassigned trainer" test */ });
  });
  describe('create', () => {
    it('always inserts a new record with current recorded_at and records audit', async () => {
      // repository.insertRecord resolves 1; call service.create(100, {blood_group:'O+', ...}, ADMIN_USER)
      // assert repository.insertRecord called with expect.objectContaining({ member_id: 100, blood_group: 'O+', recorded_at: expect.any(Date) })
      // assert repository.findByIdAndMemberId called with (1, 100)
      // assert auditService.recordAudit called with expect.objectContaining({ action: 'member_health.recorded', entityName: 'member_health' })
    });
  });
  ```
- [ ] **Step 2: Run tests to verify they fail**
  Run: `pnpm --filter api test -- member-health.service`
  Expected: FAIL (service still has old `get`/`put` methods, no `list`/`create`).
- [ ] **Step 3: Implement** `list`/`create`/`toDto` in `member-health.service.ts`: delete `get`/`put`. `list` mirrors `MedicalHistoryService.list` exactly (swap repository/DTO types). `create` mirrors `MedicalHistoryService.create`'s shape but always calls `repository.insertRecord` (never checks for an existing row) with `recorded_at: now` plus every field from `dto` defaulted to `null` via `dto.x ?? null` (same null-coalescing style `member-health.service.ts` already uses today), then re-fetches via `findByIdAndMemberId` and records the audit.
- [ ] **Step 4: Run tests to verify they pass**
  Run: `pnpm --filter api test -- member-health.service`
  Expected: PASS
- [ ] **Step 5: Commit**
  ```bash
  git add apps/api/src/people/member-health.service.ts apps/api/src/people/member-health.service.spec.ts
  git commit -m "feat(api): add member health history list/create service with tests"
  ```

## Task 6: Backend controller — `GET/POST members/:id/health/history`

**Files:**
- Modify: `apps/api/src/people/member-health.controller.ts`

**Interfaces:**
- Consumes: `MemberHealthService.list`/`.create` (Task 5), `MemberHealthRecordDto`/`memberHealthWriteSchema`/`MemberHealthWriteDto` (Task 4).
- Produces: `@Controller('members/:id/health/history')` with `GET` → `operationId: listMemberHealthHistory` (query params `limit`/`offset` via `@ApiQuery`, same as `MedicalHistoryController.list`) and `POST` → `operationId: createMemberHealthRecord`, response type `MemberHealthRecordDto` (array for GET via the paginated envelope, single object for POST, status 201).

- [ ] **Step 1:** Replace the `@Get()`/`@Put()` handlers and `MemberHealthResponseDto` class with a `GET`/`POST` pair modeled directly on `MedicalHistoryController`'s `list`/`create` handlers (same `@RequirePermission`, `@ApiOperation`, `@ApiParam`, `@ApiQuery`, `@ApiResponse` decorator shapes) — reuse the existing `health.read`/`health.update` permission strings, path param decorator, and `ZodValidationPipe(memberHealthWriteSchema)` for the POST body.
- [ ] **Step 2: Run typecheck and tests**
  Run: `pnpm --filter api typecheck && pnpm --filter api test`
  Expected: PASS (all prior failures from Tasks 1–5 now resolved).
- [ ] **Step 3: Commit**
  ```bash
  git add apps/api/src/people/member-health.controller.ts
  git commit -m "feat(api): expose member health history as list/create endpoints"
  ```

## Task 7: OpenAPI contract — hand-authored spec + regenerated Dart client

**Files:**
- Modify: `docs/openapi/v1.yaml`

**Interfaces:**
- Produces: path `/members/{id}/health/history` with `get` (`operationId: listMemberHealthHistory`, `x-status: mvp`, `x-parity: required`, `x-permission: health.read`, `$ref: "#/components/parameters/Id"`, 200 → `MemberHealthHistoryPage`) and `post` (`operationId: createMemberHealthRecord`, same `x-status`/`x-parity`, `x-permission: health.update`, `requestBody` → `MemberHealthWrite`, 201 → `MemberHealthRecord`) — same `Error400/401/403/404/409/429` response refs the existing `/members/{id}/health` block uses.
- Produces: component schemas `MemberHealthRecord` (copy `MemberHealth`'s properties, drop nothing, add `recorded_at: { $ref: "#/components/schemas/Date" }` — check whether `Date` is a date-only or date-time ref by reading its definition; if `Date` is date-only (`YYYY-MM-DD`, like `MedicalHistory.diagnosed_date`), instead define `recorded_at` as `{ type: string, format: date-time }` since this must carry a precise timestamp, not just a day), `MemberHealthWrite` (copy today's `MemberHealthWrite` schema unchanged — no `recorded_at`, server sets it), `MemberHealthHistoryPage` (copy `MedicalHistoryPage`'s shape: `data: array of MemberHealthRecord`, `meta: $ref PageMeta`).
- Removes: the `/members/{id}/health` `get`/`put` path block and (if nothing else references them) the old `MemberHealth`/`MemberHealthWrite` schema entries — but **only** `MemberHealthWrite` is reused unchanged by name in this task's own new schema, so keep that name and just delete the old `MemberHealth` entry, replacing its usages with `MemberHealthRecord`.

- [ ] **Step 1:** Edit `docs/openapi/v1.yaml`: replace the `/members/{id}/health` block (lines ~1100–1160) with `/members/{id}/health/history`, and replace the `MemberHealth`/`MemberHealthWrite` component schemas (~line 7204) with `MemberHealthRecord`/`MemberHealthWrite`/`MemberHealthHistoryPage` as specified above.
- [ ] **Step 2: Dump the live Nest spec and check parity**
  Run: `pnpm --filter api openapi:dump && pnpm --filter api openapi:check`
  Expected: PASS — confirms the live controller from Task 6 covers every `x-status: mvp`/`x-parity: required` path now in the yaml.
- [ ] **Step 3: Regenerate the Dart client**
  Run: `bash tool/gen_api.sh`
  Expected: completes without error; `packages/api_client/lib/src/model/` gains `member_health_record.dart`, `member_health_record_write.dart` (or `member_health_write.dart` if the generator keeps the existing name), `member_health_history_page.dart` and their `.g.dart` pairs; `HEALTHApi` gains `listMemberHealthHistory`/`createMemberHealthRecord` methods. Note the **exact** generated class and method names from this run's output — later Flutter tasks must use them verbatim, not the names guessed here.
- [ ] **Step 4: Commit**
  ```bash
  git add docs/openapi/v1.yaml packages/api_client
  git commit -m "feat(api): add member health history to OpenAPI contract and regenerate client"
  ```

## Task 8: Flutter domain — `HealthInfo` gains `recordedAt`, new use cases

**Files:**
- Modify: `app/lib/features/people/domain/entities/health_info.dart`
- Modify: `app/lib/features/people/domain/repositories/profile_repository.dart`
- Create: `app/lib/features/people/domain/usecases/list_health_history_usecase.dart`
- Create: `app/lib/features/people/domain/usecases/create_health_record_usecase.dart`
- Delete: `app/lib/features/people/domain/usecases/get_health_info_usecase.dart`
- Delete: `app/lib/features/people/domain/usecases/update_health_info_usecase.dart`

**Interfaces:**
- Produces: `HealthInfo` with an added `required DateTime recordedAt` field (keep every existing field/constructor-param/copyWith-param/props entry; add `recordedAt` to all four, following the exact pattern `updatedAt` already uses but **required**, not nullable).
- Produces: `ProfileRepository.listHealthHistory(int memberId): Future<Either<Failure, List<HealthInfo>>>` and `ProfileRepository.createHealthRecord(HealthInfo info): Future<Either<Failure, HealthInfo>>`, replacing `getHealthInfo`/`updateHealthInfo`.
- Produces: `ListHealthHistoryUseCase implements UseCase<List<HealthInfo>, int>` and `CreateHealthRecordUseCase implements UseCase<HealthInfo, HealthInfo>`, both `@lazySingleton`, both calling the matching `ProfileRepository` method — copy `GetHealthInfoUseCase`/`UpdateHealthInfoUseCase`'s structure exactly.

- [ ] **Step 1:** Add `recordedAt` to `HealthInfo` (constructor, `copyWith`, `props`).
- [ ] **Step 2:** Replace `getHealthInfo`/`updateHealthInfo` in `ProfileRepository` with `listHealthHistory`/`createHealthRecord` as specified.
- [ ] **Step 3:** Delete the two old usecase files; create `ListHealthHistoryUseCase`/`CreateHealthRecordUseCase` as specified.
- [ ] **Step 4: Run analyzer**
  Run: `cd app && flutter analyze lib/features/people/domain`
  Expected: errors only in files Task 9–10 haven't updated yet (datasource/repository impl/mapper, cubit, screen) — confirms the domain layer itself is internally consistent.
- [ ] **Step 5: Commit**
  ```bash
  git add app/lib/features/people/domain
  git commit -m "feat(app): model health info as dated history in the domain layer"
  ```

## Task 9: Flutter data layer — list/create against the regenerated client

**Files:**
- Modify: `app/lib/features/people/data/datasources/profile_remote_datasource.dart`
- Modify: `app/lib/features/people/data/models/people_mapper.dart`
- Modify: `app/lib/features/people/data/repositories/profile_repository_impl.dart`

**Interfaces:**
- Consumes: the generated `api_client` names confirmed in Task 7 Step 3 (referred to below by their planned names; substitute the client's actual generated names if the generator produced different ones).
- Produces: `ProfileRemoteDataSource.listHealthHistory(int memberId): Future<api.MemberHealthHistoryPage>` calling `_healthApi.listMemberHealthHistory(id: memberId)`; `ProfileRemoteDataSource.createHealthRecord(int memberId, api.MemberHealthWrite write): Future<api.MemberHealthRecord>` calling `_healthApi.createMemberHealthRecord(id: memberId, memberHealthWrite: write)` — replacing `getHealth`/`putHealth` in both the abstract class and `ProfileRemoteDataSourceImpl`.
- Produces in `people_mapper.dart`: `HealthInfo healthInfoFromApi(api.MemberHealthRecord record)` (same field mapping as today's `healthInfoFromApi` plus `recordedAt: record.recordedAt`), `api.MemberHealthWrite healthInfoToWrite(HealthInfo info)` (unchanged field set — no `recordedAt`).
- Produces in `profile_repository_impl.dart`: `listHealthHistory(int memberId)` — calls `_remote.listHealthHistory`, maps `page.data` through `healthInfoFromApi`, **sorts the result `desc` by `recordedAt` then by `id`** client-side (defense in depth — mirrors `MembershipHistoryCubit`'s `items.sort((a,b) => b.timestamp.compareTo(a.timestamp))` pattern; do not rely solely on server order), returns `Right(sorted)`; on any thrown error returns `Left(mapThrownToFailure(e))` (no more special-casing `NotFoundFailure` into a synthetic record — an empty list is simply empty). `createHealthRecord(HealthInfo info)` — calls `_remote.createHealthRecord(info.memberId, healthInfoToWrite(info))`, maps the result through `healthInfoFromApi`, same try/catch pattern as today's `updateHealthInfo`.

- [ ] **Step 1:** Update `ProfileRemoteDataSource`'s abstract method pair and `ProfileRemoteDataSourceImpl`'s implementation as specified.
- [ ] **Step 2:** Update `healthInfoFromApi`/`healthInfoToWrite` in `people_mapper.dart` as specified.
- [ ] **Step 3:** Update `profile_repository_impl.dart`'s `listHealthHistory`/`createHealthRecord` as specified, replacing `getHealthInfo`/`updateHealthInfo`.
- [ ] **Step 4: Run analyzer**
  Run: `cd app && flutter analyze lib/features/people/data`
  Expected: PASS (or errors only in presentation/routing files not yet touched).
- [ ] **Step 5: Commit**
  ```bash
  git add app/lib/features/people/data
  git commit -m "feat(app): wire health history list/create through the data layer"
  ```

## Task 10: Flutter presentation — `HealthHistoryCubit`, TDD

**Files:**
- Delete: `app/lib/features/people/presentation/cubit/health_info_cubit.dart`, `health_info_cubit.freezed.dart`
- Create: `app/lib/features/people/presentation/cubit/health_history_cubit.dart`
- Delete: `app/test/features/people/presentation/health_info_cubit_test.dart`
- Create: `app/test/features/people/presentation/health_history_cubit_test.dart`

**Interfaces:**
- Consumes: `ListHealthHistoryUseCase`, `CreateHealthRecordUseCase` (Task 8).
- Produces: `@freezed abstract class HealthHistoryState` with `status: LoadStatus`, `@Default(<HealthInfo>[]) records: List<HealthInfo>`, `@Default(0) currentIndex: int`, `message: String?`, `failure: Failure?`.
- Produces: `HealthHistoryCubit(this._list, this._create) : super(const HealthHistoryState())` with methods:
  - `Future<void> load(int memberId)` — on success with a non-empty list, emit `records` (already desc-sorted by the repository) and `currentIndex: 0`; on an **empty** list, emit a single synthetic `HealthInfo(id: 0, memberId: memberId, recordedAt: DateTime.now())` as the sole entry of `records` with `currentIndex: 0` (so the form always has something to display) — same spirit as today's `HealthInfoCubit.load` NotFoundFailure branch, but driven by list-emptiness, not a thrown failure.
  - `Future<void> save(HealthInfo edited)` — calls `_create(edited)`; on success, re-invokes `load(edited.memberId)` so the brand-new record becomes `records[0]`/`currentIndex: 0`; on failure, emits `status: LoadStatus.failure, failure: ...` without touching `records`/`currentIndex`.
  - `void previous()` — if `currentIndex < records.length - 1`, emit `currentIndex: currentIndex + 1` (moves to an older record).
  - `void next()` — if `currentIndex > 0`, emit `currentIndex: currentIndex - 1` (moves to a newer record).
  - Getters/derived values the screen needs: `bool get canGoPrevious => currentIndex < records.length - 1;`, `bool get canGoNext => currentIndex > 0;`, `HealthInfo? get current => records.isEmpty ? null : records[currentIndex];` (plain getters on the cubit, not state fields, so they can't drift from `records`/`currentIndex`).

- [ ] **Step 1: Write the failing tests** in `health_history_cubit_test.dart` (mirror `health_info_cubit_test.dart`'s `Mock...UseCase` + `setUp`/`tearDown` scaffolding):
  ```dart
  group('HealthHistoryCubit.load', () {
    test('emits records desc-sorted with currentIndex 0 when usecase succeeds', () async { /* _list(5) -> Right([older, newer]); after load, state.records == [newer, older], state.currentIndex == 0 */ });
    test('emits a single synthetic blank record when history is empty', () async { /* _list(5) -> Right(<HealthInfo>[]); state.records.length == 1; state.records[0].id == 0; state.currentIndex == 0 */ });
    test('emits failure when usecase fails', () async { /* _list(5) -> Left(NetworkFailure()); state.status == LoadStatus.failure */ });
  });
  group('HealthHistoryCubit.save', () {
    test('creates a new record and reloads to currentIndex 0', () async { /* _create(any()) -> Right(newRecord); _list(any()) -> Right([newRecord, old]); after save(old), state.records[0] == newRecord, state.currentIndex == 0 */ });
    test('emits failure without mutating records when create fails', () async { /* seed state.records via a prior successful load; _create -> Left(ValidationFailure([...])); records unchanged, status == failure */ });
  });
  group('HealthHistoryCubit.previous/next', () {
    test('previous moves to an older record and next moves back', () { /* seed cubit.emit or load with 3 records; previous() -> currentIndex 1; previous() -> currentIndex 2; previous() again stays at 2; next() -> currentIndex 1; canGoPrevious/canGoNext reflect bounds at each step */ });
  });
  ```
- [ ] **Step 2: Run tests to verify they fail**
  Run: `cd app && flutter test test/features/people/presentation/health_history_cubit_test.dart`
  Expected: FAIL (`HealthHistoryCubit` doesn't exist yet).
- [ ] **Step 3: Implement** `HealthHistoryState`/`HealthHistoryCubit` as specified; delete the old cubit/freezed/test files.
- [ ] **Step 4: Regenerate freezed code**
  Run: `cd app && dart run build_runner build --delete-conflicting-outputs`
  Expected: generates `health_history_cubit.freezed.dart`; removes the stale `health_info_cubit.freezed.dart` output.
- [ ] **Step 5: Run tests to verify they pass**
  Run: `cd app && flutter test test/features/people/presentation/health_history_cubit_test.dart`
  Expected: PASS
- [ ] **Step 6: Commit**
  ```bash
  git add app/lib/features/people/presentation/cubit app/test/features/people/presentation/health_history_cubit_test.dart
  git commit -m "feat(app): add HealthHistoryCubit with previous/next navigation"
  ```

## Task 11: Flutter presentation — `HealthDetailScreen` with Previous/Next

**Files:**
- Delete: `app/lib/features/people/presentation/screens/health_info_screen.dart`
- Create: `app/lib/features/people/presentation/screens/health_detail_screen.dart`
- Modify: `app/lib/features/people/presentation/people_strings.dart`
- Create: `app/test/features/people/presentation/health_detail_screen_test.dart`

**Interfaces:**
- Consumes: `HealthHistoryCubit` (Task 10), `ListHealthHistoryUseCase`/`CreateHealthRecordUseCase` (Task 8), `getIt` (DI).
- Produces: `class HealthDetailScreen extends StatelessWidget` with `required this.memberId` — same top-level shape as today's `HealthInfoScreen` (`BlocProvider` creating `HealthHistoryCubit(getIt<ListHealthHistoryUseCase>(), getIt<CreateHealthRecordUseCase>())..load(memberId)`), wrapping a body that: shows `AppLoading`/`AppErrorView` the same way `HealthInfoScreen` does for `state.status`; otherwise renders the form for `cubit.current` (from Task 10) plus a bottom row of two buttons — `IconButton`/`TextButton` labeled with new `PeopleStrings.previous`/`PeopleStrings.next` constants, `onPressed: cubit.canGoPrevious ? () => context.read<HealthHistoryCubit>().previous() : null` (and the mirror for next) — and a label showing the displayed record's date (e.g. `PeopleStrings.recordedOn` + a formatted `current.recordedAt`).
- Produces: the save button calls `context.read<HealthHistoryCubit>().save(currentFormValues)` — reusing the exact same field-by-field `TextEditingController`/`_optional(...)` pattern `HealthInfoScreen`'s `_HealthForm` already has, just sourced from `cubit.current` instead of a `HealthInfo info` constructor param, and keyed so the form's controllers reset when `currentIndex` changes (`ValueKey((current.id, current.recordedAt))` on the form widget, extending today's `ValueKey(info.id)` pattern to also change when the synthetic blank record — `id == 0` — is shown at a different point in time).
- Produces: new `PeopleStrings` constants `previous = 'Previous'`, `next = 'Next'`, `recordedOn = 'Recorded on'` (names only — exact copy can be adjusted to match the file's existing string style).

- [ ] **Step 1:** Add the three new `PeopleStrings` constants.
- [ ] **Step 2:** Write `health_detail_screen.dart` as specified, adapting `health_info_screen.dart`'s `_HealthInfoBody`/`_HealthForm` structure: `_HealthDetailBody` reads `cubit.current` (handling `null` the same way `_HealthInfoBody` handles `info == null`), and `_HealthForm` grows a `Row` of the Previous/Next buttons plus the recorded-date label above the existing `FilledButton`. Delete `health_info_screen.dart`.
- [ ] **Step 3: Write a widget test** in `health_detail_screen_test.dart` covering the Review Focus risk of Previous/Next gating:
  ```dart
  testWidgets('Previous is disabled with a single record, enabled after loading two', (tester) async { /* pump HealthDetailScreen wrapped with a BlocProvider seeded via a mocked HealthHistoryCubit (or real cubit + mocked usecases) with records.length == 1 then == 2; verify the Previous button's onPressed is null vs non-null */ });
  testWidgets('tapping Save calls cubit.save, not an update path', (tester) async { /* mock CreateHealthRecordUseCase; verify it is invoked on Save tap; there is no update usecase in this feature anymore to assert against */ });
  ```
- [ ] **Step 4: Run the widget test**
  Run: `cd app && flutter test test/features/people/presentation/health_detail_screen_test.dart`
  Expected: PASS
- [ ] **Step 5: Commit**
  ```bash
  git add app/lib/features/people/presentation/screens/health_detail_screen.dart app/lib/features/people/presentation/people_strings.dart app/test/features/people/presentation/health_detail_screen_test.dart
  git commit -m "feat(app): add Member Health Detail screen with previous/next history navigation"
  ```

## Task 12: Flutter routing + DI wiring

**Files:**
- Modify: `app/lib/core/router/member_routes.dart`
- Modify: `app/lib/core/router/trainer_routes.dart`
- Modify: `app/lib/features/people/presentation/screens/member_dossier_screen.dart`

**Interfaces:**
- Consumes: `HealthDetailScreen` (Task 11).
- Produces: every existing reference to `HealthInfoScreen(memberId: ...)` in these three files now reads `HealthDetailScreen(memberId: ...)`, with the import updated accordingly; route `path`s (`'health'`) and `ShellStrings.*` titles are unchanged.

- [ ] **Step 1:** In `member_routes.dart` and `trainer_routes.dart`, replace the `health_info_screen.dart` import with `health_detail_screen.dart` and swap the two `HealthInfoScreen(memberId: id)` constructor calls (lines ~323 and ~151) for `HealthDetailScreen(memberId: id)`.
- [ ] **Step 2:** In `member_dossier_screen.dart`, swap the `HealthInfoScreen(memberId: person.id)` push (line ~343) for `HealthDetailScreen(memberId: person.id)`, updating its import.
- [ ] **Step 3: Regenerate DI config**
  Run: `cd app && dart run build_runner build --delete-conflicting-outputs`
  Expected: `injector.config.dart` regenerates cleanly — `GetHealthInfoUseCase`/`UpdateHealthInfoUseCase` registrations are gone, `ListHealthHistoryUseCase`/`CreateHealthRecordUseCase` are present (both still `@lazySingleton`, no manual DI registration needed beyond the annotation).
- [ ] **Step 4: Full verification**
  Run: `cd app && flutter analyze && flutter test`
  Expected: PASS, zero analyzer errors, all tests green.
- [ ] **Step 5: Commit**
  ```bash
  git add app/lib/core/router app/lib/features/people/presentation/screens/member_dossier_screen.dart app/lib/injector.config.dart
  git commit -m "feat(app): route Health to the new Member Health Detail screen"
  ```

## Task 13: Backend full verification

**Files:** none (verification only)

- [ ] **Step 1: Run full backend test suite**
  Run: `pnpm --filter api typecheck && pnpm --filter api lint && pnpm --filter api test`
  Expected: PASS
- [ ] **Step 2: Re-check OpenAPI parity once more** (guards against any drift introduced by Tasks 1–6 landing after Task 7's parity check)
  Run: `pnpm --filter api openapi:dump && pnpm --filter api openapi:check`
  Expected: PASS
- [ ] **Step 3:** If either step fails, fix forward in the task that owns the failing file and re-run; do not weaken a check to make it pass.
