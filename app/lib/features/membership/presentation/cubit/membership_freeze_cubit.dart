import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership_freeze.dart';
import '../../domain/usecases/approve_freeze_usecase.dart';
import '../../domain/usecases/get_membership_freezes_usecase.dart';
import '../../domain/usecases/get_memberships_usecase.dart';
import '../../domain/usecases/reject_freeze_usecase.dart';

part 'membership_freeze_cubit.freezed.dart';

@freezed
abstract class MembershipFreezeState with _$MembershipFreezeState {
  const factory MembershipFreezeState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<MembershipFreeze>[]) List<MembershipFreeze> items,
    String? membershipId,
    Failure? failure,
    String? busyId,
  }) = _MembershipFreezeState;
}

@injectable
class MembershipFreezeCubit extends Cubit<MembershipFreezeState> {
  MembershipFreezeCubit(
    this._getMemberships,
    this._getFreezes,
    this._approve,
    this._reject,
  ) : super(const MembershipFreezeState());

  final GetMembershipsUseCase _getMemberships;
  final GetMembershipFreezesUseCase _getFreezes;
  final ApproveFreezeUseCase _approve;
  final RejectFreezeUseCase _reject;

  /// [membershipId] loads that contract's freezes. Otherwise [memberId]
  /// resolves the caller's first contract (null member → no membership).
  Future<void> load({String? memberId, String? membershipId}) async {
    if (membershipId != null) {
      await _loadFreezes(membershipId);
      return;
    }
    await _resolveOwn(memberId);
  }

  Future<void> _resolveOwn(String? memberId) async {
    if (memberId == null) {
      emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          membershipId: null,
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
          membershipId: page.items.isEmpty ? null : page.items.first.id,
        ),
      ),
    );
  }

  Future<void> _loadFreezes(String membershipId) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        membershipId: membershipId,
      ),
    );
    final result = await _getFreezes(membershipId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          items: page.items,
        ),
      ),
    );
  }

  Future<Failure?> approve(String freezeId) async {
    emit(state.copyWith(busyId: freezeId));
    final result = await _approve(freezeId);
    if (isClosed) return null;
    final failure = result.fold<Failure?>((f) => f, (_) => null);
    emit(state.copyWith(busyId: null));
    final membershipId = state.membershipId;
    if (failure == null && membershipId != null) {
      await _loadFreezes(membershipId);
    }
    return failure;
  }

  Future<Failure?> reject(String freezeId, {String? reason}) async {
    emit(state.copyWith(busyId: freezeId));
    final result = await _reject(
      RejectFreezeParams(freezeId: freezeId, reason: reason),
    );
    if (isClosed) return null;
    final failure = result.fold<Failure?>((f) => f, (_) => null);
    emit(state.copyWith(busyId: null));
    final membershipId = state.membershipId;
    if (failure == null && membershipId != null) {
      await _loadFreezes(membershipId);
    }
    return failure;
  }
}
