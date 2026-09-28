import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../foods/domain/entities/food.dart';
import '../../../foods/domain/entities/food_filter.dart';
import '../../../foods/domain/usecases/get_foods_usecase.dart';

part 'food_picker_cubit.freezed.dart';

@freezed
abstract class FoodPickerState with _$FoodPickerState {
  const factory FoodPickerState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<Food>[]) List<Food> items,
    Failure? failure,
  }) = _FoodPickerState;
}

@injectable
class FoodPickerCubit extends Cubit<FoodPickerState> {
  FoodPickerCubit(this._getFoods) : super(const FoodPickerState());

  final GetFoodsUseCase _getFoods;

  /// Refresh keeps [FoodPickerState.items]. Failure does too.
  Future<void> load({String? search}) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final text = search?.trim();
    final result = await _getFoods(
      GetFoodsParams(
        filter: FoodFilter(
          query: (text == null || text.isEmpty) ? null : text,
        ),
      ),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: page.items,
          failure: null,
        ),
      ),
    );
  }
}
