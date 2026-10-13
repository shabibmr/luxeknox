import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/purchase_bill.dart';
import '../../domain/usecases/get_purchase_bill_usecase.dart';
import '../../domain/usecases/post_purchase_bill_usecase.dart';

const Object _sentinel = Object();

class PurchaseBillDetailState extends Equatable {
  const PurchaseBillDetailState({
    this.status = LoadStatus.initial,
    this.bill,
    this.isPosting = false,
    this.failure,
    this.postSuccess,
  });

  final LoadStatus status;
  final PurchaseBill? bill;
  final bool isPosting;
  final Failure? failure;
  final PurchaseBill? postSuccess;

  PurchaseBillDetailState copyWith({
    LoadStatus? status,
    Object? bill = _sentinel,
    bool? isPosting,
    Object? failure = _sentinel,
    Object? postSuccess = _sentinel,
  }) {
    return PurchaseBillDetailState(
      status: status ?? this.status,
      bill: identical(bill, _sentinel) ? this.bill : (bill as PurchaseBill?),
      isPosting: isPosting ?? this.isPosting,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      postSuccess: identical(postSuccess, _sentinel)
          ? this.postSuccess
          : (postSuccess as PurchaseBill?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        bill,
        isPosting,
        failure,
        postSuccess,
      ];
}

@injectable
class PurchaseBillDetailCubit extends Cubit<PurchaseBillDetailState> {
  PurchaseBillDetailCubit(
    this._getPurchaseBill,
    this._postPurchaseBill,
  ) : super(const PurchaseBillDetailState());

  final GetPurchaseBillUseCase _getPurchaseBill;
  final PostPurchaseBillUseCase _postPurchaseBill;

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

  Future<bool> post() async {
    final currentBill = state.bill;
    if (currentBill == null) return false;

    emit(state.copyWith(isPosting: true, failure: null, postSuccess: null));

    final result = await _postPurchaseBill(currentBill.id);

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isPosting: false,
            failure: failure,
          ),
        );
        return false;
      },
      (postedBill) {
        emit(
          state.copyWith(
            isPosting: false,
            bill: postedBill,
            postSuccess: postedBill,
            failure: null,
          ),
        );
        return true;
      },
    );
  }
}
