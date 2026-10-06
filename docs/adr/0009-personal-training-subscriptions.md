# ADR-0009 — Personal Training as its own package, with a fixed trainer slot

| | |
| :--- | :--- |
| **Status** | **Accepted** |
| **Date** | 2026-09-29 |
| **Resolves** | Personal Training sale, trainer assignment and trainer scheduling |
| **Related** | [ADR-0004](./0004-tenancy-model.md), FR-MEMB-009, FR-SCHED-005/016, BR-SCHED-003 |
| **Supersedes** | The per-membership PT counter (`membership_products.pt_sessions_included` → `memberships.remaining_pt_sessions`) |

## Context

The gym sells Personal Training (PT) as an add-on for members whose membership has not
expired. A trainer is assigned for the whole PT period at a fixed hour on fixed weekdays.
That trainer-hour must show as occupied to everyone else for the whole period. Any active
trainer can take any member. The trainer then works on the member's goals,
workout plans and diet plans.

The old model kept a session counter on the membership. It had no trainer and no slot, and it could not block a trainer's hour for weeks at a time.

## Decision

1. **Separate PT package.** `pt_products` holds name, code, duration_days,
   sessions_per_week and price. PT is sold on its own invoice (`payments.pt_subscription_id`).
2. **PT subscription = trainer + recurring slot.** `pt_subscriptions` stores member, package,
   trainer, start/end, `weekdays` (count = sessions_per_week) and a one-hour `slot_start` on
   the hour. There is one open (scheduled/active) PT per member; a renewal queues the day
   after the current end date.
3. **Occupancy uses real schedule rows.** Each PT day becomes a `schedules` row
   (type "Personal Training", capacity 1, `pt_subscription_id` set) plus a booked
   participant. Calendars, attendance and the existing overlap checks work without changes.
   A trainer-hour is **free** only if it falls inside the trainer's `trainer_availabilities`
   and has no clash on *every* PT date. Sales lock the trainer row (`SELECT … FOR UPDATE`)
   and re-check before inserting.
4. **No gender rule.** Member and trainer gender do not restrict PT. Trainers are listed
   regardless of gender, and a missing gender does not block a sale. *(Amended: the
   original same-gender rule was removed. Trainer and member gender are no longer checked.)*
5. **Membership gate.** A sale needs an `active` membership whose end date has not passed.
   PT may run beyond the membership end date.
6. **Payment gate.** A sale or renewal only goes through when payment activates it (paid,
   or partial when `payments_activate_membership_on_partial` is on). Otherwise nothing is
   written.
7. **Trainer access.** PT sets `members.assigned_trainer_id`, so reads follow the existing
   row scope. Writes to goals, workout plans and diet plans additionally require an
   **active** PT between that trainer and member (`PtAccessService`). After PT ends the
   trainer stays assigned but is read-only until renewal. `trainer_access` is exposed on
   `GET /members/{id}/pt-subscriptions`.
8. **Mid-PT changes.** `reassign-trainer` and `change-slot` (optionally with a new trainer)
   cancel the future generated sessions from an effective date and regenerate them.
   Past sessions and attendance are left alone. Every change is recorded in
   `pt_subscription_changes`.
9. **Trainer capacity.** `trainers.max_clients_capacity` is not applied to PT; the hourly
   slots are the only limit. It still applies to the manual assign-trainer action.
10. **Old counter retired.** Membership create/renew/upgrade no longer set
    `remaining_pt_sessions`, and attendance no longer decrements it. The columns stay
    until a later cleanup migration. There was no production PT data to migrate.

## Consequences

- A sale writes one schedule row per PT day, about 40 for a 3-per-week, 90-day package.
  This is acceptable at single-gym scale (ADR-0004).
- An hourly job moves subscriptions `scheduled → active → completed` using the gym-timezone
  date.
- Trainer availability edits do not re-validate existing PT sessions. Staff re-plan
  through change-slot or reassign-trainer.
