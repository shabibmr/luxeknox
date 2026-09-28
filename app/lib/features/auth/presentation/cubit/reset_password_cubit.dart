import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../session/domain/usecases/reset_password_usecase.dart';
import '../auth_strings.dart';

part 'reset_password_cubit.freezed.dart';

@freezed
abstract class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default(LoadStatus.initial) LoadStatus status,
    String? errorMessage,
  }) = _ResetPasswordState;
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
          status: LoadStatus.failure,
          errorMessage: AuthStrings.enterResetToken,
        ),
      );
      return;
    }
    if (newPassword.length < 8) {
      emit(
        const ResetPasswordState(
          status: LoadStatus.failure,
          errorMessage: AuthStrings.passwordTooShort,
        ),
      );
      return;
    }
    if (newPassword != confirmPassword) {
      emit(
        const ResetPasswordState(
          status: LoadStatus.failure,
          errorMessage: AuthStrings.passwordsDoNotMatch,
        ),
      );
      return;
    }

    emit(const ResetPasswordState(status: LoadStatus.loading));
    final result = await _resetPassword(
      ResetPasswordParams(token: trimmedToken, newPassword: newPassword),
    );
    result.fold(
      (failure) => emit(
        ResetPasswordState(
          status: LoadStatus.failure,
          errorMessage: _messageFor(failure),
        ),
      ),
      (_) => emit(const ResetPasswordState(status: LoadStatus.success)),
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
