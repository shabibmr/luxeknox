import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/capabilities.dart';
import '../entities/principal.dart';
import '../repositories/session_repository.dart';

class LoginParams extends Equatable {
  const LoginParams({required this.identifier, required this.password});

  final String identifier;
  final String password;

  @override
  List<Object?> get props => [identifier, password];
}

@lazySingleton
class LoginUseCase implements UseCase<(Principal, Capabilities), LoginParams> {
  const LoginUseCase(this._repository);

  final SessionRepository _repository;

  @override
  Future<Either<Failure, (Principal, Capabilities)>> call(LoginParams params) {
    return _repository.login(params.identifier, params.password);
  }
}
