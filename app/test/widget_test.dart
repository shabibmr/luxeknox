import 'package:app/core/di/injector.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/main.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  testWidgets(
    'LuxeKnoxApp boots to the splash screen while session is unknown',
    (tester) async {
      final sessionCubit = MockSessionCubit();
      whenListen(
        sessionCubit,
        const Stream<SessionState>.empty(),
        initialState: const SessionUnknown(),
      );
      when(() => sessionCubit.restore()).thenAnswer((_) async {});

      getIt.registerSingleton<SessionCubit>(sessionCubit);
      getIt.registerSingleton<GoRouter>(createRouter(sessionCubit));
      addTearDown(getIt.reset);

      await tester.pumpWidget(const LuxeKnoxApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(() => sessionCubit.restore()).called(1);
    },
  );
}
