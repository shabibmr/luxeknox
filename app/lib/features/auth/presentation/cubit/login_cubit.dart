import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../session/presentation/session_cubit.dart';

enum LoginStatus { idle, submitting, failure }

class LoginState extends Equatable {
  const LoginState({this.status = LoginStatus.idle, this.errorMessage});

  final LoginStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}

/// Drives the login form. Delegates the actual login call to [SessionCubit]
/// (the single source of truth for [SessionState]) but keeps its own
/// idle/submitting/failure state for the form UI, since `SessionCubit`
/// only exposes signed-in/signed-out, not the failure reason.
@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._sessionCubit) : super(const LoginState());

  final SessionCubit _sessionCubit;

  Future<void> submit(String identifier, String password) async {
    final trimmedIdentifier = identifier.trim();
    if (trimmedIdentifier.isEmpty || password.isEmpty) {
      emit(
        const LoginState(
          status: LoginStatus.failure,
          errorMessage: 'Enter your email or phone and your password.',
        ),
      );
      return;
    }

    emit(const LoginState(status: LoginStatus.submitting));

    final result = await _sessionCubit.login(trimmedIdentifier, password);
    result.fold(
      (failure) => emit(
        LoginState(
          status: LoginStatus.failure,
          errorMessage: _messageFor(failure),
        ),
      ),
      (_) => emit(const LoginState()),
    );
  }

  /// Wrong credentials, unknown identifier, and a suspended account all map
  /// to [AuthFailure] server-side and must show the identical message
  /// (FR-AUTH-002 — never reveal whether the account exists or its status).
  String _messageFor(Failure failure) => switch (failure) {
    AuthFailure() => 'Incorrect email/phone or password.',
    RateLimitFailure() =>
      'Too many attempts. Please wait a moment and try again.',
    NetworkFailure() =>
      'Network error. Please check your connection and try again.',
    _ => 'Something went wrong. Please try again.',
  };
}
