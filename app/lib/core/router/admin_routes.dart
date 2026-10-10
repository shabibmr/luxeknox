import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/alerts/presentation/screens/system_alerts_screen.dart';
import '../../features/attendance/presentation/screens/admin_attendance_screen.dart';
import '../../features/auth/presentation/widgets/sign_out_tile.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/exercises/presentation/screens/exercise_library_screen.dart';
import '../../features/foods/presentation/screens/food_library_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/injector.dart';
import '../../features/goals/presentation/cubit/admin_measurements_audit_cubit.dart';
import '../../features/goals/presentation/cubit/admin_member_goals_cubit.dart';
import '../../features/goals/presentation/cubit/admin_progress_aggregate_cubit.dart';
import '../../features/goals/presentation/cubit/admin_progress_photos_vault_cubit.dart';
import '../../features/goals/presentation/cubit/measurements_cubit.dart';
import '../../features/goals/presentation/cubit/progress_overview_cubit.dart';
import '../../features/goals/presentation/cubit/progress_timeline_cubit.dart';
import '../../features/goals/presentation/goals_strings.dart';
import '../../features/goals/presentation/screens/admin_measurements_audit_screen.dart';
import '../../features/goals/presentation/screens/admin_member_goals_screen.dart';
import '../../features/goals/presentation/screens/admin_progress_aggregate_screen.dart';
import '../../features/goals/presentation/screens/admin_progress_photos_vault_screen.dart';
import '../../features/goals/presentation/screens/goal_metrics_admin_screen.dart';
import '../../features/goals/presentation/screens/goal_detail_screen.dart';
import '../../features/goals/presentation/screens/goal_form_screen.dart';
import '../../features/goals/presentation/screens/measurements_history_screen.dart';
import '../../features/goals/presentation/screens/measurements_screen.dart';
import '../../features/goals/presentation/screens/progress_hub_screen.dart';
import '../../features/goals/presentation/screens/progress_notes_screen.dart';
import '../../features/goals/presentation/screens/progress_overview_screen.dart';
import '../../features/goals/presentation/screens/progress_photos_screen.dart';
import '../../features/goals/presentation/screens/progress_timeline_screen.dart';
import '../../session/presentation/session_cubit.dart';
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
import '../../features/pt/presentation/screens/pt_packages_screen.dart';
import '../../features/pt/presentation/screens/sell_pt_screen.dart';
import '../../features/scheduling/presentation/screens/facilities_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_calendar_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_detail_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_form_screen.dart';
import '../../features/settings/presentation/screens/settings_category_screen.dart';
import '../../features/settings/presentation/screens/settings_hub_screen.dart';
import '../../features/diet/presentation/diet_history_role.dart';
import '../../features/diet/presentation/screens/diet_history_screen.dart';
import '../../features/diet/presentation/screens/diet_plan_builder_screen.dart';
import '../../features/diet/presentation/screens/diet_plan_detail_screen.dart';
import '../../features/diet/presentation/screens/diet_plan_list_screen.dart';
import '../../features/diet/presentation/screens/diet_plan_versions_screen.dart';
import '../../features/workout/presentation/screens/workout_history_screen.dart';
import '../../features/workout/presentation/screens/workout_plan_builder_screen.dart';
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
                    path: 'add-pt',
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');
                      if (id == null) {
                        return const PlaceholderScreen(
                          title: ShellStrings.adminMembers,
                        );
                      }
                      final memberName = state.extra as String?;
                      return SellPtScreen(memberId: id, memberName: memberName);
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
                  GoRoute(
                    path: 'goals',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      final args = state.extra as ProgressHubArgs?;
                      return ProgressHubScreen(
                        memberId: id,
                        canCreateGoals: args?.canCreateGoals ?? true,
                        isAssignedTrainer: args?.isAssignedTrainer,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'overview',
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? '';
                          return BlocProvider(
                            create: (_) =>
                                getIt<ProgressOverviewCubit>()
                                  ..load(id, includeCircumference: true),
                            child: ProgressOverviewScreen(
                              memberId: id,
                              isTrainerContext: true,
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'photos',
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? '';
                          final assigned = state.extra as bool? ?? false;
                          return ProgressPhotosScreen(
                            memberId: id,
                            isAssignedTrainer: assigned,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'notes',
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? '';
                          return ProgressNotesScreen(memberId: id);
                        },
                      ),
                      GoRoute(
                        path: 'timeline',
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? '';
                          return BlocProvider(
                            create: (_) =>
                                getIt<ProgressTimelineCubit>()..load(id),
                            child: ProgressTimelineScreen(memberId: id),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'measurements',
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? '';
                          return BlocProvider(
                            create: (_) => getIt<MeasurementsCubit>()..load(id),
                            child: MeasurementsScreen(memberId: id),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'history',
                            builder: (context, state) {
                              final id = state.pathParameters['id'] ?? '';
                              return BlocProvider(
                                create: (_) =>
                                    getIt<MeasurementsCubit>()..load(id),
                                child: MeasurementsHistoryScreen(memberId: id),
                              );
                            },
                          ),
                        ],
                      ),
                      GoRoute(
                        path: 'measurements/new',
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? '';
                          final metric = state.uri.queryParameters['metric'];
                          return MeasurementsScreen(
                            memberId: id,
                            focusMetricId: metric,
                            returnToCaller: metric != null,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'new',
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? '';
                          return GoalFormScreen(memberId: id);
                        },
                      ),
                      GoRoute(
                        path: 'goal/:goalId',
                        builder: (context, state) {
                          return GoalDetailScreen(
                            goalId: state.pathParameters['goalId']!,
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (context, state) {
                              final id = state.pathParameters['id'] ?? '';
                              final goalId = state.pathParameters['goalId']!;
                              return GoalFormScreen(
                                memberId: id,
                                goalId: goalId,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
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
            path: Routes.adminWorkoutPlansCreate,
            builder: (context, state) {
              final memberId = state.uri.queryParameters['memberId'];
              return WorkoutPlanBuilderScreen(
                isTemplate: false,
                memberId: memberId,
                afterSavePath: memberId == null
                    ? Routes.adminMembers
                    : Routes.adminMembersWorkoutHistoryById(memberId),
              );
            },
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
                  return EditTrainerProfileScreen(trainerId: id, isAdmin: true);
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
                builder: (context, state) => const EmployeeFormScreen.create(),
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
            path: Routes.adminPtPackages,
            builder: (context, state) => const PtPackagesScreen(),
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
                builder: (context, state) => const ScheduleFormScreen.create(),
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
            path: Routes.adminDietPlans,
            builder: (context, state) => DietPlanListScreen(
              createPath: Routes.adminDietPlansCreate,
              detailPathBuilder: (id) => Routes.adminDietPlansDetailById(id),
            ),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) {
                  final memberId = state.uri.queryParameters['memberId'];
                  final isTemplateParam =
                      state.uri.queryParameters['isTemplate'];
                  return DietPlanBuilderScreen(
                    isTemplate: isTemplateParam != null
                        ? isTemplateParam == 'true'
                        : null,
                    memberId: memberId,
                    detailPathBuilder: (id) =>
                        Routes.adminDietPlansDetailById(id),
                  );
                },
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => DietPlanDetailScreen(
                  planId: state.pathParameters['id']!,
                  editPathBuilder: (id) => Routes.adminDietPlansEditById(id),
                  versionsPathBuilder: (id) =>
                      Routes.adminDietPlansVersionsById(id),
                  detailPathBuilder: (id) =>
                      Routes.adminDietPlansDetailById(id),
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => DietPlanBuilderScreen(
                      planId: state.pathParameters['id'],
                      detailPathBuilder: (id) =>
                          Routes.adminDietPlansDetailById(id),
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
          GoRoute(
            path: Routes.adminGoalMetrics,
            builder: (context, state) => const GoalMetricsAdminScreen(),
          ),
          GoRoute(
            path: Routes.adminMemberGoals,
            builder: (context, state) => BlocProvider(
              create: (_) =>
                  getIt<AdminMemberGoalsCubit>()..load(status: 'in_progress'),
              child: const AdminMemberGoalsScreen(),
            ),
          ),
          GoRoute(
            path: Routes.adminProgress,
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<AdminProgressAggregateCubit>()..load(),
              child: const AdminProgressAggregateScreen(),
            ),
          ),
          GoRoute(
            path: Routes.adminMeasurements,
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<AdminMeasurementsAuditCubit>()..load(),
              child: const AdminMeasurementsAuditScreen(),
            ),
            routes: [
              GoRoute(
                path: 'history',
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<AdminMeasurementsAuditCubit>()..load(),
                  child: const AdminMeasurementsAuditScreen(
                    title: GoalsStrings.adminMeasurementsHistoryTitle,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: Routes.adminProgressPhotos,
            builder: (context, state) {
              final session = getIt<SessionCubit>().state;
              final canModerate =
                  session is SessionAuthenticated &&
                  session.capabilities.can('progress_photos.moderate');
              return BlocProvider(
                create: (_) =>
                    getIt<AdminProgressPhotosVaultCubit>()
                      ..load(canModerate: canModerate),
                child: const AdminProgressPhotosVaultScreen(),
              );
            },
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
    // Always reset the destination branch to its root route: switching
    // verticals (or re-tapping the active one) should never resume a
    // stale, deep navigation state from a previous visit.
    if (index == _adminMoreBranchIndex) {
      setState(() => _showMoreHub = true);
      widget.navigationShell.goBranch(index, initialLocation: true);
      return;
    }
    setState(() => _showMoreHub = false);
    widget.navigationShell.goBranch(index, initialLocation: true);
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
