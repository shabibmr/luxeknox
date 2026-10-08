import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/config/remote_api_base_url_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('read returns null when unset', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = RemoteApiBaseUrlStore(prefs);
    expect(store.read(), isNull);
  });

  test('write then read round-trips the URL', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = RemoteApiBaseUrlStore(prefs);
    await store.write('https://api.example.com/v1');
    expect(store.read(), 'https://api.example.com/v1');
  });
}
