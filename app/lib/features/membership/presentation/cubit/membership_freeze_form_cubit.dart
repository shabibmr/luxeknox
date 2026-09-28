import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership.dart';
import '../../domain/usecases/get_membership_usecase.dart';
import '../../domain/usecases/request_membership_freeze_usecase.dart';

part 'membership_freeze_form_cubit.freezed.dart';

@freezed
abstract class MembershipFreezeFormState with _$MembershipFreezeFormState {
  const factory MembershipFreezeFormState({
    @Default(LoadStatus.initial) LoadStatus status,
    Membership? membership,
    DateTime? startDate,
    DateTime? endDate,
    @Default('') String reason,
    Failure? failure,
    @Default(false) bool isSubmitting,
    @Default(false) bool success,
    String? validationError,
  }) = _MembershipFreezeFormState;
}

@injectable
class MembershipFreezeFormCubit extends Cubit<MembershipFreezeFormState> {
  MembershipFreezeFormCubit(
    this._getMembership,
    this._requestFreeze,
  ) : super(const MembershipFreezeFormState());

  final GetMembershipUseCase _getMembership;
  final RequestMembershipFreezeUseCase _requestFreeze;

  Future<void> load(String membershipId) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getMembership(membershipId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (membership) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final defaultEnd = today.add(const Duration(days: 7));
        emit(
          state.copyWith(
            status: LoadStatus.success,
            membership: membership,
            startDate: today,
            endDate: defaultEnd,
          ),
        );
      },
    );
  }

  void onStartDateChanged(DateTime startDate) {
    emit(state.copyWith(startDate: startDate, validationError: null));
  }

  void onEndDateChanged(DateTime endDate) {
    emit(state.copyWith(endDate: endDate, validationError: null));
  }

  void onReasonChanged(String reason) {
    emit(state.copyWith(reason: reason));
  }

  Future<bool> submit() async {
    final membership = state.membership;
    final startDate = state.startDate;
    final endDate = state.endDate;

    if (membership == null || startDate == null || endDate == null) {
      return false;
    }

    if (endDate.isBefore(startDate)) {
      emit(state.copyWith(validationError: 'End date cannot be before start date'));
      return false;
    }

    emit(state.copyWith(isSubmitting: true, failure: null, validationError: null));

    final result = await _requestFreeze(
      RequestMembershipFreezeParams(
        membershipId: membership.id,
        startDate: startDate,
        endDate: endDate,
        reason: state.reason.trim().isEmpty ? null : state.reason.trim(),
      ),
    );

    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, failure: failure));
        return false;
      },
      (freeze) {
        emit(state.copyWith(isSubmitting: false, success: true));
        return true;
      },
    );
  }
}
