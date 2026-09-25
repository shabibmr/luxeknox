import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/notifications/domain/entities/app_notification.dart';
import 'package:app/features/notifications/domain/entities/broadcast_audience.dart';
import 'package:app/features/notifications/domain/entities/broadcast_request_input.dart';
import 'package:app/features/notifications/domain/usecases/notification_usecases.dart';
import 'package:app/features/notifications/presentation/cubit/broadcast_cubit.dart';
import 'package:app/features/notifications/presentation/notification_strings.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockBroadcast extends Mock implements BroadcastNotificationUseCase {}

class _MockListBroadcasts extends Mock implements ListBroadcastsUseCase {}

void main() {
  late _MockBroadcast broadcast;
  late _MockListBroadcasts listBroadcasts;

  setUpAll(() {
    registerFallbackValue(
      const BroadcastRequestInput(title: 't', message: 'm'),
    );
    registerFallbackValue(const ListBroadcastsParams());
  });

  setUp(() {
    broadcast = _MockBroadcast();
    listBroadcasts = _MockListBroadcasts();
  });

  BroadcastCubit buildCubit() => BroadcastCubit(broadcast, listBroadcasts);

  test('validate requires title and message', () {
    final cubit = buildCubit();
    final form = cubit.state;
    expect(cubit.validate(form), NotificationStrings.titleRequired);
    expect(
      cubit.validate(form.copyWith(title: 'Hi')),
      NotificationStrings.messageRequired,
    );
    expect(
      cubit.validate(
        form.copyWith(
          title: 'Hi',
          message: 'Body',
          audience: BroadcastAudience.role,
        ),
      ),
      NotificationStrings.roleIdRequired,
    );
    expect(
      cubit.validate(form.copyWith(title: 'Hi', message: 'Body')),
      isNull,
    );
  });

  blocTest<BroadcastCubit, BroadcastState>(
    'trainer configure locks assigned_clients audience',
    build: buildCubit,
    act: (cubit) => cubit.configure(trainerOnlyAssigned: true),
    expect: () => [
      isA<BroadcastState>()
          .having(
            (s) => s.effectiveAudience,
            'audience',
            BroadcastAudience.assignedClients,
          )
          .having(
            (s) => s.lockedAudience,
            'locked',
            BroadcastAudience.assignedClients,
          ),
    ],
  );

  blocTest<BroadcastCubit, BroadcastState>(
    'submit succeeds and clears form fields in state',
    build: () {
      when(() => broadcast(any())).thenAnswer(
        (_) async => Right(
          AppNotification(
            id: '10',
            title: 'Hi',
            message: 'Body',
            createdAt: DateTime.utc(2026, 1, 1),
            isRead: true,
          ),
        ),
      );
      when(() => listBroadcasts(any())).thenAnswer(
        (_) async => const Right(
          CursorPage(items: [], nextCursor: null, hasMore: false),
        ),
      );
      return buildCubit();
    },
    seed: () => const BroadcastState(title: 'Hi', message: 'Body'),
    act: (cubit) => cubit.submit(),
    expect: () => [
      isA<BroadcastState>().having((s) => s.submitting, 'submitting', true),
      isA<BroadcastState>()
          .having((s) => s.submitting, 'submitting', false)
          .having((s) => s.submitted?.id, 'id', '10')
          .having((s) => s.title, 'title', '')
          .having((s) => s.message, 'message', ''),
    ],
  );
}
