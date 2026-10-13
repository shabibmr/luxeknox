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
    this._getAccountingPeriods,
  ) : super(const AccountingHomeState());

  final GetOpenItemsUseCase _getOpenItems;
  final GetAccountsUseCase _getAccounts;
  final GetAccountingPeriodsUseCase _getAccountingPeriods;

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
      (page) => bankAccounts =
          page.items.where((Account a) => a.isBank).toList(),
    );
    periodsResult.fold(
      (f) => firstFailure ??= f,
      (List<AccountingPeriod> periods) {
        if (periods.isNotEmpty) {
          period = periods.firstWhere(
            (p) => !p.isLocked,
            orElse: () => periods.first,
          );
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
          bankAndCashAccounts: bankAccounts,
          currentPeriod: period ?? state.currentPeriod,
          failure: null,
        ),
      );
    }
  }
}
