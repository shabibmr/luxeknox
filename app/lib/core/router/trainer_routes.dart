import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/profile_tab_screen.dart';
import '../../features/exercises/presentation/screens/exercise_detail_screen.dart';
import '../../features/exercises/presentation/screens/exercise_library_screen.dart';
import '../../features/foods/presentation/screens/food_detail_screen.dart';
import '../../features/foods/presentation/screens/food_library_screen.dart';
import '../../features/membership/presentation/screens/trainer_membership_summary_screen.dart';
import '../l10n/shell_strings.dart';
import '../widgets/adaptive_shell.dart';
import '../widgets/placeholder_screen.dart';
import 'routes.dart';

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
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.trainerHome),
          ),
          GoRoute(
            path: Routes.trainerSessionsToday,
            builder: (context, state) => const PlaceholderScreen(
              title: ShellStrings.trainerSessionsToday,
            ),
          ),
          GoRoute(
            path: Routes.trainerNotifications,
            builder: (context, state) => const PlaceholderScreen(
              title: ShellStrings.trainerNotifications,
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerMembers,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.trainerMembers),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => PlaceholderScreen(
                  title:
                      '${ShellStrings.memberDetail}: ${state.pathParameters['id']}',
                ),
                routes: [
                  GoRoute(
                    path: 'health',
                    builder: (context, state) => const PlaceholderScreen(
                      title: ShellStrings.memberHealth,
                    ),
                  ),
                  GoRoute(
                    path: 'goals',
                    builder: (context, state) => const PlaceholderScreen(
                      title: ShellStrings.memberGoals,
                    ),
                    routes: [
                      GoRoute(
                        path: 'add-measurement',
                        builder: (context, state) => const PlaceholderScreen(
                          title: ShellStrings.memberAddMeasurement,
                        ),
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
                    builder: (context, state) => const PlaceholderScreen(
                      title: ShellStrings.memberAttendance,
                    ),
                  ),
                  GoRoute(
                    path: 'schedule',
                    builder: (context, state) => const PlaceholderScreen(
                      title: ShellStrings.memberSchedule,
                    ),
                  ),
                  GoRoute(
                    path: 'payments',
                    builder: (context, state) => const PlaceholderScreen(
                      title: ShellStrings.memberPayments,
                    ),
                  ),
                  GoRoute(
                    path: 'workout-history',
                    builder: (context, state) => const PlaceholderScreen(
                      title: ShellStrings.memberWorkoutHistory,
                    ),
                  ),
                  GoRoute(
                    path: 'diet-history',
                    builder: (context, state) => const PlaceholderScreen(
                      title: ShellStrings.memberDietHistory,
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
            path: Routes.trainerSchedule,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.trainerSchedule),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    const PlaceholderScreen(title: ShellStrings.scheduleDetail),
              ),
              GoRoute(
                path: 'availability',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.scheduleAvailability,
                ),
              ),
              GoRoute(
                path: 'history',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.scheduleHistory,
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
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.trainerPlans),
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
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.createWorkoutPlan,
                ),
              ),
              GoRoute(
                path: 'workouts/history',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.workoutPlanHistory,
                ),
              ),
              GoRoute(
                path: 'workouts/:id',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.workoutPlanDetail,
                ),
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
                builder: (context, state) =>
                    const PlaceholderScreen(title: ShellStrings.createDietPlan),
              ),
              GoRoute(
                path: 'diets/history',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.dietPlanHistory,
                ),
              ),
              GoRoute(
                path: 'diets/:id',
                builder: (context, state) =>
                    const PlaceholderScreen(title: ShellStrings.dietPlanDetail),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerProfile,
            builder: (context, state) =>
                const ProfileTabScreen(title: ShellStrings.trainerProfile),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) =>
                    const PlaceholderScreen(title: ShellStrings.editProfile),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
