import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/entities/diet_plan_status.dart';
import '../../domain/usecases/list_diet_plans_usecase.dart';

enum DietPlanListFilter { all, draft, active, archived, templates }

sealed class DietPlanListState extends Equatable {
  const DietPlanListState();

  @override
  List<Object?> get props => [];
}

final class DietPlanListLoading extends DietPlanListState {
  const DietPlanListLoading({this.filter = DietPlanListFilter.all});

  final DietPlanListFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class DietPlanListLoaded extends DietPlanListState {
  const DietPlanListLoaded({
    required this.items,
    required this.filter,
  });

  final List<DietPlan> items;
  final DietPlanListFilter filter;

  @override
  List<Object?> get props => [items, filter];
}

final class DietPlanListFailure extends DietPlanListState {
  const DietPlanListFailure(this.message, {required this.filter});

  final String message;
  final DietPlanListFilter filter;

  @override
  List<Object?> get props => [message, filter];
}

@injectable
class DietPlanListCubit extends Cubit<DietPlanListState> {
  DietPlanListCubit(this._listPlans) : super(const DietPlanListLoading());

  final ListDietPlansUseCase _listPlans;
  bool? _isTemplate;
  List<DietPlan> _allItems = const [];

  DietPlanListFilter get _filter {
    final s = state;
    return switch (s) {
      DietPlanListLoading(:final filter) => filter,
      DietPlanListLoaded(:final filter) => filter,
      DietPlanListFailure(:final filter) => filter,
    };
  }

  Future<void> load({
    bool? isTemplate,
    DietPlanListFilter? filter,
  }) async {
    if (isTemplate != null) _isTemplate = isTemplate;
    final next = filter ?? _filter;
    emit(DietPlanListLoading(filter: next));
    final result = await _listPlans(
      ListDietPlansParams(isTemplate: _isTemplate),
    );
    result.fold(
      (failure) => emit(
        DietPlanListFailure(failureMessage(failure), filter: next),
      ),
      (page) {
        _allItems = page.items;
        emit(
          DietPlanListLoaded(
            items: _applyFilter(_allItems, next),
            filter: next,
          ),
        );
      },
    );
  }

  Future<void> setFilter(DietPlanListFilter filter) async {
    if (state is DietPlanListLoaded || state is DietPlanListFailure) {
      emit(
        DietPlanListLoaded(
          items: _applyFilter(_allItems, filter),
          filter: filter,
        ),
      );
      return;
    }
    await load(filter: filter);
  }

  List<DietPlan> _applyFilter(
    List<DietPlan> items,
    DietPlanListFilter filter,
  ) {
    return switch (filter) {
      DietPlanListFilter.all => items,
      DietPlanListFilter.draft =>
        items.where((p) => p.status == DietPlanStatus.draft).toList(),
      DietPlanListFilter.active =>
        items.where((p) => p.status == DietPlanStatus.active).toList(),
      DietPlanListFilter.archived =>
        items.where((p) => p.status == DietPlanStatus.archived).toList(),
      DietPlanListFilter.templates =>
        items.where((p) => p.isTemplate).toList(),
    };
  }
}
