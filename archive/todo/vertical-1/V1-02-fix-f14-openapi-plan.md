# V1-02 — Correct F-14's OpenAPI-artifact plan

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | none |
| **Files** | 1 |

## Why

`todo/fixes/F-14-e2e-ci-gaps.md` (Module 0 fix register, still open) instructed `git rm
docs/openapi/v1.yaml` and keeping only the code-dumped `v1.json`. That is backwards:
`docs/openapi/README.md` already names `v1.yaml` as the authoritative, hand-authored, contract-first
spec ("Implement against this file... A dump that drifts is a bug"), it already covers every MVP
module (not just Module 0), and `packages/api_client` — consumed by the already-partially-executed
Flutter Exercise Library work — was generated from it. Executing F-14 as originally written would
have deleted the only committed contract for this vertical and broken the Flutter client generation
pipeline.

## Files

- `todo/fixes/F-14-e2e-ci-gaps.md`

## Work

Rewrote finding #2, its Decision, Files, Steps, and Done-when so the fix keeps `v1.yaml` untouched
and instead either (a) adds a real operationId/path parity check between the live dump and `v1.yaml`,
or (b) stops committing the unread `v1.json` — implementer's choice, recorded at execution time.

## Done when

`todo/fixes/F-14-e2e-ci-gaps.md` no longer instructs deleting `docs/openapi/v1.yaml` under any
option. (Already applied — this ticket documents the change for the register's own history.)
