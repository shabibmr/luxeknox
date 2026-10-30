import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../domain/entities/pt_progress_review.dart';
import '../../domain/repositories/pt_progress_review_repository.dart';
import '../datasources/pt_progress_review_remote_datasource.dart';
import '../models/pt_progress_review_mapper.dart';

@LazySingleton(as: PtProgressReviewRepository)
class PtProgressReviewRepositoryImpl implements PtProgressReviewRepository {
  PtProgressReviewRepositoryImpl(this._remote);

  final PtProgressReviewRemoteDataSource _remote;

  @override
  Future<Either<Failure, PtProgressReview>> createDraft(
    PtProgressReviewDraftInput input,
  ) async {
    final problems = _validateDraft(input);
    if (problems.isNotEmpty) {
      return Left(ValidationFailure(problems));
    }
    try {
      final created = await _remote.createDraft(
        input.memberId,
        ptProgressReviewDraftToApi(input),
      );
      return Right(ptProgressReviewFromApi(created));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PtProgressReview>> get(int reviewId) async {
    try {
      return Right(ptProgressReviewFromApi(await _remote.get(reviewId)));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PtProgressReview>> updateCard(
    int reviewId,
    PtProgressReviewCardEdit edit,
  ) async {
    try {
      final updated = await _remote.updateCard(
        reviewId,
        ptProgressReviewCardEditToApi(edit),
      );
      return Right(ptProgressReviewFromApi(updated));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PtProgressReview>> trainerSign(int reviewId) async {
    try {
      return Right(
        ptProgressReviewFromApi(await _remote.trainerSign(reviewId)),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PtProgressReview>> clientSign(int reviewId) async {
    try {
      return Right(ptProgressReviewFromApi(await _remote.clientSign(reviewId)));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PtProgressReview>> managerApprove(int reviewId) async {
    try {
      return Right(
        ptProgressReviewFromApi(await _remote.managerApprove(reviewId)),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> exportPdf(int reviewId) async {
    try {
      return Right(await _remote.exportPdf(reviewId));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  /// Mirrors the server: end must not be before start (equal is allowed).
  List<String> _validateDraft(PtProgressReviewDraftInput input) {
    final problems = <String>[];
    final start = DateTime(
      input.reviewPeriodStart.year,
      input.reviewPeriodStart.month,
      input.reviewPeriodStart.day,
    );
    final end = DateTime(
      input.reviewPeriodEnd.year,
      input.reviewPeriodEnd.month,
      input.reviewPeriodEnd.day,
    );
    if (end.isBefore(start)) {
      problems.add('Review period end must not be before the start');
    }
    return problems;
  }
}
