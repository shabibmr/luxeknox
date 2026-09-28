import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/helpers/unread_count.dart';
import '../../domain/repositories/device_token_registrar.dart';
import '../../domain/usecases/notification_usecases.dart';

part 'notifications_inbox_cubit.freezed.dart';

enum InboxFilter { all, unread }

@freezed
abstract class NotificationsInboxState with _$NotificationsInboxState {
  const NotificationsInboxState._();

  const factory NotificationsInboxState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<AppNotification>[]) List<AppNotification> items,
    @Default(InboxFilter.all) InboxFilter filter,
    @Default(false) bool hasMore,
    String? nextCursor,
    @Default(false) bool loadingMore,
    Failure? failure,
    String? actionMessage,
  }) = _NotificationsInboxState;

  int get unread => unreadCount(items);

  List<AppNotification> get visibleItems {
    if (filter == InboxFilter.unread) {
      return items.where((n) => n.unread).toList();
    }
    return items;
  }
}

@injectable
class NotificationsInboxCubit extends Cubit<NotificationsInboxState> {
  NotificationsInboxCubit(
    this._listNotifications,
    this._markRead,
    this._markAllRead,
    this._deviceTokenRegistrar,
  ) : super(const NotificationsInboxState());

  final ListNotificationsUseCase _listNotifications;
  final MarkNotificationReadUseCase _markRead;
  final MarkAllNotificationsReadUseCase _markAllRead;
  final DeviceTokenRegistrar _deviceTokenRegistrar;

  static const _pageSize = 30;

  bool get _hasList =>
      state.status == LoadStatus.success || state.items.isNotEmpty;

  Future<void> load({InboxFilter filter = InboxFilter.all}) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        filter: filter,
        loadingMore: false,
        actionMessage: null,
      ),
    );
    final result = await _listNotifications(
      const ListNotificationsParams(limit: _pageSize),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: page.items,
          filter: filter,
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          failure: null,
          loadingMore: false,
          actionMessage: null,
        ),
      ),
    );
  }

  Future<void> refresh() => load(filter: state.filter);

  void setFilter(InboxFilter filter) {
    if (!_hasList) return;
    emit(state.copyWith(filter: filter, failure: null, actionMessage: null));
  }

  Future<void> loadMore() async {
    final current = state;
    if (current.status == LoadStatus.loading || current.loadingMore) return;
    if (!current.hasMore || current.nextCursor == null) return;
    if (current.items.isEmpty && current.status != LoadStatus.success) {
      return;
    }
    emit(
      current.copyWith(
        loadingMore: true,
        failure: null,
        actionMessage: null,
      ),
    );
    final result = await _listNotifications(
      ListNotificationsParams(limit: _pageSize, cursor: current.nextCursor),
    );
    result.fold(
      (failure) => emit(
        current.copyWith(loadingMore: false, failure: failure),
      ),
      (page) => emit(
        current.copyWith(
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
          nextCursor: page.nextCursor ?? current.nextCursor,
          loadingMore: false,
          failure: null,
        ),
      ),
    );
  }

  Future<void> markRead(String id) async {
    final current = state;
    if (!_loaded(current)) return;
    final result = await _markRead(id);
    result.fold(
      (failure) => emit(
        current.copyWith(failure: failure, actionMessage: null),
      ),
      (updated) {
        final items = current.items
            .map((n) => n.id == updated.id ? updated : n)
            .toList();
        emit(
          current.copyWith(items: items, failure: null, actionMessage: null),
        );
      },
    );
  }

  Future<void> markAllRead() async {
    final current = state;
    if (!_loaded(current)) return;
    final result = await _markAllRead(const NoParams());
    result.fold(
      (failure) => emit(
        current.copyWith(failure: failure, actionMessage: null),
      ),
      (_) {
        final now = DateTime.now().toUtc();
        final items = current.items
            .map(
              (n) => n.unread ? n.copyWith(isRead: true, readAt: now) : n,
            )
            .toList();
        emit(
          current.copyWith(
            items: items,
            failure: null,
            actionMessage: 'Marked all read',
          ),
        );
      },
    );
  }

  Future<void> registerDevice({bool rotate = false}) async {
    final current = state;
    if (!_loaded(current)) return;
    final result = await _deviceTokenRegistrar.registerOrRotate(
      forceNewToken: rotate,
    );
    result.fold(
      (failure) => emit(
        current.copyWith(failure: failure, actionMessage: null),
      ),
      (_) => emit(
        current.copyWith(
          failure: null,
          actionMessage: rotate ? 'Device token rotated' : 'Device registered',
        ),
      ),
    );
  }

  bool _loaded(NotificationsInboxState current) =>
      current.status == LoadStatus.success || current.items.isNotEmpty;
}
