import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership.dart';
import '../../domain/usecases/get_memberships_usecase.dart';

part 'trainer_membership_summary_cubit.freezed.dart';

@freezed
abstract class TrainerMembershipSummaryState
    with _$TrainerMembershipSummaryState {
  const factory TrainerMembershipSummaryState({
    @Default(LoadStatus.initial) LoadStatus status,
    Membership? membership,
    Failure? failure,
  }) = _TrainerMembershipSummaryState;
}

@injectable
class TrainerMembershipSummaryCubit
    extends Cubit<TrainerMembershipSummaryState> {
  TrainerMembershipSummaryCubit(this._getMemberships)
    : super(const TrainerMembershipSummaryState());

  final GetMembershipsUseCase _getMemberships;

  Future<void> load(String memberId) async {
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
}

Membership? _preferActive(List<Membership> items) {
  if (items.isEmpty) return null;
  return items.firstWhere(
    (m) => m.isActiveOrFrozen,
    orElse: () => items.first,
  );
}
