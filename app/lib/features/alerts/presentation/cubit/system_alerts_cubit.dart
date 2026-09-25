import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/system_alert.dart';
import '../../domain/usecases/list_system_alerts_usecase.dart';

part 'system_alerts_cubit.freezed.dart';

@freezed
abstract class SystemAlertsState with _$SystemAlertsState {
  const factory SystemAlertsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<SystemAlert>[]) List<SystemAlert> items,
    @Default(false) bool hasMore,
    String? nextCursor,
    @Default(false) bool loadingMore,
    Failure? failure,
  }) = _SystemAlertsState;
}

@injectable
class SystemAlertsCubit extends Cubit<SystemAlertsState> {
  SystemAlertsCubit(this._listAlerts) : super(const SystemAlertsState());

  final ListSystemAlertsUseCase _listAlerts;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        loadingMore: false,
      ),
    );
    final result = await _listAlerts(const ListSystemAlertsParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: page.items,
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          failure: null,
          loadingMore: false,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current.status == LoadStatus.loading || current.loadingMore) return;
    if (!current.hasMore) return;
    if (current.items.isEmpty && current.status != LoadStatus.success) {
      return;
    }
    emit(current.copyWith(loadingMore: true, failure: null));
    final result = await _listAlerts(
      ListSystemAlertsParams(cursor: current.nextCursor),
    );
    result.fold(
      (failure) => emit(
        current.copyWith(
          status: LoadStatus.failure,
          loadingMore: false,
          failure: failure,
        ),
      ),
      (page) => emit(
        current.copyWith(
          status: LoadStatus.success,
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
          nextCursor: page.nextCursor ?? current.nextCursor,
          loadingMore: false,
          failure: null,
        ),
      ),
    );
  }
}
