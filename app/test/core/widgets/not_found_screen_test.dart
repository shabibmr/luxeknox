import 'package:luxeknox/core/l10n/shell_strings.dart';
import 'package:luxeknox/core/widgets/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NotFoundScreen shows message and location', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NotFoundScreen(uri: Uri(path: '/nope/missing')),
      ),
    );

    expect(find.text(ShellStrings.notFoundTitle), findsOneWidget);
    expect(find.text(ShellStrings.notFoundMessage), findsOneWidget);
    expect(find.text('/nope/missing'), findsOneWidget);
    expect(find.text(ShellStrings.notFoundGoHome), findsOneWidget);
  });
}
