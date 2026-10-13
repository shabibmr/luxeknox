import 'package:equatable/equatable.dart';

class FundTransfer extends Equatable {
  const FundTransfer({
    required this.id,
    required this.transferNumber,
    required this.transferDate,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    this.feeAmount = '0.00',
    this.feeAccountId,
    this.memo,
    required this.status,
    this.journalEntryId,
    this.rowVersion = 1,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String transferNumber;
  final DateTime transferDate;
  final String fromAccountId;
  final String toAccountId;
  final String amount;
  final String feeAmount;
  final String? feeAccountId;
  final String? memo;
  final String status;
  final String? journalEntryId;
  final int rowVersion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isDraft => status == 'draft';
  bool get isPosted => status == 'posted';
  bool get hasFee => double.tryParse(feeAmount) != null && double.parse(feeAmount) > 0.0;

  @override
  List<Object?> get props => [
        id,
        transferNumber,
        transferDate,
        fromAccountId,
        toAccountId,
        amount,
        feeAmount,
        feeAccountId,
        memo,
        status,
        journalEntryId,
        rowVersion,
        createdAt,
        updatedAt,
      ];
}
