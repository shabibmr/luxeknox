# M0-20 — Opaque tokens and session store

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-10, M0-16 |
| **Files** | 6 |

## Files

- `apps/api/src/auth/token.ts`
- `apps/api/src/auth/token.spec.ts`
- `apps/api/src/auth/session.repository.ts`
- `apps/api/src/auth/session.cache.ts`
- `apps/api/src/auth/session.cache.spec.ts`
- `apps/api/src/auth/password.ts`

## Work

Issue `gk_at_` / `gk_rt_`. Hash tokens with SHA-256. Hash passwords with argon2id. Session cache TTL 60 s; drop on revoke. Never log tokens.

## Done when

Hash lookup works. Cache invalidates on revoke.
