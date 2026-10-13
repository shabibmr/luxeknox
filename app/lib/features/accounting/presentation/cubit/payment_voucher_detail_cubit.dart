import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/payment_voucher.dart';
import '../../domain/usecases/get_payment_voucher_usecase.dart';
import '../../domain/usecases/post_payment_voucher_usecase.dart';

const Object _sentinel = Object();

class PaymentVoucherDetailState extends Equatable {
  const PaymentVoucherDetailState({
    this.status = LoadStatus.initial,
    this.voucher,
    this.isPosting = false,
    this.failure,
    this.postSuccess,
  });

  final LoadStatus status;
  final PaymentVoucher? voucher;
  final bool isPosting;
  final Failure? failure;
  final PaymentVoucher? postSuccess;

  PaymentVoucherDetailState copyWith({
    LoadStatus? status,
    Object? voucher = _sentinel,
    bool? isPosting,
    Object? failure = _sentinel,
    Object? postSuccess = _sentinel,
  }) {
    return PaymentVoucherDetailState(
      status: status ?? this.status,
      voucher: identical(voucher, _sentinel)
          ? this.voucher
          : (voucher as PaymentVoucher?),
      isPosting: isPosting ?? this.isPosting,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      postSuccess: identical(postSuccess, _sentinel)
          ? this.postSuccess
          : (postSuccess as PaymentVoucher?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        voucher,
        isPosting,
        failure,
        postSuccess,
      ];
}

@injectable
class PaymentVoucherDetailCubit extends Cubit<PaymentVoucherDetailState> {
  PaymentVoucherDetailCubit(
    this._getPaymentVoucher,
    this._postPaymentVoucher,
  ) : super(const PaymentVoucherDetailState());

  final GetPaymentVoucherUseCase _getPaymentVoucher;
  final PostPaymentVoucherUseCase _postPaymentVoucher;

  Future<void> load(String id) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await _getPaymentVoucher(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
        ),
      ),
      (voucher) => emit(
        state.copyWith(
          status: LoadStatus.success,
          voucher: voucher,
          failure: null,
        ),
      ),
    );
  }

  void setVoucher(PaymentVoucher voucher) {
    emit(
      state.copyWith(
        status: LoadStatus.success,
        voucher: voucher,
        failure: null,
      ),
    );
  }

  Future<bool> post() async {
    final current = state.voucher;
    if (current == null) return false;

    emit(state.copyWith(isPosting: true, failure: null, postSuccess: null));

    final result = await _postPaymentVoucher(current.id);

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
      (postedVoucher) {
        emit(
          state.copyWith(
            isPosting: false,
            voucher: postedVoucher,
            postSuccess: postedVoucher,
            failure: null,
          ),
        );
        return true;
      },
    );
  }
}
