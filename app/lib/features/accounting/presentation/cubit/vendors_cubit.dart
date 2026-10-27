import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/usecases/get_vendors_usecase.dart';

const Object _sentinel = Object();

class VendorsState extends Equatable {
  const VendorsState({
    this.status = LoadStatus.initial,
    this.vendors = const [],
    this.search,
    this.isActive,
    this.failure,
    this.hasReachedMax = false,
    this.offset = 0,
    this.limit = 50,
  });

  final LoadStatus status;
  final List<Vendor> vendors;
  final String? search;
  final bool? isActive;
  final Failure? failure;
  final bool hasReachedMax;
  final int offset;
  final int limit;

  VendorsState copyWith({
    LoadStatus? status,
    List<Vendor>? vendors,
    Object? search = _sentinel,
    Object? isActive = _sentinel,
    Object? failure = _sentinel,
    bool? hasReachedMax,
    int? offset,
    int? limit,
  }) {
    return VendorsState(
      status: status ?? this.status,
      vendors: vendors ?? this.vendors,
      search: identical(search, _sentinel) ? this.search : (search as String?),
      isActive: identical(isActive, _sentinel)
          ? this.isActive
          : (isActive as bool?),
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [
        status,
        vendors,
        search,
        isActive,
        failure,
        hasReachedMax,
        offset,
        limit,
      ];
}

@injectable
class VendorsCubit extends Cubit<VendorsState> {
  VendorsCubit(
    this._getVendors, {
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(const VendorsState());

  final GetVendorsUseCase _getVendors;
  final Duration debounceDuration;
  Timer? _debounceTimer;
  int _loadEpoch = 0;

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> load({
    bool refresh = true,
    String? search,
    bool? isActive,
    bool clearSearch = false,
    bool clearActiveFilter = false,
  }) async {
    _debounceTimer?.cancel();
    final epoch = ++_loadEpoch;
    final nextSearch = clearSearch ? null : (search ?? state.search);
    final nextIsActive =
        clearActiveFilter ? null : (isActive ?? state.isActive);
    final nextOffset = refresh ? 0 : state.offset;

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        search: nextSearch,
        isActive: nextIsActive,
        offset: nextOffset,
        failure: null,
        vendors: refresh ? [] : state.vendors,
        hasReachedMax: refresh ? false : state.hasReachedMax,
      ),
    );

    final result = await _getVendors(
      GetVendorsParams(
        limit: state.limit,
        offset: nextOffset,
        search: (nextSearch != null && nextSearch.trim().isNotEmpty)
            ? nextSearch.trim()
            : null,
        isActive: nextIsActive,
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
      (page) {
        final combined =
            refresh ? page.items : [...state.vendors, ...page.items];
        emit(
          state.copyWith(
            status: LoadStatus.success,
            vendors: combined,
            hasReachedMax: !page.hasMore,
            offset: nextOffset + page.items.length,
            failure: null,
          ),
        );
      },
    );
  }

  Future<void> loadNextPage() async {
    if (state.hasReachedMax || state.status == LoadStatus.loading) return;
    await load(refresh: false);
  }

  void searchVendors(String? query) {
    _debounceTimer?.cancel();
    final trimmed = query?.trim();
    final isClearing = trimmed == null || trimmed.isEmpty;

    emit(
      state.copyWith(
        search: isClearing ? null : trimmed,
      ),
    );

    if (debounceDuration == Duration.zero) {
      load(
        refresh: true,
        search: isClearing ? null : trimmed,
        clearSearch: isClearing,
      );
    } else {
      _debounceTimer = Timer(debounceDuration, () {
        load(
          refresh: true,
          search: isClearing ? null : trimmed,
          clearSearch: isClearing,
        );
      });
    }
  }

  void setSearch(String? query) => searchVendors(query);

  Future<void> filterByActive(bool? isActive) {
    return load(
      refresh: true,
      isActive: isActive,
      clearActiveFilter: isActive == null,
    );
  }

  Future<void> clearFilters() {
    _debounceTimer?.cancel();
    return load(
      refresh: true,
      clearSearch: true,
      clearActiveFilter: true,
    );
  }
}
