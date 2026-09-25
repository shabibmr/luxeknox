import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../session/domain/usecases/change_password_usecase.dart';
import '../auth_strings.dart';

part 'change_password_cubit.freezed.dart';

@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default(LoadStatus.initial) LoadStatus status,
    String? errorMessage,
  }) = _ChangePasswordState;
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
          status: LoadStatus.failure,
          errorMessage: AuthStrings.enterPassword,
        ),
      );
      return;
    }
    if (newPassword.length < 8) {
      emit(
        const ChangePasswordState(
          status: LoadStatus.failure,
          errorMessage: AuthStrings.passwordTooShort,
        ),
      );
      return;
    }
    if (newPassword != confirmPassword) {
      emit(
        const ChangePasswordState(
          status: LoadStatus.failure,
          errorMessage: AuthStrings.passwordsDoNotMatch,
        ),
      );
      return;
    }

    emit(const ChangePasswordState(status: LoadStatus.loading));
    final result = await _changePassword(
      ChangePasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
    result.fold(
      (failure) => emit(
        ChangePasswordState(
          status: LoadStatus.failure,
          errorMessage: _messageFor(failure),
        ),
      ),
      (_) => emit(const ChangePasswordState(status: LoadStatus.success)),
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
