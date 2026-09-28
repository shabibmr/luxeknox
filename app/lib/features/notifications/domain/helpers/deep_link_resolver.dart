import '../../../../core/router/routes.dart';
import '../entities/deep_link_target.dart';

/// Maps a [DeepLinkTarget] to a known app route path, or null if unknown.
String? resolveDeepLinkPath(DeepLinkTarget target) {
  final type = target.entityType.toLowerCase().replaceAll('-', '_');
  final id = target.entityId;

  return switch (type) {
    'membership' || 'memberships' => Routes.memberMembership,
    'schedule' ||
    'schedules' ||
    'booking' ||
    'session' =>
      Routes.memberScheduleById(id),
    'payment' || 'payments' => Routes.memberProfilePaymentById(id),
    'goal' || 'goals' || 'progress_goal' => Routes.memberProgressGoalById(id),
    'progress' => Routes.memberProgress,
    'measurement' || 'measurements' => Routes.memberProgressMeasurements,
    'progress_photo' || 'progress_photos' || 'photo' =>
      Routes.memberProgressPhotos,
    'progress_note' || 'progress_notes' || 'note' =>
      Routes.memberProgressNotes,
    'attendance' => Routes.memberProfileAttendance,
    'workout' || 'workouts' => Routes.memberHomeWorkoutHistory,
    'diet' || 'diets' || 'diet_plan' => Routes.memberHomeDietHistory,
    'notification' || 'notifications' => Routes.memberNotificationById(id),
    'member' || 'members' || 'person' || 'people' =>
      Routes.adminMemberById(id),
    _ => null,
  };
}
