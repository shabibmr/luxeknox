import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

// tests for PaymentReceipt
void main() {
  final instance = PaymentReceiptBuilder();
  // TODO add properties to the builder and call build()

  group(PaymentReceipt, () {
    // int id
    test('to test the property `id`', () async {
      // TODO
    });

    // int paymentId
    test('to test the property `paymentId`', () async {
      // TODO
    });

    // String receiptNumber
    test('to test the property `receiptNumber`', () async {
      // TODO
    });

    // Null in MVP; receipt is re-rendered from ledger rows (ADR-0005).
    // String receiptPdfUrl
    test('to test the property `receiptPdfUrl`', () async {
      // TODO
    });

    // UTC ISO-8601
    // DateTime generatedAt
    test('to test the property `generatedAt`', () async {
      // TODO
    });

    // Payment payment
    test('to test the property `payment`', () async {
      // TODO
    });

  });
}
