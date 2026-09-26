# Gap-fix plan sections

Write `docs/vertical-<n>-<slug>-gap-plan.md` after both analysis docs exist.
Pull candidates from each doc’s **§9 Takeaways** and scored tables.

**Title block** — vertical, links to implementation + UI design docs, mode notes.

1. **In scope** — actionable code/spec fixes that close a **partial / different / missing** score or a takeaway that breaks live behavior.
2. **Out of scope (intentional)** — product deltas vs V1 that stay (e.g. admin-only create, verified+active visibility). One line each with the evidence path.
3. **Work items** — ordered table: ID | Fix | Primary paths | Acceptance | Depends on.
4. **Verification** — commands/tests to run after the change (API unit/e2e, Flutter widget/role tests, optional browser).
5. **Implement handoff** — one paragraph the `/implement` skill can take as its task description (paths + acceptance, no essay).

## Ranking

1. Live bugs (wrong permission slug, wrong deactivate field, dropped wire fields).
2. Contract/client lag (filters not forwarded, stale domain comments).
3. Label/spec alignment (hub title vs screen title, `docs/screens/` vs routes).
4. Nice-to-have chrome parity with V1.

Do not file work items for catalogue-vs-plans boundary rows already marked out of vertical in the vertical index.
