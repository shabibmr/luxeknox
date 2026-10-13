import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/payment_voucher.dart';
import '../../domain/usecases/get_payment_vouchers_usecase.dart';

const Object _sentinel = Object();

class PaymentVouchersState extends Equatable {
  const PaymentVouchersState({
    this.status = LoadStatus.initial,
    this.vouchers = const [],
    this.statusFilter,
    this.bankAccountId,
    this.fromDate,
    this.toDate,
    this.search,
    this.failure,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.offset = 0,
  });

  final LoadStatus status;
  final List<PaymentVoucher> vouchers;
  final String? statusFilter;
  final String? bankAccountId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? search;
  final Failure? failure;
  final bool hasMore;
  final bool isLoadingMore;
  final int offset;

  PaymentVouchersState copyWith({
    LoadStatus? status,
    List<PaymentVoucher>? vouchers,
    Object? statusFilter = _sentinel,
    Object? bankAccountId = _sentinel,
    Object? fromDate = _sentinel,
    Object? toDate = _sentinel,
    Object? search = _sentinel,
    Object? failure = _sentinel,
    bool? hasMore,
    bool? isLoadingMore,
    int? offset,
  }) {
    return PaymentVouchersState(
      status: status ?? this.status,
      vouchers: vouchers ?? this.vouchers,
      statusFilter: identical(statusFilter, _sentinel)
          ? this.statusFilter
          : (statusFilter as String?),
      bankAccountId: identical(bankAccountId, _sentinel)
          ? this.bankAccountId
          : (bankAccountId as String?),
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
        vouchers,
        statusFilter,
        bankAccountId,
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
class PaymentVouchersCubit extends Cubit<PaymentVouchersState> {
  PaymentVouchersCubit(this._getPaymentVouchers)
      : super(const PaymentVouchersState());

  final GetPaymentVouchersUseCase _getPaymentVouchers;

  static const int _pageSize = 20;

  Future<void> load({
    String? status,
    String? bankAccountId,
    DateTime? from,
    DateTime? to,
    String? search,
    bool clearStatus = false,
    bool clearBank = false,
    bool clearDates = false,
    bool clearSearch = false,
    bool refresh = false,
  }) async {
    final nextStatus =
        clearStatus ? null : (status ?? state.statusFilter);
    final nextBank =
        clearBank ? null : (bankAccountId ?? state.bankAccountId);
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
        bankAccountId: nextBank,
        fromDate: nextFrom,
        toDate: nextTo,
        search: nextSearch,
        failure: null,
        offset: 0,
      ),
    );

    final result = await _getPaymentVouchers(
      GetPaymentVouchersParams(
        status: nextStatus,
        bankAccountId: nextBank,
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
          vouchers: page.items,
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

    final result = await _getPaymentVouchers(
      GetPaymentVouchersParams(
        status: state.statusFilter,
        bankAccountId: state.bankAccountId,
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
          vouchers: [...state.vouchers, ...page.items],
          hasMore: page.hasMore,
          offset: state.offset + page.items.length,
        ),
      ),
    );
  }

  Future<void> filterByStatus(String? status) {
    return load(status: status, clearStatus: status == null || status.isEmpty);
  }

  Future<void> filterByBankAccount(String? bankAccountId) {
    return load(
      bankAccountId: bankAccountId,
      clearBank: bankAccountId == null || bankAccountId.isEmpty,
    );
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
      clearBank: true,
      clearDates: true,
      clearSearch: true,
    );
  }
}
