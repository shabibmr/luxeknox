import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership_history_entry.dart';
import '../../domain/usecases/get_membership_history_usecase.dart';
import '../../domain/usecases/get_memberships_usecase.dart';

part 'membership_history_cubit.freezed.dart';

@freezed
abstract class MembershipHistoryState with _$MembershipHistoryState {
  const factory MembershipHistoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<MembershipHistoryEntry>[]) List<MembershipHistoryEntry> items,
    String? membershipId,
    Failure? failure,
  }) = _MembershipHistoryState;
}

@injectable
class MembershipHistoryCubit extends Cubit<MembershipHistoryState> {
  MembershipHistoryCubit(this._getMemberships, this._getHistory)
    : super(const MembershipHistoryState());

  final GetMembershipsUseCase _getMemberships;
  final GetMembershipHistoryUseCase _getHistory;

  /// [membershipId] loads that contract's history. Otherwise [memberId]
  /// resolves the caller's first contract (null member → no membership).
  Future<void> load({String? memberId, String? membershipId}) async {
    if (membershipId != null) {
      await _loadHistory(membershipId);
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

  Future<void> _loadHistory(String membershipId) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        membershipId: membershipId,
      ),
    );
    final result = await _getHistory(
      GetMembershipHistoryParams(membershipId: membershipId),
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
          items: page.items,
        ),
      ),
    );
  }
}
