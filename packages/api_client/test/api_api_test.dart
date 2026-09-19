import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for APIApi
void main() {
  final instance = ApiClient().getAPIApi();

  group(APIApi, () {
    // Process liveness
    //
    //Future<Health> getHealth() async
    test('test getHealth', () async {
      // TODO
    });

    // Database readiness
    //
    //Future<Ready> getReady() async
    test('test getReady', () async {
      // TODO
    });

  });
}
