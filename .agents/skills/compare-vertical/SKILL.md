---
name: compare-vertical
description: >
  Compare one gym vertical to Exercise Library (stack, UI, gap plan, then
  /implement). Use for /compare-vertical, /compare-vertical-ui, Foods/PEOPLE
  vs V1, or fixing vertical deltas. Modes: default, analysis-only, plan-only.
---

# Compare vertical

Baseline: Vertical 1 Exercise Library. Catalogue only (vertical index, “Out of this vertical”).

Default order: Resolve → A stack → B UI → C gap plan → D implement.
Finish a step, `/compact`, then start the next step on the following turn.

## Paths

Read `.agents/skills/compare-vertical/references/vertical-index.md` for the vertical row and output paths. Open only the checklist for the active step, from that same `references/` directory: `section-checklist.md`, `ui-design-checklist.md`, or `gap-plan-checklist.md`.

## Modes

| Mode | Steps |
| :--- | :--- |
| default | A B C D |
| `analysis-only` | A B |
| `plan-only` | A B C |
| Docs exist and the user says fix or implement | C from those docs, then D |

Ambiguous vertical or overwrite: ask once and stop.

## Context budget

The parent keeps the vertical id, mode, output paths, and at most 7 deltas. Source text stays out of this chat.

- Steps A, B, and C each run in one subagent. Prompt: vertical id, mode, output path, and “read the checklist file, write the doc, return the path plus at most 7 deltas.” Do not paste the checklist or the V1 baseline into that prompt.
- The parent does not read `docs/openapi/v1.yaml`, `docs/vertical-1-exercise-library-implementation.md`, `docs/screens/`, or the feature trees. The step subagent may, and returns a summary.
- Searches follow workspace context-mode routing so command output is not inlined here.
- Step D is one subagent. Its prompt is specified under **D. Implement**. The parent does not read the implement skill, the responsive-layout skill, or edit code.

## Compact

When the step’s file is on disk (for D, when the final report is back), stop tool use. The turn’s only prose is the step result: at most 7 deltas, or for D the implement final report. The last line is:

`/compact keep vertical=<id> mode=<mode> done=<step> next=<step|stop> paths=<written paths>`

Do not open the next checklist or spawn the next subagent in that turn. Resume at `next`. Do not re-read this skill after compact; the keep line is the resume state.

## Steps

### Resolve
Name the vertical and resource from the index row. Record the three output paths. Compact with `next=A`, or `next=C` when existing docs should go straight to the gap plan.

### A. Stack
Subagent writes the stack-picture path from the index, per `section-checklist.md`. Compact with `next=B`.

### B. UI
Subagent writes the UI-design path from the index, per `ui-design-checklist.md`. If the app was not opened, the title block says so. Compact with `next=C`, or `next=stop` for `analysis-only`.

### C. Gap plan
Subagent reads §9 and the scored tables of the two analysis docs (not the evidence sections) and writes the gap-plan path from the index, per `gap-plan-checklist.md`. Compact with `next=D`, or `next=stop` for `plan-only`.

### D. Implement
Runs only after the gap-plan file exists. Subagent prompt: gap-plan path, “follow bundled `/implement` using the plan’s implement-handoff section; return its final report only.” When that work creates or edits Flutter UI under `presentation/` (screens, widgets, layout), the implementer reads and follows `.agents/skills/flutter-build-responsive-layout/SKILL.md` before writing those files. Reply with that final report, then compact with `next=stop`.
