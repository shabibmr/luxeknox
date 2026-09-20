# ADR-0008 — Object storage & MEDIA (signed PUT/GET)

| | |
| :--- | :--- |
| **Status** | **Accepted** |
| **Date** | 2026-09-20 |
| **Resolves** | FRD §21 (`MEDIA`), NFR-005; triggered by Vertical 3 PEOPLE onboarding (ID proof / waiver / photo) |
| **Related** | [ADR-0005](./0005-object-storage-and-media.md) (deferred placeholder), [ADR-0002](./0002-database-engine-and-data-access.md), [ADR-0003](./0003-api-style-and-authentication.md), [ADR-0007](./0007-first-delivery-vertical.md) |
| **Supersedes** | The deferral decision in ADR-0005 for Vertical 3+ upload features |

## Context

ADR-0005 deferred the object store until member onboarding needed ID proof / waiver capture.
That trigger is Vertical 3. Requirements re-read from the parked list: FR-MEDIA-001..005,
NFR-005, and **BR-HEALTH-001** (trainers must never receive identity-proof files).

FR-API-013 still forbids BLOB / base64 in MySQL — parent tables store object keys (or opaque
URL strings that resolve through `StorageService`), never file bytes.

## Decision

**Ship `MEDIA` with an S3 API–compatible adapter boundary and a local-disk adapter for
development/verification. Uploads use signed PUT; downloads use short-lived signed GET.
Nest never persists file bytes in the relational store.**

### Adapter boundary

```
StorageService (Nest)
  ├── LocalDiskAdapter   — default for NODE_ENV=development / CI without cloud creds
  └── S3CompatibleAdapter — production (AWS S3, MinIO, R2, etc.) via env config
```

- `createUploadSlot({ purpose, contentType, sizeBytes })` → `{ objectKey, putUrl, expiresAt }`
- `createSignedGetUrl(objectKey)` → `{ url, expiresAt }`
- Object key convention: `{purpose}/{yyyy}/{mm}/{uuid}{ext}` so purpose is recoverable from the
  key for BR-HEALTH-001 without a separate metadata table in MVP.

### Local verification (no cloud credentials)

- Files land under `MEDIA_LOCAL_ROOT` (default `.media/` under the API process cwd; gitignored).
- Signed PUT/GET URLs point at Nest routes `PUT|GET /v1/media/objects/{key}` authenticated by
  HMAC query signature (`MEDIA_SIGNING_SECRET`), not by session Bearer. Those routes are `@Public`
  but reject bad/expired signatures.
- This satisfies “local path without cloud credentials” while keeping the same client flow as S3
  (request slot → HTTP PUT to signed URL → attach `object_key` on parent entity).

### S3-compatible deploy

- Env: `MEDIA_DRIVER=s3`, `MEDIA_S3_BUCKET`, `MEDIA_S3_REGION`, `MEDIA_S3_ENDPOINT` (optional for
  MinIO), `MEDIA_S3_ACCESS_KEY`, `MEDIA_S3_SECRET_KEY`, `MEDIA_PUBLIC_BASE_URL` if needed.
- Adapter issues true S3/MinIO presigned PUT/GET. Implementation may land behind the interface in
  the same vertical; until wired, `MEDIA_DRIVER=s3` fails fast at boot if credentials are missing.

### Purpose limits (FR-MEDIA-002)

| Purpose | Max bytes | Allowed MIME (MVP) |
| :--- | ---: | :--- |
| `avatar` | 5 MiB | `image/jpeg`, `image/png`, `image/webp` |
| `id_proof` | 10 MiB | `image/jpeg`, `image/png`, `application/pdf` |
| `waiver` | 10 MiB | `application/pdf`, `image/jpeg`, `image/png` |
| `medical_cert` | 10 MiB | `application/pdf`, `image/jpeg`, `image/png` |
| `progress_photo` | 8 MiB | `image/jpeg`, `image/png`, `image/webp` |
| `exercise_media` | 50 MiB | `image/gif`, `image/jpeg`, `image/png`, `video/mp4` |
| `receipt_pdf` | 5 MiB | `application/pdf` |

Oversize / bad MIME → 422. Virus scan optional (FR-MEDIA-005); MVP rejects size/MIME only.

### Authz

- Slot create: `media.create`. Signed GET issue: `media.read`, plus parent row-scope when the key
  is attached to a PEOPLE/HEALTH parent (documents/photos).
- **BR-HEALTH-001:** any GET that would expose an `id_proof` object to a trainer principal returns
  **404** (same leak-safe posture as PEOPLE row-scope). Admins/employees with health perms may read.

### Orphan collection / retention (FR-MEDIA-004 sketch)

- Keys created via `/media/uploads` but never referenced by a parent row within **24h** are eligible
  for deletion (local: filesystem walk; S3: lifecycle or periodic List+Delete).
- Receipt PDFs (later PAY) are not member-deletable; retention is longer than orphan TTL — document
  when PAY lands.
- MVP Vertical 3: no cron required to ship; document the rule and leave a `StorageService` hook
  (`deleteObject` / `listOrphans`) for a follow-up job.

### Encryption / logging (NFR-005)

- Prefer bucket default encryption (SSE-S3 / SSE-KMS) in deploy; local disk relies on host volume
  encryption.
- Audit `media.upload_slot_created` and `media.signed_get_issued` (actor, purpose, key prefix — not
  full signed URL query strings).

## Consequences

**Positive**

- Unblocks PEOPLE document/photo onboarding without BLOB columns.
- Same client contract for local and S3 (signed PUT then attach key).
- Purpose-in-key enables BR-HEALTH-001 without a media_objects table in MVP.

**Negative / trade-offs**

- Local signed PUT still touches Nest (bytes stream through the API process) — acceptable for
  verification only; production must use S3 presign so Nest never sees the body.
- Orphan GC is sketched, not scheduled, in Vertical 3.

## Alternatives considered

| Option | Why not |
| :--- | :--- |
| Keep ADR-0005 deferral | Vertical 3 onboarding needs files now |
| MySQL BLOB / base64 TEXT | Violates FR-API-013 and ADR-0002 backup story |
| Only S3 (no local adapter) | Blocks MariaDB/local verification without cloud secrets |
| Multipart form upload through Nest in all envs | Couples API CPU/memory to large files; fights FR-MEDIA-001 |
