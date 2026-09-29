# Screen Inventory

86 screens across 16 features. Routes are defined in `lib/core/router/routes.dart` (member/trainer/admin route trees in `member_routes.dart` / `trainer_routes.dart` / `admin_routes.dart`). State management is `flutter_bloc` throughout (Cubit for most screens, Bloc for a handful of legacy/list-heavy screens: `CheckInBloc`, `ExerciseListBloc`, `FoodListBloc`, `MembersDirectoryBloc`, `BookScheduleBloc`, `ActiveWorkoutBloc`, `CreateMembershipBloc`).

Legend for "Empty/Error/Loading": ✅ = uses `AppEmptyView`/`AppErrorView`/`AppLoading` (or `DashboardSkeleton`); ⚠️ = only `CircularProgressIndicator` inline, no shared empty/error widget; ❌ = none found.

## Alerts
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| alerts/.../system_alerts_screen.dart | SystemAlertsScreen | `/admin/alerts` | Admin audit-log/system alerts feed | list | SystemAlertsCubit | ✅ |

## Attendance
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| attendance/.../admin_attendance_screen.dart | AdminAttendanceScreen | `/admin/attendance` (+scan/manual) | Live check-in feed + manual/scan check-in | list + form | AttendanceLiveFeedCubit, CheckInBloc | ✅ |
| attendance/.../attendance_pass_screen.dart | AttendancePassScreen | `/profile/attendance` | Member's own attendance pass + history | list-detail | AttendanceHistoryCubit, AttendancePassCubit | ✅ |
| attendance/.../attendance_summary_screen.dart | AttendanceSummaryScreen | `/profile/attendance/summary` | Attendance stats summary | chart/stat | AttendanceSummaryCubit | ⚠️ (no empty) |

## Auth
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| auth/.../change_password_screen.dart | ChangePasswordScreen | `/change-password` | Change password form | form | ChangePasswordCubit | n/a (form) |
| auth/.../forgot_password_screen.dart | ForgotPasswordScreen | `/forgot-password` | Request reset email | form | ForgotPasswordCubit | n/a (form) |
| auth/.../login_screen.dart | LoginScreen | `/login` | Sign in | form | LoginCubit | n/a (form) |
| auth/.../profile_tab_screen.dart | ProfileTabScreen | `/profile`, `/trainer/profile` | Profile tab root (nav links + sign-out) | hub/list | none directly (SignOutTile has its own) | ❌ none — pure static nav list |
| auth/.../reset_password_screen.dart | ResetPasswordScreen | `/reset-password` | Reset password w/ token | form | ResetPasswordCubit | n/a (form) |
| auth/.../splash_screen.dart | SplashScreen | `/splash` | Session bootstrap / redirect gate | splash | SessionCubit (read only, router reacts) | n/a |

## Dashboard
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| dashboard/.../dashboard_screen.dart | DashboardScreen | `/home`, `/trainer/home`, `/admin/dashboard` | Role-aware home dashboard (member/trainer/admin sections + agenda) | dashboard, composed of sub-widgets | DashboardCubit, DashboardAgendaCubit, SessionCubit | ✅ (DashboardSkeleton, own agenda section error/empty) |

## Diet
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| diet/.../diet_daily_log_screen.dart | DietDailyLogScreen | `/home/diet/log` | Log meals for a day | form + list | DietDailyLogCubit | ⚠️ (no AppEmptyView) |
| diet/.../diet_history_screen.dart | DietHistoryScreen | `/home/diet/history` | Diet log history list | list | DietHistoryCubit | ✅ |
| diet/.../diet_meal_detail_screen.dart | DietMealDetailScreen | `/home/diet/meal/:id` | Meal detail (macros) | detail | DietMealDetailCubit | ⚠️ (no empty) |
| diet/.../diet_plan_builder_screen.dart | DietPlanBuilderScreen | `/trainer/plans/diets/create`, `.../:id/edit` | Build/edit a diet plan | form/builder | DietPlanBuilderCubit | ⚠️ (no empty) |
| diet/.../diet_plan_detail_screen.dart | DietPlanDetailScreen | `/trainer/plans/diets/:id` | View diet plan | detail | DietPlanDetailCubit | ⚠️ (no empty) |
| diet/.../diet_plan_list_screen.dart | DietPlanListScreen | `/trainer/plans` (diet tab) | List diet plans | list | DietPlanListCubit | ✅ |
| diet/.../diet_plan_versions_screen.dart | DietPlanVersionsScreen | `/trainer/plans/diets/:id/versions` | Plan version history | list | DietPlanVersionsCubit | ⚠️ (no empty) |

Duplication: `diet_plan_status_chip.dart` mirrors `workout/plan_status_chip.dart` almost exactly (draft/active/archived, same color scheme).

## Exercises
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| exercises/.../exercise_detail_screen.dart | ExerciseDetailScreen | `/trainer/plans/exercises/:id` | Exercise detail (media, instructions) | detail | ExerciseDetailCubit, ExerciseListBloc | ⚠️ (no shared empty/error) |
| exercises/.../exercise_form_screen.dart | ExerciseFormScreen | admin exercise create/edit (via library) | Create/edit exercise | form | ExerciseFormCubit | n/a (form) |
| exercises/.../exercise_library_screen.dart | ExerciseLibraryScreen | `/trainer/plans/exercises`, `/admin/workout-library` | Browse/filter exercise catalog (side pane on wide) | list + filter sheet | ExerciseListBloc | ⚠️ (no shared empty/error) |

## Foods
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| foods/.../food_detail_screen.dart | FoodDetailScreen | `/trainer/plans/foods/:id` | Food detail (macros) | detail | FoodDetailCubit, FoodListBloc | ⚠️ |
| foods/.../food_form_screen.dart | FoodFormScreen | admin food create/edit | Create/edit food | form | FoodFormCubit | n/a (form) |
| foods/.../food_library_screen.dart | FoodLibraryScreen | `/trainer/plans/foods`, `/admin/diet-library` | Browse/filter food catalog | list + filter sheet | FoodListBloc | ⚠️ |

## Goals (Progress)
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| goals/.../goal_detail_screen.dart | GoalDetailScreen | `/progress/goal/:id`, `/trainer/members/:id/goals/...` | Goal detail + metric chart | detail/chart | GoalDetailCubit | ⚠️ (no empty) |
| goals/.../goal_form_screen.dart | GoalFormScreen | goal create/edit | Create/edit member goal | form | GoalFormCubit | ⚠️ (no empty) |
| goals/.../goal_metrics_admin_screen.dart | GoalMetricsAdminScreen | `/admin/goal-metrics` | Admin CRUD for goal metric catalog | list+form | GoalMetricsAdminCubit | ✅ |
| goals/.../measurements_screen.dart | MeasurementsScreen | `/progress/measurements` | Body measurements log | list | MeasurementsCubit | ✅ |
| goals/.../progress_hub_screen.dart | ProgressHubScreen | `/progress` | Goals overview hub | list/hub | GoalsListCubit | ✅ |
| goals/.../progress_notes_screen.dart | ProgressNotesScreen | `/progress/notes` | Progress notes log | list | ProgressNotesCubit | ✅ |
| goals/.../progress_photos_screen.dart | ProgressPhotosScreen | `/progress/photos` | Progress photo gallery | grid | ProgressPhotosCubit | ✅ |

## Membership
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| membership/.../create_membership_screen.dart | CreateMembershipScreen | `/admin/memberships/create`, `.../assign-membership` | Sell/assign a membership | form | CreateMembershipBloc | ⚠️ |
| membership/.../membership_card_screen.dart | MembershipCardScreen | `/membership` | Member's own membership card | detail | MembershipCardCubit, SessionCubit | ⚠️ (no AppEmptyView/Error) |
| membership/.../membership_detail_screen.dart | MembershipDetailScreen | `/admin/memberships/:id` | Admin membership detail (contract, freeze/change history) | detail (tabs-like sections) | MembershipDetailCubit, SessionCubit | ⚠️ |
| membership/.../membership_freeze_history_screen.dart | MembershipFreezeHistoryScreen | `/membership/freeze-history` | Read-only freeze history | list | MembershipFreezeCubit (via widget), SessionCubit | ⚠️ (delegates to MembershipFreezeList which has its own E/E/L) |
| membership/.../membership_freeze_screen.dart | MembershipFreezeScreen | `/admin/memberships/:id/freeze` | Submit freeze request | form | MembershipFreezeFormCubit | ⚠️ |
| membership/.../membership_history_screen.dart | MembershipHistoryScreen | `/membership/history` | Membership change history | list | (delegates to MembershipHistoryList), SessionCubit | ⚠️ |
| membership/.../membership_packages_catalog_screen.dart | MembershipPackagesCatalogScreen | `/membership/packages`, `/admin/memberships/packages` | Browse/manage package catalog | list+form | MembershipPackagesCatalogCubit, SessionCubit | ⚠️ |
| membership/.../membership_product_form_screen.dart | MembershipProductFormScreen | package create/edit | Create/edit membership product | form | MembershipProductFormCubit | n/a (form) |
| membership/.../membership_renew_screen.dart | MembershipRenewScreen | `/admin/memberships/:id/renew` | Renew a membership | form | MembershipRenewCubit | ⚠️ |
| membership/.../memberships_directory_screen.dart | MembershipsDirectoryScreen | `/admin/memberships` | Admin memberships list/search | list | MembershipsDirectoryCubit | ✅ |
| membership/.../trainer_membership_summary_screen.dart | TrainerMembershipSummaryScreen | `/trainer/members/:id/membership` | Trainer's read-only view of a member's membership | detail | (reads data passed in, minimal own state) | ❌ (no E/E/L markers found) |

Duplication: `membership_status_chip.dart` is the same pattern as `payment_status_chip`, `diet_plan_status_chip`, `plan_status_chip` (switch → (label, Color), `Chip` w/ alpha-0.15 bg).

## Notifications
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| notifications/.../broadcast_screen.dart | BroadcastScreen | `/admin/notifications/broadcast`, `/trainer/notifications/broadcast` | Compose/send broadcast notification | form + tabs | BroadcastCubit | ✅ |
| notifications/.../notification_detail_screen.dart | NotificationDetailScreen | `/notifications/:id`, `/trainer/notifications/:id` | Notification detail | detail | NotificationDetailCubit | ⚠️ (no empty) |
| notifications/.../notifications_inbox_screen.dart | NotificationsInboxScreen | `/notifications`, `/trainer/notifications` | Notification inbox list | list | NotificationsInboxCubit | ✅ |

## Payments
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| payments/.../outstanding_dues_screen.dart | OutstandingDuesScreen | `/admin/payments/outstanding` | List members with outstanding dues | list | OutstandingDuesCubit | ✅ |
| payments/.../payment_detail_screen.dart | PaymentDetailScreen | `/admin/payments/:id`, `/profile/payments/:id` | Payment detail | detail | PaymentDetailCubit | ✅ |
| payments/.../payment_methods_screen.dart | PaymentMethodsScreen | `/admin/payments/methods` | Manage accepted payment methods | list+form | PaymentMethodsCubit | ✅ |
| payments/.../payments_ledger_screen.dart | PaymentsLedgerScreen | `/admin/payments`, `/profile/payments` | Payment ledger/history | list | PaymentsLedgerCubit | ✅ |

## People (Members / Trainers / Employees / Profile)
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| people/.../add_member_wizard_screen.dart | AddMemberWizardScreen | `/admin/members/add` | Multi-step new-member onboarding | wizard (Stepper) | AddMemberWizardCubit | n/a (form/wizard) |
| people/.../add_trainer_screen.dart | AddTrainerScreen | `/admin/trainers/create` | Create trainer | form | TrainerFormCubit | n/a (form) |
| people/.../documents_screen.dart | DocumentsScreen | `/profile/documents` | Member document uploads | list | DocumentsCubit, SessionCubit | ✅ |
| people/.../edit_member_screen.dart | EditMemberScreen | `/admin/members/:id/edit` | Edit existing member | form | EditMemberCubit | ⚠️ (no empty) |
| people/.../edit_profile_screen.dart | EditProfileScreen | `/profile/edit` | Edit own profile | form | EditProfileCubit | ⚠️ (no empty) |
| people/.../edit_trainer_profile_screen.dart | EditTrainerProfileScreen | `/trainer/profile/edit`, `/admin/trainers/:id/edit` | Edit trainer profile | form | EditTrainerProfileCubit | ⚠️ (no empty) |
| people/.../emergency_contacts_screen.dart | EmergencyContactsScreen | `/profile/emergency-contacts` | Manage emergency contacts | list+form | EmergencyContactsCubit | ✅ |
| people/.../employee_form_screen.dart | EmployeeFormScreen | `/admin/employees/create`, `.../:id/edit` | Create/edit employee | form | EmployeeFormCubit | ⚠️ (AppLoading only, no error view) |
| people/.../employee_roles_screen.dart | EmployeeRolesScreen | `/admin/employees/:id/roles` | Assign roles/permissions to employee | list (checkboxes) | EmployeeRolesCubit | ✅ |
| people/.../employees_directory_screen.dart | EmployeesDirectoryScreen | `/admin/employees` | Admin employee directory | list | EmployeesDirectoryCubit | ✅ |
| people/.../health_info_screen.dart | HealthInfoScreen | `/trainer/members/:id/health` | Member health info | form | HealthInfoCubit | ⚠️ (no empty) |
| people/.../medical_history_screen.dart | MedicalHistoryScreen | (nested under health) | Medical history log | list | MedicalHistoryCubit | ✅ |
| people/.../member_dossier_screen.dart | MemberDossierScreen | `/trainer/members/:id` | Trainer's full member dossier (PT-gated) | detail hub | MemberDossierCubit, SessionCubit | ⚠️ (no empty) |
| people/.../members_directory_screen.dart | MembersDirectoryScreen | `/admin/members` | Admin members directory/search | list | MembersDirectoryBloc | ✅ |
| people/.../my_trainer_profile_screen.dart | MyTrainerProfileScreen | `/profile/trainer` | Member's assigned trainer info | detail | MyTrainerProfileCubit | ✅ |
| people/.../photos_avatar_screen.dart | PhotosAvatarScreen | avatar/profile photo mgmt | Avatar upload/crop | grid+form | PhotosCubit | ✅ |
| people/.../trainers_directory_screen.dart | TrainersDirectoryScreen | `/admin/trainers` | Admin trainer directory | list | TrainersDirectoryCubit | ✅ |

## PT (Personal Training)
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| pt/.../pt_packages_screen.dart | PtPackagesScreen | `/admin/pt-packages` | Admin PT package catalog | list+form | PtPackagesCubit | ⚠️ (no empty) |
| pt/.../sell_pt_screen.dart | SellPtScreen | `/admin/members/:id/add-pt` | Sell PT sessions to a member, trainer/slot grid | form + grid (PtScheduleGridView) | SellPtCubit | ⚠️ (no empty) |

## Reports
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| reports/.../report_viewer_screen.dart | ReportViewerScreen | `/admin/reports/:category`, `/trainer/reports/own` | Chart + data-table report viewer | chart-heavy + table | ReportCubit | ⚠️ (no empty state, only error/loading) |
| reports/.../reports_hub_screen.dart | ReportsHubScreen | `/admin/reports` | Report category navigation hub | hub/list | none (static nav) | ❌ (static hub, N/A) |

## Scheduling
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| scheduling/.../book_schedule_screen.dart | BookScheduleScreen | `/schedule/book-pt`, `/schedule/book-class` | Member booking (PT open-slots or class list) | list + picker | BookScheduleBloc, OpenSlotsCubit, ScheduleCalendarCubit, SessionCubit | ✅ |
| scheduling/.../facilities_screen.dart | FacilitiesScreen | `/admin/schedules` (facilities) | Manage facilities | list+form | FacilitiesCubit | ✅ |
| scheduling/.../schedule_calendar_screen.dart | ScheduleCalendarScreen | `/schedule`, `/trainer/schedule` | Calendar/list of sessions | calendar+list | ScheduleCalendarCubit, SessionCubit | ✅ |
| scheduling/.../schedule_detail_screen.dart | ScheduleDetailScreen | `/schedule/:id`, `/trainer/schedule/:id` | Session detail (reschedule, move, cancel) | detail | ScheduleDetailCubit, SessionCubit | ⚠️ (no empty) |
| scheduling/.../schedule_form_screen.dart | ScheduleFormScreen | `/admin/schedules/create`, `.../:id/edit` | Create/edit a scheduled session | form | ScheduleFormCubit | n/a (form) |
| scheduling/.../schedule_history_screen.dart | ScheduleHistoryScreen | `/schedule/history`, `/trainer/schedule/history` | Past sessions list | list | ScheduleHistoryCubit | ✅ |
| scheduling/.../todays_sessions_screen.dart | TodaysSessionsScreen | `/trainer/sessions/today` | Trainer's sessions today | list | TodaysSessionsCubit | ✅ |
| scheduling/.../trainer_availability_screen.dart | TrainerAvailabilityScreen | `/trainer/schedule/availability` | Trainer availability editor | list+form | TrainerAvailabilityCubit, SessionCubit | ✅ |

## Settings
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| settings/.../settings_category_screen.dart | SettingsCategoryScreen | `/admin/settings/:category` | Generic key/value settings editor | form (dynamic) | SettingsCategoryCubit | ✅ |
| settings/.../settings_hub_screen.dart | SettingsHubScreen | `/admin/settings` | Settings category nav hub | hub/list | none (static nav) | ❌ (static hub, N/A) |

## Workout
| File | Screen | Route | Purpose | Pattern | State | E/E/L |
|---|---|---|---|---|---|---|
| workout/.../active_workout_screen.dart | ActiveWorkoutScreen | `/home/workout/active` | Live in-progress workout session w/ rest timer | active/stateful | ActiveWorkoutBloc, RestTimerCubit (via RestTimerWidget) | ⚠️ (AppLoading only) |
| workout/.../workout_history_screen.dart | WorkoutHistoryScreen | `/home/workout/history`, `/trainer/members/:id/workout-history` | Past workout sessions | list | WorkoutHistoryCubit | ✅ |
| workout/.../workout_plan_builder_screen.dart | WorkoutPlanBuilderScreen | `/trainer/plans/workouts/create`, `.../:id/edit` | Build/edit workout plan (day groups, reorder) | form/builder | WorkoutPlanBuilderCubit | ⚠️ (no empty) |
| workout/.../workout_plan_detail_screen.dart | WorkoutPlanDetailScreen | `/trainer/plans/workouts/:id` | View workout plan | detail | WorkoutPlanDetailCubit | ⚠️ (no empty) |
| workout/.../workout_plan_list_screen.dart | WorkoutPlanListScreen | `/trainer/plans` (workout tab) | List workout plans | list | WorkoutPlanListCubit | ✅ |
| workout/.../workout_plan_versions_screen.dart | WorkoutPlanVersionsScreen | `/trainer/plans/workouts/:id/versions` | Plan version history | list | WorkoutPlanVersionsCubit | ⚠️ (no empty) |

Duplication: `plan_status_chip.dart` (workout) is byte-for-byte the same shape as `diet_plan_status_chip.dart`.
