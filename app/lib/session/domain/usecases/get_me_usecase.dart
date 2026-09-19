import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/capabilities.dart';
import '../entities/principal.dart';
import '../repositories/session_repository.dart';

@lazySingleton
class GetMeUseCase implements UseCase<(Principal, Capabilities), NoParams> {
  const GetMeUseCase(this._repository);

  final SessionRepository _repository;

  @override
  Future<Either<Failure, (Principal, Capabilities)>> call(NoParams params) {
    return _repository.getMe();
  }
}
