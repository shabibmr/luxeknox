import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/profile_tab_screen.dart';
import '../../features/exercises/presentation/screens/exercise_detail_screen.dart';
import '../l10n/shell_strings.dart';
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
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.memberHome),
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
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberHomeActiveWorkout,
                ),
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
            builder: (context, state) =>
                const PlaceholderScreen(title: ShellStrings.membership),
            routes: [
              // Member: R (Browse) — Membership Packages Catalog
              GoRoute(
                path: 'packages',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberMembershipPackages,
                ),
              ),
              // Member: R (Self) — Membership History
              GoRoute(
                path: 'history',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberMembershipHistory,
                ),
              ),
              // Member: C (Request) — Freeze & Extension Manager
              GoRoute(
                path: 'freeze-history',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberMembershipFreezeHistory,
                ),
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
                const PlaceholderScreen(title: ShellStrings.schedule),
            routes: [
              // Member: C (Cancel) — Schedule Details Screen
              GoRoute(
                path: ':id',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberScheduleDetail,
                ),
              ),
              // Member: C (Book) — Create / Edit Booking Screen (PT)
              GoRoute(
                path: 'book-pt',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberScheduleBookPt,
                ),
              ),
              // Member: C (Book) — Create / Edit Booking Screen (Class)
              GoRoute(
                path: 'book-class',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberScheduleBookClass,
                ),
              ),
              // Member: R (Self) — Schedule History Screen
              GoRoute(
                path: 'history',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberScheduleHistory,
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
            builder: (context, state) =>
                const ProfileTabScreen(title: ShellStrings.profile),
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
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberProfileHealth,
                ),
              ),
              // Member: E (Self) — Emergency Contacts Screen
              GoRoute(
                path: 'emergency-contacts',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberProfileEmergencyContacts,
                ),
              ),
              // Member: E (Self) — Documents & Photos Gallery (upload only)
              GoRoute(
                path: 'documents',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberProfileDocuments,
                ),
              ),
              // Member: R (Self) — Payments & Invoices Ledger
              GoRoute(
                path: 'payments',
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberProfilePayments,
                ),
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
                builder: (context, state) => const PlaceholderScreen(
                  title: ShellStrings.memberProfileAttendance,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
