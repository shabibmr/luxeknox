import 'package:app/core/error/failures.dart';
import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/notifications/domain/entities/app_notification.dart';
import 'package:app/features/notifications/domain/repositories/device_token_registrar.dart';
import 'package:app/features/notifications/domain/usecases/notification_usecases.dart';
import 'package:app/features/notifications/presentation/cubit/notifications_inbox_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockList extends Mock implements ListNotificationsUseCase {}

class _MockMarkRead extends Mock implements MarkNotificationReadUseCase {}

class _MockMarkAll extends Mock implements MarkAllNotificationsReadUseCase {}

class _MockDeviceToken extends Mock implements DeviceTokenRegistrar {}

AppNotification n({required String id, bool isRead = false}) {
  return AppNotification(
    id: id,
    title: 'Title $id',
    message: 'Message',
    createdAt: DateTime.utc(2026, 1, 1),
    isRead: isRead,
  );
}

void main() {
  late _MockList list;
  late _MockMarkRead markRead;
  late _MockMarkAll markAll;
  late _MockDeviceToken devices;

  setUpAll(() {
    registerFallbackValue(const ListNotificationsParams());
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    list = _MockList();
    markRead = _MockMarkRead();
    markAll = _MockMarkAll();
    devices = _MockDeviceToken();
  });

  NotificationsInboxCubit buildCubit() => NotificationsInboxCubit(
    list,
    markRead,
    markAll,
    devices,
  );

  blocTest<NotificationsInboxCubit, NotificationsInboxState>(
    'loads inbox and exposes unread count',
    build: () {
      when(() => list(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: [n(id: '1'), n(id: '2', isRead: true)],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      return buildCubit();
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<NotificationsInboxLoading>(),
      isA<NotificationsInboxLoaded>()
          .having((s) => s.items.length, 'len', 2)
          .having((s) => s.unread, 'unread', 1),
    ],
  );

  blocTest<NotificationsInboxCubit, NotificationsInboxState>(
    'markAllRead updates local unread flags',
    build: () {
      when(() => list(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: [n(id: '1'), n(id: '2')],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      when(() => markAll(any())).thenAnswer((_) async => const Right(null));
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.load();
      await cubit.markAllRead();
    },
    expect: () => [
      isA<NotificationsInboxLoading>(),
      isA<NotificationsInboxLoaded>().having((s) => s.unread, 'unread', 2),
      isA<NotificationsInboxLoaded>().having((s) => s.unread, 'unread', 0),
    ],
  );

  blocTest<NotificationsInboxCubit, NotificationsInboxState>(
    'emits failure on list error',
    build: () {
      when(() => list(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return buildCubit();
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<NotificationsInboxLoading>(),
      isA<NotificationsInboxFailure>(),
    ],
  );
}
