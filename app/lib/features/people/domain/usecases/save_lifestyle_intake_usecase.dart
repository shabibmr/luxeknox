import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/lifestyle_intake.dart';
import '../repositories/lifestyle_intake_repository.dart';

@lazySingleton
class SaveLifestyleIntakeUseCase
    implements UseCase<LifestyleIntake, LifestyleIntakeInput> {
  const SaveLifestyleIntakeUseCase(this._repository);

  final LifestyleIntakeRepository _repository;

  @override
  Future<Either<Failure, LifestyleIntake>> call(LifestyleIntakeInput params) {
    return _repository.save(params);
  }
}
