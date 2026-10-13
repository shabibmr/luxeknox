import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/purchase_bill.dart';
import '../../domain/usecases/get_purchase_bills_usecase.dart';

const Object _sentinel = Object();

class PurchaseBillsState extends Equatable {
  const PurchaseBillsState({
    this.status = LoadStatus.initial,
    this.bills = const [],
    this.statusFilter,
    this.vendorId,
    this.fromDate,
    this.toDate,
    this.search,
    this.hasMore = false,
    this.offset = 0,
    this.limit = 20,
    this.isLoadingMore = false,
    this.failure,
  });

  final LoadStatus status;
  final List<PurchaseBill> bills;
  final String? statusFilter;
  final String? vendorId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? search;
  final bool hasMore;
  final int offset;
  final int limit;
  final bool isLoadingMore;
  final Failure? failure;

  PurchaseBillsState copyWith({
    LoadStatus? status,
    List<PurchaseBill>? bills,
    Object? statusFilter = _sentinel,
    Object? vendorId = _sentinel,
    Object? fromDate = _sentinel,
    Object? toDate = _sentinel,
    Object? search = _sentinel,
    bool? hasMore,
    int? offset,
    int? limit,
    bool? isLoadingMore,
    Object? failure = _sentinel,
  }) {
    return PurchaseBillsState(
      status: status ?? this.status,
      bills: bills ?? this.bills,
      statusFilter: identical(statusFilter, _sentinel)
          ? this.statusFilter
          : (statusFilter as String?),
      vendorId: identical(vendorId, _sentinel)
          ? this.vendorId
          : (vendorId as String?),
      fromDate: identical(fromDate, _sentinel)
          ? this.fromDate
          : (fromDate as DateTime?),
      toDate: identical(toDate, _sentinel)
          ? this.toDate
          : (toDate as DateTime?),
      search: identical(search, _sentinel)
          ? this.search
          : (search as String?),
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        bills,
        statusFilter,
        vendorId,
        fromDate,
        toDate,
        search,
        hasMore,
        offset,
        limit,
        isLoadingMore,
        failure,
      ];
}

@injectable
class PurchaseBillsCubit extends Cubit<PurchaseBillsState> {
  PurchaseBillsCubit(this._getPurchaseBills)
      : super(const PurchaseBillsState());

  final GetPurchaseBillsUseCase _getPurchaseBills;

  Future<void> load({
    String? statusFilter,
    String? vendorId,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
    bool clearStatus = false,
    bool clearVendor = false,
    bool clearDates = false,
    bool clearSearch = false,
    bool clearFilters = false,
  }) async {
    final nextStatus = clearFilters || clearStatus
        ? null
        : (statusFilter ?? state.statusFilter);
    final nextVendor = clearFilters || clearVendor
        ? null
        : (vendorId ?? state.vendorId);
    final nextFrom = clearFilters || clearDates
        ? null
        : (fromDate ?? state.fromDate);
    final nextTo = clearFilters || clearDates
        ? null
        : (toDate ?? state.toDate);
    final nextSearch = clearFilters || clearSearch
        ? null
        : (search ?? state.search);

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        statusFilter: nextStatus,
        vendorId: nextVendor,
        fromDate: nextFrom,
        toDate: nextTo,
        search: nextSearch,
        failure: null,
      ),
    );

    final result = await _getPurchaseBills(
      GetPurchaseBillsParams(
        status: nextStatus,
        vendorId: nextVendor,
        from: nextFrom,
        to: nextTo,
        search: nextSearch,
        offset: 0,
        limit: state.limit,
      ),
    );

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
          bills: page.items,
          hasMore: page.hasMore,
          offset: page.items.length,
          failure: null,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final result = await _getPurchaseBills(
      GetPurchaseBillsParams(
        status: state.statusFilter,
        vendorId: state.vendorId,
        from: state.fromDate,
        to: state.toDate,
        search: state.search,
        offset: state.offset,
        limit: state.limit,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMore: false,
          failure: failure,
        ),
      ),
      (page) => emit(
        state.copyWith(
          bills: [...state.bills, ...page.items],
          hasMore: page.hasMore,
          offset: state.offset + page.items.length,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<void> filterByStatus(String? status) {
    return load(statusFilter: status, clearStatus: status == null);
  }

  Future<void> filterByVendor(String? vendorId) {
    return load(vendorId: vendorId, clearVendor: vendorId == null);
  }

  Future<void> filterByDateRange(DateTime? from, DateTime? to) {
    return load(
      fromDate: from,
      toDate: to,
      clearDates: from == null && to == null,
    );
  }

  Future<void> searchBills(String? query) {
    return load(
      search: query,
      clearSearch: query == null || query.trim().isEmpty,
    );
  }

  Future<void> clearFilters() {
    return load(clearFilters: true);
  }
}
