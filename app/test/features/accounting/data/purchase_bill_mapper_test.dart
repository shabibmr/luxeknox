import 'package:api_client/api_client.dart' as api;
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/accounting/data/models/accounting_mappers.dart';
import 'package:luxeknox/features/accounting/domain/entities/purchase_bill.dart';

api.PurchaseBillLine _line({
  int? itemId,
  String itemName = '',
  String uomCode = '',
  bool tracked = false,
  String quantity = '1.000',
  String? description,
}) => api.PurchaseBillLine(
  (b) => b
    ..id = 1
    ..purchaseBillId = 5
    ..itemId = itemId
    ..itemName = itemName
    ..uomCode = uomCode
    ..inventoryTracked = tracked
    ..returnedQuantity = '0.000'
    ..accountId = 40
    ..description = description
    ..quantity = quantity
    ..rate = '100.00'
    ..netAmount = '100.00'
    ..taxAmount = '18.00',
);

api.PurchaseBill _bill(List<api.PurchaseBillLine> lines, {String? invoiceNo}) =>
    api.PurchaseBill(
      (b) => b
        ..id = 5
        ..billNumber = 'PB-1'
        ..supplierInvoiceNo = invoiceNo
        ..vendorId = 3
        ..billDate = api.Date(2026, 1, 2)
        ..status = api.PurchaseBillStatus.draft
        ..subtotal = '100.00'
        ..taxAmount = '18.00'
        ..totalAmount = '118.00'
        ..rowVersion = 1
        ..createdAt = DateTime.utc(2026, 1, 2)
        ..lines.replace(lines),
    );

void main() {
  group('purchase bill mapper', () {
    test('tracked line carries item name, UOM and tracked flag', () {
      final bill = _bill([
        _line(itemId: 9, itemName: 'Whey', uomCode: 'KG', tracked: true),
      ], invoiceNo: 'INV-77').toDomain();
      final l = bill.lines.single;
      expect(bill.supplierInvoiceNo, 'INV-77');
      expect(l.itemId, '9');
      expect(l.itemName, 'Whey');
      expect(l.uomCode, 'KG');
      expect(l.inventoryTracked, true);
      expect(l.quantity, '1.000');
    });

    test('untracked item line is not flagged tracked', () {
      final l = _bill([
        _line(itemId: 4, itemName: 'Towel', uomCode: 'PCS'),
      ]).toDomain().lines.single;
      expect(l.inventoryTracked, false);
      expect(l.itemName, 'Towel');
    });

    test('service line without item keeps description, no supplier no', () {
      final bill = _bill([_line(description: 'Repair')]).toDomain();
      expect(bill.supplierInvoiceNo, isNull);
      expect(bill.lines.single.itemId, isNull);
      expect(bill.lines.single.description, 'Repair');
    });

    test('create payload omits account_id for item lines and sends invoice no',
        () {
      final create = toPurchaseBillCreate(
        vendorId: '3',
        billDate: DateTime(2026, 1, 2),
        supplierInvoiceNo: 'INV-77',
        lines: const [
          PurchaseBillLine(
            id: '',
            billId: '',
            itemId: '9',
            quantity: '2.500',
            unitPrice: '10.00',
            amount: '25.00',
          ),
        ],
      );
      expect(create.supplierInvoiceNo, 'INV-77');
      expect(create.lines.single.accountId, isNull);
      expect(create.lines.single.itemId, 9);
    });
  });
}
