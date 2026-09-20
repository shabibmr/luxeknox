import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/food.dart';
import '../entities/food_filter.dart';
import '../repositories/food_repository.dart';

class GetFoodsParams extends Equatable {
  const GetFoodsParams({this.filter = const FoodFilter(), this.cursor});

  final FoodFilter filter;
  final String? cursor;

  @override
  List<Object?> get props => [filter, cursor];
}

@lazySingleton
class GetFoodsUseCase implements UseCase<CursorPage<Food>, GetFoodsParams> {
  const GetFoodsUseCase(this._repository);

  final FoodRepository _repository;

  @override
  Future<Either<Failure, CursorPage<Food>>> call(GetFoodsParams params) {
    return _repository.getFoods(params.filter, params.cursor);
  }
}
