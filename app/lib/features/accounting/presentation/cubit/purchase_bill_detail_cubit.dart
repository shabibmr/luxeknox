import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/purchase_bill.dart';
import '../../domain/usecases/get_purchase_bill_usecase.dart';

const Object _sentinel = Object();

class PurchaseBillDetailState extends Equatable {
  const PurchaseBillDetailState({
    this.status = LoadStatus.initial,
    this.bill,
    this.failure,
  });

  final LoadStatus status;
  final PurchaseBill? bill;
  final Failure? failure;

  PurchaseBillDetailState copyWith({
    LoadStatus? status,
    Object? bill = _sentinel,
    Object? failure = _sentinel,
  }) {
    return PurchaseBillDetailState(
      status: status ?? this.status,
      bill: identical(bill, _sentinel) ? this.bill : (bill as PurchaseBill?),
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        bill,
        failure,
      ];
}

@injectable
class PurchaseBillDetailCubit extends Cubit<PurchaseBillDetailState> {
  PurchaseBillDetailCubit(this._getPurchaseBill) : super(const PurchaseBillDetailState());

  final GetPurchaseBillUseCase _getPurchaseBill;

  Future<void> load(String id) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await _getPurchaseBill(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
        ),
      ),
      (bill) => emit(
        state.copyWith(
          status: LoadStatus.success,
          bill: bill,
          failure: null,
        ),
      ),
    );
  }

  void setBill(PurchaseBill bill) {
    emit(
      state.copyWith(
        status: LoadStatus.success,
        bill: bill,
        failure: null,
      ),
    );
  }
}
