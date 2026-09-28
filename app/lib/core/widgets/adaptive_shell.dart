import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdaptiveNavigationDestination {
  const AdaptiveNavigationDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final Widget icon;
  final Widget? selectedIcon;
  final String label;
}

/// Breakpoints for [AdaptiveShell] chrome (dp / logical pixels).
abstract final class AdaptiveShellBreakpoints {
  /// Below this width: [NavigationBar] (phone).
  static const double compact = 600;

  /// At/above this width: extended [NavigationRail] (desktop).
  /// Between [compact] and this: compact [NavigationRail] (tablet).
  static const double expanded = 1240;
}

/// Adaptive shell:
/// - Bottom navigation bar under [AdaptiveShellBreakpoints.compact]
/// - NavigationRail (compact) from compact to just under expanded
/// - Extended NavigationRail at [AdaptiveShellBreakpoints.expanded] and above
class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({
    super.key,
    required this.navigationShell,
    required this.destinations,
    this.onDestinationSelected,
    this.body,
  });

  final StatefulNavigationShell navigationShell;
  final List<AdaptiveNavigationDestination> destinations;

  /// Optional override for tab selection (e.g. Admin More hub).
  final ValueChanged<int>? onDestinationSelected;

  /// Optional body override (e.g. More hub chrome). Defaults to [navigationShell].
  final Widget? body;

  void _onDestinationSelected(int index) {
    if (onDestinationSelected != null) {
      onDestinationSelected!(index);
      return;
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = body ?? navigationShell;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < AdaptiveShellBreakpoints.compact) {
          return Scaffold(
            body: content,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: destinations
                  .map(
                    (d) => NavigationDestination(
                      icon: d.icon,
                      selectedIcon: d.selectedIcon,
                      label: d.label,
                    ),
                  )
                  .toList(),
            ),
          );
        }

        final isExtended = width >= AdaptiveShellBreakpoints.expanded;

        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _onDestinationSelected,
                extended: isExtended,
                destinations: destinations
                    .map(
                      (d) => NavigationRailDestination(
                        icon: d.icon,
                        selectedIcon: d.selectedIcon ?? d.icon,
                        label: Text(d.label),
                      ),
                    )
                    .toList(),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }
}
