import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../session/domain/usecases/change_password_usecase.dart';
import '../auth_strings.dart';

enum ChangePasswordStatus { idle, submitting, success, failure }

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.status = ChangePasswordStatus.idle,
    this.errorMessage,
  });

  final ChangePasswordStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._changePassword)
    : super(const ChangePasswordState());

  final ChangePasswordUseCase _changePassword;

  Future<void> submit({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      emit(
        const ChangePasswordState(
          status: ChangePasswordStatus.failure,
          errorMessage: AuthStrings.enterPassword,
        ),
      );
      return;
    }
    if (newPassword.length < 8) {
      emit(
        const ChangePasswordState(
          status: ChangePasswordStatus.failure,
          errorMessage: AuthStrings.passwordTooShort,
        ),
      );
      return;
    }
    if (newPassword != confirmPassword) {
      emit(
        const ChangePasswordState(
          status: ChangePasswordStatus.failure,
          errorMessage: AuthStrings.passwordsDoNotMatch,
        ),
      );
      return;
    }

    emit(const ChangePasswordState(status: ChangePasswordStatus.submitting));
    final result = await _changePassword(
      ChangePasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
    result.fold(
      (failure) => emit(
        ChangePasswordState(
          status: ChangePasswordStatus.failure,
          errorMessage: _messageFor(failure),
        ),
      ),
      (_) => emit(
        const ChangePasswordState(status: ChangePasswordStatus.success),
      ),
    );
  }

  String _messageFor(Failure failure) => switch (failure) {
    AuthFailure() => AuthStrings.incorrectCredentials,
    ValidationFailure(:final details) =>
      details.isEmpty ? AuthStrings.genericError : details.first,
    RateLimitFailure() => AuthStrings.rateLimited,
    NetworkFailure() => AuthStrings.networkError,
    _ => AuthStrings.genericError,
  };
}
