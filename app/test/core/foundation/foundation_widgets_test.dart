import 'package:luxeknox/core/validation/validators.dart';
import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/core/pagination/page_request.dart';
import 'package:luxeknox/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppTheme', () {
    test('light and dark use Material 3', () {
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.dark.useMaterial3, isTrue);
      expect(AppTheme.light.colorScheme.brightness, Brightness.light);
      expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
    });
  });

  group('PageRequest', () {
    test('toQueryParameters omits empty cursor', () {
      expect(
        const PageRequest(limit: 10).toQueryParameters(),
        {'limit': 10},
      );
      expect(
        const PageRequest(cursor: 'abc', limit: 5).toQueryParameters(),
        {'cursor': 'abc', 'limit': 5},
      );
    });

    test('copyWith clearCursor resets cursor', () {
      final next = const PageRequest(cursor: 'x').copyWith(clearCursor: true);
      expect(next.cursor, isNull);
    });
  });

  group('Validators', () {
    test('required rejects blank', () {
      expect(Validators.required(null), isNotNull);
      expect(Validators.required('  '), isNotNull);
      expect(Validators.required('ok'), isNull);
    });

    test('emailOrPhone accepts either form', () {
      expect(Validators.emailOrPhone('a@b.com'), isNull);
      expect(Validators.emailOrPhone('+15551234567'), isNull);
      expect(Validators.emailOrPhone('nope'), isNotNull);
    });

    test('password enforces min length', () {
      expect(Validators.password('short'), isNotNull);
      expect(Validators.password('longenough'), isNull);
    });

    test('compose returns first error', () {
      final v = Validators.compose([
        (s) => Validators.required(s),
        (s) => Validators.minLength(s, 3),
      ]);
      expect(v(''), isNotNull);
      expect(v('ab'), contains('3'));
      expect(v('abc'), isNull);
    });
  });

  group('Common state widgets', () {
    testWidgets('AppLoading shows spinner', (tester) async {
      await pumpApp(tester, const AppLoading(message: 'Wait'));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Wait'), findsOneWidget);
    });

    testWidgets('AppErrorView retry fires', (tester) async {
      var taps = 0;
      await pumpApp(
        tester,
        AppErrorView(message: 'Boom', onRetry: () => taps++),
      );
      expect(find.text('Boom'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(taps, 1);
    });

    testWidgets('AppEmptyView renders message', (tester) async {
      await pumpApp(tester, const AppEmptyView(message: 'None'));
      expect(find.text('None'), findsOneWidget);
    });
  });
}
