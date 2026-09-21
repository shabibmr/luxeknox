import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/presentation/screens/attendance_pass_screen.dart';
import '../../features/attendance/presentation/screens/attendance_summary_screen.dart';
import '../../features/auth/presentation/screens/profile_tab_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/exercises/presentation/screens/exercise_detail_screen.dart';
import '../../features/membership/presentation/screens/membership_card_screen.dart';
import '../../features/membership/presentation/screens/membership_freeze_history_screen.dart';
import '../../features/membership/presentation/screens/membership_history_screen.dart';
import '../../features/membership/presentation/screens/membership_packages_catalog_screen.dart';
import '../../features/payments/presentation/payment_ledger_role.dart';
import '../../features/payments/presentation/screens/payment_detail_screen.dart';
import '../../features/payments/presentation/screens/payments_ledger_screen.dart';
import '../../features/people/presentation/screens/documents_screen.dart';
import '../../features/people/presentation/screens/emergency_contacts_screen.dart';
import '../../features/people/presentation/screens/health_info_screen.dart';
import '../../features/scheduling/presentation/screens/book_schedule_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_calendar_screen.dart';
import '../../features/scheduling/presentation/screens/schedule_detail_screen.dart';
import '../../features/workout/presentation/screens/active_workout_screen.dart';
import '../../features/workout/presentation/screens/workout_history_screen.dart';
import '../../features/workout/presentation/workout_history_role.dart';
import '../l10n/shell_strings.dart';
import '../widgets/adaptive_shell.dart';
import '../widgets/placeholder_screen.dart';
import 'routes.dart';
import 'session_route_ids.dart';

StatefulShellRoute createMemberBranchRoute() {
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
            icon: Icon(Icons.card_membership_outlined),
            selectedIcon: Icon(Icons.card_membership),
            label: ShellStrings.membership,
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: ShellStrings.schedule,
          ),
          AdaptiveNavigationDestination(
            icon: Icon(Icons.trending_up_outlined),
            selectedIcon: Icon(Icons.trending_up),
            label: ShellStrings.progress,
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
      // Member: R — Adaptive Dashboard
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.memberHome,
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'workout/exercises/:id',
                builder: (context, state) => ExerciseDetailScreen(
                  exerciseId: state.pathParameters['id']!,
                ),
              ),
              // Member: E (Self) — Live Workout Session Tracker
              GoRoute(
                path: 'workout/active',
                builder: (context, state) => ActiveWorkoutScreen(
                  workoutPlanId:
                      state.uri.queryParameters['workoutPlanId'],
                ),
              ),
              // Member: R (Self) — Workout Session History
              GoRoute(
                path: 'workout/history',
                builder: (context, state) {
                  final profileId = sessionProfileId(context);
                  return WorkoutHistoryScreen(
                    role: WorkoutHistoryRole.member,
                    memberId: profileId?.toString(),
                  );
                },
              ),
              // Member: R — Meal Details
              GoRoute(
                path: 'diet/meal/:id',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberHomeMealDetail,
                ),
              ),
            ],
          ),
          // Member: R (Self) — Notifications Inbox & Details
          GoRoute(
            path: Routes.memberNotifications,
            builder: (context, state) => const PlaceholderScreen(
              title: ShellStrings.memberNotifications,
            ),
          ),
        ],
      ),
      // Member: R (Self) — Membership Details & Status
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.memberMembership,
            builder: (context, state) => const MembershipCardScreen(),
            routes: [
              // Member: R (Browse) — Membership Packages Catalog
              GoRoute(
                path: 'packages',
                builder: (context, state) =>
                    const MembershipPackagesCatalogScreen(readOnly: true),
              ),
              // Member: R (Self) — Membership History
              GoRoute(
                path: 'history',
                builder: (context, state) => const MembershipHistoryScreen(),
              ),
              // Member: R (Self) — Freeze request history
              GoRoute(
                path: 'freeze-history',
                builder: (context, state) =>
                    const MembershipFreezeHistoryScreen(),
              ),
            ],
          ),
        ],
      ),
      // Member: R (Self) — Schedule Calendar
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.memberSchedule,
            builder: (context, state) =>
                const ScheduleCalendarScreen(role: ScheduleCalendarRole.member),
            routes: [
              GoRoute(
                path: 'book-pt',
                builder: (context, state) =>
                    const BookScheduleScreen(isPt: true),
              ),
              GoRoute(
                path: 'book-class',
                builder: (context, state) =>
                    const BookScheduleScreen(isPt: false),
              ),
              GoRoute(
                path: 'history',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberScheduleHistory,
                ),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => ScheduleDetailScreen(
                  scheduleId: state.pathParameters['id']!,
                  role: ScheduleCalendarRole.member,
                ),
              ),
            ],
          ),
        ],
      ),
      // Member: R (Self) — Goals Hub & Details
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.memberProgress,
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.progress),
            routes: [
              // Member: R (Self) — Goal Details (Trainer/Admin edit, not Member)
              GoRoute(
                path: 'goal/:id',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberProgressGoalDetail,
                ),
              ),
              // Member: E (Self) — Measurements & History
              GoRoute(
                path: 'measurements',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberProgressMeasurements,
                ),
              ),
              // Member: E (Upload) — Progress Photos Gallery
              GoRoute(
                path: 'photos',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberProgressPhotos,
                ),
              ),
              // Member: E (Self) — Progress Notes Screen
              GoRoute(
                path: 'notes',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberProgressNotes,
                ),
              ),
            ],
          ),
        ],
      ),
      // Member: R (Self) — Profile Screen
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.memberProfile,
            builder: (context, state) => const ProfileTabScreen(
              title: ShellStrings.profile,
              links: [
                ProfileTabLink(
                  title: ShellStrings.editProfile,
                  path: Routes.memberProfileEdit,
                  icon: Icons.edit_outlined,
                ),
                ProfileTabLink(
                  title: ShellStrings.memberProfileHealth,
                  path: Routes.memberProfileHealth,
                  icon: Icons.favorite_outline,
                ),
                ProfileTabLink(
                  title: ShellStrings.memberProfileEmergencyContacts,
                  path: Routes.memberProfileEmergencyContacts,
                  icon: Icons.contact_emergency_outlined,
                ),
                ProfileTabLink(
                  title: ShellStrings.memberProfileDocuments,
                  path: Routes.memberProfileDocuments,
                  icon: Icons.folder_outlined,
                ),
                ProfileTabLink(
                  title: ShellStrings.memberProfilePayments,
                  path: Routes.memberProfilePayments,
                  icon: Icons.receipt_long_outlined,
                ),
                ProfileTabLink(
                  title: ShellStrings.memberProfileTrainer,
                  path: Routes.memberProfileTrainer,
                  icon: Icons.sports_gymnastics_outlined,
                ),
                ProfileTabLink(
                  title: ShellStrings.memberProfileAttendance,
                  path: Routes.memberProfileAttendance,
                  icon: Icons.qr_code_outlined,
                ),
              ],
            ),
            routes: [
              // Member: E (Self) — Edit Profile Screen
              GoRoute(
                path: 'edit',
                builder: (context, state) =>
                    const PlaceholderScreen(title: ShellStrings.editProfile),
              ),
              // Member: E (Self) — Health Information Screen
              GoRoute(
                path: 'health',
                builder: (context, state) {
                  final id = sessionProfileId(context);
                  if (id == null) {
                    return const PlaceholderScreen(
                      title: ShellStrings.memberProfileHealth,
                    );
                  }
                  return HealthInfoScreen(memberId: id);
                },
              ),
              // Member: E (Self) — Emergency Contacts Screen
              GoRoute(
                path: 'emergency-contacts',
                builder: (context, state) {
                  final id = sessionUserId(context);
                  if (id == null) {
                    return const PlaceholderScreen(
                      title: ShellStrings.memberProfileEmergencyContacts,
                    );
                  }
                  return EmergencyContactsScreen(userId: id);
                },
              ),
              // Member: E (Self) — Documents & Photos Gallery (upload only)
              GoRoute(
                path: 'documents',
                builder: (context, state) {
                  final id = sessionProfileId(context);
                  if (id == null) {
                    return const PlaceholderScreen(
                      title: ShellStrings.memberProfileDocuments,
                    );
                  }
                  return DocumentsScreen(memberId: id);
                },
              ),
              // Member: R (Self) — Payments & Invoices Ledger
              GoRoute(
                path: 'payments',
                builder: (context, state) {
                  final id = sessionProfileId(context);
                  return PaymentsLedgerScreen(
                    role: PaymentsLedgerRole.member,
                    memberId: id?.toString(),
                  );
                },
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => PaymentDetailScreen(
                      paymentId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
              // Member: R — My Trainer
              GoRoute(
                path: 'trainer',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberProfileTrainer,
                ),
              ),
              // Member: C (Pass) — Attendance Pass & Check-In / History
              GoRoute(
                path: 'attendance',
                builder: (context, state) => const AttendancePassScreen(),
                routes: [
                  GoRoute(
                    path: 'history',
                    builder: (context, state) =>
                        const AttendanceHistoryScreen(),
                  ),
                  GoRoute(
                    path: 'summary',
                    builder: (context, state) =>
                        const AttendanceSummaryScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
