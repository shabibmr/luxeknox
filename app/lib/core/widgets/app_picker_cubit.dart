import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';
import '../pagination/cursor_page.dart';
import '../presentation/load_status.dart';

/// Signature for fetching a page of items of type [T].
///
/// Can be used with cursor-based, offset-based, or non-paginated endpoints.
/// For non-paginated endpoints, return `CursorPage(items: [...], nextCursor: null, hasMore: false)`.
typedef PageFetcher<T> = Future<Either<Failure, CursorPage<T>>> Function({
  String? query,
  String? cursor,
});

/// Generic state for an entity picker.
class AppPickerState<T> extends Equatable {
  const AppPickerState({
    this.status = LoadStatus.initial,
    this.items = const [],
    this.failure,
    this.nextCursor,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.query,
  });

  final LoadStatus status;
  final List<T> items;
  final Failure? failure;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;
  final String? query;

  AppPickerState<T> copyWith({
    LoadStatus? status,
    List<T>? items,
    Failure? failure,
    String? nextCursor,
    bool? hasMore,
    bool? isLoadingMore,
    String? query,
    bool clearFailure = false,
    bool clearNextCursor = false,
  }) {
    return AppPickerState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      failure: clearFailure ? null : (failure ?? this.failure),
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    failure,
    nextCursor,
    hasMore,
    isLoadingMore,
    query,
  ];
}

/// Generic [Cubit] powering entity pickers with search debouncing,
/// request epoch tracking to avoid race conditions, and cursor-based infinite scrolling.
class AppPickerCubit<T> extends Cubit<AppPickerState<T>> {
  AppPickerCubit({
    required this.fetcher,
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(AppPickerState<T>());

  final PageFetcher<T> fetcher;
  final Duration debounceDuration;

  Timer? _debounceTimer;
  int _searchEpoch = 0;

  /// Loads the first page for the given [query] (or existing query if omitted).
  Future<void> load({String? query}) async {
    _debounceTimer?.cancel();
    final epoch = ++_searchEpoch;

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        clearFailure: true,
        query: query,
      ),
    );

    final result = await fetcher(query: query, cursor: null);
    if (isClosed || epoch != _searchEpoch) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: page.items,
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
          clearFailure: true,
        ),
      ),
    );
  }

  /// Debounces live search input to avoid spamming the backend.
  void onSearchChanged(String rawQuery) {
    _debounceTimer?.cancel();
    final query = rawQuery.trim().isEmpty ? null : rawQuery.trim();
    if (query == state.query && state.status == LoadStatus.success) return;

    _debounceTimer = Timer(debounceDuration, () {
      load(query: query);
    });
  }

  /// Loads the next cursor page when user scrolls towards the bottom.
  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.status == LoadStatus.loading ||
        state.nextCursor == null) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    final result = await fetcher(query: state.query, cursor: state.nextCursor);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false, failure: failure)),
      (page) => emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...page.items],
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
