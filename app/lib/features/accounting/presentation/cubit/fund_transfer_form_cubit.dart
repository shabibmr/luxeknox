import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/fund_transfer.dart';
import '../../domain/usecases/create_fund_transfer_usecase.dart';
import '../accounting_strings.dart';

const Object _sentinel = Object();

class FundTransferFormState extends Equatable {
  FundTransferFormState({
    this.status = LoadStatus.initial,
    DateTime? transferDate,
    this.fromAccountId = '',
    this.toAccountId = '',
    this.fromAccount,
    this.toAccount,
    this.amount = '',
    this.feeAmount = '',
    this.feeAccountId,
    this.feeAccount,
    this.memo,
    this.isSubmitting = false,
    this.failure,
    this.createdTransfer,
    this.fromAccountError,
    this.toAccountError,
    this.amountError,
    this.feeAmountError,
  }) : transferDate = transferDate ?? _defaultDate();

  static DateTime _defaultDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  final LoadStatus status;
  final DateTime transferDate;
  final String fromAccountId;
  final String toAccountId;
  final Account? fromAccount;
  final Account? toAccount;
  final String amount;
  final String feeAmount;
  final String? feeAccountId;
  final Account? feeAccount;
  final String? memo;
  final bool isSubmitting;
  final Failure? failure;
  final FundTransfer? createdTransfer;
  final String? fromAccountError;
  final String? toAccountError;
  final String? amountError;
  final String? feeAmountError;

  FundTransferFormState copyWith({
    LoadStatus? status,
    DateTime? transferDate,
    String? fromAccountId,
    String? toAccountId,
    Object? fromAccount = _sentinel,
    Object? toAccount = _sentinel,
    String? amount,
    String? feeAmount,
    Object? feeAccountId = _sentinel,
    Object? feeAccount = _sentinel,
    Object? memo = _sentinel,
    bool? isSubmitting,
    Object? failure = _sentinel,
    Object? createdTransfer = _sentinel,
    Object? fromAccountError = _sentinel,
    Object? toAccountError = _sentinel,
    Object? amountError = _sentinel,
    Object? feeAmountError = _sentinel,
  }) {
    return FundTransferFormState(
      status: status ?? this.status,
      transferDate: transferDate ?? this.transferDate,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      fromAccount: identical(fromAccount, _sentinel)
          ? this.fromAccount
          : (fromAccount as Account?),
      toAccount: identical(toAccount, _sentinel)
          ? this.toAccount
          : (toAccount as Account?),
      amount: amount ?? this.amount,
      feeAmount: feeAmount ?? this.feeAmount,
      feeAccountId: identical(feeAccountId, _sentinel)
          ? this.feeAccountId
          : (feeAccountId as String?),
      feeAccount: identical(feeAccount, _sentinel)
          ? this.feeAccount
          : (feeAccount as Account?),
      memo: identical(memo, _sentinel) ? this.memo : (memo as String?),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      createdTransfer: identical(createdTransfer, _sentinel)
          ? this.createdTransfer
          : (createdTransfer as FundTransfer?),
      fromAccountError: identical(fromAccountError, _sentinel)
          ? this.fromAccountError
          : (fromAccountError as String?),
      toAccountError: identical(toAccountError, _sentinel)
          ? this.toAccountError
          : (toAccountError as String?),
      amountError: identical(amountError, _sentinel)
          ? this.amountError
          : (amountError as String?),
      feeAmountError: identical(feeAmountError, _sentinel)
          ? this.feeAmountError
          : (feeAmountError as String?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        transferDate,
        fromAccountId,
        toAccountId,
        fromAccount,
        toAccount,
        amount,
        feeAmount,
        feeAccountId,
        feeAccount,
        memo,
        isSubmitting,
        failure,
        createdTransfer,
        fromAccountError,
        toAccountError,
        amountError,
        feeAmountError,
      ];
}

@injectable
class FundTransferFormCubit extends Cubit<FundTransferFormState> {
  FundTransferFormCubit(this._createFundTransfer)
      : super(FundTransferFormState());

  final CreateFundTransferUseCase _createFundTransfer;

  void transferDateChanged(DateTime date) {
    emit(state.copyWith(transferDate: date));
  }

  void fromAccountSelected(Account account) {
    emit(
      state.copyWith(
        fromAccountId: account.id,
        fromAccount: account,
        fromAccountError: null,
        toAccountError:
            account.id == state.toAccountId && state.toAccountId.isNotEmpty
                ? AccountingStrings.cannotTransferSameAccount
                : null,
      ),
    );
  }

  void toAccountSelected(Account account) {
    emit(
      state.copyWith(
        toAccountId: account.id,
        toAccount: account,
        toAccountError: account.id == state.fromAccountId
            ? AccountingStrings.cannotTransferSameAccount
            : null,
      ),
    );
  }

  void feeAccountSelected(Account? account) {
    emit(
      state.copyWith(
        feeAccountId: account?.id,
        feeAccount: account,
      ),
    );
  }

  void amountChanged(String value) {
    String? error;
    final parsed = double.tryParse(value);
    if (value.isNotEmpty && (parsed == null || parsed <= 0)) {
      error = 'Amount must be greater than zero';
    }
    emit(state.copyWith(amount: value, amountError: error));
  }

  void feeAmountChanged(String value) {
    String? error;
    final parsed = double.tryParse(value);
    if (value.isNotEmpty && (parsed == null || parsed < 0)) {
      error = 'Fee amount cannot be negative';
    }
    emit(state.copyWith(feeAmount: value, feeAmountError: error));
  }

  void memoChanged(String value) {
    emit(state.copyWith(memo: value));
  }

  bool validate() {
    String? fromError;
    if (state.fromAccountId.isEmpty) {
      fromError = 'Source account is required';
    }

    String? toError;
    if (state.toAccountId.isEmpty) {
      toError = 'Destination account is required';
    } else if (state.fromAccountId.isNotEmpty &&
        state.fromAccountId == state.toAccountId) {
      toError = AccountingStrings.cannotTransferSameAccount;
    }

    String? amountErr;
    final parsedAmount = double.tryParse(state.amount);
    if (state.amount.isEmpty || parsedAmount == null || parsedAmount <= 0) {
      amountErr = 'Amount must be greater than zero';
    }

    String? feeErr;
    if (state.feeAmount.isNotEmpty) {
      final parsedFee = double.tryParse(state.feeAmount);
      if (parsedFee == null || parsedFee < 0) {
        feeErr = 'Fee amount cannot be negative';
      }
    }

    emit(
      state.copyWith(
        fromAccountError: fromError,
        toAccountError: toError,
        amountError: amountErr,
        feeAmountError: feeErr,
      ),
    );

    return fromError == null &&
        toError == null &&
        amountErr == null &&
        feeErr == null;
  }

  Future<bool> submit() async {
    if (!validate()) return false;

    emit(state.copyWith(isSubmitting: true, failure: null));

    final fee = state.feeAmount.trim().isEmpty ? '0.00' : state.feeAmount.trim();

    final result = await _createFundTransfer(
      CreateFundTransferParams(
        transferDate: state.transferDate,
        fromAccountId: state.fromAccountId,
        toAccountId: state.toAccountId,
        amount: state.amount.trim(),
        feeAmount: fee,
        feeAccountId: state.feeAccountId,
        memo: state.memo?.trim().isEmpty == true ? null : state.memo?.trim(),
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
      (transfer) {
        emit(
          state.copyWith(
            status: LoadStatus.success,
            createdTransfer: transfer,
            isSubmitting: false,
            failure: null,
          ),
        );
        return true;
      },
    );
  }
}
