import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/workout_plan_status.dart';
import '../../domain/usecases/list_workout_plans_usecase.dart';

part 'workout_plan_list_cubit.freezed.dart';

enum WorkoutPlanListFilter { all, draft, active, archived }

@freezed
abstract class WorkoutPlanListState with _$WorkoutPlanListState {
  const factory WorkoutPlanListState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<WorkoutPlan>[]) List<WorkoutPlan> items,
    /// True after a successful fetch, so an empty filter result is still data.
    @Default(false) bool hasLoaded,
    @Default(WorkoutPlanListFilter.all) WorkoutPlanListFilter filter,
    Failure? failure,
  }) = _WorkoutPlanListState;
}

@injectable
class WorkoutPlanListCubit extends Cubit<WorkoutPlanListState> {
  WorkoutPlanListCubit(this._listPlans) : super(const WorkoutPlanListState());

  final ListWorkoutPlansUseCase _listPlans;
  bool? _isTemplate;
  List<WorkoutPlan> _allItems = const [];

  Future<void> load({
    bool? isTemplate,
    WorkoutPlanListFilter? filter,
  }) async {
    if (isTemplate != null) _isTemplate = isTemplate;
    final next = filter ?? state.filter;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        filter: next,
      ),
    );
    final result = await _listPlans(
      ListWorkoutPlansParams(isTemplate: _isTemplate),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          filter: next,
        ),
      ),
      (page) {
        _allItems = page.items;
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            items: _applyFilter(_allItems, next),
            hasLoaded: true,
            filter: next,
          ),
        );
      },
    );
  }

  Future<void> setFilter(WorkoutPlanListFilter filter) async {
    if (state.status == LoadStatus.success ||
        state.status == LoadStatus.failure) {
      emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          items: _applyFilter(_allItems, filter),
          filter: filter,
        ),
      );
      return;
    }
    await load(filter: filter);
  }

  List<WorkoutPlan> _applyFilter(
    List<WorkoutPlan> items,
    WorkoutPlanListFilter filter,
  ) {
    return switch (filter) {
      WorkoutPlanListFilter.all => items,
      WorkoutPlanListFilter.draft =>
        items.where((p) => p.status == WorkoutPlanStatus.draft).toList(),
      WorkoutPlanListFilter.active =>
        items.where((p) => p.status == WorkoutPlanStatus.active).toList(),
      WorkoutPlanListFilter.archived =>
        items.where((p) => p.status == WorkoutPlanStatus.archived).toList(),
    };
  }
}
