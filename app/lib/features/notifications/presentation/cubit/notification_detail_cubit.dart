import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/helpers/deep_link_parser.dart';
import '../../domain/helpers/deep_link_resolver.dart';
import '../../domain/usecases/notification_usecases.dart';

sealed class NotificationDetailState extends Equatable {
  const NotificationDetailState();

  @override
  List<Object?> get props => [];
}

final class NotificationDetailLoading extends NotificationDetailState {
  const NotificationDetailLoading();
}

final class NotificationDetailLoaded extends NotificationDetailState {
  const NotificationDetailLoaded({
    required this.notification,
    this.deepLinkPath,
    this.actionError,
  });

  final AppNotification notification;
  final String? deepLinkPath;
  final String? actionError;

  NotificationDetailLoaded copyWith({
    AppNotification? notification,
    String? deepLinkPath,
    String? actionError,
    bool clearActionError = false,
  }) {
    return NotificationDetailLoaded(
      notification: notification ?? this.notification,
      deepLinkPath: deepLinkPath ?? this.deepLinkPath,
      actionError: clearActionError ? null : (actionError ?? this.actionError),
    );
  }

  @override
  List<Object?> get props => [notification, deepLinkPath, actionError];
}

final class NotificationDetailFailure extends NotificationDetailState {
  const NotificationDetailFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class NotificationDetailCubit extends Cubit<NotificationDetailState> {
  NotificationDetailCubit(this._getNotification, this._markRead)
    : super(const NotificationDetailLoading());

  final GetNotificationUseCase _getNotification;
  final MarkNotificationReadUseCase _markRead;

  Future<void> load(String id) async {
    emit(const NotificationDetailLoading());
    final result = await _getNotification(id);
    await result.fold(
      (failure) async {
        emit(NotificationDetailFailure(failureMessage(failure)));
      },
      (notification) async {
        final path = _deepLinkPathFor(notification);
        emit(
          NotificationDetailLoaded(
            notification: notification,
            deepLinkPath: path,
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
    if (current is! NotificationDetailLoaded) return;
    if (!current.notification.unread) return;

    final result = await _markRead(current.notification.id);
    result.fold(
      (failure) => emit(
        current.copyWith(actionError: failureMessage(failure)),
      ),
      (updated) => emit(
        current.copyWith(
          notification: updated,
          clearActionError: true,
        ),
      ),
    );
  }

  String? _deepLinkPathFor(AppNotification notification) {
    final target = parseNotificationDeepLink(notification.dataPayload);
    if (target == null) return null;
    return resolveDeepLinkPath(target);
  }
}
