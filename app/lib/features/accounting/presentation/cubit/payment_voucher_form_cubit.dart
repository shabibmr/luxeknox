import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/payment_voucher.dart';
import '../../domain/usecases/create_payment_voucher_usecase.dart';

const Object _sentinel = Object();

class PaymentVoucherAllocationDraft extends Equatable {
  const PaymentVoucherAllocationDraft({
    this.targetType = 'bill',
    this.targetId = '',
    this.targetNumber = '',
    this.amount = '',
  });

  final String targetType;
  final String targetId;
  final String targetNumber;
  final String amount;

  PaymentVoucherAllocationDraft copyWith({
    String? targetType,
    String? targetId,
    String? targetNumber,
    String? amount,
  }) {
    return PaymentVoucherAllocationDraft(
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      targetNumber: targetNumber ?? this.targetNumber,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [targetType, targetId, targetNumber, amount];
}

class PaymentVoucherFormState extends Equatable {
  PaymentVoucherFormState({
    this.status = LoadStatus.initial,
    DateTime? paymentDate,
    this.bankAccount,
    this.totalAmount = '',
    this.memo,
    this.allocations = const [
      PaymentVoucherAllocationDraft(),
    ],
    this.isSubmitting = false,
    this.failure,
    this.createdVoucher,
  }) : paymentDate = paymentDate ?? _defaultDate();

  static DateTime _defaultDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  final LoadStatus status;
  final DateTime paymentDate;
  final Account? bankAccount;
  final String totalAmount;
  final String? memo;
  final List<PaymentVoucherAllocationDraft> allocations;
  final bool isSubmitting;
  final Failure? failure;
  final PaymentVoucher? createdVoucher;

  String? get bankAccountId => bankAccount?.id;

  double get allocationsSum => allocations.fold<double>(
        0.0,
        (sum, a) => sum + (double.tryParse(a.amount) ?? 0.0),
      );

  double get parsedTotalAmount => double.tryParse(totalAmount) ?? 0.0;

  bool get isAllocationsMatching =>
      parsedTotalAmount > 0 &&
      (allocationsSum - parsedTotalAmount).abs() < 0.001;

  bool get hasAllocationMismatch =>
      totalAmount.isNotEmpty &&
      allocations.isNotEmpty &&
      !isAllocationsMatching;

  bool get hasValidAllocations {
    if (allocations.isEmpty) return false;
    return allocations.every((a) {
      if (a.targetId.trim().isEmpty) return false;
      final amt = double.tryParse(a.amount);
      return amt != null && amt > 0;
    });
  }

  bool get canSubmit =>
      !isSubmitting &&
      bankAccountId != null &&
      bankAccountId!.isNotEmpty &&
      hasValidAllocations &&
      isAllocationsMatching;

  PaymentVoucherFormState copyWith({
    LoadStatus? status,
    DateTime? paymentDate,
    Object? bankAccount = _sentinel,
    String? totalAmount,
    Object? memo = _sentinel,
    List<PaymentVoucherAllocationDraft>? allocations,
    bool? isSubmitting,
    Object? failure = _sentinel,
    Object? createdVoucher = _sentinel,
  }) {
    return PaymentVoucherFormState(
      status: status ?? this.status,
      paymentDate: paymentDate ?? this.paymentDate,
      bankAccount: identical(bankAccount, _sentinel)
          ? this.bankAccount
          : (bankAccount as Account?),
      totalAmount: totalAmount ?? this.totalAmount,
      memo: identical(memo, _sentinel) ? this.memo : (memo as String?),
      allocations: allocations ?? this.allocations,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      createdVoucher: identical(createdVoucher, _sentinel)
          ? this.createdVoucher
          : (createdVoucher as PaymentVoucher?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        paymentDate,
        bankAccount,
        totalAmount,
        memo,
        allocations,
        isSubmitting,
        failure,
        createdVoucher,
      ];
}

@injectable
class PaymentVoucherFormCubit extends Cubit<PaymentVoucherFormState> {
  PaymentVoucherFormCubit(this._createPaymentVoucher)
      : super(PaymentVoucherFormState());

  final CreatePaymentVoucherUseCase _createPaymentVoucher;

  void setPaymentDate(DateTime date) {
    emit(state.copyWith(paymentDate: date));
  }

  void setBankAccount(Account? bankAccount) {
    emit(state.copyWith(bankAccount: bankAccount));
  }

  void setTotalAmount(String totalAmount) {
    emit(state.copyWith(totalAmount: totalAmount));
  }

  void setMemo(String? memo) {
    emit(state.copyWith(memo: memo));
  }

  void addAllocation({
    String targetType = 'bill',
    String targetId = '',
    String targetNumber = '',
    String amount = '',
  }) {
    emit(
      state.copyWith(
        allocations: [
          ...state.allocations,
          PaymentVoucherAllocationDraft(
            targetType: targetType,
            targetId: targetId,
            targetNumber: targetNumber,
            amount: amount,
          ),
        ],
      ),
    );
  }

  void removeAllocation(int index) {
    if (state.allocations.length <= 1) return;
    if (index < 0 || index >= state.allocations.length) return;
    final updated = List<PaymentVoucherAllocationDraft>.from(state.allocations)
      ..removeAt(index);
    emit(state.copyWith(allocations: updated));
  }

  void updateAllocation(
    int index, {
    String? targetType,
    String? targetId,
    String? targetNumber,
    String? amount,
  }) {
    if (index < 0 || index >= state.allocations.length) return;
    final current = state.allocations[index];
    final updated = current.copyWith(
      targetType: targetType,
      targetId: targetId,
      targetNumber: targetNumber,
      amount: amount,
    );
    final updatedAllocations =
        List<PaymentVoucherAllocationDraft>.from(state.allocations);
    updatedAllocations[index] = updated;
    emit(state.copyWith(allocations: updatedAllocations));
  }

  Future<bool> submit() async {
    if (!state.canSubmit) return false;

    emit(state.copyWith(isSubmitting: true, failure: null));

    final mappedAllocations = state.allocations.map((a) {
      final map = <String, dynamic>{
        'amount': a.amount,
      };
      if (a.targetType == 'expense') {
        map['expenseVoucherId'] = a.targetId;
      } else {
        map['purchaseBillId'] = a.targetId;
      }
      return map;
    }).toList();

    final result = await _createPaymentVoucher(
      CreatePaymentVoucherParams(
        paymentDate: state.paymentDate,
        bankAccountId: state.bankAccountId!,
        totalAmount: state.totalAmount,
        memo: state.memo,
        allocations: mappedAllocations,
      ),
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            failure: failure,
            isSubmitting: false,
          ),
        );
        return false;
      },
      (voucher) {
        emit(
          state.copyWith(
            status: LoadStatus.success,
            createdVoucher: voucher,
            isSubmitting: false,
            failure: null,
          ),
        );
        return true;
      },
    );
  }
}
