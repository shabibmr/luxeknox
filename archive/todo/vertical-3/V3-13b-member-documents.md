# V3-13b — Member documents + flip x-status

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-13a |
| **Files** | ≤7 |

## Why

OpenAPI `/members/{id}/documents` (+ verify + delete) are `deferred`. Flip to `mvp` and wire
attach-after-signed-PUT. BR-HEALTH-001: trainers must never receive identity-proof files on GET.

## Files

- Document repo/service/controller/dto
- `docs/openapi/v1.yaml` — flip documents paths to `mvp`
- Media purpose checks integration
- Row-scope + health perms (`health.read` / `health.update` / `health.approve` for verify)

## Work

- List/create/delete documents; create accepts media key from `/media/uploads` for purposes
  `id_proof` | `waiver` | `medical_cert`.
- `POST …/verify` with `health.approve` sets verified_by / verified_at.
- GET list/detail: if purpose/`document_type` is `id_proof`, **deny trainers** (404 or 403 per
  BR-HEALTH-001 — prefer consistent 404 with row-scope philosophy unless OpenAPI says 403).
- Flip all document path `x-status` deferred → mvp.
- Audit on create/verify/delete.

## Done when

- Documents CRUD + verify; trainer cannot fetch id_proof.
- YAML documents mvp.
- lint/typecheck/test green.
