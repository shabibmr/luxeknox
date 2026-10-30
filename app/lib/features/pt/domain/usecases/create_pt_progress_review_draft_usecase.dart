import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/pt_progress_review.dart';
import '../repositories/pt_progress_review_repository.dart';

@lazySingleton
class CreatePtProgressReviewDraftUseCase
    implements UseCase<PtProgressReview, PtProgressReviewDraftInput> {
  const CreatePtProgressReviewDraftUseCase(this._repository);

  final PtProgressReviewRepository _repository;

  @override
  Future<Either<Failure, PtProgressReview>> call(
    PtProgressReviewDraftInput params,
  ) {
    return _repository.createDraft(params);
  }
}
