import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/par_q_inputs.dart';
import '../entities/par_q_screening.dart';
import '../repositories/par_q_repository.dart';

@lazySingleton
class ReviewParQUseCase implements UseCase<ParQScreening, ParQTrainerReviewInput> {
  const ReviewParQUseCase(this._repository);

  final ParQRepository _repository;

  @override
  Future<Either<Failure, ParQScreening>> call(ParQTrainerReviewInput params) {
    return _repository.trainerReview(params);
  }
}
