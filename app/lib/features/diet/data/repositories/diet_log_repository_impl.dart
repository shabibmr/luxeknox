import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/diet_log.dart';
import '../../domain/repositories/diet_log_repository.dart';
import '../datasources/diet_log_remote_datasource.dart';
import '../models/diet_log_mappers.dart';

@LazySingleton(as: DietLogRepository)
class DietLogRepositoryImpl implements DietLogRepository {
  DietLogRepositoryImpl(this._remoteDataSource);

  final DietLogRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, DietLog>> recordDietLog({
    required String memberId,
    required DateTime date,
    String? dietPlanId,
    num? totalCaloriesConsumed,
    num? adherenceScore,
    int? waterIntakeMl,
    String? memberNotes,
  }) async {
    final intMemberId = int.tryParse(memberId);
    if (intMemberId == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final logged = await _remoteDataSource.recordDietLog(
        memberId: intMemberId,
        date: date.toDate(),
        write: toDietLogWrite(
          dietPlanId: dietPlanId,
          totalCaloriesConsumed: totalCaloriesConsumed,
          adherenceScore: adherenceScore,
          waterIntakeMl: waterIntakeMl,
          memberNotes: memberNotes,
        ),
      );
      return Right(logged.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CursorPage<DietLog>>> listDietLogs({
    required String memberId,
    int? limit,
    String? cursor,
  }) async {
    final intMemberId = int.tryParse(memberId);
    if (intMemberId == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final resultPage = await _remoteDataSource.listDietLogs(
        memberId: intMemberId,
        limit: limit,
        cursor: cursor,
      );
      return Right(
        CursorPage<DietLog>(
          items: resultPage.data.map((l) => l.toDomain()).toList(),
          nextCursor: resultPage.meta.nextCursor,
          hasMore: resultPage.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
