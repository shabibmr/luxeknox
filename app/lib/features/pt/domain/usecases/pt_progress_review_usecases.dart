import 'dart:typed_data';

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

/// Params is the review id.
@lazySingleton
class GetPtProgressReviewUseCase implements UseCase<PtProgressReview, int> {
  const GetPtProgressReviewUseCase(this._repository);

  final PtProgressReviewRepository _repository;

  @override
  Future<Either<Failure, PtProgressReview>> call(int params) {
    return _repository.get(params);
  }
}

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

/// Params is the review id. `pending_client_sign` → `pending_manager_approval`.
@lazySingleton
class ClientSignPtProgressReviewUseCase
    implements UseCase<PtProgressReview, int> {
  const ClientSignPtProgressReviewUseCase(this._repository);

  final PtProgressReviewRepository _repository;

  @override
  Future<Either<Failure, PtProgressReview>> call(int params) {
    return _repository.clientSign(params);
  }
}

/// Params is the review id. `pending_manager_approval` → `approved`.
@lazySingleton
class ManagerApprovePtProgressReviewUseCase
    implements UseCase<PtProgressReview, int> {
  const ManagerApprovePtProgressReviewUseCase(this._repository);

  final PtProgressReviewRepository _repository;

  @override
  Future<Either<Failure, PtProgressReview>> call(int params) {
    return _repository.managerApprove(params);
  }
}

/// Params is the review id. Returns the presentation-card PDF bytes.
@lazySingleton
class ExportPtProgressReviewPdfUseCase implements UseCase<Uint8List, int> {
  const ExportPtProgressReviewPdfUseCase(this._repository);

  final PtProgressReviewRepository _repository;

  @override
  Future<Either<Failure, Uint8List>> call(int params) {
    return _repository.exportPdf(params);
  }
}
