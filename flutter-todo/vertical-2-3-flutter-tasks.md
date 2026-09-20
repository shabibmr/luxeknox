# Vertical 2 & 3 — Flutter task register (Food Library + PEOPLE / Members)

Follows the format and conventions of [`vertical-1-flutter-tasks.md`](./vertical-1-flutter-tasks.md).
Execute top to bottom. Check a box when the code change is in.

## Blocking dependency — read first

The Flutter API client (`packages/api_client`) is **generated from
[`docs/openapi/v1.yaml`](../docs/openapi/v1.yaml)**. That contract today exposes only
`auth`, `me`, `exercises`, `settings`, `health`. It has **no `foods`, `members`/`people`,
`profiles`, `health-info`, or `media` paths**. Therefore:

- **Each vertical below is gated on its backend OpenAPI contract landing first.** The Flutter
  work cannot start its data layer until the paths exist and `bash tool/gen.sh` has regenerated
  the client (per ADR-0006 / vertical-1 Phase B).
- Domain and presentation scaffolding (pure Dart, no `api_client`) *can* be written against the
  screen specs ahead of the contract, but wiring waits for regen.

## Global rules (apply to every task — same as vertical 1)

- Layer boundaries enforced by `tool/check_layers.sh`: `presentation/` must not import `data/`;
  `domain/` must not import `package:flutter`; neither `domain/` nor `presentation/` may import
  `package:api_client`. Generated types live only in `data/`.
- `flutter analyze` zero issues; `dart format --set-exit-if-changed .` clean.
- All repository methods return `Future<Either<Failure, …>>`; reuse `core/error` mapper and
  `core/network` Dio stack unchanged. **Reuse `core/` as-is — no new core work in V-02.**
- Role behaviour is driven by `context.can(<slug>)` against `Capabilities`, never by hard-coded
  role checks.

---

# Vertical 2 — Food Library (screen 36; DIET §15)

**Thesis (ADR-0007):** structurally identical to the Exercise Library, no media. This is the
**reuse regression test** — if it is materially slower than a mechanical clone of the exercises
feature, the vertical-1 patterns are wrong and must be fixed before the hub (V-03). Budget it as a
clone, not a redesign.

**Contract gate:** `GET/POST /v1/foods`, `GET/PATCH /v1/foods/{id}` (browse/search by name +
`is_active`; nutrition per 100g/serving) present in `v1.yaml` and client regenerated.

**Fields (per screen 36 / admin spec):** name, serving size + unit, calories, protein, carbs, fats,
fiber, `is_active`. No media URLs.

## Phase N — Contract & client
| ID | Task | Creates / Touches | Done when |
| :-- | :-- | :-- | :-- |
| N1 | Confirm `foods` paths merged into `docs/openapi/v1.yaml`; regenerate client | `packages/api_client` | `bash tool/gen.sh` clean; `FoodsApi` present |

## Phase O — Foods: domain (mirror exercises `domain/`)
| ID | Task | Creates | Done when |
| :-- | :-- | :-- | :-- |
| O1 | `Food` entity (nutrition fields above), pure Dart, value equality | `features/foods/domain/entities/food.dart` | No Flutter/`api_client` import |
| O2 | `FoodFilter` (query, isActive) | `features/foods/domain/entities/food_filter.dart` | Mirrors `ExerciseFilter` |
| O3 | Abstract `FoodRepository` (list, get, create, update, deactivate) | `features/foods/domain/repositories/food_repository.dart` | All return `Either<Failure, …>` |
| O4 | Five use cases, one file each (get/list/create/update/deactivate) | `features/foods/domain/usecases/*.dart` | Each has a unit test with a mocked repo |

## Phase P — Foods: data
| ID | Task | Creates | Done when |
| :-- | :-- | :-- | :-- |
| P1 | `FoodModel` + model↔entity mapper | `features/foods/data/models/food_model.dart` | Generated types confined here |
| P2 | `FoodRemoteDataSource` over generated `FoodsApi` (offset pagination, opaque cursor — copy exercises J1/J4) | `features/foods/data/datasources/food_remote_datasource.dart` | Search + filter round-trip |
| P3 | `FoodRepositoryImpl` calling `mapThrownToFailure` | `features/foods/data/repositories/food_repository_impl.dart` | Reuses shared error mapper |

## Phase Q — Foods: presentation (clone exercises Phase K minus media)
| ID | Task | Creates | Done when |
| :-- | :-- | :-- | :-- |
| Q1 | `FoodListBloc` + freezed state/events (status field, debounce 300ms, append-on-scroll pagination) | `features/foods/presentation/bloc/…` | `bloc_test` mirrors K1–K3 |
| Q2 | Food list item: name, calories, macro summary badge | `features/foods/presentation/widgets/food_list_item.dart` | Renders from a `Food`, no fetching |
| Q3 | Food Library screen: search, filter chips, list, empty/error, pull-to-refresh; admin sees add | `features/foods/presentation/screens/food_library_screen.dart` | Member browse / trainer pick / admin CRUD |
| Q4 | Filter sheet (isActive; extend if backend adds category) with clear-all | `features/foods/presentation/widgets/food_filter_sheet.dart` | Applying re-queries |
| Q5 | `FoodDetailCubit` + state | `features/foods/presentation/cubit/food_detail_cubit.dart` | Covers success/not-found/failure |
| Q6 | Food Details screen: full nutrition + **macro-percentage breakdown** widget | `features/foods/presentation/screens/food_detail_screen.dart` | Push on phone; admin sees edit |
| Q7 | Create/edit form: numeric validation on macros, admin-only via `context.can('foods.create'/'foods.update')`, deactivate with confirm | `features/foods/presentation/screens/food_form_screen.dart` | Non-admin cannot reach route; empty/invalid blocked |
| Q8 | Master-detail at ≥840dp (reuse exercises K11 pattern) | `food_library_screen.dart` | Phone push, desktop side pane |
| Q9 | `foods_strings.dart` (centralized UI strings) | `features/foods/presentation/foods_strings.dart` | No raw literals in widgets |

## Phase R — Routing & DI
| ID | Task | Touches | Done when |
| :-- | :-- | :-- | :-- |
| R1 | Replace the `adminDietLibrary` `PlaceholderScreen` with `FoodLibraryScreen`; add member/trainer diet-library routes under their More hubs | `core/router/{admin,member,trainer}_routes.dart`, `routes.dart` | No raw path strings outside `routes.dart` |
| R2 | `@injectable` annotations on datasource/repo/usecases/bloc/cubit; run build_runner | `injector.config.dart` | DI resolves `FoodListBloc` |

## Phase S — Tests & acceptance
| ID | Task | Done when |
| :-- | :-- | :-- |
| S1 | Role-variant widget tests (member/trainer/admin) reusing vertical-1 `L1` test helpers | Three roles assert correct affordances |
| S2 | Bloc/cubit tests green (debounce, pagination, detail states) | — |
| S3 | Goldens at 390 / 1280 for library + detail | — |

---

# Vertical 3 — PEOPLE / Members (the hub; screens 02–09)

**Thesis (ADR-0007):** the hub that unblocks everything else. It introduces **row-level scoping**
(BR-PEOPLE-002/003 — self vs assigned-client vs any) and is where the **deferred MEDIA work comes
due** (ADR-0005 → write ADR-0008 first). Budget the media lift explicitly here — do not discover it
mid-sprint.

**Hard gates before any Flutter data work:**
1. **Product-owner sign-off** on document-capture scope (ADR-0005 flags paper-desk waivers as the
   descoped fallback).
2. **ADR-0008 written** and `MEDIA` endpoints in the contract: FR-MEDIA-001 (signed PUT),
   FR-MEDIA-002 (size/MIME per purpose), FR-MEDIA-003 (short-lived signed GET honouring the parent
   entity's row-level rules).
3. `people`/`profiles`/`health`/`documents` paths in `v1.yaml`; client regenerated.

**Screens in scope (consolidated-screens 02–09):** 02 Profile (adaptive: member self / trainer
client 360° / admin master dossier), 03 Edit Profile, 04 Health Information, 05 Medical History
(uploads), 06 Emergency Contacts, 07 Documents & Photos Gallery (uploads), 08 Membership Details
(read-only slice — full MEMB is a later vertical), plus an **admin Members list**.

**Data-leak rule to enforce in UI (BR-HEALTH-001):** trainers must **never** be shown or fetch
identity-proof / waiver files. Gate document access by purpose + role, not just by the parent
capability.

## Phase T — Prereqs & contract
| ID | Task | Done when |
| :-- | :-- | :-- |
| T1 | Confirm gates 1–3 above are met; regenerate client | `PeopleApi` + `MediaApi` present |

## Phase U — Core media surface (new `core/` work — first upload feature)
| ID | Task | Creates | Done when |
| :-- | :-- | :-- | :-- |
| U1 | `MediaUploader`: request signed PUT → upload bytes → return object key; size/MIME validated client-side per purpose (FR-MEDIA-001/002) | `core/media/media_uploader.dart` | Oversize/wrong-MIME rejected before upload |
| U2 | `SignedMediaImage`/`SignedFileLink`: fetch short-lived signed GET, loading/broken/forbidden states (FR-MEDIA-003) | `core/media/…` | 403 shows "no access", never a crash |
| U3 | File/photo picker wrapper (camera + gallery + document) | `core/media/media_picker.dart` | Returns bytes + MIME; permissions handled |
| U4 | `DocumentPurpose` enum + guard helper encoding **BR-HEALTH-001** | `core/media/document_access.dart` | Trainer + identity-proof purpose → denied |

## Phase V — People: domain
| ID | Task | Creates | Done when |
| :-- | :-- | :-- | :-- |
| V1 | Entities: `Person`, `ProfileSummary`, `HealthInfo`, `MedicalRecord`, `EmergencyContact`, `MemberDocument` | `features/people/domain/entities/*.dart` | Pure Dart, value equality |
| V2 | `PersonScope` value object (self / assignedClient / any) driving BR-PEOPLE-002/003 | `features/people/domain/entities/person_scope.dart` | Resolves from `Capabilities` + subject id |
| V3 | Abstract repos: `PeopleRepository`, `ProfileRepository`, `DocumentRepository` | `features/people/domain/repositories/*.dart` | All return `Either<Failure, …>` |
| V4 | Use cases: list/search members, get profile, update profile, get/update health, list/upload/delete documents, emergency contacts CRUD | `features/people/domain/usecases/*.dart` | Each unit-tested with mocked repo |

## Phase W — People: data
| ID | Task | Creates | Done when |
| :-- | :-- | :-- | :-- |
| W1 | Models + mappers for every entity in V1 | `features/people/data/models/*.dart` | Generated types confined to `data/` |
| W2 | Remote datasources over `PeopleApi`; document datasource composes `MediaUploader` | `features/people/data/datasources/*.dart` | Upload writes key then links to person |
| W3 | Repo impls via `mapThrownToFailure` | `features/people/data/repositories/*.dart` | Shared error mapper reused |

## Phase X — Members & Profile presentation (screens 02–08)
| ID | Task | Creates | Done when |
| :-- | :-- | :-- | :-- |
| X1 | `MemberListBloc` (search, filter, pagination — reuse foods pattern) | `features/people/presentation/bloc/…` | Admin-only list |
| X2 | Members list screen (admin) with master-detail ≥840dp | `.../screens/member_list_screen.dart` | Non-admin cannot reach route |
| X3 | Adaptive Profile screen (02): member self / trainer client 360° / admin dossier, driven by `PersonScope` | `.../screens/profile_screen.dart` | Each role sees the correct sections |
| X4 | Edit Profile (03): member/trainer self fields; admin also roles/status/membership links | `.../screens/edit_profile_screen.dart` | Field editability gated by scope |
| X5 | Health Information (04) + Medical History (05) with document upload | `.../screens/health_*_screen.dart` | Trainer read-only; member edits self |
| X6 | Emergency Contacts (06) CRUD | `.../screens/emergency_contacts_screen.dart` | Editable by member/admin, read by trainer |
| X7 | Documents & Photos Gallery (07): upload, view, admin approve/delete; **enforces BR-HEALTH-001** | `.../screens/documents_gallery_screen.dart` | Trainer never sees identity-proof docs |
| X8 | Membership Details read-only slice (08) | `.../screens/membership_details_screen.dart` | Full MEMB deferred to later vertical |
| X9 | `people_strings.dart` | `features/people/presentation/people_strings.dart` | No raw literals |

## Phase Y — Scoping enforcement & routing
| ID | Task | Touches | Done when |
| :-- | :-- | :-- | :-- |
| Y1 | Wire People/Profile/Documents routes into member, trainer, admin shells (profile tab replaces vertical-1 placeholder profile) | `core/router/*` | Deep links respect scope + redirect |
| Y2 | `@injectable` wiring + build_runner | `injector.config.dart` | DI resolves all blocs/cubits |

## Phase Z — Tests, leak gate, release
| ID | Task | Done when |
| :-- | :-- | :-- |
| Z1 | Row-level scope tests: member cannot fetch another member; trainer only assigned clients (BR-PEOPLE-002/003) | Forbidden paths mapped to `AuthFailure`/hidden UI |
| Z2 | **BR-HEALTH-001 leak test** — trainer session + identity-proof document → denied at datasource *and* UI | Explicit acceptance gate; must be green |
| Z3 | Media tests: signed-PUT happy path, oversize/MIME reject, signed-GET 403 fallback | — |
| Z4 | Role-variant widget/acceptance tests for screens 02–08; goldens 390 / 1280 | — |

---

## Notes & risks

- **V-02 is a velocity signal, not a feature.** Track how long it takes vs. a mechanical exercises
  clone; a large gap means fix vertical-1 patterns before starting V-03.
- **V-03 media is the real cost.** It is a new `core/media` surface, ADR-0008, and a product decision
  — sequence it before the PEOPLE UI, not alongside it.
- **BR-HEALTH-001 is a data-leak rule, not a nicety.** It has a dedicated acceptance test (Z2) and
  blocks release if red.
- Both verticals are **blocked on the backend OpenAPI contract**; domain/presentation scaffolding may
  proceed ahead of it, data wiring may not.
