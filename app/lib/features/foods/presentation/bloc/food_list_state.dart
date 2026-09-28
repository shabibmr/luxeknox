import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/food_filter.dart';

part 'food_list_state.freezed.dart';

@freezed
abstract class FoodListState with _$FoodListState {
  const factory FoodListState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<Food>[]) List<Food> items,
    @Default(FoodFilter()) FoodFilter filter,
    String? cursor,
    @Default(false) bool hasMore,
    Failure? failure,
  }) = _FoodListState;
}
