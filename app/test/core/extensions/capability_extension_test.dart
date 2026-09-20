import 'package:app/core/extensions/capability_extension.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin',
    profileId: 'p3',
  );
  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member',
    profileId: 'p1',
  );

  Future<void> pumpWith({
    required WidgetTester tester,
    required Principal principal,
    required Capabilities capabilities,
  }) async {
    final cubit = MockSessionCubit();
    whenListen(
      cubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: capabilities,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SessionCubit>.value(
          value: cubit,
          child: Builder(
            builder: (context) {
              final canCreate = context.can('exercises.create');
              return Scaffold(
                body: canCreate
                    ? const Text('add-button')
                    : const Text('no-add'),
              );
            },
          ),
        ),
      ),
    );
  }

  testWidgets('G9: admin with exercises.create sees the button', (
    tester,
  ) async {
    await pumpWith(
      tester: tester,
      principal: adminPrincipal,
      capabilities: const Capabilities(slugs: ['exercises.create']),
    );
    expect(find.text('add-button'), findsOneWidget);
    expect(find.text('no-add'), findsNothing);
  });

  testWidgets('G9: member without exercises.create does not see the button', (
    tester,
  ) async {
    await pumpWith(
      tester: tester,
      principal: memberPrincipal,
      capabilities: const Capabilities(slugs: ['exercises.read']),
    );
    expect(find.text('no-add'), findsOneWidget);
    expect(find.text('add-button'), findsNothing);
  });
}
