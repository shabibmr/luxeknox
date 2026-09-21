import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/helpers/unread_count.dart';
import '../../domain/repositories/device_token_registrar.dart';
import '../../domain/usecases/notification_usecases.dart';

enum InboxFilter { all, unread }

sealed class NotificationsInboxState extends Equatable {
  const NotificationsInboxState();

  @override
  List<Object?> get props => [];
}

final class NotificationsInboxLoading extends NotificationsInboxState {
  const NotificationsInboxLoading();
}

final class NotificationsInboxLoaded extends NotificationsInboxState {
  const NotificationsInboxLoaded({
    required this.items,
    required this.filter,
    required this.hasMore,
    this.nextCursor,
    this.loadingMore = false,
    this.actionError,
    this.actionMessage,
  });

  final List<AppNotification> items;
  final InboxFilter filter;
  final bool hasMore;
  final String? nextCursor;
  final bool loadingMore;
  final String? actionError;
  final String? actionMessage;

  int get unread => unreadCount(items);

  List<AppNotification> get visibleItems {
    if (filter == InboxFilter.unread) {
      return items.where((n) => n.unread).toList();
    }
    return items;
  }

  NotificationsInboxLoaded copyWith({
    List<AppNotification>? items,
    InboxFilter? filter,
    bool? hasMore,
    String? nextCursor,
    bool? loadingMore,
    String? actionError,
    String? actionMessage,
    bool clearActionError = false,
    bool clearActionMessage = false,
  }) {
    return NotificationsInboxLoaded(
      items: items ?? this.items,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      loadingMore: loadingMore ?? this.loadingMore,
      actionError: clearActionError ? null : (actionError ?? this.actionError),
      actionMessage:
          clearActionMessage ? null : (actionMessage ?? this.actionMessage),
    );
  }

  @override
  List<Object?> get props => [
    items,
    filter,
    hasMore,
    nextCursor,
    loadingMore,
    actionError,
    actionMessage,
  ];
}

final class NotificationsInboxFailure extends NotificationsInboxState {
  const NotificationsInboxFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class NotificationsInboxCubit extends Cubit<NotificationsInboxState> {
  NotificationsInboxCubit(
    this._listNotifications,
    this._markRead,
    this._markAllRead,
    this._deviceTokenRegistrar,
  ) : super(const NotificationsInboxLoading());

  final ListNotificationsUseCase _listNotifications;
  final MarkNotificationReadUseCase _markRead;
  final MarkAllNotificationsReadUseCase _markAllRead;
  final DeviceTokenRegistrar _deviceTokenRegistrar;

  static const _pageSize = 30;

  Future<void> load({InboxFilter filter = InboxFilter.all}) async {
    emit(const NotificationsInboxLoading());
    final result = await _listNotifications(
      const ListNotificationsParams(limit: _pageSize),
    );
    result.fold(
      (failure) => emit(NotificationsInboxFailure(failureMessage(failure))),
      (page) => emit(
        NotificationsInboxLoaded(
          items: page.items,
          filter: filter,
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  Future<void> refresh() async {
    final currentFilter = state is NotificationsInboxLoaded
        ? (state as NotificationsInboxLoaded).filter
        : InboxFilter.all;
    await load(filter: currentFilter);
  }

  void setFilter(InboxFilter filter) {
    final current = state;
    if (current is! NotificationsInboxLoaded) return;
    emit(current.copyWith(filter: filter, clearActionError: true));
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! NotificationsInboxLoaded) return;
    if (!current.hasMore || current.loadingMore || current.nextCursor == null) {
      return;
    }
    emit(current.copyWith(loadingMore: true, clearActionError: true));
    final result = await _listNotifications(
      ListNotificationsParams(limit: _pageSize, cursor: current.nextCursor),
    );
    result.fold(
      (failure) => emit(
        current.copyWith(
          loadingMore: false,
          actionError: failureMessage(failure),
        ),
      ),
      (page) => emit(
        current.copyWith(
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          loadingMore: false,
        ),
      ),
    );
  }

  Future<void> markRead(String id) async {
    final current = state;
    if (current is! NotificationsInboxLoaded) return;
    final result = await _markRead(id);
    result.fold(
      (failure) => emit(
        current.copyWith(actionError: failureMessage(failure)),
      ),
      (updated) {
        final items = current.items
            .map((n) => n.id == updated.id ? updated : n)
            .toList();
        emit(current.copyWith(items: items, clearActionError: true));
      },
    );
  }

  Future<void> markAllRead() async {
    final current = state;
    if (current is! NotificationsInboxLoaded) return;
    final result = await _markAllRead(const NoParams());
    result.fold(
      (failure) => emit(
        current.copyWith(actionError: failureMessage(failure)),
      ),
      (_) {
        final now = DateTime.now().toUtc();
        final items = current.items
            .map(
              (n) => n.unread
                  ? n.copyWith(isRead: true, readAt: now)
                  : n,
            )
            .toList();
        emit(
          current.copyWith(
            items: items,
            clearActionError: true,
            actionMessage: 'Marked all read',
          ),
        );
      },
    );
  }

  Future<void> registerDevice({bool rotate = false}) async {
    final current = state;
    if (current is! NotificationsInboxLoaded) return;
    final result = await _deviceTokenRegistrar.registerOrRotate(
      forceNewToken: rotate,
    );
    result.fold(
      (failure) => emit(
        current.copyWith(actionError: failureMessage(failure)),
      ),
      (_) => emit(
        current.copyWith(
          clearActionError: true,
          actionMessage: rotate ? 'Device token rotated' : 'Device registered',
        ),
      ),
    );
  }
}
