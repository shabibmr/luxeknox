import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/pt_progress_review.dart';

/// PT progress reviews: draft → trainer sign → client sign → manager approve,
/// plus PDF presentation-card export (Screen 45).
abstract class PtProgressReviewRepository {
  Future<Either<Failure, PtProgressReview>> createDraft(
    PtProgressReviewDraftInput input,
  );

  Future<Either<Failure, PtProgressReview>> get(int reviewId);

  Future<Either<Failure, PtProgressReview>> trainerSign(int reviewId);

  Future<Either<Failure, PtProgressReview>> clientSign(int reviewId);

  Future<Either<Failure, PtProgressReview>> managerApprove(int reviewId);

  Future<Either<Failure, Uint8List>> exportPdf(int reviewId);
}
