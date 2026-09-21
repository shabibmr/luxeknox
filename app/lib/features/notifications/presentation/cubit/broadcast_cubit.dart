import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/broadcast_audience.dart';
import '../../domain/entities/broadcast_request_input.dart';
import '../../domain/usecases/notification_usecases.dart';
import '../notification_strings.dart';

sealed class BroadcastState extends Equatable {
  const BroadcastState();

  @override
  List<Object?> get props => [];
}

final class BroadcastFormState extends BroadcastState {
  const BroadcastFormState({
    this.title = '',
    this.message = '',
    this.audience = BroadcastAudience.allMembers,
    this.roleId = '',
    this.submitting = false,
    this.validationError,
    this.submitError,
    this.submitted,
    this.history = const [],
    this.historyHasMore = false,
    this.historyOffset,
    this.historyLoading = false,
    this.historyError,
    this.lockedAudience,
  });

  final String title;
  final String message;
  final BroadcastAudience audience;
  final String roleId;
  final bool submitting;
  final String? validationError;
  final String? submitError;
  final AppNotification? submitted;
  final List<AppNotification> history;
  final bool historyHasMore;
  final int? historyOffset;
  final bool historyLoading;
  final String? historyError;

  /// When set (trainer), audience cannot change.
  final BroadcastAudience? lockedAudience;

  BroadcastAudience get effectiveAudience => lockedAudience ?? audience;

  BroadcastFormState copyWith({
    String? title,
    String? message,
    BroadcastAudience? audience,
    String? roleId,
    bool? submitting,
    String? validationError,
    String? submitError,
    AppNotification? submitted,
    List<AppNotification>? history,
    bool? historyHasMore,
    int? historyOffset,
    bool? historyLoading,
    String? historyError,
    BroadcastAudience? lockedAudience,
    bool clearValidation = false,
    bool clearSubmitError = false,
    bool clearSubmitted = false,
    bool clearHistoryError = false,
  }) {
    return BroadcastFormState(
      title: title ?? this.title,
      message: message ?? this.message,
      audience: audience ?? this.audience,
      roleId: roleId ?? this.roleId,
      submitting: submitting ?? this.submitting,
      validationError:
          clearValidation ? null : (validationError ?? this.validationError),
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      submitted: clearSubmitted ? null : (submitted ?? this.submitted),
      history: history ?? this.history,
      historyHasMore: historyHasMore ?? this.historyHasMore,
      historyOffset: historyOffset ?? this.historyOffset,
      historyLoading: historyLoading ?? this.historyLoading,
      historyError:
          clearHistoryError ? null : (historyError ?? this.historyError),
      lockedAudience: lockedAudience ?? this.lockedAudience,
    );
  }

  @override
  List<Object?> get props => [
    title,
    message,
    audience,
    roleId,
    submitting,
    validationError,
    submitError,
    submitted,
    history,
    historyHasMore,
    historyOffset,
    historyLoading,
    historyError,
    lockedAudience,
  ];
}

@injectable
class BroadcastCubit extends Cubit<BroadcastState> {
  BroadcastCubit(this._broadcast, this._listBroadcasts)
    : super(const BroadcastFormState());

  final BroadcastNotificationUseCase _broadcast;
  final ListBroadcastsUseCase _listBroadcasts;

  static const _pageSize = 20;

  void configure({required bool trainerOnlyAssigned}) {
    final current = state;
    if (current is! BroadcastFormState) return;
    if (trainerOnlyAssigned) {
      emit(
        current.copyWith(
          audience: BroadcastAudience.assignedClients,
          lockedAudience: BroadcastAudience.assignedClients,
        ),
      );
    }
  }

  void setTitle(String value) {
    final current = state;
    if (current is! BroadcastFormState) return;
    emit(current.copyWith(title: value, clearValidation: true));
  }

  void setMessage(String value) {
    final current = state;
    if (current is! BroadcastFormState) return;
    emit(current.copyWith(message: value, clearValidation: true));
  }

  void setAudience(BroadcastAudience audience) {
    final current = state;
    if (current is! BroadcastFormState) return;
    if (current.lockedAudience != null) return;
    emit(current.copyWith(audience: audience, clearValidation: true));
  }

  void setRoleId(String value) {
    final current = state;
    if (current is! BroadcastFormState) return;
    emit(current.copyWith(roleId: value, clearValidation: true));
  }

  String? validate(BroadcastFormState form) {
    if (form.title.trim().isEmpty) return NotificationStrings.titleRequired;
    if (form.message.trim().isEmpty) {
      return NotificationStrings.messageRequired;
    }
    if (form.effectiveAudience == BroadcastAudience.role &&
        form.roleId.trim().isEmpty) {
      return NotificationStrings.roleIdRequired;
    }
    return null;
  }

  Future<void> submit() async {
    final current = state;
    if (current is! BroadcastFormState || current.submitting) return;

    final error = validate(current);
    if (error != null) {
      emit(current.copyWith(validationError: error));
      return;
    }

    emit(
      current.copyWith(
        submitting: true,
        clearValidation: true,
        clearSubmitError: true,
        clearSubmitted: true,
      ),
    );

    final input = BroadcastRequestInput(
      title: current.title.trim(),
      message: current.message.trim(),
      audience: current.effectiveAudience,
      roleId: current.effectiveAudience == BroadcastAudience.role
          ? current.roleId.trim()
          : null,
    );

    final result = await _broadcast(input);
    result.fold(
      (failure) => emit(
        current.copyWith(
          submitting: false,
          submitError: failureMessage(failure),
        ),
      ),
      (created) {
        emit(
          current.copyWith(
            submitting: false,
            submitted: created,
            title: '',
            message: '',
            clearSubmitError: true,
            history: [created, ...current.history],
          ),
        );
      },
    );
  }

  Future<void> loadHistory({bool refresh = true}) async {
    final current = state;
    if (current is! BroadcastFormState) return;

    final offset = refresh ? 0 : (current.historyOffset ?? 0);
    emit(
      current.copyWith(
        historyLoading: true,
        clearHistoryError: true,
      ),
    );

    final result = await _listBroadcasts(
      ListBroadcastsParams(limit: _pageSize, offset: offset),
    );
    result.fold(
      (failure) => emit(
        current.copyWith(
          historyLoading: false,
          historyError: failureMessage(failure),
        ),
      ),
      (page) {
        final nextOffset = page.nextCursor != null
            ? int.tryParse(page.nextCursor!)
            : null;
        emit(
          current.copyWith(
            historyLoading: false,
            history: refresh
                ? page.items
                : [...current.history, ...page.items],
            historyHasMore: page.hasMore,
            historyOffset: nextOffset,
          ),
        );
      },
    );
  }
}
