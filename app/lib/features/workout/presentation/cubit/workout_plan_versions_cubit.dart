import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/workout_plan_version.dart';
import '../../domain/usecases/list_workout_plan_versions_usecase.dart';

sealed class WorkoutPlanVersionsState extends Equatable {
  const WorkoutPlanVersionsState();

  @override
  List<Object?> get props => [];
}

final class WorkoutPlanVersionsLoading extends WorkoutPlanVersionsState {
  const WorkoutPlanVersionsLoading();
}

final class WorkoutPlanVersionsLoaded extends WorkoutPlanVersionsState {
  const WorkoutPlanVersionsLoaded(this.versions, {this.expandedId});

  final List<WorkoutPlanVersion> versions;
  final String? expandedId;

  @override
  List<Object?> get props => [versions, expandedId];
}

final class WorkoutPlanVersionsFailure extends WorkoutPlanVersionsState {
  const WorkoutPlanVersionsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class WorkoutPlanVersionsCubit extends Cubit<WorkoutPlanVersionsState> {
  WorkoutPlanVersionsCubit(this._listVersions)
      : super(const WorkoutPlanVersionsLoading());

  final ListWorkoutPlanVersionsUseCase _listVersions;

  Future<void> load(String planId) async {
    emit(const WorkoutPlanVersionsLoading());
    final result = await _listVersions(planId);
    result.fold(
      (failure) =>
          emit(WorkoutPlanVersionsFailure(failureMessage(failure))),
      (versions) => emit(WorkoutPlanVersionsLoaded(versions)),
    );
  }

  void toggleExpanded(String versionId) {
    final current = state;
    if (current is! WorkoutPlanVersionsLoaded) return;
    final next =
        current.expandedId == versionId ? null : versionId;
    emit(WorkoutPlanVersionsLoaded(current.versions, expandedId: next));
  }
}
