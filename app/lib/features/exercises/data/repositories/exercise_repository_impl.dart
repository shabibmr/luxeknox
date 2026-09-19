import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_filter.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_datasource.dart';
import '../models/exercise_model.dart';

@LazySingleton(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  ExerciseRepositoryImpl(this._remoteDataSource);

  final ExerciseRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, CursorPage<Exercise>>> getExercises(
    ExerciseFilter filter,
    String? cursor,
  ) async {
    try {
      final page = await _remoteDataSource.getExercises(
        filter: filter,
        cursor: cursor,
      );
      final items = page.data.map((m) => m.toDomain()).toList();
      return Right(
        CursorPage<Exercise>(
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
  Future<Either<Failure, Exercise>> getExercise(String id) async {
    try {
      final intId = int.tryParse(id);
      if (intId == null) {
        return const Left(NotFoundFailure());
      }
      final model = await _remoteDataSource.getExercise(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Exercise>> create(Exercise exercise) async {
    try {
      final created = await _remoteDataSource.createExercise(
        exercise.toWriteModel(),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Exercise>> update(Exercise exercise) async {
    try {
      final intId = int.tryParse(exercise.id);
      if (intId == null) {
        return const Left(NotFoundFailure());
      }
      final updated = await _remoteDataSource.updateExercise(
        intId,
        exercise.toWriteModel(),
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
      final exercise = await _remoteDataSource.getExercise(intId);
      final write = exercise
          .toDomain()
          .copyWith(isActive: false)
          .toWriteModel();
      await _remoteDataSource.updateExercise(intId, write);
      return const Right(null);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
