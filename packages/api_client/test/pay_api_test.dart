import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for PAYApi
void main() {
  final instance = ApiClient().getPAYApi();

  group(PAYApi, () {
    // Adjust an invoice
    //
    //Future<Payment> adjustPayment(int id, PaymentAdjustRequest paymentAdjustRequest) async
    test('test adjustPayment', () async {
      // TODO
    });

    // Record POS / issue invoice
    //
    //Future<Payment> createPayment(PaymentCreate paymentCreate, { String idempotencyKey }) async
    test('test createPayment', () async {
      // TODO
    });

    // Create a payment method
    //
    //Future<PaymentMethod> createPaymentMethod(PaymentMethodWrite paymentMethodWrite) async
    test('test createPaymentMethod', () async {
      // TODO
    });

    // Invoice detail with history
    //
    //Future<Payment> getPayment(int id) async
    test('test getPayment', () async {
      // TODO
    });

    // Receipt (re-rendered in MVP; no stored PDF)
    //
    //Future<PaymentReceipt> getPaymentReceipt(int id) async
    test('test getPaymentReceipt', () async {
      // TODO
    });

    // Pending and partial invoices
    //
    //Future<PaymentPage> listOutstandingPayments({ int limit, int offset }) async
    test('test listOutstandingPayments', () async {
      // TODO
    });

    // Payment methods
    //
    //Future<PaymentMethodPage> listPaymentMethods() async
    test('test listPaymentMethods', () async {
      // TODO
    });

    // Invoice ledger
    //
    //Future<PaymentPage> listPayments({ int limit, int offset, int memberId, String status }) async
    test('test listPayments', () async {
      // TODO
    });

    // Refund against an invoice
    //
    //Future<Payment> refundPayment(int id, PaymentAdjustRequest paymentAdjustRequest, { String idempotencyKey }) async
    test('test refundPayment', () async {
      // TODO
    });

  });
}
