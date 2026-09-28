# Vertical starting map

Verify paths on disk before writing. Discover anything not listed from
`docs/adr/0007-first-delivery-vertical.md`, `docs/openapi/v1.yaml` tags, and
`apps/api/src/**` + `app/lib/features/**`.

| Vertical | In-scope resource | Nest | Flutter | Tickets | Out of this vertical |
| :--- | :--- | :--- | :--- | :--- | :--- |
| V1 Exercise Library | catalogue exercises | `apps/api/src/work/exercise.*` | `app/lib/features/exercises/` | `archive/todo/vertical-1/` | `workout-plan.*` / `workout-session.*`; `app/lib/features/workout/` |
| V2 Food Library | catalogue foods (FR-DIET-001) | `apps/api/src/diet/food.*` | `app/lib/features/foods/` | `archive/todo/vertical-2/` | diet plans/logs; `app/lib/features/diet/` |
| V3 PEOPLE | members, trainers, employees, profile, emergency contacts, member health/documents/photos | `apps/api/src/people/` | `app/lib/features/people/` | `archive/todo/vertical-3/` | medical-histories deferred in places; plans/payments/schedule |
| MEDIA (with V3) | signed upload/download | `apps/api/src/media/` | `app/lib/core/media/` | `archive/todo/vertical-3/` (V3-10, V3-11) | BLOB storage |

Output names:

- Stack picture: `docs/vertical-<n>-<slug>-implementation.md`
- UI design: `docs/vertical-<n>-<slug>-ui-design.md`
- Gap plan: `docs/vertical-<n>-<slug>-gap-plan.md`

Examples: `docs/vertical-2-food-library-implementation.md`, `docs/vertical-2-food-library-ui-design.md`, `docs/vertical-2-food-library-gap-plan.md`.
