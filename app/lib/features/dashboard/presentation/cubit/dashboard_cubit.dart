import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

/// `loading` is the first, empty-state fetch; `refreshing` is a reload that
/// still has a previous [DashboardState.snapshot] to show underneath
/// (DSH cache-last-successful / section-loading tasks).
enum DashboardStatus { initial, loading, refreshing, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.snapshot,
    this.failure,
  });

  final DashboardStatus status;
  final DashboardSnapshot? snapshot;
  final Failure? failure;

  bool get hasData => snapshot != null;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSnapshot? snapshot,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return DashboardState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, snapshot, failure];
}

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._getDashboardUseCase) : super(const DashboardState());

  final GetDashboardUseCase _getDashboardUseCase;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: state.hasData
            ? DashboardStatus.refreshing
            : DashboardStatus.loading,
        clearFailure: true,
      ),
    );

    final result = await _getDashboardUseCase(const NoParams());

    result.fold(
      // Keep the last successful snapshot visible behind a failed refresh
      // rather than blanking the screen (cache-last-successful).
      (failure) => emit(
        state.copyWith(status: DashboardStatus.failure, failure: failure),
      ),
      (snapshot) => emit(
        DashboardState(status: DashboardStatus.success, snapshot: snapshot),
      ),
    );
  }

  Future<void> refresh() => load();
}
