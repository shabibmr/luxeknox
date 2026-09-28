import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/member_goal.dart';
import '../../domain/usecases/goals_usecases.dart';

part 'goal_detail_cubit.freezed.dart';

@freezed
abstract class GoalDetailState with _$GoalDetailState {
  const factory GoalDetailState({
    @Default(LoadStatus.initial) LoadStatus status,
    MemberGoal? goal,
    @Default(false) bool submitting,
    Failure? failure,
  }) = _GoalDetailState;
}

@injectable
class GoalDetailCubit extends Cubit<GoalDetailState> {
  GoalDetailCubit(this._getGoal, this._checkIn)
    : super(const GoalDetailState());

  final GetGoalUseCase _getGoal;
  final CheckInGoalUseCase _checkIn;
  String? _goalId;

  Future<void> load(String goalId) async {
    _goalId = goalId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        submitting: false,
      ),
    );
    final result = await _getGoal(goalId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          submitting: false,
        ),
      ),
      (goal) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          submitting: false,
          goal: goal,
        ),
      ),
    );
  }

  Future<bool> submitCheckIn({
    required num recordedValue,
    DateTime? recordedDate,
    String? notes,
  }) async {
    final id = _goalId;
    final current = state;
    if (id == null ||
        current.goal == null ||
        current.status == LoadStatus.loading ||
        current.submitting) {
      return false;
    }
    emit(current.copyWith(submitting: true, failure: null));
    final result = await _checkIn(
      CheckInGoalParams(
        id: id,
        recordedValue: recordedValue,
        recordedDate: recordedDate,
        notes: notes,
      ),
    );
    return result.fold(
      (failure) {
        emit(
          current.copyWith(
            submitting: false,
            status: LoadStatus.failure,
            failure: failure,
          ),
        );
        return false;
      },
      (_) async {
        await load(id);
        return true;
      },
    );
  }
}
