import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/helpers/deep_link_parser.dart';
import '../../domain/helpers/deep_link_resolver.dart';
import '../../domain/usecases/notification_usecases.dart';

part 'notification_detail_cubit.freezed.dart';

@freezed
abstract class NotificationDetailState with _$NotificationDetailState {
  const factory NotificationDetailState({
    @Default(LoadStatus.initial) LoadStatus status,
    AppNotification? notification,
    String? deepLinkPath,
    Failure? failure,
  }) = _NotificationDetailState;
}

@injectable
class NotificationDetailCubit extends Cubit<NotificationDetailState> {
  NotificationDetailCubit(this._getNotification, this._markRead)
    : super(const NotificationDetailState());

  final GetNotificationUseCase _getNotification;
  final MarkNotificationReadUseCase _markRead;

  Future<void> load(String id) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getNotification(id);
    await result.fold(
      (failure) async {
        emit(state.copyWith(status: LoadStatus.failure, failure: failure));
      },
      (notification) async {
        final path = _deepLinkPathFor(notification);
        emit(
          state.copyWith(
            status: LoadStatus.success,
            notification: notification,
            deepLinkPath: path,
            failure: null,
          ),
        );
        if (notification.unread) {
          await markRead();
        }
      },
    );
  }

  Future<void> markRead() async {
    final current = state;
    final notification = current.notification;
    if (notification == null || !notification.unread) return;

    final result = await _markRead(notification.id);
    result.fold(
      (failure) => emit(current.copyWith(failure: failure)),
      (updated) => emit(
        current.copyWith(notification: updated, failure: null),
      ),
    );
  }

  String? _deepLinkPathFor(AppNotification notification) {
    final target = parseNotificationDeepLink(notification.dataPayload);
    if (target == null) return null;
    return resolveDeepLinkPath(target);
  }
}
