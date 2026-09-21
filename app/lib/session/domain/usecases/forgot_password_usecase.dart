import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/session_repository.dart';

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({required this.identifier});

  final String identifier;

  @override
  List<Object?> get props => [identifier];
}

@lazySingleton
class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  const ForgotPasswordUseCase(this._repository);

  final SessionRepository _repository;

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) {
    return _repository.forgotPassword(params.identifier);
  }
}
