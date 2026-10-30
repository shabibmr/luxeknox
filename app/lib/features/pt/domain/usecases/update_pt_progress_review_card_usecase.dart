import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/pt_progress_review.dart';
import '../repositories/pt_progress_review_repository.dart';

/// Saves highlights and checklist on a draft review.
class UpdatePtProgressReviewCardParams {
  const UpdatePtProgressReviewCardParams(this.reviewId, this.edit);

  final int reviewId;
  final PtProgressReviewCardEdit edit;
}

@lazySingleton
class UpdatePtProgressReviewCardUseCase
    implements UseCase<PtProgressReview, UpdatePtProgressReviewCardParams> {
  const UpdatePtProgressReviewCardUseCase(this._repository);

  final PtProgressReviewRepository _repository;

  @override
  Future<Either<Failure, PtProgressReview>> call(
    UpdatePtProgressReviewCardParams params,
  ) {
    return _repository.updateCard(params.reviewId, params.edit);
  }
}
