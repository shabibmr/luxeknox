import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/system_alert.dart';
import '../../domain/usecases/list_system_alerts_usecase.dart';

sealed class SystemAlertsState extends Equatable {
  const SystemAlertsState();

  @override
  List<Object?> get props => [];
}

final class SystemAlertsLoading extends SystemAlertsState {
  const SystemAlertsLoading();
}

final class SystemAlertsLoaded extends SystemAlertsState {
  const SystemAlertsLoaded({
    required this.items,
    required this.hasMore,
    this.nextCursor,
    this.loadingMore = false,
  });

  final List<SystemAlert> items;
  final bool hasMore;
  final String? nextCursor;
  final bool loadingMore;

  @override
  List<Object?> get props => [items, hasMore, nextCursor, loadingMore];
}

final class SystemAlertsFailure extends SystemAlertsState {
  const SystemAlertsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class SystemAlertsCubit extends Cubit<SystemAlertsState> {
  SystemAlertsCubit(this._listAlerts) : super(const SystemAlertsLoading());

  final ListSystemAlertsUseCase _listAlerts;

  Future<void> load() async {
    emit(const SystemAlertsLoading());
    final result = await _listAlerts(const ListSystemAlertsParams());
    result.fold(
      (failure) => emit(SystemAlertsFailure(_message(failure))),
      (page) => emit(
        SystemAlertsLoaded(
          items: page.items,
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! SystemAlertsLoaded ||
        !current.hasMore ||
        current.loadingMore) {
      return;
    }
    emit(
      SystemAlertsLoaded(
        items: current.items,
        hasMore: current.hasMore,
        nextCursor: current.nextCursor,
        loadingMore: true,
      ),
    );
    final result = await _listAlerts(
      ListSystemAlertsParams(cursor: current.nextCursor),
    );
    result.fold(
      (failure) => emit(SystemAlertsFailure(_message(failure))),
      (page) => emit(
        SystemAlertsLoaded(
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
