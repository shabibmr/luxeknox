import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../session/domain/usecases/forgot_password_usecase.dart';
import '../auth_strings.dart';

enum ForgotPasswordStatus { idle, submitting, success, failure }

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.idle,
    this.errorMessage,
  });

  final ForgotPasswordStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._forgotPassword) : super(const ForgotPasswordState());

  final ForgotPasswordUseCase _forgotPassword;

  Future<void> submit(String identifier) async {
    final trimmed = identifier.trim();
    if (trimmed.isEmpty) {
      emit(
        const ForgotPasswordState(
          status: ForgotPasswordStatus.failure,
          errorMessage: AuthStrings.enterEmailOrPhone,
        ),
      );
      return;
    }

    emit(const ForgotPasswordState(status: ForgotPasswordStatus.submitting));
    final result = await _forgotPassword(
      ForgotPasswordParams(identifier: trimmed),
    );
    result.fold(
      (failure) => emit(
        ForgotPasswordState(
          status: ForgotPasswordStatus.failure,
          errorMessage: _messageFor(failure),
        ),
      ),
      (_) => emit(
        const ForgotPasswordState(status: ForgotPasswordStatus.success),
      ),
    );
  }

  String _messageFor(Failure failure) => switch (failure) {
    RateLimitFailure() => AuthStrings.rateLimited,
    NetworkFailure() => AuthStrings.networkError,
    _ => AuthStrings.genericError,
  };
}
