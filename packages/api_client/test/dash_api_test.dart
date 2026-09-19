import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for DASHApi
void main() {
  final instance = ApiClient().getDASHApi();

  group(DASHApi, () {
    // Role-specific home snapshot; unauthorized widgets omitted
    //
    //Future<Dashboard> getDashboard() async
    test('test getDashboard', () async {
      // TODO
    });

  });
}
