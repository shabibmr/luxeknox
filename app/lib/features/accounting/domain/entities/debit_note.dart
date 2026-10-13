import 'package:equatable/equatable.dart';

class DebitNote extends Equatable {
  const DebitNote({
    required this.id,
    required this.noteNumber,
    required this.noteDate,
    required this.purchaseBillId,
    required this.amount,
    required this.taxAmount,
    required this.status,
    this.journalEntryId,
    this.reason,
    this.rowVersion = 1,
  });

  final String id;
  final String noteNumber;
  final DateTime noteDate;
  final String purchaseBillId;
  final String amount;
  final String taxAmount;
  final String status;
  final String? journalEntryId;
  final String? reason;
  final int rowVersion;

  @override
  List<Object?> get props => [
    id,
    noteNumber,
    noteDate,
    purchaseBillId,
    amount,
    taxAmount,
    status,
    journalEntryId,
    reason,
    rowVersion,
  ];
}
