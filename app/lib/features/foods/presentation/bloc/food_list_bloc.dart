// Initializing formals aren't usable for `_getFoodsUseCase`: the field
// name is private but the named parameter must stay public for injectable's
// generated DI code, and `debounceDuration` has a default value that isn't
// stored on a field at all.
// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/food_filter.dart';
import '../../domain/usecases/get_foods_usecase.dart';
import 'food_list_event.dart';
import 'food_list_state.dart';

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
    emit(state.copyWith(status: FoodListStatus.loading, failure: null));

    final result = await _getFoodsUseCase(
      GetFoodsParams(filter: filter, cursor: cursor),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: FoodListStatus.failure, failure: failure));
      },
      (page) {
        final newItems = isNextPage
            ? [...state.items, ...page.items]
            : page.items;
        emit(
          state.copyWith(
            status: FoodListStatus.success,
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
    if (!state.hasMore || state.status == FoodListStatus.loading) {
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
