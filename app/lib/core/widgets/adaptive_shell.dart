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

/// Adaptive shell:
/// - Bottom navigation bar under 600dp
/// - NavigationRail (compact) 600dp to 1239dp
/// - Extended NavigationRail at 1240dp and above
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

        if (width < 600) {
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

        final isExtended = width >= 1240;

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
