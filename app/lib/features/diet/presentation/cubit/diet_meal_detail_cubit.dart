import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/diet_plan_meal.dart';
import '../../domain/usecases/get_diet_meal_usecase.dart';

part 'diet_meal_detail_cubit.freezed.dart';

@freezed
abstract class DietMealDetailState with _$DietMealDetailState {
  const factory DietMealDetailState({
    @Default(LoadStatus.initial) LoadStatus status,
    DietPlanMeal? meal,
    Failure? failure,
  }) = _DietMealDetailState;
}

@injectable
class DietMealDetailCubit extends Cubit<DietMealDetailState> {
  DietMealDetailCubit(this._getMeal) : super(const DietMealDetailState());

  final GetDietMealUseCase _getMeal;

  String? _mealId;
  String? _planId;

  Future<void> load({required String mealId, String? planId}) async {
    _mealId = mealId;
    _planId = planId;
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getMeal(
      GetDietMealParams(mealId: mealId, planId: planId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (meal) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          meal: meal,
        ),
      ),
    );
  }

  Future<void> refresh() async {
    if (_mealId == null) return;
    await load(mealId: _mealId!, planId: _planId);
  }
}
