import 'package:equatable/equatable.dart';

class PurchaseBill extends Equatable {
  const PurchaseBill({
    required this.id,
    required this.billNumber,
    this.supplierInvoiceNo,
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
  final String? supplierInvoiceNo;
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
    supplierInvoiceNo,
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
    this.accountId,
    this.itemId,
    this.itemName,
    this.uomCode,
    this.inventoryTracked = false,
    this.description,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    this.taxCodeId,
    this.taxAmount,
  });

  final String id;
  final String billId;
  /// Null on item lines the server routes (tracked: inventory account).
  final String? accountId;
  final String? itemId;
  final String? itemName;
  final String? uomCode;
  final bool inventoryTracked;
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
    itemName,
    uomCode,
    inventoryTracked,
    description,
    quantity,
    unitPrice,
    amount,
    taxCodeId,
    taxAmount,
  ];
}
