import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/payment.dart';
import '../../domain/usecases/get_outstanding_payments_usecase.dart';

part 'outstanding_dues_cubit.freezed.dart';

@freezed
abstract class OutstandingDuesState with _$OutstandingDuesState {
  const factory OutstandingDuesState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<Payment>[]) List<Payment> items,
    Failure? failure,
  }) = _OutstandingDuesState;
}

@injectable
class OutstandingDuesCubit extends Cubit<OutstandingDuesState> {
  OutstandingDuesCubit(this._getOutstanding)
    : super(const OutstandingDuesState());

  final GetOutstandingPaymentsUseCase _getOutstanding;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getOutstanding(
      const GetOutstandingPaymentsParams(),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: page.items,
          failure: null,
        ),
      ),
    );
  }
}
