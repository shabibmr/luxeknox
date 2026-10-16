import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/item.dart';
import '../../domain/usecases/get_items_usecase.dart';

const Object _sentinel = Object();

class ItemsState extends Equatable {
  const ItemsState({
    this.status = LoadStatus.initial,
    this.items = const [],
    this.search,
    this.kind,
    this.isActive,
    this.inventoryTracked,
    this.failure,
    this.hasMore = false,
    this.offset = 0,
    this.limit = 50,
    this.isLoadingMore = false,
  });

  final LoadStatus status;
  final List<Item> items;
  final String? search;
  final String? kind;
  final bool? isActive;
  final bool? inventoryTracked;
  final Failure? failure;
  final bool hasMore;
  final int offset;
  final int limit;
  final bool isLoadingMore;

  ItemsState copyWith({
    LoadStatus? status,
    List<Item>? items,
    Object? search = _sentinel,
    Object? kind = _sentinel,
    Object? isActive = _sentinel,
    Object? inventoryTracked = _sentinel,
    Object? failure = _sentinel,
    bool? hasMore,
    int? offset,
    int? limit,
    bool? isLoadingMore,
  }) {
    return ItemsState(
      status: status ?? this.status,
      items: items ?? this.items,
      search: identical(search, _sentinel) ? this.search : search as String?,
      kind: identical(kind, _sentinel) ? this.kind : kind as String?,
      isActive:
          identical(isActive, _sentinel) ? this.isActive : isActive as bool?,
      inventoryTracked: identical(inventoryTracked, _sentinel)
          ? this.inventoryTracked
          : inventoryTracked as bool?,
      failure:
          identical(failure, _sentinel) ? this.failure : failure as Failure?,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        search,
        kind,
        isActive,
        inventoryTracked,
        failure,
        hasMore,
        offset,
        limit,
        isLoadingMore,
      ];
}

@injectable
class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit(
    this._getItems, {
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(const ItemsState());

  final GetItemsUseCase _getItems;
  final Duration debounceDuration;

  Timer? _debounceTimer;
  int _loadEpoch = 0;

  Future<void> load({
    String? search,
    String? kind,
    bool? isActive,
    bool? inventoryTracked,
    bool clearSearch = false,
    bool clearKind = false,
    bool clearActive = false,
    bool clearTracked = false,
    bool clearFilters = false,
  }) async {
    _debounceTimer?.cancel();
    final epoch = ++_loadEpoch;

    final nextSearch = clearFilters || clearSearch
        ? null
        : (search ?? state.search);
    final nextKind =
        clearFilters || clearKind ? null : (kind ?? state.kind);
    final nextActive = clearFilters || clearActive
        ? null
        : (isActive ?? state.isActive);
    final nextTracked = clearFilters || clearTracked
        ? null
        : (inventoryTracked ?? state.inventoryTracked);

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        search: nextSearch,
        kind: nextKind,
        isActive: nextActive,
        inventoryTracked: nextTracked,
        offset: 0,
        failure: null,
        isLoadingMore: false,
      ),
    );

    final result = await _getItems(
      GetItemsParams(
        limit: state.limit,
        offset: 0,
        search: (nextSearch != null && nextSearch.trim().isNotEmpty)
            ? nextSearch.trim()
            : null,
        kind: nextKind,
        isActive: nextActive,
        inventoryTracked: nextTracked,
      ),
    );

    if (isClosed || epoch != _loadEpoch) return;

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
          hasMore: page.hasMore,
          offset: page.items.length,
          failure: null,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status == LoadStatus.loading) {
      return;
    }

    final epoch = _loadEpoch;
    emit(state.copyWith(isLoadingMore: true, failure: null));

    final result = await _getItems(
      GetItemsParams(
        limit: state.limit,
        offset: state.offset,
        search: state.search,
        kind: state.kind,
        isActive: state.isActive,
        inventoryTracked: state.inventoryTracked,
      ),
    );

    if (isClosed || epoch != _loadEpoch) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMore: false,
          failure: failure,
        ),
      ),
      (page) => emit(
        state.copyWith(
          items: [...state.items, ...page.items],
          hasMore: page.hasMore,
          offset: state.offset + page.items.length,
          isLoadingMore: false,
          failure: null,
        ),
      ),
    );
  }

  /// Updates [ItemsState.search] immediately and reloads after [debounceDuration].
  void searchItems(String? query) {
    _debounceTimer?.cancel();
    final next = (query == null || query.trim().isEmpty) ? null : query.trim();
    emit(state.copyWith(search: next));

    _debounceTimer = Timer(debounceDuration, () {
      load(search: next, clearSearch: next == null);
    });
  }

  Future<void> filterByKind(String? kind) {
    return load(kind: kind, clearKind: kind == null);
  }

  Future<void> filterByActive(bool? isActive) {
    return load(isActive: isActive, clearActive: isActive == null);
  }

  Future<void> filterByTracked(bool? inventoryTracked) {
    return load(
      inventoryTracked: inventoryTracked,
      clearTracked: inventoryTracked == null,
    );
  }

  Future<void> clearFilters() {
    return load(clearFilters: true);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
