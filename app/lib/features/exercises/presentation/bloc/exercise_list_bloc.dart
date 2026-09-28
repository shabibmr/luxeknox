// Initializing formals aren't usable for `_getExercisesUseCase`: the field
// name is private but the named parameter must stay public for injectable's
// generated DI code, and `debounceDuration` has a default value that isn't
// stored on a field at all.
// ignore_for_file: prefer_initializing_formals

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/bloc/event_transformers.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/exercise_filter.dart';
import '../../domain/usecases/get_exercises_usecase.dart';
import 'exercise_list_event.dart';
import 'exercise_list_state.dart';

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
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await _getExercisesUseCase(
      GetExercisesParams(filter: filter, cursor: cursor),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: LoadStatus.failure, failure: failure));
      },
      (page) {
        final newItems = isNextPage
            ? [...state.items, ...page.items]
            : page.items;
        emit(
          state.copyWith(
            status: LoadStatus.success,
            items: newItems,
            filter: filter,
            cursor: page.nextCursor,
            hasMore: page.hasMore,
            failure: null,
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
    if (!state.hasMore || state.status == LoadStatus.loading) {
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
