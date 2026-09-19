# Fix Vertical 1 review findings

Source: [vertical-1-code-review.md](vertical-1-code-review.md) vs spec [../flutter-todo/vertical-1-flutter-tasks.md](../flutter-todo/vertical-1-flutter-tasks.md).

Execute in order. Do not start later phases until the earlier phase’s tests pass.

**Implementation model: Grok 4.5** (`grok-4.5`). The parent orchestrator may stay on the current model for sequencing, review, and verification. Every FIX-01…FIX-27 code-edit subagent must be spawned with `model: grok-4.5`. Do not implement the Flutter diffs on Grok 4.6.

## Decisions (do not reopen during implementation)

| Finding | Decision |
| :--- | :--- |
| J1 cursor vs OpenAPI offset | Keep domain `CursorPage`. In `ExerciseRemoteDataSourceImpl`, pass **`offset`** (parse opaque cursor as `int`, default 0). Never send a `cursor` query param. Set `nextCursor` from `meta.nextCursor`, else `offset + items.length` when `hasMore`. |
| J2 `equipment_needed` | OpenAPI is a **single string**. Stop comma-splitting. Map null/empty → `[]`, otherwise `[raw]`. Write-back joins with no added commas (`items.singleOrNull`). |
| K9 YouTube vs mp4 | No inline player. `Image.network` for `.gif`/image URLs; **`url_launcher`** for every other https URL; broken/no-link fallbacks. Matches ADR-0005 (external URL). |
| L4 suspension | Do **not** add a fourth `SessionState`. F7 is `unknown \| authenticated \| unauthenticated`. Suspended/revoked = `AuthFailure` on restore/refresh → `unauthenticated` (FR-AUTH-010). Cover with a `bloc_test`. |
| G6 More tab vs G1 | Do **not** invent `/admin/more`. More branch = sibling `GoRoute`s for every nav-§4 More path (placeholders except workout-library). **Default location** of the branch stays `/admin/workout-library`. `MoreHubScreen` is the 5th-tab chrome: tapping More opens the hub (list of those routes); hub tiles `context.go` the documented paths. |
| G3 unknown-first | Keep `SessionUnknown` → splash **before** unauthenticated. Required for H1. G3 “unauthenticated first” applies after session is known. |
| Scope creep to keep | `redirect_logic.dart`, `FailureDioException`, `AppEnvironment`, `SessionCubit.onSignedOut`, extra unit tests. They implement named tasks or make them testable. |
| Scope creep to delete | Empty unused `app/lib/features/auth/{data,domain,bloc}` leaves (H* only needs `presentation/`). |
| Primitive `userType` | Domain enum `UserType { member, trainer, employee, admin }` in `session/domain`. Mapper uses generated `api.UserType`. Redirect switches on the enum. |
| Thin use cases | **Keep** (ADR-0006 §2). |
| Debounce smell | Add `rxdart` + `bloc_concurrency`. Search event uses `debounceTime(300ms)` + `switchMap`. Delete the 80-line hand-rolled transformer. |
| M1 icons | Brand PDF is gone. Set display name / bundle ids (M2). Leave stock launcher icons unless a brand PNG appears under `docs/`. Do not invent a luxury logo. |
| M6 crash reporting | No vendor chosen. `[NEW]` `CrashReporter` no-op (`developer.log` in debug). Do **not** add Sentry/Firebase. Dashboard verification stays blocked. |
| Extra tests | Keep. Extend them where a fix makes an assertion wrong. |

## Out of scope

- Backend/OpenAPI changes (client follows committed `docs/openapi/v1.yaml`).
- Food library / later verticals.
- Real crash-reporting account, store signing, physical-device icon check.

See [tasks.md](tasks.md) for the executable checklist and phase tables.
