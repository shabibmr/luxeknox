# ADR-0005 — Object storage & media *(placeholder — deferred)*

| | |
| :--- | :--- |
| **Status** | **Superseded by [ADR-0008](./0008-object-storage-and-media.md)** — Vertical 3 PEOPLE onboarding triggered MEDIA |
| **Date** | 2026-09-16 |
| **Revision** | Originally deferred uploads. Vertical 3 (ID proof / waiver / photo) is the revisit trigger; decisions live in ADR-0008. |
| **Resolves** | Nothing (placeholder). See ADR-0008 for the accepted storage decision. |
| **Related** | [ADR-0003](./0003-api-style-and-authentication.md), [ADR-0007](./0007-first-delivery-vertical.md), [ADR-0008](./0008-object-storage-and-media.md) |

## Context

`MEDIA` (FRD §21) specifies signed-PUT upload, short-lived signed GET, per-purpose size and MIME
limits, and orphan collection. It is a dependency of six other modules — exercise video/GIF, member
documents and ID photos, progress photos, receipt PDFs, avatars.

An earlier draft of this record picked the S3 API with MinIO self-hosted alongside the database.
**That decision has been withdrawn, and object storage is out of MVP scope.** No bucket, no object
store, no upload endpoints.

The reason it can be withdrawn without breaking the delivery plan is narrow but real: of the six
consumers, only one appears before the hub module, and it does not need an upload.

## Decision

**Defer the `MEDIA` module and the object-store choice entirely. Ship no file upload in the MVP.**

### What that means concretely

| Area | MVP behaviour |
| :--- | :--- |
| **Exercise video / GIF** (`exercises.video_url`, `gif_url`) | Plain `VARCHAR` columns holding an **externally hosted URL** that an admin pastes — a YouTube link, a CDN link, a link to wherever the gym already keeps its demo clips. The API validates that it is a well-formed `https` URL and stores the string. Nothing is uploaded, hosted, or signed by us. |
| **Member documents** (`id_proof`, `waiver`, `medical_cert`) | **Not in MVP.** Collected on paper or out of band. |
| **Member photos / avatars, progress photos** | **Not in MVP.** |
| **Receipt PDFs** | **Not in MVP.** Receipts are rendered on demand from ledger rows and printed or displayed; nothing is stored as a file. |
| `MEDIA` module, `StorageService`, signed URLs | Not built. No placeholder class — an unimplemented abstraction is worse than an absent one. |

### Guardrails while this is deferred

These exist because "no object storage" is exactly the condition under which someone reinvents it
badly:

1. **FR-API-013 still holds in full — file bytes never live in a relational row.** Deferring the
   object store is not licence to add a `BLOB` or a base64 `TEXT` column. That would break the
   backup and PITR story in [ADR-0002](./0002-database-engine-and-data-access.md) and is harder to
   undo than building `MEDIA` properly would have been.
2. **No upload endpoint may be added ad hoc.** The API process does not stream file bytes. If a
   feature needs upload, that is the trigger below, not a local workaround.
3. **URL columns hold external URLs only.** They are not our object keys, and code must not start
   treating them as such, because when `MEDIA` lands the two are different things.
4. **Externally hosted media is public.** Only non-sensitive content may use a pasted URL — exercise
   demos qualify; nothing belonging to a member does. This is why member photos and documents are
   descoped rather than given the same treatment.

### When to revisit

Any one of these is the trigger to write **ADR-0008** and build `MEDIA` properly:

| Trigger | Module |
| :--- | :--- |
| Member onboarding needs ID proof / waiver capture | `PEOPLE` — vertical 3 |
| Progress photos enter scope | `GOAL` |
| Receipts must be archived as immutable files rather than re-rendered | `PAY` |
| The gym wants to host its own exercise clips rather than link out | `WORK` |

The first of these arrives at **vertical 3**, so this deferral buys two verticals, not the whole
project. It is a sequencing decision, not a permanent one.

**Requirements parked, to be re-read in full when that ADR is written:** FR-MEDIA-001 (signed PUT),
FR-MEDIA-002 (size / MIME per purpose), FR-MEDIA-003 (short-lived signed GET with the parent
entity's row-level rules), FR-MEDIA-004 (orphan collection, receipt retention), NFR-005 (media PII
encrypted at rest, access logged), and **BR-HEALTH-001 — trainers must never receive identity-proof
files.** That last one is a data-leak rule, not a feature rule; it is dormant only because the files
do not exist yet.

## Consequences

**Positive**

- Removes an entire module, a storage service, a bucket policy matrix, and an orphan-collection cron
  job from the MVP. It also removes the weakest point of the withdrawn draft — MinIO sharing a disk
  and a failure domain with the database.
- **Vertical 1 is unaffected and gets smaller.** The Exercise Library needs media *URLs*, not media
  *uploads*, so `MEDIA` drops out of the prerequisite spine in
  [ADR-0007](./0007-first-delivery-vertical.md) without touching the vertical itself.
- No object-store bill, no S3 credentials, no signing code to get wrong.

**Negative**

- **Member onboarding is functionally incomplete without document capture**, and that is a real
  product gap, not just a technical one — a gym that collects waivers on paper at the desk is the
  assumption being made here. **This needs the product owner's explicit agreement**, because it is
  the one descoped item a real front desk will notice on day one.
- Progress photos are a visible member-facing feature in the screen specs; they will be absent.
- Exercise media quality depends on whatever an admin pastes, including links that rot or that sit
  behind a platform's player rather than an embeddable file.
- The work is deferred, not avoided. Vertical 3 will carry it, and the estimate for `PEOPLE` should
  say so out loud rather than discovering it mid-sprint.

**Neutral**

- Because nothing was built, there is no migration cost when `MEDIA` does land — only the URL columns
  need a decision about whether pasted external links coexist with owned object keys.

## Alternatives considered

| Option | Why not |
| :--- | :--- |
| **Build `MEDIA` on the S3 API now (MinIO / R2 / S3)** — the withdrawn draft | The correct long-term answer, and the ADR to return to. Withdrawn for MVP scope, not on merit. When it returns, prefer Cloudflare R2 over self-hosted MinIO: same API, zero egress, and it does not share a disk with the database. |
| **Files on the VPS filesystem** | The tempting shortcut once the object store is gone, and the one option that actively creates future work: it reimplements expiry and authorization badly, and it makes backup and restore a second, separate problem. If upload is needed, that is the trigger to build `MEDIA` properly. |
| **Bytes in the database (`BLOB` / base64)** | Directly forbidden by FR-API-013, and it would wreck the backup and PITR story in [ADR-0002](./0002-database-engine-and-data-access.md). Called out explicitly in the guardrails above because it is what deferral tempts people into. |
| **Keep the S3 decision on paper but build nothing** | Rejected as the worst of both: an `Accepted` record nobody has validated, which the team would treat as settled and inherit unexamined a year later. A `Deferred` placeholder states the truth — the question is open. |
