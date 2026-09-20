import 'package:app/features/auth/presentation/widgets/sign_out_tile.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockSessionCubit sessionCubit;

  setUp(() {
    sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionAuthenticated(
        principal: Principal(
          userId: '1',
          userType: UserType.member,
          displayName: 'Member One',
          profileId: 'p1',
        ),
        capabilities: Capabilities(slugs: []),
      ),
    );
    when(() => sessionCubit.logout()).thenAnswer((_) async {});
  });

  Future<void> pumpTile(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SessionCubit>.value(
          value: sessionCubit,
          child: const Scaffold(body: SignOutTile()),
        ),
      ),
    );
  }

  group('SignOutTile (H5)', () {
    testWidgets('shows a confirm dialog and does not sign out on cancel', (
      tester,
    ) async {
      await pumpTile(tester);

      await tester.tap(find.text('Sign out').first);
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to sign out?'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => sessionCubit.logout());
    });

    testWidgets('confirming clears the session', (tester) async {
      await pumpTile(tester);

      await tester.tap(find.text('Sign out').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign out').last);
      await tester.pumpAndSettle();

      verify(() => sessionCubit.logout()).called(1);
    });
  });
}
