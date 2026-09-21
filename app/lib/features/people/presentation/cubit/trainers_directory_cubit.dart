import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/trainer_summary.dart';
import '../../domain/usecases/list_trainers_usecase.dart';

sealed class TrainersDirectoryState extends Equatable {
  const TrainersDirectoryState();

  @override
  List<Object?> get props => [];
}

final class TrainersDirectoryLoading extends TrainersDirectoryState {
  const TrainersDirectoryLoading();
}

final class TrainersDirectoryLoaded extends TrainersDirectoryState {
  const TrainersDirectoryLoaded({
    required this.items,
    required this.hasMore,
    this.nextCursor,
    this.query,
    this.loadingMore = false,
  });

  final List<TrainerSummary> items;
  final bool hasMore;
  final String? nextCursor;
  final String? query;
  final bool loadingMore;

  @override
  List<Object?> get props => [items, hasMore, nextCursor, query, loadingMore];
}

final class TrainersDirectoryFailure extends TrainersDirectoryState {
  const TrainersDirectoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class TrainersDirectoryCubit extends Cubit<TrainersDirectoryState> {
  TrainersDirectoryCubit(this._listTrainers)
    : super(const TrainersDirectoryLoading());

  final ListTrainersUseCase _listTrainers;
  String? _query;

  Future<void> load({String? query}) async {
    _query = query?.trim().isEmpty == true ? null : query?.trim();
    emit(const TrainersDirectoryLoading());
    final result = await _listTrainers(ListTrainersParams(query: _query));
    result.fold(
      (failure) => emit(TrainersDirectoryFailure(_message(failure))),
      (page) => emit(
        TrainersDirectoryLoaded(
          items: page.items,
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          query: _query,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! TrainersDirectoryLoaded ||
        !current.hasMore ||
        current.loadingMore) {
      return;
    }
    emit(
      TrainersDirectoryLoaded(
        items: current.items,
        hasMore: current.hasMore,
        nextCursor: current.nextCursor,
        query: current.query,
        loadingMore: true,
      ),
    );
    final result = await _listTrainers(
      ListTrainersParams(query: current.query, cursor: current.nextCursor),
    );
    result.fold(
      (failure) => emit(TrainersDirectoryFailure(_message(failure))),
      (page) => emit(
        TrainersDirectoryLoaded(
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          query: current.query,
        ),
      ),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
