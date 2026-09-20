import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/widgets/sign_out_tile.dart';
import '../../features/exercises/presentation/screens/exercise_library_screen.dart';
import '../l10n/shell_strings.dart';
import '../widgets/adaptive_shell.dart';
import '../widgets/more_hub_screen.dart';
import '../widgets/placeholder_screen.dart';
import 'routes.dart';

const int _adminMoreBranchIndex = 4;

StatefulShellRoute createAdminBranchRoute() {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return _AdminAdaptiveShell(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminDashboard,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.adminDashboard),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminMembers,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.adminMembers),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminMemberships,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.adminMemberships),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminPayments,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.adminPayments),
          ),
        ],
      ),
      // More branch: sibling routes for every nav-§4 More path.
      // Default location stays workout-library; hub is tab chrome.
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminWorkoutLibrary,
            builder: (context, state) => const ExerciseLibraryScreen(),
          ),
          GoRoute(
            path: Routes.adminTrainers,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.trainers),
          ),
          GoRoute(
            path: Routes.adminEmployees,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.employees),
          ),
          GoRoute(
            path: Routes.adminPackages,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.packages),
          ),
          GoRoute(
            path: Routes.adminAttendance,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.attendance),
          ),
          GoRoute(
            path: Routes.adminSchedules,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.schedules),
          ),
          GoRoute(
            path: Routes.adminDietLibrary,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.dietLibrary),
          ),
          GoRoute(
            path: Routes.adminGoalMetrics,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.goalMetrics),
          ),
          GoRoute(
            path: Routes.adminNotificationsBroadcast,
            builder: (context, state) => const PlaceholderScreen(
              title: ShellStrings.notificationsBroadcast,
            ),
          ),
          GoRoute(
            path: Routes.adminReports,
            builder: (context, state) => PlaceholderScreen(
              title:
                  '${ShellStrings.reports}: ${state.pathParameters['category']}',
            ),
          ),
          GoRoute(
            path: Routes.adminSettings,
            builder: (context, state) => PlaceholderScreen(
              title:
                  '${ShellStrings.settings}: ${state.pathParameters['category']}',
            ),
          ),
        ],
      ),
    ],
  );
}

/// Shows [MoreHubScreen] when the More tab is selected; sibling routes render
/// underneath once a hub tile navigates away from the hub chrome.
class _AdminAdaptiveShell extends StatefulWidget {
  const _AdminAdaptiveShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<_AdminAdaptiveShell> createState() => _AdminAdaptiveShellState();
}

class _AdminAdaptiveShellState extends State<_AdminAdaptiveShell> {
  bool _showMoreHub = false;

  void _onDestinationSelected(int index) {
    if (index == _adminMoreBranchIndex) {
      setState(() => _showMoreHub = true);
      widget.navigationShell.goBranch(
        index,
        initialLocation: index == widget.navigationShell.currentIndex,
      );
      return;
    }
    setState(() => _showMoreHub = false);
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Deep-link into a More sibling: show that page, not the hub.
    final onMoreBranch =
        widget.navigationShell.currentIndex == _adminMoreBranchIndex;
    final showHub = _showMoreHub && onMoreBranch;

    // Keep [navigationShell] mounted under the hub so other tab stacks
    // are not disposed while More chrome is visible.
    return AdaptiveShell(
      navigationShell: widget.navigationShell,
      onDestinationSelected: _onDestinationSelected,
      body: Stack(
        children: [
          widget.navigationShell,
          if (showHub)
            Positioned.fill(
              child: MoreHubScreen(
                onOpenPath: (_) {
                  setState(() => _showMoreHub = false);
                },
                footer: const SignOutTile(),
              ),
            ),
        ],
      ),
      destinations: const [
        AdaptiveNavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: ShellStrings.dashboard,
        ),
        AdaptiveNavigationDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people),
          label: ShellStrings.members,
        ),
        AdaptiveNavigationDestination(
          icon: Icon(Icons.card_membership_outlined),
          selectedIcon: Icon(Icons.card_membership),
          label: ShellStrings.memberships,
        ),
        AdaptiveNavigationDestination(
          icon: Icon(Icons.payment_outlined),
          selectedIcon: Icon(Icons.payment),
          label: ShellStrings.payments,
        ),
        AdaptiveNavigationDestination(
          icon: Icon(Icons.more_horiz_outlined),
          selectedIcon: Icon(Icons.more_horiz),
          label: ShellStrings.more,
        ),
      ],
    );
  }
}
