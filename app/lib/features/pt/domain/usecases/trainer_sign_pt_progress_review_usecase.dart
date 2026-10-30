import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/pt_progress_review.dart';
import '../repositories/pt_progress_review_repository.dart';

/// Params is the review id. `draft` → `pending_client_sign`.
@lazySingleton
class TrainerSignPtProgressReviewUseCase
    implements UseCase<PtProgressReview, int> {
  const TrainerSignPtProgressReviewUseCase(this._repository);

  final PtProgressReviewRepository _repository;

  @override
  Future<Either<Failure, PtProgressReview>> call(int params) {
    return _repository.trainerSign(params);
  }
}
