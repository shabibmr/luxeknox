import 'package:equatable/equatable.dart';

class FiscalYear extends Equatable {
  const FiscalYear({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.isClosed = false,
  });

  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isClosed;

  @override
  List<Object?> get props => [id, name, startDate, endDate, isClosed];
}

class DraftDocumentCounts extends Equatable {
  const DraftDocumentCounts({
    required this.billsCount,
    required this.expensesCount,
    required this.paymentVouchersCount,
    required this.debitNotesCount,
  });

  final int billsCount;
  final int expensesCount;
  final int paymentVouchersCount;
  final int debitNotesCount;

  @override
  List<Object?> get props => [
    billsCount,
    expensesCount,
    paymentVouchersCount,
    debitNotesCount,
  ];
}

class AccountingPeriod extends Equatable {
  const AccountingPeriod({
    required this.id,
    required this.fiscalYearId,
    required this.periodNumber,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.isLocked = false,
    this.lockedAt,
    this.lockedByUserId,
    this.draftCounts,
  });

  final String id;
  final String fiscalYearId;
  final int periodNumber;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isLocked;
  final DateTime? lockedAt;
  final String? lockedByUserId;
  final DraftDocumentCounts? draftCounts;

  @override
  List<Object?> get props => [
    id,
    fiscalYearId,
    periodNumber,
    name,
    startDate,
    endDate,
    isLocked,
    lockedAt,
    lockedByUserId,
    draftCounts,
  ];
}
