import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/lifestyle_intake.dart';
import '../repositories/lifestyle_intake_repository.dart';

/// Params is the member id.
@lazySingleton
class GetLifestyleIntakeUseCase implements UseCase<LifestyleIntake, int> {
  const GetLifestyleIntakeUseCase(this._repository);

  final LifestyleIntakeRepository _repository;

  @override
  Future<Either<Failure, LifestyleIntake>> call(int params) {
    return _repository.get(params);
  }
}
