import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/expense_voucher.dart';
import '../../domain/entities/purchase_bill.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/usecases/create_expense_usecase.dart';

const Object _sentinel = Object();

class ExpenseFormLineDraft extends Equatable {
  const ExpenseFormLineDraft({
    this.account,
    this.description = '',
    this.amount = '',
  });

  final Account? account;
  final String description;
  final String amount;

  ExpenseFormLineDraft copyWith({
    Object? account = _sentinel,
    String? description,
    String? amount,
  }) {
    return ExpenseFormLineDraft(
      account: identical(account, _sentinel)
          ? this.account
          : (account as Account?),
      description: description ?? this.description,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [account, description, amount];
}

class ExpenseFormState extends Equatable {
  ExpenseFormState({
    this.status = LoadStatus.initial,
    DateTime? expenseDate,
    this.paidFromAccount,
    this.vendor,
    this.payeeName,
    this.lines = const [
      ExpenseFormLineDraft(),
    ],
    this.isSubmitting = false,
    this.failure,
    this.createdExpense,
  }) : expenseDate = expenseDate ?? _defaultDate();

  static DateTime _defaultDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  final LoadStatus status;
  final DateTime expenseDate;
  final Account? paidFromAccount;
  final Vendor? vendor;
  final String? payeeName;
  final List<ExpenseFormLineDraft> lines;
  final bool isSubmitting;
  final Failure? failure;
  final ExpenseVoucher? createdExpense;

  String? get paidFromAccountId => paidFromAccount?.id;
  String? get vendorId => vendor?.id;
  bool get isCreditExpense => paidFromAccount == null;

  double get subtotal => lines.fold<double>(
        0.0,
        (sum, line) => sum + (double.tryParse(line.amount) ?? 0.0),
      );

  double get taxAmount => 0.0;

  double get totalAmount => subtotal + taxAmount;

  bool get hasValidLines {
    if (lines.isEmpty) return false;
    return lines.every((l) {
      if (l.account == null) return false;
      final a = double.tryParse(l.amount);
      return a != null && a > 0;
    });
  }

  bool get hasValidPayee {
    if (!isCreditExpense) return true;
    return (vendorId != null && vendorId!.isNotEmpty) ||
        (payeeName != null && payeeName!.trim().isNotEmpty);
  }

  bool get canSubmit =>
      !isSubmitting && hasValidLines && hasValidPayee && totalAmount > 0;

  ExpenseFormState copyWith({
    LoadStatus? status,
    DateTime? expenseDate,
    Object? paidFromAccount = _sentinel,
    Object? vendor = _sentinel,
    Object? payeeName = _sentinel,
    List<ExpenseFormLineDraft>? lines,
    bool? isSubmitting,
    Object? failure = _sentinel,
    Object? createdExpense = _sentinel,
  }) {
    return ExpenseFormState(
      status: status ?? this.status,
      expenseDate: expenseDate ?? this.expenseDate,
      paidFromAccount: identical(paidFromAccount, _sentinel)
          ? this.paidFromAccount
          : (paidFromAccount as Account?),
      vendor: identical(vendor, _sentinel)
          ? this.vendor
          : (vendor as Vendor?),
      payeeName: identical(payeeName, _sentinel)
          ? this.payeeName
          : (payeeName as String?),
      lines: lines ?? this.lines,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      createdExpense: identical(createdExpense, _sentinel)
          ? this.createdExpense
          : (createdExpense as ExpenseVoucher?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        expenseDate,
        paidFromAccount,
        vendor,
        payeeName,
        lines,
        isSubmitting,
        failure,
        createdExpense,
      ];
}

@injectable
class ExpenseFormCubit extends Cubit<ExpenseFormState> {
  ExpenseFormCubit(this._createExpense) : super(ExpenseFormState());

  final CreateExpenseUseCase _createExpense;

  void setExpenseDate(DateTime date) {
    emit(state.copyWith(expenseDate: date));
  }

  void setPaidFromAccount(Account? account) {
    emit(state.copyWith(paidFromAccount: account));
  }

  void setVendor(Vendor? vendor) {
    emit(state.copyWith(vendor: vendor));
  }

  void setPayeeName(String? payeeName) {
    emit(state.copyWith(payeeName: payeeName));
  }

  void addLine() {
    emit(
      state.copyWith(
        lines: [...state.lines, const ExpenseFormLineDraft()],
      ),
    );
  }

  void removeLine(int index) {
    if (state.lines.length <= 1) return;
    if (index < 0 || index >= state.lines.length) return;
    final updated = List<ExpenseFormLineDraft>.from(state.lines)..removeAt(index);
    emit(state.copyWith(lines: updated));
  }

  void updateLine(
    int index, {
    Object? account = _sentinel,
    String? description,
    String? amount,
  }) {
    if (index < 0 || index >= state.lines.length) return;
    final current = state.lines[index];
    final updated = current.copyWith(
      account: account,
      description: description,
      amount: amount,
    );
    final updatedLines = List<ExpenseFormLineDraft>.from(state.lines);
    updatedLines[index] = updated;
    emit(state.copyWith(lines: updatedLines));
  }

  Future<bool> submit() async {
    if (!state.canSubmit) return false;

    emit(state.copyWith(isSubmitting: true, failure: null));

    final mappedLines = state.lines.map((l) {
      return PurchaseBillLine(
        id: '',
        billId: '',
        accountId: l.account!.id,
        description: l.description.isEmpty ? null : l.description,
        quantity: '1',
        unitPrice: l.amount,
        amount: l.amount,
      );
    }).toList();

    final result = await _createExpense(
      CreateExpenseParams(
        expenseDate: state.expenseDate,
        paidFromAccountId: state.paidFromAccountId,
        vendorId: state.vendorId,
        payeeName: state.payeeName,
        lines: mappedLines,
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
      (expense) {
        emit(
          state.copyWith(
            status: LoadStatus.success,
            createdExpense: expense,
            isSubmitting: false,
            failure: null,
          ),
        );
        return true;
      },
    );
  }
}
