// Initializing formals aren't usable for `_getExercisesUseCase`: the field
// name is private but the named parameter must stay public for injectable's
// generated DI code, and `debounceDuration` has a default value that isn't
// stored on a field at all.
// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/exercise_filter.dart';
import '../../domain/usecases/get_exercises_usecase.dart';
import 'exercise_list_event.dart';
import 'exercise_list_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events
      .transform(_DebounceStreamTransformer<T>(duration))
      .switchMap(mapper);
}

class _DebounceStreamTransformer<T> extends StreamTransformerBase<T, T> {
  const _DebounceStreamTransformer(this.duration);

  final Duration duration;

  @override
  Stream<T> bind(Stream<T> stream) {
    Timer? timer;
    StreamController<T>? controller;

    controller = StreamController<T>(
      onListen: () {
        final subscription = stream.listen(
          (data) {
            timer?.cancel();
            timer = Timer(duration, () {
              if (!controller!.isClosed) {
                controller.add(data);
              }
            });
          },
          onError: (Object error, StackTrace stackTrace) {
            controller?.addError(error, stackTrace);
          },
          onDone: () {
            timer?.cancel();
            controller?.close();
          },
        );

        controller?.onCancel = () {
          timer?.cancel();
          return subscription.cancel();
        };
      },
    );

    return controller.stream;
  }
}

extension _StreamSwitchMap<T> on Stream<T> {
  Stream<R> switchMap<R>(Stream<R> Function(T event) mapper) {
    StreamSubscription<R>? innerSubscription;
    StreamSubscription<T>? outerSubscription;
    StreamController<R>? controller;

    controller = StreamController<R>(
      onListen: () {
        outerSubscription = listen(
          (data) {
            innerSubscription?.cancel();
            innerSubscription = mapper(data).listen(
              (r) => controller?.add(r),
              onError: (Object e, StackTrace s) => controller?.addError(e, s),
            );
          },
          onError: (Object e, StackTrace s) => controller?.addError(e, s),
          onDone: () => controller?.close(),
        );

        controller?.onCancel = () async {
          await innerSubscription?.cancel();
          await outerSubscription?.cancel();
        };
      },
    );

    return controller.stream;
  }
}

@injectable
class ExerciseListBloc extends Bloc<ExerciseListEvent, ExerciseListState> {
  ExerciseListBloc({
    required GetExercisesUseCase getExercisesUseCase,
    @ignoreParam Duration debounceDuration = const Duration(milliseconds: 300),
  }) : _getExercisesUseCase = getExercisesUseCase,
       super(const ExerciseListState()) {
    on<ExerciseListStarted>(_onStarted);
    on<ExerciseListSearchChanged>(
      _onSearchChanged,
      transformer: debounce(debounceDuration),
    );
    on<ExerciseListFilterChanged>(_onFilterChanged);
    on<ExerciseListNextPageRequested>(_onNextPageRequested);
    on<ExerciseListRefreshed>(_onRefreshed);
  }

  final GetExercisesUseCase _getExercisesUseCase;

  Future<void> _fetchPage({
    required Emitter<ExerciseListState> emit,
    required ExerciseFilter filter,
    String? cursor,
    bool isNextPage = false,
  }) async {
    emit(state.copyWith(status: ExerciseListStatus.loading, failure: null));

    final result = await _getExercisesUseCase(
      GetExercisesParams(filter: filter, cursor: cursor),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(status: ExerciseListStatus.failure, failure: failure),
        );
      },
      (page) {
        final newItems = isNextPage
            ? [...state.items, ...page.items]
            : page.items;
        emit(
          state.copyWith(
            status: ExerciseListStatus.success,
            items: newItems,
            filter: filter,
            cursor: page.nextCursor,
            clearCursor: page.nextCursor == null,
            hasMore: page.hasMore,
          ),
        );
      },
    );
  }

  Future<void> _onStarted(
    ExerciseListStarted event,
    Emitter<ExerciseListState> emit,
  ) async {
    await _fetchPage(emit: emit, filter: state.filter);
  }

  Future<void> _onSearchChanged(
    ExerciseListSearchChanged event,
    Emitter<ExerciseListState> emit,
  ) async {
    final updatedFilter = state.filter.copyWith(
      searchText: event.query.isNotEmpty ? event.query : null,
    );
    await _fetchPage(emit: emit, filter: updatedFilter);
  }

  Future<void> _onFilterChanged(
    ExerciseListFilterChanged event,
    Emitter<ExerciseListState> emit,
  ) async {
    await _fetchPage(emit: emit, filter: event.filter);
  }

  Future<void> _onNextPageRequested(
    ExerciseListNextPageRequested event,
    Emitter<ExerciseListState> emit,
  ) async {
    if (!state.hasMore || state.status == ExerciseListStatus.loading) {
      return;
    }
    await _fetchPage(
      emit: emit,
      filter: state.filter,
      cursor: state.cursor,
      isNextPage: true,
    );
  }

  Future<void> _onRefreshed(
    ExerciseListRefreshed event,
    Emitter<ExerciseListState> emit,
  ) async {
    await _fetchPage(emit: emit, filter: state.filter);
  }
}
