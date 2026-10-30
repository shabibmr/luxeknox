import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/par_q_screening.dart';
import '../repositories/par_q_repository.dart';

/// Params is the member id. [NotFoundFailure] when no screening is on file.
@lazySingleton
class GetParQUseCase implements UseCase<ParQScreening, int> {
  const GetParQUseCase(this._repository);

  final ParQRepository _repository;

  @override
  Future<Either<Failure, ParQScreening>> call(int params) {
    return _repository.getLatest(params);
  }
}
