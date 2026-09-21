/// Route constants for the LuxeKnox Gym app.
/// All paths are copied exactly from docs/screens/navigation-architecture.md §2–4.
/// These are used throughout the app for navigation and redirect logic.
class Routes {
  Routes._();

  /// Role path prefixes used by redirect boundary checks (not standalone screens).
  static const String adminPathPrefix = '/admin';
  static const String trainerPathPrefix = '/trainer';

  static bool isAdminPath(String path) =>
      path == adminPathPrefix || path.startsWith('$adminPathPrefix/');

  static bool isTrainerPath(String path) =>
      path == trainerPathPrefix || path.startsWith('$trainerPathPrefix/');

  // ========== Auth Routes ==========
  static const String login = '/login';
  static const String splash = '/splash';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/change-password';

  // ========== Member App Routes ==========
  // Home Stack
  static const String memberHome = '/home';
  static const String memberHomeWorkoutActive = '/home/workout/active';
  static const String memberHomeWorkoutExerciseDetail =
      '/home/workout/exercises/:id';
  static const String memberHomeDietMeal = '/home/diet/meal/:id';
  static const String memberNotifications = '/notifications';

  // Membership Stack
  static const String memberMembership = '/membership';
  static const String memberMembershipPackages = '/membership/packages';
  static const String memberMembershipHistory = '/membership/history';
  static const String memberMembershipFreezeHistory =
      '/membership/freeze-history';

  // Schedule Stack
  static const String memberSchedule = '/schedule';
  static const String memberScheduleDetail = '/schedule/:id';
  static const String memberScheduleBookPt = '/schedule/book-pt';
  static const String memberScheduleBookClass = '/schedule/book-class';
  static const String memberScheduleHistory = '/schedule/history';

  // Progress Stack
  static const String memberProgress = '/progress';
  static const String memberProgressGoalDetail = '/progress/goal/:id';
  static const String memberProgressMeasurements = '/progress/measurements';
  static const String memberProgressPhotos = '/progress/photos';
  static const String memberProgressNotes = '/progress/notes';

  // Profile Stack
  static const String memberProfile = '/profile';
  static const String memberProfileEdit = '/profile/edit';
  static const String memberProfileHealth = '/profile/health';
  static const String memberProfileEmergencyContacts =
      '/profile/emergency-contacts';
  static const String memberProfileDocuments = '/profile/documents';
  static const String memberProfilePayments = '/profile/payments';
  static const String memberProfilePaymentsDetail = '/profile/payments/:id';
  static const String memberProfileTrainer = '/profile/trainer';
  static const String memberProfileAttendance = '/profile/attendance';
  static const String memberProfileAttendanceHistory =
      '/profile/attendance/history';
  static const String memberProfileAttendanceSummary =
      '/profile/attendance/summary';

  // ========== Trainer App Routes ==========
  // Home Stack
  static const String trainerHome = '/trainer/home';
  static const String trainerSessionsToday = '/trainer/sessions/today';
  static const String trainerNotifications = '/trainer/notifications';

  // Members Stack
  static const String trainerMembers = '/trainer/members';
  static const String trainerMembersDetail = '/trainer/members/:id';
  static const String trainerMembersHealth = '/trainer/members/:id/health';
  static const String trainerMembersGoals = '/trainer/members/:id/goals';
  static const String trainerMembersGoalsAddMeasurement =
      '/trainer/members/:id/goals/add-measurement';
  static const String trainerMembersMembership =
      '/trainer/members/:id/membership';
  static const String trainerMembersAttendance =
      '/trainer/members/:id/attendance';
  static const String trainerMembersSchedule = '/trainer/members/:id/schedule';
  static const String trainerMembersPayments = '/trainer/members/:id/payments';
  static const String trainerMembersWorkoutHistory =
      '/trainer/members/:id/workout-history';
  static const String trainerMembersDietHistory =
      '/trainer/members/:id/diet-history';

  // Schedule Stack
  static const String trainerSchedule = '/trainer/schedule';
  static const String trainerScheduleDetail = '/trainer/schedule/:id';
  static const String trainerScheduleAvailability =
      '/trainer/schedule/availability';
  static const String trainerScheduleHistory = '/trainer/schedule/history';

  // Plans Stack
  static const String trainerPlans = '/trainer/plans';
  static const String trainerPlansWorkoutsCreate =
      '/trainer/plans/workouts/create';
  static const String trainerPlansWorkoutsDetail =
      '/trainer/plans/workouts/:id';
  static const String trainerPlansWorkoutsEdit =
      '/trainer/plans/workouts/:id/edit';
  static const String trainerPlansDietsCreate = '/trainer/plans/diets/create';
  static const String trainerPlansDietsDetail = '/trainer/plans/diets/:id';
  static const String trainerPlansExercises = '/trainer/plans/exercises';
  static const String trainerPlansExercisesDetail =
      '/trainer/plans/exercises/:id';
  static const String trainerPlansFoods = '/trainer/plans/foods';
  static const String trainerPlansFoodsDetail = '/trainer/plans/foods/:id';
  static const String trainerPlansWorkoutsHistory =
      '/trainer/plans/workouts/history';
  static const String trainerPlansDietsHistory = '/trainer/plans/diets/history';

  // Profile Stack
  static const String trainerProfile = '/trainer/profile';
  static const String trainerProfileEdit = '/trainer/profile/edit';

  // ========== Admin App Routes ==========
  // Dashboard Stack
  static const String adminDashboard = '/admin/dashboard';
  static const String adminAlerts = '/admin/alerts';

  // Members Stack
  static const String adminMembers = '/admin/members';
  static const String adminMembersAdd = '/admin/members/add';
  static const String adminMembersDetail = '/admin/members/:id';
  static const String adminMembersEdit = '/admin/members/:id/edit';
  static const String adminMembersAssignMembership =
      '/admin/members/:id/assign-membership';

  // Memberships Stack
  static const String adminMemberships = '/admin/memberships';
  static const String adminMembershipsCreate = '/admin/memberships/create';
  static const String adminMembershipsPackages = '/admin/memberships/packages';
  static const String adminMembershipsDetail = '/admin/memberships/:id';
  static const String adminMembershipsRenew = '/admin/memberships/:id/renew';
  static const String adminMembershipsFreeze = '/admin/memberships/:id/freeze';

  // Payments Stack
  static const String adminPayments = '/admin/payments';
  static const String adminPaymentsRecord = '/admin/payments/record';
  static const String adminPaymentsMethods = '/admin/payments/methods';
  static const String adminPaymentsDetail = '/admin/payments/:id';
  static const String adminPaymentsOutstanding = '/admin/payments/outstanding';

  // More (Menu / Side Navigation)
  /// Lightweight More-branch root; hub chrome overlays this location.
  static const String adminMore = '/admin/more';
  static const String adminTrainers = '/admin/trainers';
  static const String adminEmployees = '/admin/employees';
  static const String adminPackages = '/admin/packages';
  static const String adminAttendance = '/admin/attendance';
  static const String adminAttendanceScan = '/admin/attendance/scan';
  static const String adminAttendanceManual = '/admin/attendance/manual';
  static const String adminSchedules = '/admin/schedules';
  static const String adminWorkoutLibrary = '/admin/workout-library';
  static const String adminDietLibrary = '/admin/diet-library';
  static const String adminGoalMetrics = '/admin/goal-metrics';
  static const String adminNotificationsBroadcast =
      '/admin/notifications/broadcast';
  static const String adminReports = '/admin/reports/:category';
  static const String adminSettings = '/admin/settings/:category';

  static String adminReportsCategory(String category) =>
      '/admin/reports/$category';

  static String adminSettingsCategory(String category) =>
      '/admin/settings/$category';

  /// Query key used when redirecting unauthenticated users to login so the
  /// intended deep link can be restored after sign-in.
  static const String redirectQueryParam = 'redirect';

  // ========== Deep-link path builders (replace `:id` / `:category`) ==========

  static String memberHomeWorkoutExerciseById(String id) =>
      '/home/workout/exercises/$id';

  static String memberHomeDietMealById(String id) => '/home/diet/meal/$id';

  static String memberScheduleById(String id) => '/schedule/$id';

  static String memberProgressGoalById(String id) => '/progress/goal/$id';

  static String trainerMemberById(String id) => '/trainer/members/$id';

  static String trainerMemberHealthById(String id) =>
      '/trainer/members/$id/health';

  static String trainerScheduleById(String id) => '/trainer/schedule/$id';

  static String trainerPlansWorkoutById(String id) =>
      '/trainer/plans/workouts/$id';

  static String trainerPlansWorkoutEditById(String id) =>
      '/trainer/plans/workouts/$id/edit';

  static String trainerPlansDietById(String id) => '/trainer/plans/diets/$id';

  static String trainerPlansExerciseById(String id) =>
      '/trainer/plans/exercises/$id';

  static String adminMemberById(String id) => '/admin/members/$id';

  static String adminMembershipById(String id) => '/admin/memberships/$id';

  static String adminPaymentById(String id) => '/admin/payments/$id';

  static String memberProfilePaymentById(String id) => '/profile/payments/$id';

  static String loginWithRedirect(String intendedPath) => Uri(
    path: login,
    queryParameters: {redirectQueryParam: intendedPath},
  ).toString();
}
