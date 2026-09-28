import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership.dart';
import '../../domain/entities/membership_freeze.dart';
import '../../domain/usecases/get_memberships_usecase.dart';
import '../../domain/usecases/request_membership_freeze_usecase.dart';

part 'membership_card_cubit.freezed.dart';

@freezed
abstract class MembershipCardState with _$MembershipCardState {
  const factory MembershipCardState({
    @Default(LoadStatus.initial) LoadStatus status,
    Membership? membership,
    Failure? failure,
    @Default(false) bool requestingFreeze,
  }) = _MembershipCardState;
}

@injectable
class MembershipCardCubit extends Cubit<MembershipCardState> {
  MembershipCardCubit(this._getMemberships, this._requestFreeze)
    : super(const MembershipCardState());

  final GetMembershipsUseCase _getMemberships;
  final RequestMembershipFreezeUseCase _requestFreeze;

  Future<void> load(String? memberId) async {
    if (memberId == null) {
      emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          membership: null,
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getMemberships(
      GetMembershipsParams(memberId: memberId),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          membership: _preferActive(page.items),
        ),
      ),
    );
  }

  /// Null when nothing was submitted. Otherwise the use-case result so the
  /// screen can tell a successful request from a failure.
  Future<Either<Failure, MembershipFreeze>?> requestFreeze(
    RequestMembershipFreezeParams params,
  ) async {
    if (state.membership == null || state.requestingFreeze) return null;
    emit(state.copyWith(requestingFreeze: true));
    final result = await _requestFreeze(params);
    if (isClosed) return null;
    emit(state.copyWith(requestingFreeze: false));
    return result;
  }
}

Membership? _preferActive(List<Membership> items) {
  if (items.isEmpty) return null;
  return items.firstWhere(
    (m) => m.isActiveOrFrozen,
    orElse: () => items.first,
  );
}
