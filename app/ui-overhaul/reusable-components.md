# Reusable Components Catalog

All widgets actually read from source (not guessed from filenames). 18 shared `core/widgets` + `core/presentation`, 44 feature-local widgets.

## Core widgets (`lib/core/widgets/`, `lib/core/presentation/`) — already shared

### State placeholders
| Component | File | Purpose | Key params |
|---|---|---|---|
| `AppEmptyView` | `core/widgets/app_empty_view.dart` | Full-area empty state (icon + message + optional action button) | `message`, `icon` (default inbox), `action`, `actionLabel` |
| `AppErrorView` | `core/widgets/app_error_view.dart` | Full-area error state with retry | `message`, `onRetry`, `retryLabel` |
| `AppLoading` | `core/widgets/app_loading.dart` | Centered spinner + optional caption | `message` |
| `LoadStatus` (enum) | `core/presentation/load_status.dart` | `initial/loading/success/failure` lifecycle enum used by nearly every Cubit state | n/a |
| `PickerFieldSkeleton` | `core/widgets/picker_field_states.dart` | Loading placeholder for an async dropdown field | `label` |
| `PickerFieldRetry` | `core/widgets/picker_field_states.dart` | Inline error + tap-to-retry for an async dropdown field | `label`, `message`, `onRetry` |
| `AppCatalogDropdownField<T>` | `core/widgets/app_catalog_dropdown_field.dart` | Generic unpaged-catalog dropdown: owns the load/error/empty/loaded state machine on top of `PickerFieldSkeleton`/`PickerFieldRetry` | `label`, `load`, `itemId`, `itemLabel`, `value`, `onChanged` |
| `AppPickerSheet<T>` | `core/widgets/app_picker_sheet.dart` | Generic "search and pick from a list" bottom-sheet chrome (search field + optional header + loading/error/empty/list body); caller owns the search state/cubit | `searchController`, `searchLabel`, `isLoading`, `items`, `itemBuilder`, `errorMessage`, `onRetry`, `header` |
| `AppFilterSheetShell` | `core/widgets/app_filter_sheet_shell.dart` | Generic filter-sheet chrome (title + "Clear all" + spaced field list + full-width "Apply filters") | `title`, `onClearAll`, `onApply`, `children` |

### Charts
| Component | File | Purpose | Key params |
|---|---|---|---|
| `AppBarChart` | `core/widgets/app_bar_chart.dart` | Themed fl_chart bar chart, falls back to `AppEmptyView` when empty | `data: List<AppChartPoint>`, `height`, `barColor`, `valueFormatter` |
| `AppLineChart` | `core/widgets/app_line_chart.dart` | Themed fl_chart multi-series line chart, dedupes x-axis labels | `series: List<AppLineSeries>`, `height`, `xLabelFormatter`, `yLabelFormatter` |
| `AppHeatmap` | `core/widgets/app_heatmap.dart` | Custom grid heatmap (fl_chart has no heatmap type) | `values`, `rowLabels`, `colLabels`, `cellSize`, `valueFormatter` |
| `AppChartPoint` / `AppLineSeries` | `core/widgets/app_chart_types.dart` | Shared data-point types for the three chart widgets above | n/a |

### Shell / navigation
| Component | File | Purpose | Key params |
|---|---|---|---|
| `AdaptiveShell` | `core/widgets/adaptive_shell.dart` | Responsive nav shell: bottom bar (phone) → compact rail (tablet) → extended rail (desktop), breakpoints 600/1240dp | `navigationShell`, `destinations`, `onDestinationSelected`, `body` |
| `DestinationHubScreen` | `core/widgets/destination_hub_screen.dart` | Generic tappable list hub that navigates via `context.go` | `title`, `items: List<DestinationHubItem>`, `footer` |
| `MoreHubScreen` | `core/widgets/more_hub_screen.dart` | Admin "More" tab — hardcoded list of admin destinations | `onOpenPath`, `footer` |
| `NotFoundScreen` | `core/widgets/not_found_screen.dart` | GoRouter `errorBuilder` 404 screen | `uri` |
| `PlaceholderScreen` | `core/widgets/placeholder_screen.dart` | "Coming soon" stub for unfinished tab roots | `title` |
| `UnsavedChangesScope` | `core/widgets/unsaved_changes_scope.dart` | `PopScope` wrapper that confirms discard of unsaved form changes | `hasUnsavedChanges`, `child`, `title/message/stayLabel/leaveLabel` |

**Note:** `MoreHubScreen`'s destination list is hardcoded (14 items) rather than driven by `DestinationHubItem`/`DestinationHubScreen` — it duplicates that screen's list+ListTile+chevron structure inline instead of composing it. Low-risk consolidation candidate.

---

## Feature-local widgets (`lib/features/*/presentation/widgets/`)

### Status chips (4 near-identical implementations — see duplication-and-gaps.md)
| Component | File | Purpose | Params |
|---|---|---|---|
| `MembershipStatusChip` | `membership/.../membership_status_chip.dart` | active/expired/frozen/cancelled chip | `status: MembershipStatus` |
| `PaymentStatusChip` | `payments/.../payment_status_chip.dart` | pending/partial/paid/refunded chip | `status: PaymentStatus` |
| `DietPlanStatusChip` | `diet/.../diet_plan_status_chip.dart` | draft/active/archived chip | `status: DietPlanStatus` |
| `PlanStatusChip` | `workout/.../plan_status_chip.dart` | draft/active/archived chip (identical shape to DietPlanStatusChip) | `status: WorkoutPlanStatus` |
| `AchievementChip` | `goals/.../achievement_chip.dart` | achieved/in-progress goal chip w/ trophy icon | `status: GoalStatus` |

**All 5 promote cleanly to `core/widgets/status_chip.dart`** — same `Chip` + `color.withValues(alpha:0.15)` background + bold label pattern; only the `(label, color)` mapping differs per enum.

### List item / tile widgets
| Component | File | Purpose | Params |
|---|---|---|---|
| `ExerciseListItem` | `exercises/.../exercise_list_item.dart` | Exercise summary row (name, muscle group/equipment, difficulty chip) | `exercise`, `onTap` |
| `FoodListItem` | `foods/.../food_list_item.dart` | Food summary row (name, calories/macros, serving chip) — same shape as `ExerciseListItem` | `food`, `onTap` |
| `NotificationListTile` | `notifications/.../notification_list_tile.dart` | Notification row w/ unread styling + "unread" chip | `notification`, `onTap` |
| `TodayAgendaCard` | `dashboard/.../today_agenda_card.dart` | Card listing today's sessions | `items`, `title`, `emptyMessage`, `onTapSession` |
| `UpcomingAgendaList` | `dashboard/.../upcoming_agenda_list.dart` | Card listing upcoming (next 7 day) sessions — near-duplicate of `TodayAgendaCard` (same ListTile shape, different date formatting) | `items`, `onTapSession` |
| `MembershipHistoryList` | `membership/.../membership_history_list.dart` | Self-fetching (BlocProvider-wrapping) history list w/ own load/error/empty states | `membershipId` |
| `MembershipFreezeList` | `membership/.../membership_freeze_list.dart` | Self-fetching freeze-request list w/ approve/reject actions for admins | `membershipId`, `canApprove` |

### Bottom sheets / pickers
| Component | File | Purpose | Params |
|---|---|---|---|
| `FoodPickerSheet` (+ `showFoodPickerSheet`) | `diet/.../food_picker_sheet.dart` | Modal search sheet to pick a `Food`, verified-only toggle for staff — now renders via shared `AppPickerSheet<Food>` | `verifiedOnly` |
| `ExercisePickerSheet` (+ `showExercisePickerSheet`) | `workout/.../exercise_picker_sheet.dart` | Modal search sheet to pick an `Exercise` — now renders via shared `AppPickerSheet<Exercise>` | none |
| `ExerciseFilterSheet` | `exercises/.../exercise_filter_sheet.dart` | Bottom sheet: muscle group/equipment text filters + difficulty dropdown — now renders via shared `AppFilterSheetShell` | `initialFilter`, static `.show()` |
| `FoodFilterSheet` | `foods/.../food_filter_sheet.dart` | Bottom sheet: verified-only switch filter — now renders via shared `AppFilterSheetShell` | `initialFilter`, static `.show()` |
| `MoveBookingSheet` (+ `showMoveBookingSheet`) | `scheduling/.../move_booking_sheet.dart` | Sheet to move a booking to an alternative session slot | `session`, `memberId`, `listSchedules` |
| `RescheduleSheet` (+ `showRescheduleSheet`) | `scheduling/.../reschedule_sheet.dart` | Sheet to change a session's start/end via `DateTimeRangeField` | `session`, `timezoneProvider` |

### Form fields / pickers
| Component | File | Purpose | Params |
|---|---|---|---|
| `FacilityPickerField` | `scheduling/.../facility_picker_field.dart` | Dropdown backed by unpaged `GET /facilities` — now a thin wrapper over shared `AppCatalogDropdownField<FacilityInfo>` | `value`, `onChanged`, `errorText`, `enabled`, `listFacilities` |
| `ScheduleTypePickerField` | `scheduling/.../schedule_type_picker_field.dart` | Dropdown backed by unpaged `GET /schedule-types` — now a thin wrapper over shared `AppCatalogDropdownField<ScheduleTypeInfo>` | same shape as above |
| `TrainerPickerField` | `scheduling/.../trainer_picker_field.dart` | Tap-to-open paged/searchable trainer picker sheet (debounced search, infinite scroll) — different pattern from the two dropdown fields since trainers are server-paged | `value`, `onChanged`, `errorText`, `enabled`, `listTrainers` |
| `DateTimeRangeField` | `scheduling/.../date_time_range_field.dart` | Start/end date+time picker pair with range validation and gym-timezone caption | `start`, `end`, `onStartChanged`, `onEndChanged`, `timezoneProvider`, static `validateRange` |
| `GenderRadioGroup` | `people/.../gender_radio_group.dart` | Male/Female radio group for member/trainer forms | `value`, `onChanged`, `enabled` |

### Domain-specific composite widgets (not generic, but worth knowing)
| Component | File | Purpose |
|---|---|---|
| `AttendanceOccupancyTile` | `attendance/.../attendance_occupancy_tile.dart` | Self-fetching live gate-occupancy tile (FutureBuilder, one-shot) |
| `SignOutTile` | `auth/.../sign_out_tile.dart` | Confirm + sign-out ListTile, reacts via `SessionCubit` |
| `DashboardAdminSection` / `DashboardMemberSection` / `DashboardTrainerSection` | `dashboard/.../dashboard_*_section.dart` | Role-specific dashboard cards, pure presentation over `DashboardSnapshot` sub-types |
| `DashboardAgendaSection` | `dashboard/.../dashboard_agenda_section.dart` | Wraps `TodayAgendaCard` + `UpcomingAgendaList` with its own loading/error card states (not reusing `AppLoading`/`AppErrorView`) |
| `DashboardSkeleton` | `dashboard/.../dashboard_skeleton.dart` | Dependency-free shimmer-less skeleton (3 gray cards) — a second, different "loading" pattern from `AppLoading` |
| `DietMacroSummary` / `FoodMacroBreakdown` | diet/foods widgets | Two different macro-display components (chip-based vs. progress-bar-based) for overlapping concepts (calories/protein/carb/fat) |
| `ExerciseMedia` | `exercises/.../exercise_media.dart` | Gif preview + external video link launcher |
| `GoalProgressBar` | `goals/.../goal_progress_bar.dart` | Goal title + `AchievementChip` + `LinearProgressIndicator` + stats line |
| `PtScheduleGridView` | `pt/.../pt_schedule_grid_view.dart` | Hour × trainer availability grid for selling PT sessions (own legend, own cell coloring) |
| `ReportChartSection` / `ReportDataTable` / `ReportDateRangeBar` / `ReportFiltersBar` / `ReportPaginationBar` | `reports/.../*.dart` | Report-viewer building blocks; `ReportChartSection` composes `AppBarChart`/`AppLineChart`/`AppHeatmap` correctly |
| `OpenSlotsPicker` | `scheduling/.../open_slots_picker.dart` | Day-strip + slot-chip picker for PT booking |
| `PlanExerciseReorderList` | `workout/.../plan_exercise_reorder_list.dart` | Reorderable exercise list for a workout-plan day |
| `RestTimerWidget` | `workout/.../rest_timer_widget.dart` | Countdown timer card during active workout |

## Promotion candidates (feature-scoped today, generic enough for `core/widgets/`)
1. ~~**Status chip**~~ **DONE** (`MembershipStatusChip`, `PaymentStatusChip`, `DietPlanStatusChip`, `PlanStatusChip`, `AchievementChip`) → `core/widgets/app_status_chip.dart` (`AppStatusChip`).
2. ~~**Search-and-pick bottom sheet**~~ **DONE** (`FoodPickerSheet`, `ExercisePickerSheet`) → `core/widgets/app_picker_sheet.dart` (`AppPickerSheet<T>`).
3. ~~**Simple catalog dropdown field**~~ **DONE** (`FacilityPickerField`, `ScheduleTypePickerField`) → `core/widgets/app_catalog_dropdown_field.dart` (`AppCatalogDropdownField<T>`).
4. ~~**Filter bottom sheet shell**~~ **DONE** (`ExerciseFilterSheet`, `FoodFilterSheet`) → `core/widgets/app_filter_sheet_shell.dart` (`AppFilterSheetShell`).
