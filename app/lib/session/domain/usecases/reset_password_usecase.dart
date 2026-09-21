import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../repositories/session_repository.dart';

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({required this.token, required this.newPassword});

  final String token;
  final String newPassword;

  @override
  List<Object?> get props => [token, newPassword];
}

@lazySingleton
class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  const ResetPasswordUseCase(this._repository);

  final SessionRepository _repository;

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) {
    return _repository.resetPassword(
      token: params.token,
      newPassword: params.newPassword,
    );
  }
}
