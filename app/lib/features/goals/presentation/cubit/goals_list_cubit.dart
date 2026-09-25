import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/member_goal.dart';
import '../../domain/usecases/goals_usecases.dart';

part 'goals_list_cubit.freezed.dart';

@freezed
abstract class GoalsListState with _$GoalsListState {
  const factory GoalsListState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<MemberGoal>[]) List<MemberGoal> items,
    Failure? failure,
  }) = _GoalsListState;
}

@injectable
class GoalsListCubit extends Cubit<GoalsListState> {
  GoalsListCubit(this._listGoals) : super(const GoalsListState());

  final ListMemberGoalsUseCase _listGoals;

  Future<void> load(String memberId) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _listGoals(MemberIdParams(memberId));
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
