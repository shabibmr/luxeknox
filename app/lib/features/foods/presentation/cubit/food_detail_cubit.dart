import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/food.dart';
import '../../domain/usecases/get_food_usecase.dart';

enum FoodDetailStatus { initial, loading, success, failure }

class FoodDetailState extends Equatable {
  const FoodDetailState({
    this.status = FoodDetailStatus.initial,
    this.food,
    this.failure,
  });

  final FoodDetailStatus status;
  final Food? food;
  final Failure? failure;

  FoodDetailState copyWith({
    FoodDetailStatus? status,
    Food? food,
    Failure? failure,
  }) {
    return FoodDetailState(
      status: status ?? this.status,
      food: food ?? this.food,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, food, failure];
}

@injectable
class FoodDetailCubit extends Cubit<FoodDetailState> {
  FoodDetailCubit(this._getFoodUseCase) : super(const FoodDetailState());

  final GetFoodUseCase _getFoodUseCase;

  Future<void> loadFood(String id) async {
    emit(state.copyWith(status: FoodDetailStatus.loading, failure: null));

    final result = await _getFoodUseCase(id);

    result.fold(
      (failure) => emit(
        state.copyWith(status: FoodDetailStatus.failure, failure: failure),
      ),
      (food) =>
          emit(state.copyWith(status: FoodDetailStatus.success, food: food)),
    );
  }
}
