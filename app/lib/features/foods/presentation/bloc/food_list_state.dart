import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/food_filter.dart';

enum FoodListStatus { initial, loading, success, failure }

class FoodListState extends Equatable {
  const FoodListState({
    this.status = FoodListStatus.initial,
    this.items = const <Food>[],
    this.filter = const FoodFilter(),
    this.cursor,
    this.hasMore = false,
    this.failure,
  });

  final FoodListStatus status;
  final List<Food> items;
  final FoodFilter filter;
  final String? cursor;
  final bool hasMore;
  final Failure? failure;

  FoodListState copyWith({
    FoodListStatus? status,
    List<Food>? items,
    FoodFilter? filter,
    String? cursor,
    bool clearCursor = false,
    bool? hasMore,
    Failure? failure,
  }) {
    return FoodListState(
      status: status ?? this.status,
      items: items ?? this.items,
      filter: filter ?? this.filter,
      cursor: clearCursor ? null : (cursor ?? this.cursor),
      hasMore: hasMore ?? this.hasMore,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, items, filter, cursor, hasMore, failure];
}
