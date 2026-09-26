# UI design sections

Companion to the implementation picture. Title block is unnumbered.

**Title block** — vertical, primary screens, link to `docs/vertical-*-implementation.md` when it exists.

1. **Screen inventory** — Screen | Role visibility | Route(s) | Spec ref in `docs/screens/` | Dart path or `missing` / `PlaceholderScreen`.
2. **IA & navigation** — hub/tab, deep links, push vs master–detail, pop refresh.
3. **Catalogue pattern score** — one row per baseline pattern below: **match | partial | missing | n/a** plus an evidence path.
4. **Design system** — `AppTheme`, feature `*_strings.dart`, which feedback widgets the screens actually use.
5. **Responsive** — `AdaptiveShell` chrome and the feature master–detail breakpoint.
6. **States** — loading, empty, error, submitting, permission denied, unsaved.
7. **Role chrome** — what admin / trainer / member see; control hidden vs no-permission body. Cite `context.can('…')` slugs.
8. **Spec gaps** — `docs/screens/` entries with no screen, or screens with no spec row.
9. **Takeaways** — largest deltas vs the V1 rows in §3. Do not rescore the whole table.

## V1 Exercise Library UI baseline

Code: `app/lib/features/exercises/presentation/`. Spec: Workout Library / exercise entries in `docs/screens/`.

| Pattern | V1 behavior |
| :--- | :--- |
| Screens | `ExerciseLibraryScreen`, `ExerciseDetailScreen`, `ExerciseFormScreen` |
| List chrome | AppBar title, search field, filter action; next page when ~200px from scroll end |
| Create entry | AppBar `+` when `context.can('exercises.create')` |
| Master–detail | `ExerciseLibraryScreen._masterDetailBreakpoint` = **840**: side pane at/above, push detail below |
| Filter | `ExerciseFilterSheet`; apply sends a new list query |
| List item | `ExerciseListItem` renders an `Exercise`; no fetch inside the tile |
| Detail | Read layout; edit when `context.can('exercises.update')` |
| Form | Create vs edit by optional `exercise`; required slug is create or update; denied → `ExerciseStrings.noPermission` body |
| Deactivate | Edit form only; confirm dialog; then leave/refresh |
| Unsaved | `UnsavedChangesScope` while dirty and not submitting |
| Strings | `exercise_strings.dart` |
| Empty / error | Inline `Text` / `Center` and a retry `TextButton` (`ExerciseStrings`). `AppEmptyView`, `AppErrorView`, and `AppLoading` are unused on these screens |
| Theme | Material 3 `AppTheme` (`app/lib/core/theme/app_theme.dart`) |
| Shell | `AdaptiveShell`: `NavigationBar` under 600dp; compact `NavigationRail` from 600 to just under 1240; extended rail at `AdaptiveShellBreakpoints.expanded` (1240). Five destinations per role |
| Member | No library tab; detail from workout context |

Shell breakpoints live in `app/lib/core/widgets/adaptive_shell.dart`. The 840dp split is feature-local, not a shell breakpoint.

Score later verticals against this table. Using `AppEmptyView` (or similar) is a **delta**, not an automatic miss, and belongs in §4 and §9.
