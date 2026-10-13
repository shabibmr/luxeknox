import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/fund_transfer.dart';
import '../../domain/usecases/get_fund_transfers_usecase.dart';

const Object _sentinel = Object();

class FundTransfersState extends Equatable {
  const FundTransfersState({
    this.status = LoadStatus.initial,
    this.transfers = const [],
    this.statusFilter,
    this.fromDate,
    this.toDate,
    this.search,
    this.accountId,
    this.failure,
    this.hasReachedMax = false,
    this.offset = 0,
    this.limit = 50,
  });

  final LoadStatus status;
  final List<FundTransfer> transfers;
  final String? statusFilter;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? search;
  final String? accountId;
  final Failure? failure;
  final bool hasReachedMax;
  final int offset;
  final int limit;

  FundTransfersState copyWith({
    LoadStatus? status,
    List<FundTransfer>? transfers,
    Object? statusFilter = _sentinel,
    Object? fromDate = _sentinel,
    Object? toDate = _sentinel,
    Object? search = _sentinel,
    Object? accountId = _sentinel,
    Object? failure = _sentinel,
    bool? hasReachedMax,
    int? offset,
    int? limit,
  }) {
    return FundTransfersState(
      status: status ?? this.status,
      transfers: transfers ?? this.transfers,
      statusFilter: identical(statusFilter, _sentinel)
          ? this.statusFilter
          : (statusFilter as String?),
      fromDate: identical(fromDate, _sentinel)
          ? this.fromDate
          : (fromDate as DateTime?),
      toDate:
          identical(toDate, _sentinel) ? this.toDate : (toDate as DateTime?),
      search: identical(search, _sentinel) ? this.search : (search as String?),
      accountId: identical(accountId, _sentinel)
          ? this.accountId
          : (accountId as String?),
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
        transfers,
        statusFilter,
        fromDate,
        toDate,
        search,
        accountId,
        failure,
        hasReachedMax,
        offset,
        limit,
      ];
}

@injectable
class FundTransfersCubit extends Cubit<FundTransfersState> {
  FundTransfersCubit(this._getFundTransfers)
      : super(const FundTransfersState());

  final GetFundTransfersUseCase _getFundTransfers;

  Future<void> load({
    bool refresh = true,
    String? status,
    DateTime? from,
    DateTime? to,
    String? search,
    String? accountId,
    bool clearStatus = false,
    bool clearDates = false,
    bool clearSearch = false,
    bool clearAccount = false,
  }) async {
    final nextStatus =
        clearStatus ? null : (status ?? state.statusFilter);
    final nextFrom = clearDates ? null : (from ?? state.fromDate);
    final nextTo = clearDates ? null : (to ?? state.toDate);
    final nextSearch = clearSearch ? null : (search ?? state.search);
    final nextAccountId =
        clearAccount ? null : (accountId ?? state.accountId);
    final nextOffset = refresh ? 0 : state.offset;

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        statusFilter: nextStatus,
        fromDate: nextFrom,
        toDate: nextTo,
        search: nextSearch,
        accountId: nextAccountId,
        offset: nextOffset,
        failure: null,
        transfers: refresh ? [] : state.transfers,
        hasReachedMax: refresh ? false : state.hasReachedMax,
      ),
    );

    final result = await _getFundTransfers(
      GetFundTransfersParams(
        limit: state.limit,
        offset: nextOffset,
        status: nextStatus,
        from: nextFrom,
        to: nextTo,
        search: (nextSearch != null && nextSearch.trim().isNotEmpty)
            ? nextSearch.trim()
            : null,
        accountId: nextAccountId,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
        ),
      ),
      (page) {
        final combined =
            refresh ? page.items : [...state.transfers, ...page.items];
        emit(
          state.copyWith(
            status: LoadStatus.success,
            transfers: combined,
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

  Future<void> filterByStatus(String? status) {
    return load(
      refresh: true,
      status: status,
      clearStatus: status == null,
    );
  }

  Future<void> filterByDateRange(DateTime? from, DateTime? to) {
    return load(
      refresh: true,
      from: from,
      to: to,
      clearDates: from == null && to == null,
    );
  }

  Future<void> filterByAccount(String? accountId) {
    return load(
      refresh: true,
      accountId: accountId,
      clearAccount: accountId == null,
    );
  }

  Future<void> searchTransfers(String? query) {
    return load(
      refresh: true,
      search: query,
      clearSearch: query == null || query.isEmpty,
    );
  }

  Future<void> clearFilters() {
    return load(
      refresh: true,
      clearStatus: true,
      clearDates: true,
      clearSearch: true,
      clearAccount: true,
    );
  }
}
