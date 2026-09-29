import 'package:flutter/material.dart';

import '../l10n/shell_strings.dart';
import '../router/routes.dart';
import 'destination_hub_screen.dart';

/// Admin More-tab chrome: lists every nav-§4 More destination.
/// Tiles navigate with [GoRouter.go] to the documented paths.
///
/// [footer] is optional so callers in the router layer can inject
/// feature widgets (e.g. sign-out) without core importing features.
class MoreHubScreen extends StatelessWidget {
  const MoreHubScreen({super.key, required this.onOpenPath, this.footer});

  /// Called when a hub tile is tapped, after navigation.
  final ValueChanged<String> onOpenPath;

  /// Optional trailing content below the destination list.
  final Widget? footer;

  static const _items = [
    DestinationHubItem(
      title: ShellStrings.trainers,
      path: Routes.adminTrainers,
    ),
    DestinationHubItem(
      title: ShellStrings.employees,
      path: Routes.adminEmployees,
    ),
    DestinationHubItem(
      title: ShellStrings.packages,
      path: Routes.adminPackages,
    ),
    DestinationHubItem(
      title: ShellStrings.ptPackages,
      path: Routes.adminPtPackages,
    ),
    DestinationHubItem(
      title: ShellStrings.paymentMethods,
      path: Routes.adminPaymentsMethods,
    ),
    DestinationHubItem(
      title: ShellStrings.attendance,
      path: Routes.adminAttendance,
    ),
    DestinationHubItem(
      title: ShellStrings.schedules,
      path: Routes.adminSchedules,
    ),
    DestinationHubItem(
      title: ShellStrings.workoutLibrary,
      path: Routes.adminWorkoutLibrary,
    ),
    DestinationHubItem(
      title: ShellStrings.dietLibrary,
      path: Routes.adminDietLibrary,
    ),
    DestinationHubItem(
      title: ShellStrings.goalMetrics,
      path: Routes.adminGoalMetrics,
    ),
    DestinationHubItem(
      title: ShellStrings.notificationsBroadcast,
      path: Routes.adminNotificationsBroadcast,
    ),
    DestinationHubItem(
      title: ShellStrings.reports,
      path: Routes.adminReportsHub,
    ),
    DestinationHubItem(
      title: ShellStrings.settings,
      path: Routes.adminSettingsHub,
    ),
    DestinationHubItem(
      title: ShellStrings.systemAlerts,
      path: Routes.adminAlerts,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DestinationHubScreen(
      title: ShellStrings.moreHubTitle,
      items: _items,
      footer: footer,
      onSelected: onOpenPath,
    );
  }
}
