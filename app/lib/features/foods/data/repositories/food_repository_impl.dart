import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/food_filter.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/food_remote_datasource.dart';
import '../models/food_model.dart';

@LazySingleton(as: FoodRepository)
class FoodRepositoryImpl implements FoodRepository {
  FoodRepositoryImpl(this._remoteDataSource);

  final FoodRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, CursorPage<Food>>> getFoods(
    FoodFilter filter,
    String? cursor,
  ) async {
    try {
      final page = await _remoteDataSource.getFoods(
        filter: filter,
        cursor: cursor,
      );
      final items = page.data.map((m) => m.toDomain()).toList();
      return Right(
        CursorPage<Food>(
          items: items,
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Food>> getFood(String id) async {
    try {
      final intId = int.tryParse(id);
      if (intId == null) {
        return const Left(NotFoundFailure());
      }
      final model = await _remoteDataSource.getFood(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Food>> create(Food food) async {
    try {
      final created = await _remoteDataSource.createFood(food.toWriteModel());
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Food>> update(Food food) async {
    try {
      final intId = int.tryParse(food.id);
      if (intId == null) {
        return const Left(NotFoundFailure());
      }
      final updated = await _remoteDataSource.updateFood(
        intId,
        food.toWriteModel(),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deactivate(String id) async {
    try {
      final intId = int.tryParse(id);
      if (intId == null) {
        return const Left(NotFoundFailure());
      }
      final food = await _remoteDataSource.getFood(intId);
      final write = food.toDomain().copyWith(isVerified: false).toWriteModel();
      await _remoteDataSource.updateFood(intId, write);
      return const Right(null);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
