# Duplication & Gaps — UI Overhaul Findings

## (a) Ad-hoc patterns duplicated across screens/widgets

1. ~~**Status chips implemented 5 separate times.**~~ **DONE.** `membership_status_chip.dart`, `payment_status_chip.dart`, `diet_plan_status_chip.dart`, `plan_status_chip.dart` (workout), and `achievement_chip.dart` (goals) were all a `switch` on a domain enum returning `(String label, Color color)`, rendered as `Chip(backgroundColor: color.withValues(alpha: 0.15), labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600), side: BorderSide.none)`. Extracted a shared `core/widgets/app_status_chip.dart` (`AppStatusChip`) with a `tinted` flag covering both the alpha-blend "status" look (4 chips) and the achievement chip's resolved-ColorScheme look (background/foreground passed explicitly, `tinted: false`). All 5 feature-level widgets now delegate to it and keep their original class names/enum-to-label switches, so call sites were untouched. See `test/core/widgets/app_status_chip_test.dart`.

2. ~~**Two independent line-chart implementations.**~~ **DONE.** `goals/.../metric_chart.dart` (hand-rolled `CustomPainter`) has been removed. `measurements_screen.dart` now builds an `AppLineSeries` per metric (converting `DateTime` sample times to millis-since-epoch `dx` values) and renders it with `core/widgets/app_line_chart.dart`, with an `xLabelFormatter` (`DateFormat('MMM d')`) for date-axis labels and `emptyMessage: GoalsStrings.chartsEmpty` reusing `AppLineChart`'s built-in `AppEmptyView` fallback. Single call site, so no wrapper was needed. Visual note: a lone single-point series now renders a single dot via fl_chart rather than the old "not enough data" text (previously shown below 2 points) — flagging in case design wants that threshold preserved; otherwise this is a straight visual convergence onto the fl_chart look used by reports.

3. ~~**Two independent "search and pick from a list in a bottom sheet" flows.**~~ **DONE.** `diet/.../food_picker_sheet.dart` and `workout/.../exercise_picker_sheet.dart` were structurally identical: `TextField` search → `BlocBuilder` over a picker cubit → loading/error/empty branches → `ListView.builder` of tappable rows that `Navigator.pop(item)`. Extracted `core/widgets/app_picker_sheet.dart` (`AppPickerSheet<T>`), a stateless shell taking a search controller, current `isLoading`/`items`/`errorMessage`, an optional `header` (used by the food sheet's "verified only" `FilterChip`), and an `itemBuilder`. Both call sites keep their own `BlocProvider`/`BlocBuilder`/cubit wiring and search debounce/state — only the render chrome moved. `MemberPickerSheet` and `WorkoutPlanPickerSheet` (paginated, non-cubit) were left alone as out of scope — different enough state shape (cursor pagination, debounce-on-scroll) that forcing them through the same generic would cost more than it saves.

4. ~~**Two independent "unpaged catalog dropdown" fields.**~~ **DONE.** `scheduling/.../facility_picker_field.dart` and `scheduling/.../schedule_type_picker_field.dart` were near copy-paste of each other (load-once state machine, `PickerFieldSkeleton`/`PickerFieldRetry`/`DropdownButtonFormField`). Extracted `core/widgets/app_catalog_dropdown_field.dart` (`AppCatalogDropdownField<T>`), which owns the load/error/empty/loaded state machine and takes `load`, `itemId`, `itemLabel` callbacks. Both fields are now thin `StatelessWidget`s. `TrainerPickerField` (paged, modal search sheet) stays separate — different shape, already noted in the original finding.

5. ~~**Two independent filter bottom sheets.**~~ **DONE.** `exercise_filter_sheet.dart` and `food_filter_sheet.dart` shared the same outer shell (title + "Clear all" + padded content + full-width "Apply filters" button). Extracted `core/widgets/app_filter_sheet_shell.dart` (`AppFilterSheetShell`), which owns the shell and lays out a `children` list with the existing 12px inter-field spacing; each sheet now only supplies its own fields and `onClearAll`/`onApply` callbacks.

6. ~~**Two macro-display widgets for the same underlying data shape**~~ **DONE.** (`diet/.../diet_macro_summary.dart` — chip-based, shows target vs. actual; `foods/.../food_macro_breakdown.dart` — progress-bar-based, shows % of calories). Extracted a shared `core/presentation/macro_format.dart` (`MacroFormat`) covering the gram/calorie ("drop trailing `.0`") and percent formatting; `DietStrings.macroValue` and `FoodMacroBreakdown`'s `_MacroRow` both delegate to it.

7. ~~**`TodayAgendaCard` vs. `UpcomingAgendaList`**~~ **DONE.** (both in `dashboard/.../widgets/`) render the same `ListTile` shape (title + time subtitle + chevron + onTap) for scheduling sessions, differing only in date-format and section title/empty-message wiring. Unified via `agenda_session_list.dart`.

8. ~~**`MoreHubScreen` duplicates `DestinationHubScreen`'s list+ListTile+chevron+divider structure inline**~~ **DONE.** instead of composing it, even though `DestinationHubItem`/`DestinationHubScreen` already exist in the same directory for exactly this "list of nav tiles" shape. `MoreHubScreen` now routes through `DestinationHubScreen`.

## (b) Inconsistent empty/error/loading handling

The app has three different "no shared state" vocabularies in active use:
- `core/widgets/{AppEmptyView, AppErrorView, AppLoading}` — the intended standard, used by ~45 of 86 screens.
- Bare `CircularProgressIndicator` + inline `Text`/`Column` for loading/error with no dedicated empty state — used by most membership, exercises/foods detail, goals form, PT, and workout builder/detail screens (see the ⚠️ rows in `screen-inventory.md`, roughly 25 screens).
- A third, screen-specific pattern in `dashboard_agenda_section.dart` (hand-built `Card` with its own loading/error chrome, not reusing `AppLoading`/`AppErrorView`) and `dashboard_skeleton.dart` (a bespoke skeleton-card loading state, different again from spinner-based `AppLoading`).

Net effect: a user moving from `MembershipsDirectoryScreen` (polished empty/error/loading) to `MembershipDetailScreen` or `MembershipCardScreen` (spinner-only, no empty state, inline error text) sees visibly different loading/error UX within the same feature.

## (c) Screens with no shared-widget empty/error/loading handling at all

- `profile_tab_screen.dart` — static nav list, no data loading, so N/A by design.
- `reports_hub_screen.dart`, `settings_hub_screen.dart` — static nav hubs, N/A by design.
- `trainer_membership_summary_screen.dart` — renders passed-in data with no own load state; worth confirming its parent always has data ready before navigating here.
- `membership_card_screen.dart`, `membership_freeze_screen.dart`, `membership_renew_screen.dart`, `create_membership_screen.dart`, `membership_detail_screen.dart`, `membership_packages_catalog_screen.dart` — all `CircularProgressIndicator`-only, no `AppErrorView`/`AppEmptyView`.
- `exercise_detail_screen.dart`, `food_detail_screen.dart`, `exercise_library_screen.dart`, `food_library_screen.dart` — spinner-only.
- `goal_detail_screen.dart`, `goal_form_screen.dart` — spinner-only, despite `progress_hub_screen.dart`/`progress_photos_screen.dart` in the same feature being fully wired.
- `pt_packages_screen.dart`, `sell_pt_screen.dart` — spinner-only.
- `workout_plan_builder_screen.dart`, `workout_plan_detail_screen.dart`, `workout_plan_versions_screen.dart`, `active_workout_screen.dart` (loading only) — spinner-only, despite `workout_plan_list_screen.dart`/`workout_history_screen.dart` being fully wired.
- `diet_plan_builder_screen.dart`, `diet_plan_detail_screen.dart`, `diet_plan_versions_screen.dart`, `diet_daily_log_screen.dart`, `diet_meal_detail_screen.dart` — spinner-only, despite `diet_history_screen.dart`/`diet_plan_list_screen.dart` being fully wired.
- `report_viewer_screen.dart` — has `AppErrorView`/`AppLoading` but no explicit empty-rows state at the screen level (delegated silently to `ReportDataTable`'s internal `ReportStrings.emptyRows` text, which is a lesser-styled empty state than `AppEmptyView`).

Pattern: **detail/builder/form screens are the consistent gap** — list screens got the `AppEmptyView`/`AppErrorView` treatment; detail, builder, and form screens across diet/workout/goals/membership/pt did not. This looks like it happened by convention drift (later-built list screens picked up the shared widgets; earlier or hand-tuned detail/form screens didn't get backfilled) rather than an intentional distinction.

## (d) Prioritized extraction candidates for the overhaul

| # | Component | Screens/widgets that would use it | Effort |
|---|---|---|---|
| 1 | ~~`AppStatusChip` generic status chip~~ **DONE** | `membership_status_chip`, `payment_status_chip`, `diet_plan_status_chip`, `plan_status_chip`, `achievement_chip` | S |
| 2 | ~~Backfill `AppEmptyView`/`AppErrorView` onto the ~25 spinner-only screens listed in (c)~~ **DONE** | membership (6), exercises/foods detail+library (4), goals detail/form (2), PT (2), workout builder/detail/versions/active (4), diet builder/detail/versions/log/meal (5), report viewer empty-rows (1) | M (mechanical but touches ~24 files) |
| 3 | ~~`AppPickerSheet<T>` generic search-and-pick sheet~~ **DONE** | `FoodPickerSheet`, `ExercisePickerSheet` | M |
| 4 | ~~`AppCatalogDropdownField<T>` generic unpaged-catalog dropdown~~ **DONE** | `FacilityPickerField`, `ScheduleTypePickerField` | S |
| 5 | ~~`AppFilterSheetShell` generic filter-sheet chrome~~ **DONE** | `ExerciseFilterSheet`, `FoodFilterSheet` | S |
| 6 | ~~Unify `AgendaSessionList` for `TodayAgendaCard`/`UpcomingAgendaList`~~ **DONE** | dashboard agenda section | S |
| 7 | ~~Reconcile `MetricChart` (CustomPainter) into `AppLineChart` (fl_chart)~~ **DONE** | goals measurements screen | M (visual-risk: needs design sign-off since fl_chart styling differs from the hand-rolled painter) |
| 8 | ~~Route `MoreHubScreen` through `DestinationHubScreen`/`DestinationHubItem` instead of duplicating the list chrome~~ **DONE** | admin More tab | S |
| 9 | ~~Shared macro-formatting helper (calories/protein/carbs/fat string formatting) used by both `DietMacroSummary` and `FoodMacroBreakdown`~~ **DONE** | diet + foods features | S |
| 10 | ~~Reconcile the two dashboard "loading" vocabularies (`DashboardSkeleton` vs. inline `AppLoading`/spinner in `DashboardAgendaSection`) into one dashboard-loading pattern~~ **DONE** | dashboard screen | S |

All ten extraction candidates are complete.
