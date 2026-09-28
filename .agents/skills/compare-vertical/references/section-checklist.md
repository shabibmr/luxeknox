# Implementation-picture sections

Mirror this order. Title block is unnumbered; body sections match
`docs/vertical-1-exercise-library-implementation.md` §§1–9.

**Evidence** — CRUD row cites HTTP method and permission slug from Nest and OpenAPI (record drift). Every layout path exists or is `not in tree`. Unknowns are `unverified` or `not in tree`.

**Title block** — vertical id/name, in-scope FR/ADR, out-of-scope siblings, ticket status one-liner, link to the UI design doc if it exists.

1. **What “CRUD” means here** — Operation | HTTP | Permission | Notes for list, get, create, update, delete/deactivate.
2. **End-to-end stack** — Flutter UI → Bloc/Cubit → use cases → repo → remote DS → generated API → Nest controller → service → repository → table. Contract file + client package.
3. **Backend (Nest)** — layout paths; table columns; list/get/create/update behavior; Zod validation.
4. **Permissions (seeded)** — Admin / Trainer / Member matrix and what each role can do.
5. **Flutter (Clean Architecture)** — domain, data + mapper quirks, presentation gates, routes per role. Keep this to wiring; layout/states belong in the UI design doc.
6. **Read / Create / Update / Delete flows** — numbered UI → API steps.
7. **Tests / verification already in tree** — API unit/e2e; Flutter unit/bloc/widget. Paths only.
8. **Boundaries** — in vertical vs same-module later work vs sibling features.
9. **Takeaways** — 4–6 bullets, then **vs Vertical 1** scored from the delta table below.

## Delta axes vs Vertical 1

Score each axis **match | partial | different | missing** with one evidence path. V1 facts below are the comparison baseline; the filled narrative stays in `docs/vertical-1-exercise-library-implementation.md`.

| Axis | V1 baseline |
| :--- | :--- |
| HTTP surface | `GET/POST /v1/exercises`, `GET/PATCH /v1/exercises/{id}`; no DELETE |
| Soft-deactivate | `PATCH { is_active: false }`; no `exercises.delete` |
| Visibility | inactive hidden unless actor has `exercises.update` |
| Permissions | `exercises.read` all roles; `exercises.create` admin+trainer; `exercises.update` admin only |
| Nest layout | controller / service / repository / dto / schema / module |
| Audit | `exercise.created` / `exercise.updated` |
| Flutter layers | domain → data → presentation; five use cases including deactivate |
| Deactivate client | GET then PATCH (server also accepts partial `{ is_active: false }`) |
| Pagination | offset; Flutter cursor is offset-as-string |
| Mapper shims | `id` int↔String; null→empty; `equipment_needed` string↔`List<String>` in `exercise_model.dart` |
| Media | external `video_url` / `gif_url` only |
| Contract | `docs/openapi/v1.yaml` + `packages/api_client` |
