import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

// tests for PaymentCreate
void main() {
  final instance = PaymentCreateBuilder();
  // TODO add properties to the builder and call build()

  group(PaymentCreate, () {
    // int memberId
    test('to test the property `memberId`', () async {
      // TODO
    });

    // int membershipId
    test('to test the property `membershipId`', () async {
      // TODO
    });

    // If set, assign/renew membership in the same transaction when paid.
    // int productId
    test('to test the property `productId`', () async {
      // TODO
    });

    // DECIMAL(12,2) as a two-decimal string. Never a JSON number.
    // String subtotal
    test('to test the property `subtotal`', () async {
      // TODO
    });

    // DECIMAL(12,2) as a two-decimal string. Never a JSON number.
    // String discountAmount
    test('to test the property `discountAmount`', () async {
      // TODO
    });

    // int paymentMethodId
    test('to test the property `paymentMethodId`', () async {
      // TODO
    });

    // Split tender. Sum becomes amount_paid. payment_method_id on header is null when present.
    // BuiltList<TenderLine> tenders
    test('to test the property `tenders`', () async {
      // TODO
    });

    // String transactionReference
    test('to test the property `transactionReference`', () async {
      // TODO
    });

  });
}
