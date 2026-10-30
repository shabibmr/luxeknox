import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/pt_progress_review_repository.dart';

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
