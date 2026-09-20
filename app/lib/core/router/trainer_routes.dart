import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/profile_tab_screen.dart';
import '../../features/exercises/presentation/screens/exercise_detail_screen.dart';
import '../../features/exercises/presentation/screens/exercise_library_screen.dart';
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
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerMembers,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.trainerMembers),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerSchedule,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.trainerSchedule),
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
          ),
        ],
      ),
    ],
  );
}
