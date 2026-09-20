# V3-04 — Row-scope helper (404)

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-03 |
| **Files** | ≤7 |

## Why

BR-PEOPLE-002/003: members must not see other members' dossiers; trainers must not see
unassigned members. Leak via 403 reveals existence — use **404** for out-of-scope rows.
Shared helper used by members/trainers/health/EC routes.

## Files

- `apps/api/src/people/row-scope.ts` (new) — or `platform/authz/row-scope.ts`
- `apps/api/src/people/row-scope.spec.ts` (new)

## Work

- Helper takes principal + target resource identity and returns void or throws not-found
  (reuse platform error helper / Nest NotFoundException consistent with exercises).
- Rules:
  - **Admin / employee with directory perms:** no row filter (permission guard already gated).
  - **Member:** may only access own `user_id` / own `member.id` (and own emergency contacts).
  - **Trainer:** may only access members where `assigned_trainer_id` = trainer's profile id;
    own trainer profile readable.
- Keep helper free of HTTP; services call it before returning rows.
- Unit-test matrix: admin ok; member other → 404; trainer unassigned → 404; trainer assigned → ok;
  member self → ok.

## Done when

- Helper + unit tests land; no controllers yet required.
- lint/typecheck/test green.
