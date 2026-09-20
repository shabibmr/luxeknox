# V3-13c — Member photos + flip x-status

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-13b |
| **Files** | ≤7 |

## Why

OpenAPI `/members/{id}/photos` (+ set avatar) are `deferred`. Flip to `mvp`. App avatar remains
`users.avatar_url`; `is_current_avatar` may flag which gallery shot was copied there (entities).

## Files

- Photo repo/service/controller/dto
- `docs/openapi/v1.yaml` — flip photos paths to `mvp`
- Optional touch users.avatar_url on set-avatar
- Row-scope + `health.read` / `health.update`

## Work

- List/create photos via media key (`avatar` purpose or gallery).
- `POST …/photos/{photoId}/avatar`: mark current + copy/set `users.avatar_url` per entities note.
- Flip photos path `x-status` to mvp.
- Audit on create/avatar.

## Done when

- Photos + avatar route live; YAML mvp.
- lint/typecheck/test green.
