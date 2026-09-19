import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for RPTApi
void main() {
  final instance = ApiClient().getRPTApi();

  group(RPTApi, () {
    // Analytics report
    //
    //Future<Report> getReport(ReportType type, { Date from, Date to, int productId, int trainerId, String format }) async
    test('test getReport', () async {
      // TODO
    });

  });
}
