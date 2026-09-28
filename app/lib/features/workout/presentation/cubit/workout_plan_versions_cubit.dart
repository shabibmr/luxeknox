import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/workout_plan_version.dart';
import '../../domain/usecases/list_workout_plan_versions_usecase.dart';

part 'workout_plan_versions_cubit.freezed.dart';

@freezed
abstract class WorkoutPlanVersionsState with _$WorkoutPlanVersionsState {
  const factory WorkoutPlanVersionsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<WorkoutPlanVersion>[]) List<WorkoutPlanVersion> versions,
    /// True after a successful fetch, so an empty history is still data.
    @Default(false) bool hasLoaded,
    String? expandedId,
    Failure? failure,
  }) = _WorkoutPlanVersionsState;
}

@injectable
class WorkoutPlanVersionsCubit extends Cubit<WorkoutPlanVersionsState> {
  WorkoutPlanVersionsCubit(this._listVersions)
    : super(const WorkoutPlanVersionsState());

  final ListWorkoutPlanVersionsUseCase _listVersions;

  Future<void> load(String planId) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _listVersions(planId);
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (versions) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          versions: versions,
          hasLoaded: true,
          expandedId: null,
        ),
      ),
    );
  }

  void toggleExpanded(String versionId) {
    if (state.status != LoadStatus.success) return;
    final next = state.expandedId == versionId ? null : versionId;
    emit(state.copyWith(expandedId: next));
  }
}
