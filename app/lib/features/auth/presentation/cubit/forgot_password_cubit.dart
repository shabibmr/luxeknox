import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../session/domain/usecases/forgot_password_usecase.dart';
import '../auth_strings.dart';

part 'forgot_password_cubit.freezed.dart';

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(LoadStatus.initial) LoadStatus status,
    String? errorMessage,
  }) = _ForgotPasswordState;
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
          status: LoadStatus.failure,
          errorMessage: AuthStrings.enterEmailOrPhone,
        ),
      );
      return;
    }

    emit(const ForgotPasswordState(status: LoadStatus.loading));
    final result = await _forgotPassword(
      ForgotPasswordParams(identifier: trimmed),
    );
    result.fold(
      (failure) => emit(
        ForgotPasswordState(
          status: LoadStatus.failure,
          errorMessage: _messageFor(failure),
        ),
      ),
      (_) => emit(const ForgotPasswordState(status: LoadStatus.success)),
    );
  }

  String _messageFor(Failure failure) => switch (failure) {
    RateLimitFailure() => AuthStrings.rateLimited,
    NetworkFailure() => AuthStrings.networkError,
    _ => AuthStrings.genericError,
  };
}
