import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/expense_voucher.dart';
import '../../domain/usecases/get_expenses_usecase.dart';

const Object _sentinel = Object();

class ExpensesState extends Equatable {
  const ExpensesState({
    this.status = LoadStatus.initial,
    this.expenses = const [],
    this.statusFilter,
    this.vendorId,
    this.fromDate,
    this.toDate,
    this.search,
    this.failure,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.offset = 0,
  });

  final LoadStatus status;
  final List<ExpenseVoucher> expenses;
  final String? statusFilter;
  final String? vendorId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? search;
  final Failure? failure;
  final bool hasMore;
  final bool isLoadingMore;
  final int offset;

  ExpensesState copyWith({
    LoadStatus? status,
    List<ExpenseVoucher>? expenses,
    Object? statusFilter = _sentinel,
    Object? vendorId = _sentinel,
    Object? fromDate = _sentinel,
    Object? toDate = _sentinel,
    Object? search = _sentinel,
    Object? failure = _sentinel,
    bool? hasMore,
    bool? isLoadingMore,
    int? offset,
  }) {
    return ExpensesState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
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
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object?> get props => [
        status,
        expenses,
        statusFilter,
        vendorId,
        fromDate,
        toDate,
        search,
        failure,
        hasMore,
        isLoadingMore,
        offset,
      ];
}

@injectable
class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit(this._getExpenses) : super(const ExpensesState());

  final GetExpensesUseCase _getExpenses;

  static const int _pageSize = 20;

  Future<void> load({
    String? status,
    String? vendorId,
    DateTime? from,
    DateTime? to,
    String? search,
    bool clearStatus = false,
    bool clearVendor = false,
    bool clearDates = false,
    bool clearSearch = false,
    bool refresh = false,
  }) async {
    final nextStatus =
        clearStatus ? null : (status ?? state.statusFilter);
    final nextVendor =
        clearVendor ? null : (vendorId ?? state.vendorId);
    final nextFrom =
        clearDates ? null : (from ?? state.fromDate);
    final nextTo =
        clearDates ? null : (to ?? state.toDate);
    final nextSearch =
        clearSearch ? null : (search ?? state.search);

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        statusFilter: nextStatus,
        vendorId: nextVendor,
        fromDate: nextFrom,
        toDate: nextTo,
        search: nextSearch,
        failure: null,
        offset: 0,
      ),
    );

    final result = await _getExpenses(
      GetExpensesParams(
        status: nextStatus,
        vendorId: nextVendor,
        from: nextFrom,
        to: nextTo,
        search: nextSearch,
        limit: _pageSize,
        offset: 0,
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
          expenses: page.items,
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

    final result = await _getExpenses(
      GetExpensesParams(
        status: state.statusFilter,
        vendorId: state.vendorId,
        from: state.fromDate,
        to: state.toDate,
        search: state.search,
        limit: _pageSize,
        offset: state.offset,
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
          isLoadingMore: false,
          expenses: [...state.expenses, ...page.items],
          hasMore: page.hasMore,
          offset: state.offset + page.items.length,
        ),
      ),
    );
  }

  Future<void> filterByStatus(String? status) {
    return load(status: status, clearStatus: status == null || status.isEmpty);
  }

  Future<void> filterByVendor(String? vendorId) {
    return load(vendorId: vendorId, clearVendor: vendorId == null || vendorId.isEmpty);
  }

  Future<void> filterByDateRange(DateTime? from, DateTime? to) {
    return load(
      from: from,
      to: to,
      clearDates: from == null && to == null,
    );
  }

  Future<void> setSearch(String? search) {
    return load(
      search: search,
      clearSearch: search == null || search.isEmpty,
    );
  }

  Future<void> clearFilters() {
    return load(
      clearStatus: true,
      clearVendor: true,
      clearDates: true,
      clearSearch: true,
    );
  }
}
