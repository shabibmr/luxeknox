import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/journal.dart';
import '../../domain/usecases/get_journals_usecase.dart';

part 'journals_cubit.freezed.dart';

@freezed
abstract class JournalsState with _$JournalsState {
  const factory JournalsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<Journal>[]) List<Journal> journals,
    DateTime? fromDate,
    DateTime? toDate,
    String? paymentId,
    String? sourceType,
    Failure? failure,
  }) = _JournalsState;
}

@injectable
class JournalsCubit extends Cubit<JournalsState> {
  JournalsCubit(this._getJournals) : super(const JournalsState());

  final GetJournalsUseCase _getJournals;

  Future<void> load({
    DateTime? from,
    DateTime? to,
    String? paymentId,
    String? sourceType,
    bool clearDates = false,
    bool clearPaymentId = false,
  }) async {
    final nextFrom = clearDates ? null : (from ?? state.fromDate);
    final nextTo = clearDates ? null : (to ?? state.toDate);
    final nextPaymentId =
        clearPaymentId ? null : (paymentId ?? state.paymentId);
    final nextSourceType = sourceType ?? state.sourceType;

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        fromDate: nextFrom,
        toDate: nextTo,
        paymentId: nextPaymentId,
        sourceType: nextSourceType,
        failure: null,
      ),
    );

    final result = await _getJournals(
      GetJournalsParams(
        from: nextFrom,
        to: nextTo,
        paymentId: nextPaymentId,
        sourceType: nextSourceType,
        limit: 100,
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
          journals: page.items,
          failure: null,
        ),
      ),
    );
  }

  Future<void> filterByDateRange(DateTime? from, DateTime? to) {
    return load(from: from, to: to, clearDates: from == null && to == null);
  }

  Future<void> filterByPaymentId(String? paymentId) {
    return load(paymentId: paymentId, clearPaymentId: paymentId == null);
  }

  Future<void> filterBySourceType(String? sourceType) {
    return load(sourceType: sourceType);
  }

  Future<void> clearFilters() {
    return load(clearDates: true, clearPaymentId: true, sourceType: null);
  }
}
