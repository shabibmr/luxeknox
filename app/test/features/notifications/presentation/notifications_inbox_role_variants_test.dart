import 'package:app/core/di/injector.dart';
import 'package:app/core/presentation/load_status.dart';
import 'package:app/features/notifications/domain/entities/app_notification.dart';
import 'package:app/features/notifications/presentation/cubit/notifications_inbox_cubit.dart';
import 'package:app/features/notifications/presentation/notification_strings.dart';
import 'package:app/features/notifications/presentation/screens/notifications_inbox_screen.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsInboxCubit extends MockCubit<NotificationsInboxState>
    implements NotificationsInboxCubit {}

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

String _detailPath(String id) => '/notifications/$id';

/// Broadcast entry is shown only with `notifications.send` or
/// `notifications.broadcast` (ADR-0006 §11).
void main() {
  final item = AppNotification(
    id: 'n1',
    title: 'Hello',
    message: 'Body',
    createdAt: DateTime.utc(2026, 1, 1),
  );

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'p1',
  );
  const trainerPrincipal = Principal(
    userId: '2',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 'p2',
  );
  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p3',
  );

  const readOnly = Capabilities(slugs: ['notifications.read']);
  const canBroadcast = Capabilities(
    slugs: ['notifications.read', 'notifications.send', 'notifications.broadcast'],
  );

  late MockNotificationsInboxCubit inbox;

  setUp(() {
    inbox = MockNotificationsInboxCubit();
    whenListen(
      inbox,
      const Stream<NotificationsInboxState>.empty(),
      initialState: NotificationsInboxState(
        status: LoadStatus.success,
        items: [item],
      ),
    );
    when(() => inbox.load()).thenAnswer((_) async {});
    when(() => inbox.close()).thenAnswer((_) async {});
    getIt.registerFactory<NotificationsInboxCubit>(() => inbox);
  });

  tearDown(() => getIt.reset());

  Widget wrap(Principal principal, Capabilities capabilities) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: capabilities,
      ),
    );
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: const NotificationsInboxScreen(
          detailPathBuilder: _detailPath,
          showBroadcastAction: true,
          broadcastPath: '/broadcast',
        ),
      ),
    );
  }

  testWidgets('member does not see the broadcast control', (tester) async {
    await tester.pumpWidget(wrap(memberPrincipal, readOnly));
    await tester.pumpAndSettle();

    expect(find.byTooltip(NotificationStrings.broadcastTitle), findsNothing);
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('trainer does not see the broadcast control', (tester) async {
    await tester.pumpWidget(wrap(trainerPrincipal, readOnly));
    await tester.pumpAndSettle();

    expect(find.byTooltip(NotificationStrings.broadcastTitle), findsNothing);
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('admin with send or broadcast sees the broadcast control', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(adminPrincipal, canBroadcast));
    await tester.pumpAndSettle();

    expect(find.byTooltip(NotificationStrings.broadcastTitle), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);
  });
}
