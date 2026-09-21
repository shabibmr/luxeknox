import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/shell_strings.dart';
import '../router/routes.dart';

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

  List<({String title, String path})> get _items => [
    (title: ShellStrings.trainers, path: Routes.adminTrainers),
    (title: ShellStrings.employees, path: Routes.adminEmployees),
    (title: ShellStrings.packages, path: Routes.adminPackages),
    (title: ShellStrings.paymentMethods, path: Routes.adminPaymentsMethods),
    (title: ShellStrings.attendance, path: Routes.adminAttendance),
    (title: ShellStrings.schedules, path: Routes.adminSchedules),
    (title: ShellStrings.workoutLibrary, path: Routes.adminWorkoutLibrary),
    (title: ShellStrings.dietLibrary, path: Routes.adminDietLibrary),
    (title: ShellStrings.goalMetrics, path: Routes.adminGoalMetrics),
    (
      title: ShellStrings.notificationsBroadcast,
      path: Routes.adminNotificationsBroadcast,
    ),
    (title: ShellStrings.reports, path: Routes.adminReportsCategory('revenue')),
    (
      title: ShellStrings.settings,
      // Nav §4: Gym, hardware, biometric, policy — default category is gym.
      path: Routes.adminSettingsCategory('gym'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = _items;
    final footer = this.footer;
    return Scaffold(
      appBar: AppBar(title: const Text(ShellStrings.moreHubTitle)),
      body: ListView.separated(
        itemCount: items.length + (footer != null ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (footer != null && index == items.length) {
            return footer;
          }
          final item = items[index];
          return ListTile(
            title: Text(item.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.go(item.path);
              onOpenPath(item.path);
            },
          );
        },
      ),
    );
  }
}
