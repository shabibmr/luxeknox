# V3-08 — Emergency contacts

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-01, V3-04 |
| **Files** | ≤7 |

## Why

OpenAPI: `GET/POST /users/{id}/emergency-contacts`,
`PATCH/DELETE /users/{id}/emergency-contacts/{contactId}`. Contacts hang off `user_id` (members
**and** staff). At most one `is_primary=true` per user (entities uniqueness note). Permissions
`health.read` / `health.update`. Row-scope 404.

## Files

- `apps/api/src/platform/db/schema/emergency-contacts.ts` (new) + export
- `apps/api/drizzle/0004_people.sql` **or** small follow-up migration if contacts were deferred
  from V3-02 — prefer including table in V3-02; if missing, add `0004b` / fold into next migration
  within file budget
- `apps/api/src/people/emergency-contact.*.ts` (repo/service/controller/dto as needed)
- Wire module

## Work

- Schema: `id`, `user_id`, `contact_name`, `relationship`, `phone_primary`, `phone_secondary`,
  `is_primary`; unique primary via generated column or transactional unset-others pattern
  (MariaDB-safe — document choice).
- List/create/update/delete with health perms.
- Setting `is_primary=true` clears previous primary in same TX.
- Row-scope: caller may only manage contacts for in-scope users (self / assigned / admin).
- No medical_histories.

## Done when

- EC CRUD works; primary uniqueness enforced.
- Out-of-scope user id → 404.
- lint/typecheck/test green.
