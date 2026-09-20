# V3-14 — Onboarding e2e

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-09, V3-13c |
| **Files** | ≤7 |

## Why

End-to-end proof of FR-PEOPLE multi-step onboarding against real MySQL/MariaDB test helper:
create member → login (`sessions.profile_id`) → emergency contact → signed PUT waiver attach.

## Files

- `apps/api/test/people-onboarding.e2e.spec.ts` (new) — or split if needed
- Test helpers under `apps/api/test/helpers/` if required
- Possibly seed fixtures

## Work

Happy path:

1. Admin `POST /members` with credentials + names.
2. Login as that member → assert session/`/me` profile_id non-null.
3. `POST /users/{id}/emergency-contacts` with primary contact.
4. `POST /media/uploads` purpose `waiver` → signed PUT (local adapter) → attach document.
5. Optional: member_health PATCH.

Negative smoke (may share with V3-16): trainer 404 unassigned member; trainer denied id_proof.

Use `pnpm --filter api test:e2e` pattern from foods e2e.

## Done when

- Onboarding e2e green on verification DB / CI mysql service.
- lint/typecheck/unit still green.
