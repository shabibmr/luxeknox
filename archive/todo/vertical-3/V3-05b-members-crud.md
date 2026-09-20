# V3-05b — Members list / create / get / patch

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-05a |
| **Files** | ≤7 |

## Why

OpenAPI mvp ops: `GET/POST /members`, `GET/PATCH /members/{id}` (`Member` / `MemberDossier` /
`MemberCreate` / `MemberUpdate`). First consumer of person factory + row-scope.

## Files

- `apps/api/src/people/member.repository.ts` (new)
- `apps/api/src/people/member.service.ts` (new)
- `apps/api/src/people/member.dto.ts` (new)
- `apps/api/src/people/member.controller.ts` (new)
- `apps/api/src/people/people.module.ts` (new)
- `apps/api/src/app.module.ts` (wire module)
- Possibly reuse factory from V3-03 (import only)

## Work

- Permissions: `members.read` / `members.create` / `members.update` via PermissionGuard.
- `POST`: person factory (user_type member + members row); allocate `membership_number`; audit log.
- `GET /{id}`: return `MemberDossier` with MEMB/ATTN/PAY/SCHED fields **null**; apply row-scope.
- `PATCH`: profile fields only; **reject** attempts to change `membership_number` (immutable);
  do not expose password.
- `GET` list: pagination; filters that need MEMB (if any in YAML) ignored/null in V3.
- Soft conventions: no DELETE endpoint.
- Wire `PeopleModule` like `DietModule` / `WorkModule`.

## Done when

- Routes live behind auth + permission slugs.
- Create returns member with `membership_number`; patch cannot mutate it.
- Dossier extras null.
- Unit stubs optional here if file budget tight (full matrix in V3-15).
- lint/typecheck/test green.
