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
  });

  final StatefulNavigationShell navigationShell;
  final List<AdaptiveNavigationDestination> destinations;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 600) {
          // Bottom Navigation Bar
          return Scaffold(
            body: navigationShell,
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
              Expanded(child: navigationShell),
            ],
          ),
        );
      },
    );
  }
}
