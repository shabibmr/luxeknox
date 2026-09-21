import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/member_goal.dart';
import '../../domain/usecases/goals_usecases.dart';

sealed class GoalDetailState extends Equatable {
  const GoalDetailState();

  @override
  List<Object?> get props => [];
}

final class GoalDetailLoading extends GoalDetailState {
  const GoalDetailLoading();
}

final class GoalDetailLoaded extends GoalDetailState {
  const GoalDetailLoaded(this.goal, {this.submitting = false, this.toast});

  final MemberGoal goal;
  final bool submitting;
  final String? toast;

  GoalDetailLoaded copyWith({
    MemberGoal? goal,
    bool? submitting,
    String? toast,
  }) {
    return GoalDetailLoaded(
      goal ?? this.goal,
      submitting: submitting ?? this.submitting,
      toast: toast,
    );
  }

  @override
  List<Object?> get props => [goal, submitting, toast];
}

final class GoalDetailFailure extends GoalDetailState {
  const GoalDetailFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class GoalDetailCubit extends Cubit<GoalDetailState> {
  GoalDetailCubit(this._getGoal, this._checkIn)
    : super(const GoalDetailLoading());

  final GetGoalUseCase _getGoal;
  final CheckInGoalUseCase _checkIn;
  String? _goalId;

  Future<void> load(String goalId) async {
    _goalId = goalId;
    emit(const GoalDetailLoading());
    final result = await _getGoal(goalId);
    result.fold(
      (failure) => emit(GoalDetailFailure(failureMessage(failure))),
      (goal) => emit(GoalDetailLoaded(goal)),
    );
  }

  Future<bool> submitCheckIn({
    required num recordedValue,
    DateTime? recordedDate,
    String? notes,
  }) async {
    final id = _goalId;
    final current = state;
    if (id == null || current is! GoalDetailLoaded) return false;
    emit(current.copyWith(submitting: true));
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
            toast: failureMessage(failure),
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
