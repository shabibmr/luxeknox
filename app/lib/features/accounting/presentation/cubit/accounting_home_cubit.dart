import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/accounting_period.dart';
import '../../domain/entities/accounting_reports.dart';
import '../../domain/usecases/get_accounting_periods_usecase.dart';
import '../../domain/usecases/get_accounts_usecase.dart';
import '../../domain/usecases/get_open_items_usecase.dart';

part 'accounting_home_cubit.freezed.dart';

@freezed
abstract class AccountingHomeState with _$AccountingHomeState {
  const factory AccountingHomeState({
    @Default(LoadStatus.initial) LoadStatus status,
    OpenItemsReport? openAr,
    OpenItemsReport? openAp,
    @Default(<Account>[]) List<Account> bankAndCashAccounts,
    AccountingPeriod? currentPeriod,
    Failure? failure,
  }) = _AccountingHomeState;
}

@injectable
class AccountingHomeCubit extends Cubit<AccountingHomeState> {
  AccountingHomeCubit(
    this._getOpenItems,
    this._getAccounts,
    this._getAccountingPeriods, {
    DateTime Function()? now,
  })  : _now = now ?? DateTime.now,
        super(const AccountingHomeState());

  final GetOpenItemsUseCase _getOpenItems;
  final GetAccountsUseCase _getAccounts;
  final GetAccountingPeriodsUseCase _getAccountingPeriods;
  final DateTime Function() _now;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final arFuture = _getOpenItems(const GetOpenItemsParams(kind: 'ar'));
    final apFuture = _getOpenItems(const GetOpenItemsParams(kind: 'ap'));
    final accountsFuture = _getAccounts(
      const GetAccountsParams(limit: 100, isActive: true),
    );
    final periodsFuture = _getAccountingPeriods(
      const GetAccountingPeriodsParams(),
    );

    final results = await Future.wait([
      arFuture,
      apFuture,
      accountsFuture,
      periodsFuture,
    ]);

    final arResult = results[0] as dynamic;
    final apResult = results[1] as dynamic;
    final accountsResult = results[2] as dynamic;
    final periodsResult = results[3] as dynamic;

    Failure? firstFailure;
    OpenItemsReport? arReport;
    OpenItemsReport? apReport;
    List<Account> bankAccounts = [];
    AccountingPeriod? period;

    arResult.fold((f) => firstFailure ??= f, (data) => arReport = data);
    apResult.fold((f) => firstFailure ??= f, (data) => apReport = data);
    accountsResult.fold(
      (f) => firstFailure ??= f,
      (page) {
        bankAccounts = (page.items as Iterable)
            .whereType<Account>()
            .where((a) => a.isBank)
            .toList()
          ..sort((Account a, Account b) => a.code.compareTo(b.code));
      },
    );
    periodsResult.fold(
      (f) => firstFailure ??= f,
      (List<AccountingPeriod> periods) {
        if (periods.isNotEmpty) {
          final now = _now();
          final unlocked = periods.where((p) => !p.isLocked).toList();
          if (unlocked.isNotEmpty) {
            period = unlocked.firstWhere(
              (p) => _isBetween(now, p.startDate, p.endDate),
              orElse: () => unlocked.first,
            );
          } else {
            period = periods.first;
          }
        }
      },
    );

    if (arResult.isLeft() && apResult.isLeft() && accountsResult.isLeft()) {
      emit(state.copyWith(status: LoadStatus.failure, failure: firstFailure));
    } else {
      emit(
        state.copyWith(
          status: LoadStatus.success,
          openAr: arReport ?? state.openAr,
          openAp: apReport ?? state.openAp,
          bankAndCashAccounts: accountsResult.isRight()
              ? bankAccounts
              : state.bankAndCashAccounts,
          currentPeriod: period ?? state.currentPeriod,
          failure: null,
        ),
      );
    }
  }

  bool _isBetween(DateTime now, DateTime start, DateTime end) {
    if (!now.isBefore(start) && !now.isAfter(end)) {
      return true;
    }
    final effectiveEnd =
        (end.hour == 0 && end.minute == 0 && end.second == 0 && end.millisecond == 0)
            ? (end.isUtc
                ? DateTime.utc(end.year, end.month, end.day, 23, 59, 59, 999)
                : DateTime(end.year, end.month, end.day, 23, 59, 59, 999))
            : end;
    return !now.isBefore(start) && !now.isAfter(effectiveEnd);
  }
}
