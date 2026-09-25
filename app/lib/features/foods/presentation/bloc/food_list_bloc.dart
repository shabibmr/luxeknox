// Initializing formals aren't usable for `_getFoodsUseCase`: the field
// name is private but the named parameter must stay public for injectable's
// generated DI code, and `debounceDuration` has a default value that isn't
// stored on a field at all.
// ignore_for_file: prefer_initializing_formals

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/bloc/event_transformers.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/food_filter.dart';
import '../../domain/usecases/get_foods_usecase.dart';
import 'food_list_event.dart';
import 'food_list_state.dart';

@injectable
class FoodListBloc extends Bloc<FoodListEvent, FoodListState> {
  FoodListBloc({
    required GetFoodsUseCase getFoodsUseCase,
    @ignoreParam Duration debounceDuration = const Duration(milliseconds: 300),
  }) : _getFoodsUseCase = getFoodsUseCase,
       super(const FoodListState()) {
    on<FoodListStarted>(_onStarted);
    on<FoodListSearchChanged>(
      _onSearchChanged,
      transformer: debounce(debounceDuration),
    );
    on<FoodListFilterChanged>(_onFilterChanged);
    on<FoodListNextPageRequested>(_onNextPageRequested);
    on<FoodListRefreshed>(_onRefreshed);
  }

  final GetFoodsUseCase _getFoodsUseCase;

  Future<void> _fetchPage({
    required Emitter<FoodListState> emit,
    required FoodFilter filter,
    String? cursor,
    bool isNextPage = false,
  }) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await _getFoodsUseCase(
      GetFoodsParams(filter: filter, cursor: cursor),
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
    FoodListStarted event,
    Emitter<FoodListState> emit,
  ) async {
    await _fetchPage(emit: emit, filter: state.filter);
  }

  Future<void> _onSearchChanged(
    FoodListSearchChanged event,
    Emitter<FoodListState> emit,
  ) async {
    final updatedFilter = state.filter.copyWith(
      query: event.query.isNotEmpty ? event.query : null,
    );
    await _fetchPage(emit: emit, filter: updatedFilter);
  }

  Future<void> _onFilterChanged(
    FoodListFilterChanged event,
    Emitter<FoodListState> emit,
  ) async {
    await _fetchPage(emit: emit, filter: event.filter);
  }

  Future<void> _onNextPageRequested(
    FoodListNextPageRequested event,
    Emitter<FoodListState> emit,
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
    FoodListRefreshed event,
    Emitter<FoodListState> emit,
  ) async {
    await _fetchPage(emit: emit, filter: state.filter);
  }
}
