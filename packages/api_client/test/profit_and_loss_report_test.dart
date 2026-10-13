import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

// tests for ProfitAndLossReport
void main() {
  final instance = ProfitAndLossReportBuilder();
  // TODO add properties to the builder and call build()

  group(ProfitAndLossReport, () {
    // Date from
    test('to test the property `from`', () async {
      // TODO
    });

    // Date to
    test('to test the property `to`', () async {
      // TODO
    });

    // BuiltList<ProfitAndLossAccount> incomeAccounts
    test('to test the property `incomeAccounts`', () async {
      // TODO
    });

    // DECIMAL(12,2) as a two-decimal string. Never a JSON number.
    // String totalIncome
    test('to test the property `totalIncome`', () async {
      // TODO
    });

    // BuiltList<ProfitAndLossAccount> expenseAccounts
    test('to test the property `expenseAccounts`', () async {
      // TODO
    });

    // DECIMAL(12,2) as a two-decimal string. Never a JSON number.
    // String totalExpense
    test('to test the property `totalExpense`', () async {
      // TODO
    });

    // DECIMAL(12,2) as a two-decimal string. Never a JSON number.
    // String netProfit
    test('to test the property `netProfit`', () async {
      // TODO
    });

  });
}
