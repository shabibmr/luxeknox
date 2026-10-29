import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/par_q_inputs.dart';
import '../entities/par_q_screening.dart';
import '../repositories/par_q_repository.dart';

@lazySingleton
class ClearParQUseCase implements UseCase<ParQScreening, ParQClearanceInput> {
  const ClearParQUseCase(this._repository);

  final ParQRepository _repository;

  @override
  Future<Either<Failure, ParQScreening>> call(ParQClearanceInput params) {
    return _repository.clear(params);
  }
}
