import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/entities/diet_plan_status.dart';
import '../../domain/usecases/list_diet_plans_usecase.dart';

part 'diet_plan_list_cubit.freezed.dart';

enum DietPlanListFilter { all, draft, active, archived, templates }

@freezed
abstract class DietPlanListState with _$DietPlanListState {
  const factory DietPlanListState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<DietPlan>[]) List<DietPlan> items,
    @Default(DietPlanListFilter.all) DietPlanListFilter filter,
    Failure? failure,
  }) = _DietPlanListState;
}

@injectable
class DietPlanListCubit extends Cubit<DietPlanListState> {
  DietPlanListCubit(this._listPlans) : super(const DietPlanListState());

  final ListDietPlansUseCase _listPlans;
  bool? _isTemplate;
  List<DietPlan> _allItems = const [];

  Future<void> load({
    bool? isTemplate,
    DietPlanListFilter? filter,
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
      ListDietPlansParams(isTemplate: _isTemplate),
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
            filter: next,
            items: _applyFilter(_allItems, next),
          ),
        );
      },
    );
  }

  Future<void> setFilter(DietPlanListFilter filter) async {
    if (state.status == LoadStatus.success ||
        state.status == LoadStatus.failure) {
      emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          filter: filter,
          items: _applyFilter(_allItems, filter),
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
