import 'package:equatable/equatable.dart';

class PurchaseBill extends Equatable {
  const PurchaseBill({
    required this.id,
    required this.billNumber,
    required this.vendorId,
    this.vendorName,
    required this.billDate,
    this.dueDate,
    required this.subtotal,
    required this.taxAmount,
    required this.totalAmount,
    required this.status,
    required this.allocatedAmount,
    this.journalEntryId,
    this.rowVersion = 1,
    this.lines = const [],
  });

  final String id;
  final String billNumber;
  final String vendorId;
  final String? vendorName;
  final DateTime billDate;
  final DateTime? dueDate;
  final String subtotal;
  final String taxAmount;
  final String totalAmount;
  final String status;
  final String allocatedAmount;
  final String? journalEntryId;
  final int rowVersion;
  final List<PurchaseBillLine> lines;

  @override
  List<Object?> get props => [
    id,
    billNumber,
    vendorId,
    vendorName,
    billDate,
    dueDate,
    subtotal,
    taxAmount,
    totalAmount,
    status,
    allocatedAmount,
    journalEntryId,
    rowVersion,
    lines,
  ];
}

class PurchaseBillLine extends Equatable {
  const PurchaseBillLine({
    required this.id,
    required this.billId,
    required this.accountId,
    this.itemId,
    this.description,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    this.taxCodeId,
    this.taxAmount,
  });

  final String id;
  final String billId;
  final String accountId;
  final String? itemId;
  final String? description;
  final String quantity;
  final String unitPrice;
  final String amount;
  final String? taxCodeId;
  final String? taxAmount;

  @override
  List<Object?> get props => [
    id,
    billId,
    accountId,
    itemId,
    description,
    quantity,
    unitPrice,
    amount,
    taxCodeId,
    taxAmount,
  ];
}
