# M0-02 — Catalog: sessions + engine conventions

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | M0-01 |
| **Files** | 2 |

## Files

- `docs/database-entities.md`
- `docs/Entities-List.md`

## Work

Add `sessions` as the opaque token store. Raise table count from 55 to 56.

Align Schema notes with ADR-0002 and ADR-0003:

- PK: `BIGINT UNSIGNED AUTO_INCREMENT`
- Time: `DATETIME(3)` UTC
- Money: `DECIMAL(12,2)`
- Files: external `https` URL; never `BLOB`
- No `users.token_version`

Add Session under identity in `Entities-List.md`.

## Done when

Catalog lists 56 tables. Schema notes match the ADRs.
