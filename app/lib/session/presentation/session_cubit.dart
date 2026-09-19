// Initializing formals aren't usable in SessionCubit's constructor: the
// field names are private but the named parameters must stay public for
// injectable's generated DI code (and test call sites) to construct it.
// ignore_for_file: prefer_initializing_formals

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../domain/entities/capabilities.dart';
import '../domain/entities/principal.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/restore_session_usecase.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

final class SessionUnknown extends SessionState {
  const SessionUnknown();
}

final class SessionAuthenticated extends SessionState {
  const SessionAuthenticated({
    required this.principal,
    required this.capabilities,
  });

  final Principal principal;
  final Capabilities capabilities;

  @override
  List<Object?> get props => [principal, capabilities];
}

final class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated();
}

@singleton
class SessionCubit extends Cubit<SessionState> {
  SessionCubit({
    required RestoreSessionUseCase restoreSessionUseCase,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _restoreSessionUseCase = restoreSessionUseCase,
       _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       super(const SessionUnknown());

  final RestoreSessionUseCase _restoreSessionUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> restore() async {
    final result = await _restoreSessionUseCase(const NoParams());
    result.fold(
      (_) => emit(const SessionUnauthenticated()),
      (tuple) => emit(
        SessionAuthenticated(principal: tuple.$1, capabilities: tuple.$2),
      ),
    );
  }

  /// Returns the raw [Either] so callers (e.g. `LoginCubit`) can distinguish
  /// failure reasons for messaging, while this cubit still emits the
  /// resulting [SessionState] as its single source of truth.
  Future<Either<Failure, (Principal, Capabilities)>> login(
    String identifier,
    String password,
  ) async {
    final result = await _loginUseCase(
      LoginParams(identifier: identifier, password: password),
    );
    result.fold(
      (_) => emit(const SessionUnauthenticated()),
      (tuple) => emit(
        SessionAuthenticated(principal: tuple.$1, capabilities: tuple.$2),
      ),
    );
    return result;
  }

  Future<void> logout() async {
    await _logoutUseCase(const NoParams());
    emit(const SessionUnauthenticated());
  }

  void onSignedOut() {
    emit(const SessionUnauthenticated());
  }
}
