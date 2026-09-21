import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/diet_plan_meal.dart';
import '../../domain/usecases/get_diet_meal_usecase.dart';

sealed class DietMealDetailState extends Equatable {
  const DietMealDetailState();

  @override
  List<Object?> get props => [];
}

final class DietMealDetailLoading extends DietMealDetailState {
  const DietMealDetailLoading();
}

final class DietMealDetailLoaded extends DietMealDetailState {
  const DietMealDetailLoaded(this.meal);

  final DietPlanMeal meal;

  @override
  List<Object?> get props => [meal];
}

final class DietMealDetailFailure extends DietMealDetailState {
  const DietMealDetailFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class DietMealDetailCubit extends Cubit<DietMealDetailState> {
  DietMealDetailCubit(this._getMeal)
      : super(const DietMealDetailLoading());

  final GetDietMealUseCase _getMeal;

  String? _mealId;
  String? _planId;

  Future<void> load({required String mealId, String? planId}) async {
    _mealId = mealId;
    _planId = planId;
    emit(const DietMealDetailLoading());
    final result = await _getMeal(
      GetDietMealParams(mealId: mealId, planId: planId),
    );
    result.fold(
      (failure) => emit(DietMealDetailFailure(failureMessage(failure))),
      (meal) => emit(DietMealDetailLoaded(meal)),
    );
  }

  Future<void> refresh() async {
    if (_mealId == null) return;
    await load(mealId: _mealId!, planId: _planId);
  }
}
