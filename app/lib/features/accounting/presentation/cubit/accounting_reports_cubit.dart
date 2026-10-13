import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/accounting_reports.dart';
import '../../domain/usecases/get_balance_sheet_usecase.dart';
import '../../domain/usecases/get_day_book_usecase.dart';
import '../../domain/usecases/get_gst_summary_usecase.dart';
import '../../domain/usecases/get_profit_and_loss_usecase.dart';
import '../../domain/usecases/get_trial_balance_usecase.dart';

part 'accounting_reports_cubit.freezed.dart';

enum AccountingReportType {
  trialBalance,
  profitAndLoss,
  balanceSheet,
  dayBook,
  gstSummary,
}

@freezed
abstract class AccountingReportsState with _$AccountingReportsState {
  const factory AccountingReportsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(AccountingReportType.trialBalance)
    AccountingReportType selectedReportType,
    DateTime? fromDate,
    DateTime? toDate,
    TrialBalanceReport? trialBalance,
    ProfitAndLossReport? profitAndLoss,
    BalanceSheetReport? balanceSheet,
    DayBookReport? dayBook,
    GstSummaryReport? gstSummary,
    Failure? failure,
  }) = _AccountingReportsState;
}

@injectable
class AccountingReportsCubit extends Cubit<AccountingReportsState> {
  AccountingReportsCubit(
    this._getTrialBalance,
    this._getProfitAndLoss,
    this._getBalanceSheet,
    this._getDayBook,
    this._getGstSummary,
  ) : super(const AccountingReportsState());

  final GetTrialBalanceUseCase _getTrialBalance;
  final GetProfitAndLossUseCase _getProfitAndLoss;
  final GetBalanceSheetUseCase _getBalanceSheet;
  final GetDayBookUseCase _getDayBook;
  final GetGstSummaryUseCase _getGstSummary;

  Future<void> selectReportType(AccountingReportType reportType) async {
    emit(state.copyWith(selectedReportType: reportType));
    await load();
  }

  Future<void> setDateRange({DateTime? from, DateTime? to}) async {
    emit(state.copyWith(fromDate: from, toDate: to));
    await load();
  }

  Future<void> load() async {
    final to = state.toDate ?? DateTime.now();
    final from = state.fromDate ?? DateTime(to.year, 1, 1);

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        fromDate: from,
        toDate: to,
        failure: null,
      ),
    );

    switch (state.selectedReportType) {
      case AccountingReportType.trialBalance:
        final result = await _getTrialBalance(
          GetTrialBalanceParams(from: from, to: to),
        );
        result.fold(
          (failure) => emit(
            state.copyWith(status: LoadStatus.failure, failure: failure),
          ),
          (report) => emit(
            state.copyWith(
              status: LoadStatus.success,
              trialBalance: report,
              failure: null,
            ),
          ),
        );

      case AccountingReportType.profitAndLoss:
        final result = await _getProfitAndLoss(
          GetProfitAndLossParams(from: from, to: to),
        );
        result.fold(
          (failure) => emit(
            state.copyWith(status: LoadStatus.failure, failure: failure),
          ),
          (report) => emit(
            state.copyWith(
              status: LoadStatus.success,
              profitAndLoss: report,
              failure: null,
            ),
          ),
        );

      case AccountingReportType.balanceSheet:
        final result = await _getBalanceSheet(
          GetBalanceSheetParams(asOf: to),
        );
        result.fold(
          (failure) => emit(
            state.copyWith(status: LoadStatus.failure, failure: failure),
          ),
          (report) => emit(
            state.copyWith(
              status: LoadStatus.success,
              balanceSheet: report,
              failure: null,
            ),
          ),
        );

      case AccountingReportType.dayBook:
        final result = await _getDayBook(
          GetDayBookParams(date: to),
        );
        result.fold(
          (failure) => emit(
            state.copyWith(status: LoadStatus.failure, failure: failure),
          ),
          (report) => emit(
            state.copyWith(
              status: LoadStatus.success,
              dayBook: report,
              failure: null,
            ),
          ),
        );

      case AccountingReportType.gstSummary:
        final result = await _getGstSummary(
          GetGstSummaryParams(from: from, to: to),
        );
        result.fold(
          (failure) => emit(
            state.copyWith(status: LoadStatus.failure, failure: failure),
          ),
          (report) => emit(
            state.copyWith(
              status: LoadStatus.success,
              gstSummary: report,
              failure: null,
            ),
          ),
        );
    }
  }
}
