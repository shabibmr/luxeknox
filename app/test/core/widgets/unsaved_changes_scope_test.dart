import 'package:app/core/l10n/shell_strings.dart';
import 'package:app/core/widgets/unsaved_changes_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnsavedChangesScope', () {
    testWidgets('allows pop when clean', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const UnsavedChangesScope(
                      hasUnsavedChanges: false,
                      child: Scaffold(body: Text('form')),
                    ),
                  ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('form'), findsOneWidget);

      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      navigator.pop();
      await tester.pumpAndSettle();
      expect(find.text('form'), findsNothing);
      expect(find.text(ShellStrings.unsavedTitle), findsNothing);
    });

    testWidgets('blocks pop and shows confirm when dirty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const UnsavedChangesScope(
                      hasUnsavedChanges: true,
                      child: Scaffold(body: Text('dirty-form')),
                    ),
                  ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      navigator.maybePop();
      await tester.pumpAndSettle();

      expect(find.text(ShellStrings.unsavedTitle), findsOneWidget);
      expect(find.text('dirty-form'), findsOneWidget);

      await tester.tap(find.text(ShellStrings.unsavedStay));
      await tester.pumpAndSettle();
      expect(find.text('dirty-form'), findsOneWidget);

      navigator.maybePop();
      await tester.pumpAndSettle();
      await tester.tap(find.text(ShellStrings.unsavedLeave));
      await tester.pumpAndSettle();
      expect(find.text('dirty-form'), findsNothing);
    });
  });
}
