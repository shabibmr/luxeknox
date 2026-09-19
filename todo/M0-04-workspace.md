# M0-04 — Workspace root

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-01 |
| **Files** | 5 |

## Files

- `package.json` — scripts `api:dev`, `api:test`, `api:migrate`
- `pnpm-workspace.yaml` — `apps/api`
- `.gitignore` — coverage, `apps/api/dist`
- `.nvmrc` — Node current LTS
- `.env.example` — DB URL, bootstrap admin; no JWT keys

## Work

Create the pnpm workspace root. The api package lands in M0-05.

## Done when

Root workspace files exist. `pnpm install` will resolve after M0-05.
