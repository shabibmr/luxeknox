import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/broadcast_audience.dart';
import '../../domain/entities/broadcast_request_input.dart';
import '../../domain/usecases/notification_usecases.dart';
import '../notification_strings.dart';

part 'broadcast_cubit.freezed.dart';

@freezed
abstract class BroadcastState with _$BroadcastState {
  const BroadcastState._();

  const factory BroadcastState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default('') String title,
    @Default('') String message,
    @Default(BroadcastAudience.allMembers) BroadcastAudience audience,
    @Default('') String roleId,
    @Default(false) bool submitting,
    String? validationError,
    Failure? failure,
    AppNotification? submitted,
    @Default(<AppNotification>[]) List<AppNotification> history,
    @Default(false) bool historyHasMore,
    int? historyOffset,
    Failure? historyFailure,
    BroadcastAudience? lockedAudience,
  }) = _BroadcastState;

  /// When [lockedAudience] is set (trainer), audience cannot change.
  BroadcastAudience get effectiveAudience => lockedAudience ?? audience;
}

@injectable
class BroadcastCubit extends Cubit<BroadcastState> {
  BroadcastCubit(this._broadcast, this._listBroadcasts)
    : super(const BroadcastState());

  final BroadcastNotificationUseCase _broadcast;
  final ListBroadcastsUseCase _listBroadcasts;

  static const _pageSize = 20;

  void configure({required bool trainerOnlyAssigned}) {
    if (!trainerOnlyAssigned) return;
    emit(
      state.copyWith(
        audience: BroadcastAudience.assignedClients,
        lockedAudience: BroadcastAudience.assignedClients,
      ),
    );
  }

  void setTitle(String value) {
    emit(state.copyWith(title: value, validationError: null));
  }

  void setMessage(String value) {
    emit(state.copyWith(message: value, validationError: null));
  }

  void setAudience(BroadcastAudience audience) {
    if (state.lockedAudience != null) return;
    emit(state.copyWith(audience: audience, validationError: null));
  }

  void setRoleId(String value) {
    emit(state.copyWith(roleId: value, validationError: null));
  }

  String? validate(BroadcastState form) {
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
    if (current.submitting) return;

    final error = validate(current);
    if (error != null) {
      emit(current.copyWith(validationError: error));
      return;
    }

    emit(
      current.copyWith(
        submitting: true,
        validationError: null,
        failure: null,
        submitted: null,
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
          failure: failure,
          validationError: null,
        ),
      ),
      (created) {
        emit(
          current.copyWith(
            submitting: false,
            submitted: created,
            title: '',
            message: '',
            failure: null,
            validationError: null,
            history: [created, ...current.history],
          ),
        );
      },
    );
  }

  Future<void> loadHistory({bool refresh = true}) async {
    final current = state;
    final offset = refresh ? 0 : (current.historyOffset ?? 0);
    emit(
      current.copyWith(
        status: LoadStatus.loading,
        historyFailure: null,
      ),
    );

    final result = await _listBroadcasts(
      ListBroadcastsParams(limit: _pageSize, offset: offset),
    );
    result.fold(
      (failure) => emit(
        current.copyWith(
          status: LoadStatus.failure,
          historyFailure: failure,
        ),
      ),
      (page) {
        final nextOffset = page.nextCursor != null
            ? int.tryParse(page.nextCursor!)
            : null;
        emit(
          current.copyWith(
            status: LoadStatus.success,
            historyFailure: null,
            history: refresh ? page.items : [...current.history, ...page.items],
            historyHasMore: page.hasMore,
            historyOffset: nextOffset ?? current.historyOffset,
          ),
        );
      },
    );
  }
}
