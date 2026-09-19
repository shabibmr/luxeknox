import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/session_repository.dart';

@lazySingleton
class RefreshSessionUseCase implements UseCase<void, NoParams> {
  const RefreshSessionUseCase(this._repository);

  final SessionRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.refresh();
  }
}
