# V3-07 — Employees API + role + status

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-04 |
| **Files** | ≤7 |

## Why

OpenAPI: `GET/POST /employees`, `GET/PATCH /employees/{id}`, `PUT /employees/{id}/role`
(`roles.update`), `POST /employees/{id}/status` (`employees.update`). Terminate/suspend must
make the user non-authable and revoke sessions.

## Files

- `apps/api/src/people/employee.repository.ts`
- `apps/api/src/people/employee.service.ts`
- `apps/api/src/people/employee.dto.ts`
- `apps/api/src/people/employee.controller.ts`
- Session revoke via existing session repository
- Wire `PeopleModule`

## Work

- Create via person factory (`user_type=employee`) with `first_name`/`last_name`, `job_title`,
  `role_id` (EmployeeCreate required fields); password required by Zod even if YAML soft.
- Exactly one assigned role (MVP); `PUT /role` swaps role; permission `roles.update`.
- `POST /status`: set `employees.status`; when `suspended` or `terminated`:
  - set `users.status` to non-authable value used by login guard
  - revoke all sessions for that user
- `trainers.is_active` pattern does **not** apply — employment status drives auth here.
- Permissions: `employees.read|create|update` (+ `roles.update` for role endpoint).
- Audit on create/update/status/role.

## Done when

- CRUD + role + status routes live.
- Suspend/terminate blocks subsequent login (assert in unit or defer full e2e to V3-14/16).
- lint/typecheck/test green.
