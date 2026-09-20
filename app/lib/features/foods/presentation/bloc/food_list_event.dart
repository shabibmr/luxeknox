import 'package:equatable/equatable.dart';

import '../../domain/entities/food_filter.dart';

sealed class FoodListEvent extends Equatable {
  const FoodListEvent();

  @override
  List<Object?> get props => [];
}

final class FoodListStarted extends FoodListEvent {
  const FoodListStarted();
}

final class FoodListSearchChanged extends FoodListEvent {
  const FoodListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class FoodListFilterChanged extends FoodListEvent {
  const FoodListFilterChanged(this.filter);

  final FoodFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class FoodListNextPageRequested extends FoodListEvent {
  const FoodListNextPageRequested();
}

final class FoodListRefreshed extends FoodListEvent {
  const FoodListRefreshed();
}
