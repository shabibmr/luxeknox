# V3-05c — Assign / reassign trainer

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-05b |
| **Files** | ≤7 |

## Why

`POST /members/{id}/assign-trainer` (`AssignTrainerRequest`: `trainer_id`,
`override_capacity`, `reason`). FR-PEOPLE-013: inactive trainers cannot take new assignments.
Capacity exceeded → 422 unless admin override. FR-PEOPLE-007 notifications deferred — **audit
only**.

## Files

- Extend `member.service.ts` / `member.controller.ts` / dto
- Possibly `trainer.repository.ts` read helpers if not yet from V3-06 — prefer minimal read in
  member repo (`trainers.is_active`, `max_clients_capacity`, assigned count)
- Audit helper (existing M0-19)

## Work

- Validate trainer exists and `is_active=true` (else 422).
- Count current assigned members; if `>= max_clients_capacity` and `override_capacity` is not
  true **or** principal lacks admin override privilege → 422.
- Admin (or `override_capacity` + permission) may force assign; record `reason` in audit.
- Reassign: update `assigned_trainer_id`; write audit_logs; **no** notification send.
- Permission: `members.update`.
- Row-scope on target member.

## Done when

- Capacity 422 + admin override paths work.
- Inactive trainer rejected.
- Audit row on assign/reassign; no NOTIF side effects.
- lint/typecheck/test green.
