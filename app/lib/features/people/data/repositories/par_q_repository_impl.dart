import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../domain/entities/par_q_inputs.dart';
import '../../domain/entities/par_q_screening.dart';
import '../../domain/repositories/par_q_repository.dart';
import '../datasources/par_q_remote_datasource.dart';
import '../models/par_q_mapper.dart';

@LazySingleton(as: ParQRepository)
class ParQRepositoryImpl implements ParQRepository {
  ParQRepositoryImpl(this._remote);

  final ParQRemoteDataSource _remote;

  @override
  Future<Either<Failure, ParQScreening>> submit(
    ParQSubmission submission,
  ) async {
    if (!submission.declarationAccepted) {
      return const Left(
        ValidationFailure(['The legal declaration must be accepted']),
      );
    }
    try {
      final saved = await _remote.submit(
        submission.memberId,
        parQSubmitToApi(submission),
      );
      return Right(parQScreeningFromApi(saved));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ParQScreening>> trainerReview(
    ParQTrainerReviewInput review,
  ) async {
    try {
      final saved = await _remote.review(
        review.memberId,
        parQTrainerReviewToApi(review),
      );
      return Right(parQScreeningFromApi(saved));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ParQScreening>> clear(
    ParQClearanceInput clearance,
  ) async {
    try {
      final saved = await _remote.clear(
        clearance.memberId,
        parQClearanceToApi(clearance),
      );
      return Right(parQScreeningFromApi(saved));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
