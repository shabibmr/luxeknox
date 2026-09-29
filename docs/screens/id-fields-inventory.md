# LuxeKnox Gym UI — Comprehensive ID Fields Inventory

This document catalogs all fields in the Flutter frontend (`app/lib`) that accept an **ID value** of any entity (e.g., Member, Trainer, Exercise, Package/Product, Workout Plan, Diet Plan, Schedule Session, Facility, Role, Goal/Metric, Payment, Document, etc.).

---

## 1. Interactive UI Form & Input Fields Accepting Entity IDs

These are interactive UI input elements (`TextField`, `TextFormField`, `DropdownButtonFormField`, modal pickers, grid selectors) rendered in Screens, Dialogs, and Bottom Sheets where an ID is entered or selected.

| # | File Name | Screen / Dialog | UI Control & Field Name | Entity | Description |
|---|---|---|---|---|---|
| 1 | `app/lib/features/workout/presentation/screens/workout_plan_builder_screen.dart` | `WorkoutPlanBuilderScreen` (`_BuilderForm`) | `TextFormField` (`_memberId`) | **Member** (`memberId`) | Manual text field to enter Member ID when assigning a custom workout plan |
| 2 | `app/lib/features/diet/presentation/screens/diet_plan_builder_screen.dart` | `DietPlanBuilderScreen` (`_BuilderForm`) | `TextFormField` (`_memberId`) | **Member** (`memberId`) | Manual text field to enter Member ID when assigning a custom diet plan |
| 3 | `app/lib/features/attendance/presentation/screens/admin_attendance_screen.dart` | `ManualCheckInScreen` | `TextField` (`_userIdController`) | **User / Member** (`userId`) | Admin manual check-in form accepting User/Member ID |
| 4 | `app/lib/features/membership/presentation/screens/create_membership_screen.dart` | `CreateMembershipScreen` (`_CreateMembershipForm`) | `DropdownButtonFormField<String>` (`selectedMemberId`) | **Member** (`memberId`) | Dropdown to select member ID when issuing a membership contract |
| 5 | `app/lib/features/reports/presentation/widgets/report_filters_bar.dart` | `ReportViewerScreen` (Filters Bar) | `TextField` (`_trainer`) | **Trainer** (`trainerId`) | Numeric text field to filter reports by Trainer ID |
| 6 | `app/lib/features/scheduling/presentation/screens/schedule_form_screen.dart` | `ScheduleFormScreen` (`_ScheduleFormBodyState`) | `TrainerPickerField` (Modal Sheet) | **Trainer** (`trainer.id`) | Searchable modal sheet to pick Trainer ID for a scheduled session |
| 7 | `app/lib/features/pt/presentation/screens/sell_pt_screen.dart` | `SellPtScreen` (`_Form`) | `PtScheduleGridView` (`selectedTrainerId`) | **Trainer** (`trainerId`) | Visual grid to pick trainer ID and hour slot for PT |
| 8 | `app/lib/features/workout/presentation/screens/active_workout_screen.dart` | `ActiveWorkoutScreen` (`_InProgressPanel`) | `TextField` (`_freeExerciseController`) | **Exercise** (`exerciseId`) | Manual input field accepting Exercise ID when logging sets |
| 9 | `app/lib/features/workout/presentation/widgets/exercise_picker_sheet.dart` | `WorkoutPlanBuilderScreen` (Picker Sheet) | `ExercisePickerSheet` (ListTile item) | **Exercise** (`exercise.id`) | Searchable bottom sheet returning selected Exercise ID |
| 10 | `app/lib/features/workout/presentation/screens/active_workout_screen.dart` | `ActiveWorkoutScreen` (`_StartPanel`) | `TextField` (`_planIdController`) | **Workout Plan** (`workoutPlanId`) | Optional text field to input Workout Plan ID to start a session |
| 11 | `app/lib/features/diet/presentation/widgets/food_picker_sheet.dart` | `DietPlanBuilderScreen` (Picker Sheet) | `FoodPickerSheet` (ListTile item) | **Food** (`food.id`) | Searchable bottom sheet returning selected Food ID |
| 12 | `app/lib/features/membership/presentation/screens/membership_detail_screen.dart` | `MembershipDetailScreen` (Upgrade Dialog) | `TextField` (`productController`) | **Package / Product** (`productId`) | Dialog text field accepting Product ID for membership upgrade |
| 13 | `app/lib/features/membership/presentation/screens/create_membership_screen.dart` | `CreateMembershipScreen` (`_CreateMembershipForm`) | `DropdownButtonFormField<String>` (`selectedProductId`) | **Package / Product** (`productId`) | Dropdown to select membership package/product ID |
| 14 | `app/lib/features/pt/presentation/screens/sell_pt_screen.dart` | `SellPtScreen` (`_Form`) | `DropdownButtonFormField<int>` (`product.id`) | **PT Package** (`productId`) | Dropdown to select personal training package ID |
| 15 | `app/lib/features/reports/presentation/widgets/report_filters_bar.dart` | `ReportViewerScreen` (Filters Bar) | `TextField` (`_product`) | **Package / Product** (`productId`) | Numeric text field to filter reports by Product ID |
| 16 | `app/lib/features/scheduling/presentation/screens/schedule_form_screen.dart` | `ScheduleFormScreen` (`_ScheduleFormBodyState`) | `FacilityPickerField` (Dropdown) | **Facility** (`facility.id`) | Dropdown selecting Facility ID for a session |
| 17 | `app/lib/features/scheduling/presentation/widgets/move_booking_sheet.dart` | `MoveBookingSheet` (Bottom Sheet) | Session List (`session.id`) | **Schedule Session** (`targetSession.id`) | Bottom sheet to pick target Session ID to move booking to |
| 18 | `app/lib/features/pt/presentation/screens/sell_pt_screen.dart` | `SellPtScreen` (`_Form`) | `DropdownButtonFormField<String>` (`paymentMethodId`) | **Payment Method** (`paymentMethodId`) | Dropdown to select Payment Method ID |
| 19 | `app/lib/features/people/presentation/screens/member_dossier_screen.dart` | `_RenewPtDialog` (AlertDialog) | `DropdownButtonFormField<String>` (`_methodId`) | **Payment Method** (`paymentMethodId`) | Dialog dropdown to select Payment Method ID for PT renewal |
| 20 | `app/lib/features/notifications/presentation/screens/broadcast_screen.dart` | `BroadcastScreen` (`_ComposeTab`) | `TextField` (`_roleIdController`) | **Role** (`roleId`) | Text field accepting Role ID for role-targeted broadcasts |
| 21 | `app/lib/features/people/presentation/screens/employee_roles_screen.dart` | `EmployeeRolesScreen` (`_EmployeeRolesBody`) | Role card action button (`role.id`) | **Role** (`roleId`) | Action button to assign selected Role ID to an employee |
| 22 | `app/lib/features/goals/presentation/screens/goal_form_screen.dart` | `GoalFormScreen` (`_GoalFormBody`) | `DropdownButtonFormField<String>` (`_metricId`) | **Goal Metric** (`metricId`) | Dropdown to select Goal Metric ID |
| 23 | `app/lib/features/goals/presentation/screens/measurements_screen.dart` | `MeasurementsScreen` (Create Sheet) | Dynamic `TextField` (`controllers[m.id]`) | **Goal Metric** (`metricId`) | Dynamically generated numeric inputs keyed by Metric ID |
| 24 | `app/lib/features/attendance/presentation/screens/admin_attendance_screen.dart` | `QrScanCheckInScreen` | `TextField` (`_payloadController`) | **Attendance Pass** (`payload`) | Text field for manually entering attendance QR/pass token payload |
| 25 | `app/lib/features/settings/presentation/screens/settings_category_screen.dart` | `SettingsCategoryScreen` (Add Dialog) | `TextField` (`keyController`) | **Setting Key** (`settingKey`) | Text field accepting App Setting Key identifier |

---

## 2. Screen & Dialog Class Constructor Properties Accepting Entity IDs

These are widget properties defined on Screen and Dialog classes that accept entity IDs as arguments (via routes or direct instantiation).

### 2.1 Member Entity (`memberId` / `userId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `MemberDossierScreen` | `app/lib/features/people/presentation/screens/member_dossier_screen.dart` | `final int memberId;` |
| `EditMemberScreen` | `app/lib/features/people/presentation/screens/edit_member_screen.dart` | `final int memberId;` |
| `EditProfileScreen` | `app/lib/features/people/presentation/screens/edit_profile_screen.dart` | `final int memberId;` |
| `HealthInfoScreen` | `app/lib/features/people/presentation/screens/health_info_screen.dart` | `final int memberId;` |
| `MedicalHistoryScreen` | `app/lib/features/people/presentation/screens/medical_history_screen.dart` | `final int memberId;` |
| `EmergencyContactsScreen` | `app/lib/features/people/presentation/screens/emergency_contacts_screen.dart` | `final int userId;` |
| `DocumentsScreen` | `app/lib/features/people/presentation/screens/documents_screen.dart` | `final int memberId;` |
| `PhotosAvatarScreen` | `app/lib/features/people/presentation/screens/photos_avatar_screen.dart` | `final int memberId;` |
| `MyTrainerProfileScreen` | `app/lib/features/people/presentation/screens/my_trainer_profile_screen.dart` | `final int memberId;` |
| `SellPtScreen` | `app/lib/features/pt/presentation/screens/sell_pt_screen.dart` | `final int memberId;` |
| `CreateMembershipScreen` | `app/lib/features/membership/presentation/screens/create_membership_screen.dart` | `final String? memberId;` |
| `TrainerMembershipSummaryScreen` | `app/lib/features/membership/presentation/screens/trainer_membership_summary_screen.dart` | `final String memberId;` |
| `GoalFormScreen` | `app/lib/features/goals/presentation/screens/goal_form_screen.dart` | `final String memberId;` |
| `MeasurementsScreen` | `app/lib/features/goals/presentation/screens/measurements_screen.dart` | `final String? memberId;` |
| `ProgressHubScreen` | `app/lib/features/goals/presentation/screens/progress_hub_screen.dart` | `final String? memberId;` |
| `ProgressNotesScreen` | `app/lib/features/goals/presentation/screens/progress_notes_screen.dart` | `final String? memberId;` |
| `ProgressPhotosScreen` | `app/lib/features/goals/presentation/screens/progress_photos_screen.dart` | `final String? memberId;` |
| `DietDailyLogScreen` | `app/lib/features/diet/presentation/screens/diet_daily_log_screen.dart` | `final String? memberId;` |
| `DietHistoryScreen` | `app/lib/features/diet/presentation/screens/diet_history_screen.dart` | `final String? memberId;` |
| `WorkoutHistoryScreen` | `app/lib/features/workout/presentation/screens/workout_history_screen.dart` | `final String? memberId;` |
| `PaymentsLedgerScreen` | `app/lib/features/payments/presentation/screens/payments_ledger_screen.dart` | `final String? memberId;` |
| `AttendanceSummaryScreen` | `app/lib/features/attendance/presentation/screens/attendance_summary_screen.dart` | `final String? memberId;` |
| `AttendanceHistoryScreen` | `app/lib/features/attendance/presentation/screens/attendance_pass_screen.dart` | `final String? userId;` |
| `ScheduleCalendarScreen` | `app/lib/features/scheduling/presentation/screens/schedule_calendar_screen.dart` | `final String? memberId;` |
| `ScheduleHistoryScreen` | `app/lib/features/scheduling/presentation/screens/schedule_history_screen.dart` | `final String? memberId;` |
| `MoveBookingSheet` | `app/lib/features/scheduling/presentation/widgets/move_booking_sheet.dart` | `final String memberId;` |

### 2.2 Trainer Entity (`trainerId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `EditTrainerProfileScreen` | `app/lib/features/people/presentation/screens/edit_trainer_profile_screen.dart` | `final int trainerId;` |
| `TrainersDirectoryScreen` | `app/lib/features/people/presentation/screens/trainers_directory_screen.dart` | `int? _selectedTrainerId;` |
| `TrainerAvailabilityScreen` | `app/lib/features/scheduling/presentation/screens/trainer_availability_screen.dart` | `final String? trainerId;` |
| `TodaysSessionsScreen` | `app/lib/features/scheduling/presentation/screens/todays_sessions_screen.dart` | `final String? trainerId;` |
| `ScheduleCalendarScreen` | `app/lib/features/scheduling/presentation/screens/schedule_calendar_screen.dart` | `final String? trainerId;` |
| `ScheduleHistoryScreen` | `app/lib/features/scheduling/presentation/screens/schedule_history_screen.dart` | `final String? trainerId;` |
| `ReportFiltersBar` | `app/lib/features/reports/presentation/widgets/report_filters_bar.dart` | `final String? trainerId;` |

### 2.3 Exercise Entity (`exerciseId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `ExerciseDetailScreen` | `app/lib/features/exercises/presentation/screens/exercise_detail_screen.dart` | `final String exerciseId;` |
| `ExerciseLibraryScreen` | `app/lib/features/exercises/presentation/screens/exercise_library_screen.dart` | `final String? selectedExerciseId;` |

### 2.4 Food Entity (`foodId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `FoodDetailScreen` | `app/lib/features/foods/presentation/screens/food_detail_screen.dart` | `final String foodId;` |
| `FoodLibraryScreen` | `app/lib/features/foods/presentation/screens/food_library_screen.dart` | `final String? selectedFoodId;` |

### 2.5 Membership Contract Entity (`membershipId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `MembershipDetailScreen` | `app/lib/features/membership/presentation/screens/membership_detail_screen.dart` | `final String membershipId;` |
| `MembershipRenewScreen` | `app/lib/features/membership/presentation/screens/membership_renew_screen.dart` | `final String membershipId;` |
| `MembershipFreezeScreen` | `app/lib/features/membership/presentation/screens/membership_freeze_screen.dart` | `final String membershipId;` |
| `MembershipFreezeHistoryScreen` | `app/lib/features/membership/presentation/screens/membership_freeze_history_screen.dart` | `final String membershipId;` |
| `MembershipHistoryScreen` | `app/lib/features/membership/presentation/screens/membership_history_screen.dart` | `final String membershipId;` |
| `MembershipFreezeList` | `app/lib/features/membership/presentation/widgets/membership_freeze_list.dart` | `final String membershipId;` |
| `MembershipHistoryList` | `app/lib/features/membership/presentation/widgets/membership_history_list.dart` | `final String membershipId;` |

### 2.6 Workout Plan Entity (`planId` / `workoutPlanId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `WorkoutPlanDetailScreen` | `app/lib/features/workout/presentation/screens/workout_plan_detail_screen.dart` | `final String planId;` |
| `WorkoutPlanBuilderScreen` | `app/lib/features/workout/presentation/screens/workout_plan_builder_screen.dart` | `final String? planId;` |
| `WorkoutPlanVersionsScreen` | `app/lib/features/workout/presentation/screens/workout_plan_versions_screen.dart` | `final String planId;` |
| `ActiveWorkoutScreen` | `app/lib/features/workout/presentation/screens/active_workout_screen.dart` | `final String? workoutPlanId;` |

### 2.7 Diet Plan & Meal Entity (`planId` / `mealId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `DietPlanDetailScreen` | `app/lib/features/diet/presentation/screens/diet_plan_detail_screen.dart` | `final String planId;` |
| `DietPlanBuilderScreen` | `app/lib/features/diet/presentation/screens/diet_plan_builder_screen.dart` | `final String? planId;` |
| `DietPlanVersionsScreen` | `app/lib/features/diet/presentation/screens/diet_plan_versions_screen.dart` | `final String planId;` |
| `DietMealDetailScreen` | `app/lib/features/diet/presentation/screens/diet_meal_detail_screen.dart` | `final String mealId;`, `final String? planId;` |

### 2.8 Schedule Session Entity (`scheduleId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `ScheduleDetailScreen` | `app/lib/features/scheduling/presentation/screens/schedule_detail_screen.dart` | `final String scheduleId;` |
| `ScheduleFormScreen` | `app/lib/features/scheduling/presentation/screens/schedule_form_screen.dart` | `final String? scheduleId;` |
| `BookScheduleScreen` | `app/lib/features/scheduling/presentation/screens/book_schedule_screen.dart` | `final String scheduleId;` |

### 2.9 Goal & Goal Metric Entities (`goalId` / `mandatoryMetricIds`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `GoalDetailScreen` | `app/lib/features/goals/presentation/screens/goal_detail_screen.dart` | `final String goalId;` |
| `GoalFormScreen` | `app/lib/features/goals/presentation/screens/goal_form_screen.dart` | `final String? goalId;` |
| `MeasurementsScreen` | `app/lib/features/goals/presentation/screens/measurements_screen.dart` | `final List<String> mandatoryMetricIds;` |

### 2.10 Staff Employee Entity (`employeeId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `EmployeeFormScreen` | `app/lib/features/people/presentation/screens/employee_form_screen.dart` | `final int? employeeId;` |
| `EmployeeRolesScreen` | `app/lib/features/people/presentation/screens/employee_roles_screen.dart` | `final int employeeId;` |
| `EmployeesDirectoryScreen` | `app/lib/features/people/presentation/screens/employees_directory_screen.dart` | `int? _selectedEmployeeId;` |

### 2.11 Payment Entity (`paymentId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `PaymentDetailScreen` | `app/lib/features/payments/presentation/screens/payment_detail_screen.dart` | `final String paymentId;` |

### 2.12 Notification Entity (`notificationId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `NotificationDetailScreen` | `app/lib/features/notifications/presentation/screens/notification_detail_screen.dart` | `final String notificationId;` |

### 2.13 Package / Product Entity (`productId`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `ReportFiltersBar` | `app/lib/features/reports/presentation/widgets/report_filters_bar.dart` | `final String? productId;` |

### 2.14 Media Document Entity (`objectKey`)

| Screen / Dialog | File Name | Parameter / Type |
|---|---|---|
| `DocumentPreviewDialog` | `app/lib/core/media/document_preview_dialog.dart` | `final String objectKey;` |
