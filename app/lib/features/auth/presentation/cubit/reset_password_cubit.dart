import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../session/domain/usecases/reset_password_usecase.dart';
import '../auth_strings.dart';

enum ResetPasswordStatus { idle, submitting, success, failure }

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.status = ResetPasswordStatus.idle,
    this.errorMessage,
  });

  final ResetPasswordStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._resetPassword) : super(const ResetPasswordState());

  final ResetPasswordUseCase _resetPassword;

  Future<void> submit({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final trimmedToken = token.trim();
    if (trimmedToken.isEmpty) {
      emit(
        const ResetPasswordState(
          status: ResetPasswordStatus.failure,
          errorMessage: AuthStrings.enterResetToken,
        ),
      );
      return;
    }
    if (newPassword.length < 8) {
      emit(
        const ResetPasswordState(
          status: ResetPasswordStatus.failure,
          errorMessage: AuthStrings.passwordTooShort,
        ),
      );
      return;
    }
    if (newPassword != confirmPassword) {
      emit(
        const ResetPasswordState(
          status: ResetPasswordStatus.failure,
          errorMessage: AuthStrings.passwordsDoNotMatch,
        ),
      );
      return;
    }

    emit(const ResetPasswordState(status: ResetPasswordStatus.submitting));
    final result = await _resetPassword(
      ResetPasswordParams(token: trimmedToken, newPassword: newPassword),
    );
    result.fold(
      (failure) => emit(
        ResetPasswordState(
          status: ResetPasswordStatus.failure,
          errorMessage: _messageFor(failure),
        ),
      ),
      (_) =>
          emit(const ResetPasswordState(status: ResetPasswordStatus.success)),
    );
  }

  String _messageFor(Failure failure) => switch (failure) {
    AuthFailure() => AuthStrings.genericError,
    ValidationFailure(:final details) =>
      details.isEmpty ? AuthStrings.genericError : details.first,
    RateLimitFailure() => AuthStrings.rateLimited,
    NetworkFailure() => AuthStrings.networkError,
    _ => AuthStrings.genericError,
  };
}
