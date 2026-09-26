import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/alerts/presentation/screens/system_alerts_screen.dart';
import '../../features/attendance/presentation/screens/admin_attendance_screen.dart';
import '../../features/auth/presentation/widgets/sign_out_tile.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/exercises/presentation/screens/exercise_library_screen.dart';
import '../../features/foods/presentation/screens/food_library_screen.dart';
import '../../features/goals/presentation/screens/goal_metrics_admin_screen.dart';
import '../../features/notifications/presentation/screens/broadcast_screen.dart';
import '../../features/membership/presentation/screens/create_membership_screen.dart';
import '../../features/membership/presentation/screens/membership_detail_screen.dart';
import '../../features/membership/presentation/screens/membership_freeze_screen.dart';
import '../../features/membership/presentation/screens/membership_packages_catalog_screen.dart';
import '../../features/membership/presentation/screens/membership_renew_screen.dart';
import '../../features/membership/presentation/screens/memberships_directory_screen.dart';
import '../../features/payments/presentation/payment_ledger_role.dart';
import '../../features/payments/presentation/screens/outstanding_dues_screen.dart';
import '../../features/payments/presentation/screens/payment_detail_screen.dart';
import '../../features/payments/presentation/screens/payment_methods_screen.dart';
import '../../features/payments/presentation/screens/payments_ledger_screen.dart';
import '../../features/people/presentation/screens/add_member_wizard_screen.dart';
import '../../features/people/presentation/screens/add_trainer_screen.dart';
import '../../features/people/presentation/screens/edit_member_screen.dart';
import '../../features/people/presentation/screens/edit_trainer_profile_screen.dart';
import '../../features/people/presentation/screens/employee_form_screen.dart';
import '../../features/people/presentation/screens/employee_roles_screen.dart';
import '../../features/people/presentation/screens/employees_directory_screen.dart';
import '../../features/reports/presentation/screens/report_viewer_screen.dart';
import '../../features/reports/presentation/screens/reports_hub_screen.dart';
import '../../features/people/presentation/screens/member_dossier_screen.dart';
import '../../features/people/presentation/screens/members_directory_screen.dart';
import '../../features/people/presentation/screens/trainers_directory_screen.dart';
import '../../features/scheduling/presentation/screens/facilities_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_calendar_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_detail_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_form_screen.dart';
import '../../features/settings/presentation/screens/settings_category_screen.dart';
import '../../features/settings/presentation/screens/settings_hub_screen.dart';
import '../../features/diet/presentation/diet_history_role.dart';
import '../../features/diet/presentation/screens/diet_history_screen.dart';
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
            builder: (context, state) => const MembersDirectoryScreen(
              addMemberPath: Routes.adminMembersAdd,
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddMemberWizardScreen(),
              ),
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
                    path: 'edit',
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');
                      if (id == null) {
                        return const PlaceholderScreen(
                          title: ShellStrings.adminMembers,
                        );
                      }
                      return EditMemberScreen(memberId: id);
                    },
                  ),
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
                  GoRoute(
                    path: 'diet-history',
                    builder: (context, state) {
                      final memberId = state.pathParameters['id']!;
                      return DietHistoryScreen(
                        role: DietHistoryRole.admin,
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
                routes: [
                  GoRoute(
                    path: 'renew',
                    builder: (context, state) => MembershipRenewScreen(
                      membershipId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'freeze',
                    builder: (context, state) => MembershipFreezeScreen(
                      membershipId: state.pathParameters['id']!,
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
            path: Routes.adminPayments,
            builder: (context, state) =>
                const PaymentsLedgerScreen(role: PaymentsLedgerRole.admin),
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
                builder: (context, state) =>
                    const PlaceholderScreen(title: ShellStrings.adminPayments),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    PaymentDetailScreen(paymentId: state.pathParameters['id']!),
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
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const AddTrainerScreen(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  if (id == null) {
                    return const PlaceholderScreen(
                      title: ShellStrings.trainers,
                    );
                  }
                  return EditTrainerProfileScreen(
                    trainerId: id,
                    isAdmin: true,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: Routes.adminEmployees,
            builder: (context, state) => const EmployeesDirectoryScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) =>
                    const EmployeeFormScreen.create(),
              ),
              GoRoute(
                path: ':id/edit',
                builder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  if (id == null) {
                    return const PlaceholderScreen(
                      title: ShellStrings.employees,
                    );
                  }
                  return EmployeeFormScreen.edit(employeeId: id);
                },
              ),
              GoRoute(
                path: ':id/roles',
                builder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '');
                  if (id == null) {
                    return const PlaceholderScreen(
                      title: ShellStrings.employees,
                    );
                  }
                  return EmployeeRolesScreen(employeeId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: Routes.adminAlerts,
            builder: (context, state) => const SystemAlertsScreen(),
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
                path: 'create',
                builder: (context, state) =>
                    const ScheduleFormScreen.create(),
              ),
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
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => ScheduleFormScreen.edit(
                      scheduleId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: Routes.adminDietLibrary,
            builder: (context, state) => const FoodLibraryScreen(),
          ),
          GoRoute(
            path: Routes.adminGoalMetrics,
            builder: (context, state) => const GoalMetricsAdminScreen(),
          ),
          GoRoute(
            path: Routes.adminNotificationsBroadcast,
            builder: (context, state) => const BroadcastScreen(),
          ),
          GoRoute(
            path: Routes.adminReportsHub,
            builder: (context, state) => const ReportsHubScreen(),
            routes: [
              GoRoute(
                path: ':category',
                builder: (context, state) => ReportViewerScreen(
                  category: state.pathParameters['category']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: Routes.adminSettingsHub,
            builder: (context, state) => const SettingsHubScreen(),
            routes: [
              GoRoute(
                path: ':category',
                builder: (context, state) => SettingsCategoryScreen(
                  category: state.pathParameters['category'] ?? '',
                ),
              ),
            ],
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
