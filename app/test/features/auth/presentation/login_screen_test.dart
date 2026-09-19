import 'dart:async';

import 'package:app/core/di/injector.dart';
import 'package:app/core/error/failures.dart';
import 'package:app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:app/features/auth/presentation/screens/login_screen.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionCubit extends Mock implements SessionCubit {}

void main() {
  late MockSessionCubit mockSessionCubit;

  const tPrincipal = Principal(
    userId: 'user-1',
    userType: 'member',
    displayName: 'Member One',
    profileId: 'prof-1',
  );
  const tCapabilities = Capabilities(slugs: ['exercises.read']);

  setUp(() {
    mockSessionCubit = MockSessionCubit();
    getIt.registerFactory<LoginCubit>(() => LoginCubit(mockSessionCubit));
  });

  tearDown(() => getIt.reset());

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
  }

  group('LoginScreen (H3 & H4)', () {
    testWidgets('empty fields are rejected client-side', (tester) async {
      await pumpLoginScreen(tester);

      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pump();

      expect(find.text('Enter your email or phone.'), findsOneWidget);
      expect(find.text('Enter your password.'), findsOneWidget);
      verifyNever(() => mockSessionCubit.login(any(), any()));
    });

    testWidgets('submit is disabled while the login call is in flight', (
      tester,
    ) async {
      final completer = Completer<Either<Failure, (Principal, Capabilities)>>();
      when(
        () => mockSessionCubit.login(any(), any()),
      ).thenAnswer((_) => completer.future);

      await pumpLoginScreen(tester);
      await tester.enterText(
        find.byType(TextFormField).first,
        'user@luxeknox.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(const Right((tPrincipal, tCapabilities)));
      await tester.pumpAndSettle();
    });

    testWidgets('wrong password and unknown user show the identical message', (
      tester,
    ) async {
      when(
        () => mockSessionCubit.login(any(), any()),
      ).thenAnswer((_) async => const Left(AuthFailure()));

      await pumpLoginScreen(tester);
      await tester.enterText(
        find.byType(TextFormField).first,
        'wrong@luxeknox.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'badpass');
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Incorrect email/phone or password.'), findsOneWidget);
    });

    testWidgets('password visibility can be toggled', (tester) async {
      await pumpLoginScreen(tester);

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });
}
