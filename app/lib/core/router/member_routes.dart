import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/exercises/presentation/screens/exercise_detail_screen.dart';
import '../widgets/adaptive_shell.dart';
import '../widgets/placeholder_screen.dart';
import 'routes.dart';

StatefulShellRoute createMemberBranchRoute() {
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
            icon: Icon(Icons.card_membership_outlined),
            selectedIcon: Icon(Icons.card_membership),
            label: 'Membership',
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.trending_up_outlined),
            selectedIcon: Icon(Icons.trending_up),
            label: 'Progress',
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
            path: Routes.memberHome,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Member Home'),
            routes: [
              GoRoute(
                path: 'workout/exercises/:id',
                builder: (context, state) => ExerciseDetailScreen(
                  exerciseId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      ),
      // Membership Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.memberMembership,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Membership'),
          ),
        ],
      ),
      // Schedule Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.memberSchedule,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Schedule'),
          ),
        ],
      ),
      // Progress Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.memberProgress,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Progress'),
          ),
        ],
      ),
      // Profile Branch
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.memberProfile,
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Profile'),
          ),
        ],
      ),
    ],
  );
}
