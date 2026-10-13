import 'package:equatable/equatable.dart';

class Journal extends Equatable {
  const Journal({
    required this.id,
    required this.journalNumber,
    required this.entryDate,
    this.sourceType,
    this.sourceId,
    this.memo,
    required this.status,
    this.reversesJournalId,
    this.isClosing = false,
    this.isOpening = false,
    this.rowVersion = 1,
    this.lines = const [],
  });

  final String id;
  final String journalNumber;
  final DateTime entryDate;
  final String? sourceType;
  final String? sourceId;
  final String? memo;
  final String status;
  final String? reversesJournalId;
  final bool isClosing;
  final bool isOpening;
  final int rowVersion;
  final List<JournalLine> lines;

  @override
  List<Object?> get props => [
    id,
    journalNumber,
    entryDate,
    sourceType,
    sourceId,
    memo,
    status,
    reversesJournalId,
    isClosing,
    isOpening,
    rowVersion,
    lines,
  ];
}

class JournalLine extends Equatable {
  const JournalLine({
    required this.id,
    required this.journalId,
    required this.accountId,
    this.accountCode,
    this.accountName,
    required this.debit,
    required this.credit,
    this.description,
  });

  final String id;
  final String journalId;
  final String accountId;
  final String? accountCode;
  final String? accountName;
  final String debit;
  final String credit;
  final String? description;

  @override
  List<Object?> get props => [
    id,
    journalId,
    accountId,
    accountCode,
    accountName,
    debit,
    credit,
    description,
  ];
}
