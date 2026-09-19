import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/router/routes.dart';

void main() {
  group('Routes', () {
    test('all route constants are non-empty strings', () {
      expect(Routes.login, isNotEmpty);
      expect(Routes.splash, isNotEmpty);
      expect(Routes.memberHome, isNotEmpty);
      expect(Routes.trainerHome, isNotEmpty);
      expect(Routes.adminDashboard, isNotEmpty);
    });

    test('no duplicate route values exist', () {
      final allRoutes = <String>{
        Routes.login,
        Routes.splash,
        // Member routes
        Routes.memberHome,
        Routes.memberHomeWorkoutActive,
        Routes.memberHomeWorkoutExerciseDetail,
        Routes.memberHomeDietMeal,
        Routes.memberNotifications,
        Routes.memberMembership,
        Routes.memberMembershipPackages,
        Routes.memberMembershipHistory,
        Routes.memberMembershipFreezeHistory,
        Routes.memberSchedule,
        Routes.memberScheduleDetail,
        Routes.memberScheduleBookPt,
        Routes.memberScheduleBookClass,
        Routes.memberScheduleHistory,
        Routes.memberProgress,
        Routes.memberProgressGoalDetail,
        Routes.memberProgressMeasurements,
        Routes.memberProgressPhotos,
        Routes.memberProgressNotes,
        Routes.memberProfile,
        Routes.memberProfileEdit,
        Routes.memberProfileHealth,
        Routes.memberProfileEmergencyContacts,
        Routes.memberProfileDocuments,
        Routes.memberProfilePayments,
        Routes.memberProfileTrainer,
        Routes.memberProfileAttendance,
        // Trainer routes
        Routes.trainerHome,
        Routes.trainerSessionsToday,
        Routes.trainerNotifications,
        Routes.trainerMembers,
        Routes.trainerMembersDetail,
        Routes.trainerMembersHealth,
        Routes.trainerMembersGoals,
        Routes.trainerMembersGoalsAddMeasurement,
        Routes.trainerSchedule,
        Routes.trainerScheduleDetail,
        Routes.trainerScheduleAvailability,
        Routes.trainerScheduleHistory,
        Routes.trainerPlans,
        Routes.trainerPlansWorkoutsCreate,
        Routes.trainerPlansWorkoutsDetail,
        Routes.trainerPlansDietsCreate,
        Routes.trainerPlansDietsDetail,
        Routes.trainerPlansExercises,
        Routes.trainerPlansExercisesDetail,
        Routes.trainerProfile,
        Routes.trainerProfileEdit,
        // Admin routes
        Routes.adminDashboard,
        Routes.adminAlerts,
        Routes.adminMembers,
        Routes.adminMembersAdd,
        Routes.adminMembersDetail,
        Routes.adminMembersEdit,
        Routes.adminMembersAssignMembership,
        Routes.adminMemberships,
        Routes.adminMembershipsDetail,
        Routes.adminMembershipsRenew,
        Routes.adminMembershipsFreeze,
        Routes.adminPayments,
        Routes.adminPaymentsRecord,
        Routes.adminPaymentsDetail,
        Routes.adminPaymentsOutstanding,
        Routes.adminTrainers,
        Routes.adminEmployees,
        Routes.adminPackages,
        Routes.adminAttendance,
        Routes.adminSchedules,
        Routes.adminWorkoutLibrary,
        Routes.adminDietLibrary,
        Routes.adminGoalMetrics,
        Routes.adminNotificationsBroadcast,
        Routes.adminReports,
        Routes.adminSettings,
      };

      // Set literals de-duplicate identical values automatically, so if
      // every Routes.* reference above resolves to a distinct string this
      // set's length equals the number of entries listed, i.e. 74.
      expect(
        allRoutes.length,
        76,
        reason: 'All route constants should be unique; duplicate values found',
      );
    });
  });
}
