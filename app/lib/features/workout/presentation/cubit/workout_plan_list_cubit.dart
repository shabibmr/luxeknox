import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/workout_plan_status.dart';
import '../../domain/usecases/list_workout_plans_usecase.dart';

enum WorkoutPlanListFilter { all, draft, active, archived }

sealed class WorkoutPlanListState extends Equatable {
  const WorkoutPlanListState();

  @override
  List<Object?> get props => [];
}

final class WorkoutPlanListLoading extends WorkoutPlanListState {
  const WorkoutPlanListLoading({this.filter = WorkoutPlanListFilter.all});

  final WorkoutPlanListFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class WorkoutPlanListLoaded extends WorkoutPlanListState {
  const WorkoutPlanListLoaded({
    required this.items,
    required this.filter,
  });

  final List<WorkoutPlan> items;
  final WorkoutPlanListFilter filter;

  @override
  List<Object?> get props => [items, filter];
}

final class WorkoutPlanListFailure extends WorkoutPlanListState {
  const WorkoutPlanListFailure(this.message, {required this.filter});

  final String message;
  final WorkoutPlanListFilter filter;

  @override
  List<Object?> get props => [message, filter];
}

@injectable
class WorkoutPlanListCubit extends Cubit<WorkoutPlanListState> {
  WorkoutPlanListCubit(this._listPlans)
    : super(const WorkoutPlanListLoading());

  final ListWorkoutPlansUseCase _listPlans;
  bool? _isTemplate;
  List<WorkoutPlan> _allItems = const [];

  WorkoutPlanListFilter get _filter {
    final s = state;
    return switch (s) {
      WorkoutPlanListLoading(:final filter) => filter,
      WorkoutPlanListLoaded(:final filter) => filter,
      WorkoutPlanListFailure(:final filter) => filter,
    };
  }

  Future<void> load({
    bool? isTemplate,
    WorkoutPlanListFilter? filter,
  }) async {
    if (isTemplate != null) _isTemplate = isTemplate;
    final next = filter ?? _filter;
    emit(WorkoutPlanListLoading(filter: next));
    final result = await _listPlans(
      ListWorkoutPlansParams(isTemplate: _isTemplate),
    );
    result.fold(
      (failure) => emit(
        WorkoutPlanListFailure(failureMessage(failure), filter: next),
      ),
      (page) {
        _allItems = page.items;
        emit(
          WorkoutPlanListLoaded(
            items: _applyFilter(_allItems, next),
            filter: next,
          ),
        );
      },
    );
  }

  Future<void> setFilter(WorkoutPlanListFilter filter) async {
    if (state is WorkoutPlanListLoaded || state is WorkoutPlanListFailure) {
      emit(
        WorkoutPlanListLoaded(
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
