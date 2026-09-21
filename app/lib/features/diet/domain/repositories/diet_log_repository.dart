import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/diet_log.dart';

abstract class DietLogRepository {
  Future<Either<Failure, DietLog>> recordDietLog({
    required String memberId,
    required DateTime date,
    String? dietPlanId,
    num? totalCaloriesConsumed,
    num? adherenceScore,
    int? waterIntakeMl,
    String? memberNotes,
  });

  Future<Either<Failure, CursorPage<DietLog>>> listDietLogs({
    required String memberId,
    int? limit,
    String? cursor,
  });
}
