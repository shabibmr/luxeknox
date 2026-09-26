import 'package:luxeknox/core/widgets/destination_hub_screen.dart';
import 'package:luxeknox/core/widgets/more_hub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('DestinationHubScreen lists items and navigates', (tester) async {
    final router = GoRouter(
      initialLocation: '/hub',
      routes: [
        GoRoute(
          path: '/hub',
          builder: (_, _) => const DestinationHubScreen(
            title: 'Plans',
            items: [
              DestinationHubItem(title: 'Exercises', path: '/exercises'),
              DestinationHubItem(title: 'Foods', path: '/foods'),
            ],
          ),
        ),
        GoRoute(
          path: '/exercises',
          builder: (_, _) => const Text('Exercises page'),
        ),
        GoRoute(
          path: '/foods',
          builder: (_, _) => const Text('Foods page'),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Plans'), findsOneWidget);
    expect(find.text('Exercises'), findsOneWidget);
    expect(find.text('Foods'), findsOneWidget);

    await tester.tap(find.text('Exercises'));
    await tester.pumpAndSettle();
    expect(find.text('Exercises page'), findsOneWidget);
  });

  testWidgets('MoreHubScreen lists admin destinations', (tester) async {
    final router = GoRouter(
      initialLocation: '/admin/more',
      routes: [
        GoRoute(
          path: '/admin/more',
          builder: (_, _) => MoreHubScreen(onOpenPath: (_) {}),
        ),
        GoRoute(
          path: '/admin/workout-library',
          builder: (_, _) => const Text('Library'),
        ),
        GoRoute(
          path: '/admin/trainers',
          builder: (_, _) => const Text('Trainers'),
        ),
        GoRoute(
          path: '/admin/employees',
          builder: (_, _) => const Text('Employees'),
        ),
        GoRoute(
          path: '/admin/packages',
          builder: (_, _) => const Text('Packages'),
        ),
        GoRoute(
          path: '/admin/attendance',
          builder: (_, _) => const Text('Attendance'),
        ),
        GoRoute(
          path: '/admin/schedules',
          builder: (_, _) => const Text('Schedules'),
        ),
        GoRoute(
          path: '/admin/diet-library',
          builder: (_, _) => const Text('Diet'),
        ),
        GoRoute(
          path: '/admin/goal-metrics',
          builder: (_, _) => const Text('Goals'),
        ),
        GoRoute(
          path: '/admin/notifications/broadcast',
          builder: (_, _) => const Text('Broadcast'),
        ),
        GoRoute(
          path: '/admin/reports/:category',
          builder: (_, _) => const Text('Reports'),
        ),
        GoRoute(
          path: '/admin/settings/:category',
          builder: (_, _) => const Text('Settings'),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Workout Library'), findsOneWidget);
    expect(find.text('Trainers'), findsOneWidget);

    await tester.tap(find.text('Workout Library'));
    await tester.pumpAndSettle();
    expect(find.text('Library'), findsOneWidget);
  });
}
