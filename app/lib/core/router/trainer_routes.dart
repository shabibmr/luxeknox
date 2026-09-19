import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/exercises/presentation/screens/exercise_detail_screen.dart';
import '../../features/exercises/presentation/screens/exercise_library_screen.dart';
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
            label: 'Home',
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Members',
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Plans',
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      );
    },
    branches: [
      // Home Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerHome,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Trainer Home'),
          ),
        ],
      ),
      // Members Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerMembers,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Trainer Members'),
          ),
        ],
      ),
      // Schedule Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerSchedule,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Trainer Schedule'),
          ),
        ],
      ),
      // Plans Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerPlans,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Trainer Plans'),
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
      // Profile Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.trainerProfile,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Trainer Profile'),
          ),
        ],
      ),
    ],
  );
}
