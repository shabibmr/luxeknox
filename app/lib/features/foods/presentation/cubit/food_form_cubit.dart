import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/food.dart';
import '../../domain/usecases/create_food_usecase.dart';
import '../../domain/usecases/deactivate_food_usecase.dart';
import '../../domain/usecases/update_food_usecase.dart';

part 'food_form_cubit.freezed.dart';

@freezed
abstract class FoodFormState with _$FoodFormState {
  const factory FoodFormState({
    @Default(LoadStatus.initial) LoadStatus status,
    Failure? failure,
  }) = _FoodFormState;
}

@injectable
class FoodFormCubit extends Cubit<FoodFormState> {
  FoodFormCubit(
    this._createFood,
    this._updateFood,
    this._deactivateFood,
  ) : super(const FoodFormState());

  final CreateFoodUseCase _createFood;
  final UpdateFoodUseCase _updateFood;
  final DeactivateFoodUseCase _deactivateFood;

  Future<void> create(Food food) {
    return _run(() => _createFood(food));
  }

  Future<void> update(Food food) {
    return _run(() => _updateFood(food));
  }

  Future<void> deactivate(String id) {
    return _run(() => _deactivateFood(id));
  }

  Future<void> _run<T>(Future<Either<Failure, T>> Function() action) async {
    emit(const FoodFormState(status: LoadStatus.loading));
    final result = await action();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        FoodFormState(status: LoadStatus.failure, failure: failure),
      ),
      (_) => emit(const FoodFormState(status: LoadStatus.success)),
    );
  }
}
