# V3-11 — StorageService + `/media/*` mvp

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-10, V3-02 |
| **Files** | ≤7 |

## Why

OpenAPI `/media/uploads` (`media.create`) and `/media/{key}` (`media.read`) are `deferred`.
Flip to `mvp` and implement signed PUT/GET per ADR-0008. Purpose authz must enforce
BR-HEALTH-001 early (even before documents routes attach keys).

## Files

- `apps/api/src/media/storage.service.ts` (new)
- `apps/api/src/media/media.controller.ts` (new)
- `apps/api/src/media/media.module.ts` (new)
- `apps/api/src/media/media.dto.ts` (new)
- `docs/openapi/v1.yaml` — flip `/media/*` `x-status: mvp`
- `apps/api/src/app.module.ts`
- Config / env example keys for local root + optional S3 (do not edit user `.env`)

## Work

- StorageService: createUploadSlot(purpose, …) → signed PUT URL + object key; getSignedGet(key).
- Local disk adapter for dev; S3 interface as ADR specifies.
- Purpose enum + size/MIME limits (FR-MEDIA-002).
- Authz: `media.create` / `media.read`; deny trainer GET when purpose/key is `id_proof`
  (BR-HEALTH-001) — prefer purpose metadata stored with key or key prefix convention.
- Flip YAML `/media/uploads` and `/media/{key}` to `mvp`.
- No BLOB columns. No streaming file body through Nest except redirect/sign.

## Done when

- Create upload slot + signed GET work locally.
- Trainer denied id_proof GET (unit or e2e stub).
- YAML media paths mvp.
- lint/typecheck/test green.
