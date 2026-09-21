import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/presentation/screens/attendance_pass_screen.dart';
import '../../features/attendance/presentation/screens/attendance_summary_screen.dart';
import '../../features/auth/presentation/screens/profile_tab_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/exercises/presentation/screens/exercise_detail_screen.dart';
import '../../features/exercises/presentation/screens/exercise_library_screen.dart';
import '../../features/diet/presentation/diet_history_role.dart';
import '../../features/diet/presentation/screens/diet_history_screen.dart';
import '../../features/diet/presentation/screens/diet_plan_builder_screen.dart';
import '../../features/diet/presentation/screens/diet_plan_detail_screen.dart';
import '../../features/diet/presentation/screens/diet_plan_list_screen.dart';
import '../../features/diet/presentation/screens/diet_plan_versions_screen.dart';

import '../../features/foods/presentation/screens/food_detail_screen.dart';
import '../../features/foods/presentation/screens/food_library_screen.dart';
import '../../features/goals/presentation/screens/measurements_screen.dart';
import '../../features/goals/presentation/screens/progress_hub_screen.dart';
import '../../features/membership/presentation/screens/trainer_membership_summary_screen.dart';
import '../../features/notifications/presentation/screens/broadcast_screen.dart';
import '../../features/notifications/presentation/screens/notification_detail_screen.dart';
import '../../features/notifications/presentation/screens/notifications_inbox_screen.dart';
import '../../features/reports/presentation/screens/report_viewer_screen.dart';
import '../../features/payments/presentation/payment_ledger_role.dart';
import '../../features/payments/presentation/screens/payments_ledger_screen.dart';
import '../../features/people/presentation/screens/edit_trainer_profile_screen.dart';
import '../../features/people/presentation/screens/health_info_screen.dart';
import '../../features/people/presentation/screens/member_dossier_screen.dart';
import '../../features/people/presentation/screens/members_directory_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_calendar_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_detail_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_history_screen.dart';
import '../../features/scheduling/presentation/screens/todays_sessions_screen.dart';
import '../../features/scheduling/presentation/screens/trainer_availability_screen.dart';
import '../../features/workout/presentation/screens/workout_history_screen.dart';
import '../../features/workout/presentation/screens/workout_plan_builder_screen.dart';
import '../../features/workout/presentation/screens/workout_plan_detail_screen.dart';
import '../../features/workout/presentation/screens/workout_plan_list_screen.dart';
import '../../features/workout/presentation/screens/workout_plan_versions_screen.dart';
import '../../features/workout/presentation/workout_history_role.dart';
import '../l10n/shell_strings.dart';
import '../widgets/adaptive_shell.dart';
import '../widgets/destination_hub_screen.dart';
import '../widgets/placeholder_screen.dart';
import 'routes.dart';
import 'session_route_ids.dart';

StatefulShellRoute createTrainerBranchRoute() {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return AdaptiveShell(
        navigationShell: navigationShell,
        destinations: const [
          AdaptiveNavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: ShellStrings.home,
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: ShellStrings.members,
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: ShellStrings.schedule,
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: ShellStrings.plans,
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: ShellStrings.profile,
          ),
        ],
      );
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerHome,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: Routes.trainerSessionsToday,
            builder: (context, state) {
              final trainerId = sessionProfileId(context)?.toString();
              return TodaysSessionsScreen(trainerId: trainerId);
            },
          ),
          GoRoute(
            path: Routes.trainerNotifications,
            builder: (context, state) => const NotificationsInboxScreen(
              detailPathBuilder: Routes.trainerNotificationById,
              showBroadcastAction: true,
              broadcastPath: Routes.trainerNotificationsBroadcast,
            ),
            routes: [
              GoRoute(
                path: 'broadcast',
                builder: (context, state) =>
                    const BroadcastScreen(trainerOnlyAssigned: true),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => NotificationDetailScreen(
                  notificationId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerMembers,
            builder: (context, state) => MembersDirectoryScreen(
              memberDetailPathBuilder: (id) =>
                  Routes.trainerMembersDetail.replaceFirst(':id', '$id'),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  if (id == null) {
                    return const PlaceholderScreen(
                      title: ShellStrings.trainerMembers,
                    );
                  }
                  return MemberDossierScreen(memberId: id);
                },
                routes: [
                  GoRoute(
                    path: 'health',
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');
                      if (id == null) {
                        return const PlaceholderScreen(
                          title: ShellStrings.memberHealth,
                        );
                      }
                      return HealthInfoScreen(memberId: id);
                    },
                  ),
                  GoRoute(
                    path: 'goals',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return ProgressHubScreen(
                        memberId: id,
                        canCreateGoals: true,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'add-measurement',
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? '';
                          return MeasurementsScreen(memberId: id);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'membership',
                    builder: (context, state) => TrainerMembershipSummaryScreen(
                      memberId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'attendance',
                    builder: (context, state) {
                      final memberId = state.pathParameters['id']!;
                      return AttendanceSummaryScreen(memberId: memberId);
                    },
                    routes: [
                      GoRoute(
                        path: 'history',
                        builder: (context, state) {
                          final memberId = state.pathParameters['id']!;
                          return AttendanceHistoryScreen(userId: memberId);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'schedule',
                    builder: (context, state) {
                      final id = state.pathParameters['id'];
                      if (id == null || id.isEmpty) {
                        return const PlaceholderScreen(
                          title: ShellStrings.memberSchedule,
                        );
                      }
                      return ScheduleCalendarScreen(
                        role: ScheduleCalendarRole.trainer,
                        memberId: id,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'payments',
                    builder: (context, state) {
                      final memberId = state.pathParameters['id']!;
                      return PaymentsLedgerScreen(
                        role: PaymentsLedgerRole.trainer,
                        memberId: memberId,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'workout-history',
                    builder: (context, state) {
                      final memberId = state.pathParameters['id']!;
                      return WorkoutHistoryScreen(
                        role: WorkoutHistoryRole.trainer,
                        memberId: memberId,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'diet-history',
                    builder: (context, state) {
                      final memberId = state.pathParameters['id']!;
                      return DietHistoryScreen(
                        role: DietHistoryRole.trainer,
                        memberId: memberId,
                      );
                    },
                  ),

                ],
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerSchedule,
            builder: (context, state) => const ScheduleCalendarScreen(
              role: ScheduleCalendarRole.trainer,
            ),
            routes: [
              GoRoute(
                path: 'availability',
                builder: (context, state) => const TrainerAvailabilityScreen(),
              ),
              GoRoute(
                path: 'history',
                builder: (context, state) {
                  final trainerId = sessionProfileId(context)?.toString();
                  return ScheduleHistoryScreen(
                    role: ScheduleCalendarRole.trainer,
                    trainerId: trainerId,
                  );
                },
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => ScheduleDetailScreen(
                  scheduleId: state.pathParameters['id']!,
                  role: ScheduleCalendarRole.trainer,
                ),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerPlans,
            builder: (context, state) => const DestinationHubScreen(
              title: ShellStrings.plans,
              items: [
                DestinationHubItem(
                  title: ShellStrings.workoutLibrary,
                  path: Routes.trainerPlansExercises,
                  icon: Icons.fitness_center_outlined,
                ),
                DestinationHubItem(
                  title: ShellStrings.dietLibrary,
                  path: Routes.trainerPlansFoods,
                  icon: Icons.restaurant_outlined,
                ),
                DestinationHubItem(
                  title: ShellStrings.createWorkoutPlan,
                  path: Routes.trainerPlansWorkoutsCreate,
                  icon: Icons.add_circle_outline,
                ),
                DestinationHubItem(
                  title: ShellStrings.createDietPlan,
                  path: Routes.trainerPlansDietsCreate,
                  icon: Icons.add_circle_outline,
                ),
                DestinationHubItem(
                  title: ShellStrings.workoutPlans,
                  path: Routes.trainerPlansWorkoutsHistory,
                  icon: Icons.history,
                ),
                DestinationHubItem(
                  title: ShellStrings.dietPlanHistory,
                  path: Routes.trainerPlansDietsHistory,
                  icon: Icons.history,
                ),
              ],
            ),
            routes: [
              GoRoute(
                path: 'exercises',
                builder: (context, state) => const ExerciseLibraryScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => ExerciseDetailScreen(
                      exerciseId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'workouts/create',
                builder: (context, state) => const WorkoutPlanBuilderScreen(),
              ),
              GoRoute(
                path: 'workouts/history',
                builder: (context, state) => const WorkoutPlanListScreen(),
              ),
              GoRoute(
                path: 'workouts/:id',
                builder: (context, state) => WorkoutPlanDetailScreen(
                  planId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => WorkoutPlanBuilderScreen(
                      planId: state.pathParameters['id'],
                    ),
                  ),
                  GoRoute(
                    path: 'versions',
                    builder: (context, state) => WorkoutPlanVersionsScreen(
                      planId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'foods',
                builder: (context, state) => const FoodLibraryScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) =>
                        FoodDetailScreen(foodId: state.pathParameters['id']!),
                  ),
                ],
              ),
              GoRoute(
                path: 'diets/create',
                builder: (context, state) => const DietPlanBuilderScreen(),
              ),
              GoRoute(
                path: 'diets/history',
                builder: (context, state) => const DietPlanListScreen(),
              ),
              GoRoute(
                path: 'diets/:id',
                builder: (context, state) => DietPlanDetailScreen(
                  planId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => DietPlanBuilderScreen(
                      planId: state.pathParameters['id'],
                    ),
                  ),
                  GoRoute(
                    path: 'versions',
                    builder: (context, state) => DietPlanVersionsScreen(
                      planId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerProfile,
            builder: (context, state) => const ProfileTabScreen(
              title: ShellStrings.trainerProfile,
              links: [
                ProfileTabLink(
                  title: ShellStrings.editProfile,
                  path: Routes.trainerProfileEdit,
                  icon: Icons.edit_outlined,
                ),
                ProfileTabLink(
                  title: ShellStrings.trainerOwnReport,
                  path: Routes.trainerReportsOwn,
                  icon: Icons.insights_outlined,
                ),
              ],
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  final trainerId = sessionProfileId(context);
                  if (trainerId == null) {
                    return const PlaceholderScreen(
                      title: ShellStrings.editProfile,
                    );
                  }
                  return EditTrainerProfileScreen(trainerId: trainerId);
                },
              ),
            ],
          ),
          GoRoute(
            path: Routes.trainerReportsOwn,
            builder: (context, state) => const ReportViewerScreen(
              category: 'trainer_own',
              trainerOwnLocked: true,
            ),
          ),
        ],
      ),
    ],
  );
}
