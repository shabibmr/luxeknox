# V3-12 — Health / documents / photos schema (`0005`)

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-02 only (**not** blocked on MEDIA) |
| **Files** | ≤7 |

## Why

`member_health`, `member_documents`, `member_photos` (and ensure `emergency_contacts` if not in
V3-02/V3-08) are needed before nested routes. Schema can land before StorageService — store URL /
object key strings only (FR-API-013).

**Do not** add `health_conditions` / `medical_histories` tables (deferred in V3-01).

## Files

- `apps/api/src/platform/db/schema/member-health.ts` (new)
- `apps/api/src/platform/db/schema/member-documents.ts` (new)
- `apps/api/src/platform/db/schema/member-photos.ts` (new)
- `apps/api/src/platform/db/schema/index.ts`
- `apps/api/drizzle/0005_health_media_meta.sql` (new)
- `apps/api/drizzle/meta/0000_snapshot.json`
- `docs/database-entities.md` touch if attributes drift

## Work

- `member_health`: one current row per member — blood_group, height_cm, baseline_weight_kg,
  allergies, dietary_preferences, physician_*, timestamps.
- `member_documents`: document_type (`id_proof`|`waiver`|`medical_cert`), title, file_url/key,
  file_size, verified_by_user_id, verified_at.
- `member_photos`: photo_url/key, is_current_avatar, captured_at.
- Grants + MariaDB collation notes as with foods/people.
- `db:check` clean.

## Done when

- Migration applies (or MariaDB manual path documented).
- No conditions/medical_histories tables.
- lint/typecheck/test green.
