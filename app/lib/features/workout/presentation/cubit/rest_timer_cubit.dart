import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

class RestTimerState extends Equatable {
  const RestTimerState({
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.isRunning,
    required this.isFinished,
  });

  const RestTimerState.idle()
      : remainingSeconds = 0,
        totalSeconds = 0,
        isRunning = false,
        isFinished = false;

  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final bool isFinished;

  RestTimerState copyWith({
    int? remainingSeconds,
    int? totalSeconds,
    bool? isRunning,
    bool? isFinished,
  }) {
    return RestTimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  @override
  List<Object?> get props => [
    remainingSeconds,
    totalSeconds,
    isRunning,
    isFinished,
  ];
}

/// Client-only rest countdown. No API.
@injectable
class RestTimerCubit extends Cubit<RestTimerState> {
  RestTimerCubit({@ignoreParam this.ticker}) : super(const RestTimerState.idle());

  /// Optional tick stream factory for tests (emits once per second).
  final Stream<void> Function()? ticker;

  StreamSubscription<void>? _subscription;

  void start(int seconds) {
    _subscription?.cancel();
    final total = seconds < 0 ? 0 : seconds;
    if (total == 0) {
      emit(
        const RestTimerState(
          remainingSeconds: 0,
          totalSeconds: 0,
          isRunning: false,
          isFinished: true,
        ),
      );
      return;
    }
    emit(
      RestTimerState(
        remainingSeconds: total,
        totalSeconds: total,
        isRunning: true,
        isFinished: false,
      ),
    );
    final stream = ticker?.call() ?? Stream.periodic(const Duration(seconds: 1));
    _subscription = stream.listen((_) => _tick());
  }

  void _tick() {
    if (!state.isRunning) return;
    final next = state.remainingSeconds - 1;
    if (next <= 0) {
      _subscription?.cancel();
      _subscription = null;
      emit(
        state.copyWith(
          remainingSeconds: 0,
          isRunning: false,
          isFinished: true,
        ),
      );
      return;
    }
    emit(state.copyWith(remainingSeconds: next));
  }

  void skip() {
    _subscription?.cancel();
    _subscription = null;
    emit(
      state.copyWith(
        remainingSeconds: 0,
        isRunning: false,
        isFinished: true,
      ),
    );
  }

  void cancel() {
    _subscription?.cancel();
    _subscription = null;
    emit(const RestTimerState.idle());
  }

  void addSeconds(int seconds) {
    if (!state.isRunning && !state.isFinished && state.totalSeconds == 0) {
      return;
    }
    final remaining = state.remainingSeconds + seconds;
    final total = state.totalSeconds + seconds;
    final wasFinished = state.isFinished;
    emit(
      state.copyWith(
        remainingSeconds: remaining < 0 ? 0 : remaining,
        totalSeconds: total < 0 ? 0 : total,
        isRunning: remaining > 0,
        isFinished: remaining <= 0,
      ),
    );
    if (wasFinished && remaining > 0) {
      _subscription?.cancel();
      final stream =
          ticker?.call() ?? Stream.periodic(const Duration(seconds: 1));
      _subscription = stream.listen((_) => _tick());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
