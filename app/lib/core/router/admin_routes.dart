import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/presentation/screens/admin_attendance_screen.dart';
import '../../features/auth/presentation/widgets/sign_out_tile.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/exercises/presentation/screens/exercise_library_screen.dart';
import '../../features/foods/presentation/screens/food_library_screen.dart';
import '../../features/membership/presentation/screens/create_membership_screen.dart';
import '../../features/membership/presentation/screens/membership_detail_screen.dart';
import '../../features/membership/presentation/screens/membership_packages_catalog_screen.dart';
import '../../features/membership/presentation/screens/memberships_directory_screen.dart';
import '../../features/payments/presentation/payment_ledger_role.dart';
import '../../features/payments/presentation/screens/outstanding_dues_screen.dart';
import '../../features/payments/presentation/screens/payment_detail_screen.dart';
import '../../features/payments/presentation/screens/payment_methods_screen.dart';
import '../../features/payments/presentation/screens/payments_ledger_screen.dart';
import '../../features/people/presentation/screens/employees_directory_screen.dart';
import '../../features/people/presentation/screens/member_dossier_screen.dart';
import '../../features/people/presentation/screens/members_directory_screen.dart';
import '../../features/people/presentation/screens/trainers_directory_screen.dart';
import '../../features/scheduling/presentation/screens/facilities_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_calendar_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_detail_screen.dart';
import '../../features/workout/presentation/screens/workout_history_screen.dart';
import '../../features/workout/presentation/workout_history_role.dart';
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
            builder: (context, state) => const DashboardScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminMembers,
            builder: (context, state) => const MembersDirectoryScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  if (id == null) {
                    return const PlaceholderScreen(
                      title: ShellStrings.adminMembers,
                    );
                  }
                  return MemberDossierScreen(memberId: id);
                },
                routes: [
                  GoRoute(
                    path: 'assign-membership',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return CreateMembershipScreen(memberId: id);
                    },
                  ),
                  GoRoute(
                    path: 'workout-history',
                    builder: (context, state) {
                      final memberId = state.pathParameters['id']!;
                      return WorkoutHistoryScreen(
                        role: WorkoutHistoryRole.admin,
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
            path: Routes.adminMemberships,
            builder: (context, state) => const MembershipsDirectoryScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateMembershipScreen(),
              ),
              GoRoute(
                path: 'packages',
                builder: (context, state) =>
                    const MembershipPackagesCatalogScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => MembershipDetailScreen(
                  membershipId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminPayments,
            builder: (context, state) => const PaymentsLedgerScreen(
              role: PaymentsLedgerRole.admin,
            ),
            routes: [
              GoRoute(
                path: 'outstanding',
                builder: (context, state) => const OutstandingDuesScreen(),
              ),
              GoRoute(
                path: 'methods',
                builder: (context, state) => const PaymentMethodsScreen(),
              ),
              GoRoute(
                path: 'record',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.adminPayments,
                ),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => PaymentDetailScreen(
                  paymentId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      ),
      // More branch: sibling routes for every nav-§4 More path.
      // Default location is /admin/more (empty); hub overlays as tab chrome.
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.adminMore,
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: Routes.adminWorkoutLibrary,
            builder: (context, state) => const ExerciseLibraryScreen(),
          ),
          GoRoute(
            path: Routes.adminTrainers,
            builder: (context, state) => const TrainersDirectoryScreen(),
          ),
          GoRoute(
            path: Routes.adminEmployees,
            builder: (context, state) => const EmployeesDirectoryScreen(),
          ),
          GoRoute(
            path: Routes.adminPackages,
            builder: (context, state) =>
                const MembershipPackagesCatalogScreen(),
          ),
          GoRoute(
            path: Routes.adminAttendance,
            builder: (context, state) => const AdminAttendanceScreen(),
            routes: [
              GoRoute(
                path: 'scan',
                builder: (context, state) => const QrScanCheckInScreen(),
              ),
              GoRoute(
                path: 'manual',
                builder: (context, state) => const ManualCheckInScreen(),
              ),
            ],
          ),
          GoRoute(
            path: Routes.adminSchedules,
            builder: (context, state) =>
                const ScheduleCalendarScreen(role: ScheduleCalendarRole.admin),
            routes: [
              GoRoute(
                path: 'facilities',
                builder: (context, state) => const FacilitiesScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => ScheduleDetailScreen(
                  scheduleId: state.pathParameters['id']!,
                  role: ScheduleCalendarRole.admin,
                ),
              ),
            ],
          ),
          GoRoute(
            path: Routes.adminDietLibrary,
            builder: (context, state) => const FoodLibraryScreen(),
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
    // /admin/more (branch root) always shows the hub.
    final onMoreBranch =
        widget.navigationShell.currentIndex == _adminMoreBranchIndex;
    final onMoreRoot =
        GoRouterState.of(context).matchedLocation == Routes.adminMore;
    final showHub = onMoreBranch && (_showMoreHub || onMoreRoot);

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
