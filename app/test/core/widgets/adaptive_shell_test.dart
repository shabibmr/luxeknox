import 'package:app/core/widgets/adaptive_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  late GoRouter router;

  Future<void> setSurfaceSize(WidgetTester tester, double width) async {
    final view = tester.view;
    view.physicalSize = Size(width, 900);
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  Widget pumpShell({required double width}) {
    router = GoRouter(
      initialLocation: '/a',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AdaptiveShell(
              navigationShell: navigationShell,
              destinations: const [
                AdaptiveNavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'One',
                ),
                AdaptiveNavigationDestination(
                  icon: Icon(Icons.star_outline),
                  selectedIcon: Icon(Icons.star),
                  label: 'Two',
                ),
                AdaptiveNavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Three',
                ),
              ],
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/a',
                  builder: (_, _) => const Text('A'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/b',
                  builder: (_, _) => const Text('B'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/c',
                  builder: (_, _) => const Text('C'),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) => Center(
        child: SizedBox(width: width, height: 800, child: child),
      ),
    );
  }

  testWidgets('uses NavigationBar below compact breakpoint', (tester) async {
    final width = AdaptiveShellBreakpoints.compact - 1;
    await setSurfaceSize(tester, width);
    await tester.pumpWidget(pumpShell(width: width));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Three'), findsOneWidget);
  });

  testWidgets('uses compact NavigationRail between compact and expanded', (
    tester,
  ) async {
    final width = AdaptiveShellBreakpoints.compact;
    await setSurfaceSize(tester, width);
    await tester.pumpWidget(pumpShell(width: width));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsNothing);
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isFalse);
  });

  testWidgets('uses extended NavigationRail at expanded breakpoint', (
    tester,
  ) async {
    final width = AdaptiveShellBreakpoints.expanded;
    await setSurfaceSize(tester, width);
    await tester.pumpWidget(pumpShell(width: width));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsNothing);
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isTrue);
  });

  testWidgets('tapping a destination switches branch content', (tester) async {
    final width = AdaptiveShellBreakpoints.compact - 1;
    await setSurfaceSize(tester, width);
    await tester.pumpWidget(pumpShell(width: width));
    await tester.pumpAndSettle();

    expect(find.text('A'), findsOneWidget);
    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();
    expect(find.text('B'), findsOneWidget);
  });
}
