import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/accounting_period.dart';
import '../../domain/usecases/get_accounting_periods_usecase.dart';
import '../../domain/usecases/get_fiscal_years_usecase.dart';
import '../../domain/usecases/lock_accounting_period_usecase.dart';
import '../../domain/usecases/unlock_accounting_period_usecase.dart';

part 'accounting_periods_cubit.freezed.dart';

@freezed
abstract class AccountingPeriodsState with _$AccountingPeriodsState {
  const factory AccountingPeriodsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<FiscalYear>[]) List<FiscalYear> fiscalYears,
    @Default(<AccountingPeriod>[]) List<AccountingPeriod> periods,
    String? selectedFiscalYearId,
    @Default(false) bool isActionInProgress,
    Failure? failure,
  }) = _AccountingPeriodsState;
}

@injectable
class AccountingPeriodsCubit extends Cubit<AccountingPeriodsState> {
  AccountingPeriodsCubit(
    this._getFiscalYears,
    this._getAccountingPeriods,
    this._lockPeriod,
    this._unlockPeriod,
  ) : super(const AccountingPeriodsState());

  final GetFiscalYearsUseCase _getFiscalYears;
  final GetAccountingPeriodsUseCase _getAccountingPeriods;
  final LockAccountingPeriodUseCase _lockPeriod;
  final UnlockAccountingPeriodUseCase _unlockPeriod;

  Future<void> load({String? fiscalYearId}) async {
    final targetFiscalYearId = fiscalYearId ?? state.selectedFiscalYearId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        selectedFiscalYearId: targetFiscalYearId,
        failure: null,
      ),
    );

    final yearsResult = await _getFiscalYears(const NoParams());
    final periodsResult = await _getAccountingPeriods(
      GetAccountingPeriodsParams(fiscalYearId: targetFiscalYearId),
    );

    Failure? failure;
    List<FiscalYear> years = state.fiscalYears;
    List<AccountingPeriod> periods = [];

    yearsResult.fold(
      (f) => failure ??= f,
      (list) => years = list,
    );

    periodsResult.fold(
      (f) => failure ??= f,
      (list) => periods = list,
    );

    if (failure != null && years.isEmpty && periods.isEmpty) {
      emit(state.copyWith(status: LoadStatus.failure, failure: failure));
    } else {
      emit(
        state.copyWith(
          status: LoadStatus.success,
          fiscalYears: years,
          periods: periods,
          selectedFiscalYearId: targetFiscalYearId,
          failure: null,
        ),
      );
    }
  }

  Future<void> selectFiscalYear(String? fiscalYearId) async {
    await load(fiscalYearId: fiscalYearId);
  }

  Future<void> lock(String periodId) async {
    emit(state.copyWith(isActionInProgress: true, failure: null));
    final result = await _lockPeriod(
      LockAccountingPeriodParams(id: periodId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(isActionInProgress: false, failure: failure),
      ),
      (updated) {
        final updatedPeriods = state.periods
            .map((p) => p.id == updated.id ? updated : p)
            .toList();
        emit(
          state.copyWith(
            isActionInProgress: false,
            periods: updatedPeriods,
            failure: null,
          ),
        );
      },
    );
  }

  Future<void> unlock(String periodId) async {
    emit(state.copyWith(isActionInProgress: true, failure: null));
    final result = await _unlockPeriod(
      UnlockAccountingPeriodParams(id: periodId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(isActionInProgress: false, failure: failure),
      ),
      (updated) {
        final updatedPeriods = state.periods
            .map((p) => p.id == updated.id ? updated : p)
            .toList();
        emit(
          state.copyWith(
            isActionInProgress: false,
            periods: updatedPeriods,
            failure: null,
          ),
        );
      },
    );
  }
}
