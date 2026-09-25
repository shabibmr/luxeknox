import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership.dart';
import '../../domain/usecases/cancel_membership_usecase.dart';
import '../../domain/usecases/extend_membership_usecase.dart';
import '../../domain/usecases/get_membership_usecase.dart';
import '../../domain/usecases/renew_membership_usecase.dart';
import '../../domain/usecases/upgrade_membership_usecase.dart';

part 'membership_detail_cubit.freezed.dart';

@freezed
abstract class MembershipDetailState with _$MembershipDetailState {
  const factory MembershipDetailState({
    @Default(LoadStatus.initial) LoadStatus status,
    Membership? membership,
    Failure? failure,
    @Default(false) bool actionInFlight,
  }) = _MembershipDetailState;
}

@injectable
class MembershipDetailCubit extends Cubit<MembershipDetailState> {
  MembershipDetailCubit(
    this._getMembership,
    this._renew,
    this._cancel,
    this._extend,
    this._upgrade,
  ) : super(const MembershipDetailState());

  final GetMembershipUseCase _getMembership;
  final RenewMembershipUseCase _renew;
  final CancelMembershipUseCase _cancel;
  final ExtendMembershipUseCase _extend;
  final UpgradeMembershipUseCase _upgrade;

  Future<void> load(String membershipId) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getMembership(membershipId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (membership) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          membership: membership,
        ),
      ),
    );
  }

  Future<Failure?> renew() {
    return _run(
      (membership) => _renew(
        MembershipActionParams(
          membershipId: membership.id,
          rowVersion: membership.rowVersion,
        ),
      ),
    );
  }

  Future<Failure?> cancel({String? reason}) {
    return _run(
      (membership) => _cancel(
        MembershipActionParams(
          membershipId: membership.id,
          rowVersion: membership.rowVersion,
          reason: reason,
        ),
      ),
    );
  }

  Future<Failure?> extend({required int daysExtended, String? reason}) {
    return _run(
      (membership) => _extend(
        ExtendMembershipParams(
          membershipId: membership.id,
          daysExtended: daysExtended,
          reason: reason,
        ),
      ),
    );
  }

  Future<Failure?> upgrade({required String productId, String? reason}) {
    return _run(
      (membership) => _upgrade(
        MembershipActionParams(
          membershipId: membership.id,
          rowVersion: membership.rowVersion,
          productId: productId,
          reason: reason,
        ),
      ),
    );
  }

  Future<Failure?> _run(
    Future<Either<Failure, Object>> Function(Membership membership) call,
  ) async {
    final membership = state.membership;
    if (membership == null || state.actionInFlight) return null;
    emit(state.copyWith(actionInFlight: true));
    final result = await call(membership);
    if (isClosed) return null;
    final failure = result.fold<Failure?>((f) => f, (_) => null);
    emit(state.copyWith(actionInFlight: false));
    if (failure == null || failure is ConflictFailure) {
      await load(membership.id);
    }
    return failure;
  }
}
