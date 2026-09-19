import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/exercises/presentation/screens/exercise_library_screen.dart';
import '../widgets/adaptive_shell.dart';
import '../widgets/placeholder_screen.dart';
import 'routes.dart';

StatefulShellRoute createAdminBranchRoute() {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return AdaptiveShell(
        navigationShell: navigationShell,
        destinations: const [
          AdaptiveNavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Members',
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.card_membership_outlined),
            selectedIcon: Icon(Icons.card_membership),
            label: 'Memberships',
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.payment_outlined),
            selectedIcon: Icon(Icons.payment),
            label: 'Payments',
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.more_horiz_outlined),
            selectedIcon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      );
    },
    branches: [
      // Dashboard Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminDashboard,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Admin Dashboard'),
          ),
        ],
      ),
      // Members Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminMembers,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Admin Members'),
          ),
        ],
      ),
      // Memberships Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminMemberships,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Admin Memberships'),
          ),
        ],
      ),
      // Payments Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminPayments,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Admin Payments'),
          ),
        ],
      ),
      // More Branch (Includes Workout Library)
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminWorkoutLibrary,
            builder: (context, state) => const ExerciseLibraryScreen(),
          ),
        ],
      ),
    ],
  );
}
