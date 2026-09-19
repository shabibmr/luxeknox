import 'package:app/features/auth/presentation/screens/splash_screen.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  testWidgets(
    'SplashScreen calls restore() on start and shows a loading indicator (H1)',
    (tester) async {
      final sessionCubit = MockSessionCubit();
      whenListen(
        sessionCubit,
        const Stream<SessionState>.empty(),
        initialState: const SessionUnknown(),
      );
      when(() => sessionCubit.restore()).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SessionCubit>.value(
            value: sessionCubit,
            child: const SplashScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(() => sessionCubit.restore()).called(1);
    },
  );
}
