# V3-05a — Members YAML amends (MemberCreate / MemberDossier)

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-04 |
| **Files** | ≤7 |

## Why

Zod will require email-or-phone + password on create (FR-AUTH-008), but YAML `MemberCreate`
currently only requires `first_name` / `last_name`. `MemberDossier` embeds membership / balance /
check-in / schedule without `nullable: true` — V3 cannot populate those until later verticals.

FR-PEOPLE-001 MVP is multi-step OpenAPI (create → EC → media), not one mega-TX — document the
carve-out.

## Files

- `docs/openapi/v1.yaml` (`MemberCreate`, `MemberDossier`)
- Short carve-out note: either a footnote in `docs/backend-frd.md` near FR-PEOPLE-001 **or** a
  plan-linked note under `archive/todo/vertical-3/` (prefer FRD if ≤7 files allows)

## Work

- `MemberCreate`: document that **at least one of** `email` / `phone_number` is required, plus
  `password` required for login creation. Prefer OpenAPI `oneOf` / `anyOf` or explicit description
  + required list amendment consistent with LoginRequest style (`Supply email or phone…`).
- `MemberDossier` extras (`membership`, `outstanding_balance`, `last_check_in`, `next_schedule`):
  mark **`nullable: true`** (and/or make properties explicitly nullable) so V3 can return null.
- FR-PEOPLE-001 carve-out: MVP = multi-step routes; photo/waiver/EC are follow-ups, not create TX.

## Done when

- YAML reflects create credential rules + nullable dossier extras.
- Carve-out noted in FRD or ticket-linked doc.
- No Nest code required in this ticket.
- If openapi dump scripts exist, they still parse YAML.
