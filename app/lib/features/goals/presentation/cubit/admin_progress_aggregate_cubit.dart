import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/progress_aggregate.dart';
import '../../domain/usecases/goals_usecases.dart';

part 'admin_progress_aggregate_cubit.freezed.dart';

@freezed
abstract class AdminProgressAggregateState with _$AdminProgressAggregateState {
  const factory AdminProgressAggregateState({
    @Default(LoadStatus.initial) LoadStatus status,
    ProgressAggregateCounts? counts,
    Failure? failure,
  }) = _AdminProgressAggregateState;
}

@injectable
class AdminProgressAggregateCubit extends Cubit<AdminProgressAggregateState> {
  AdminProgressAggregateCubit(this._getAggregate)
    : super(const AdminProgressAggregateState());

  final GetProgressAggregateUseCase _getAggregate;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getAggregate(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (counts) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          counts: counts,
        ),
      ),
    );
  }
}
