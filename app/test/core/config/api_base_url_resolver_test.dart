import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/config/api_base_url_resolver.dart';
import 'package:luxeknox/core/config/firestore_app_config_source.dart';
import 'package:luxeknox/core/config/remote_api_base_url_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSource implements AppConfigRemoteSource {
  _FakeSource(this.value);

  final String? value;

  @override
  Future<String?> fetchApiBaseUrl() async => value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RemoteApiBaseUrlStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = RemoteApiBaseUrlStore(await SharedPreferences.getInstance());
  });

  test('uses Firestore value, appends /v1, and writes cache', () async {
    final resolver = ApiBaseUrlResolver(
      store: store,
      source: _FakeSource('https://from.firestore'),
      fallbackUrl: 'https://fallback',
    );

    expect(await resolver.resolve(), 'https://from.firestore/v1');
    expect(store.read(), 'https://from.firestore/v1');
  });

  test('keeps an existing /v1 suffix', () async {
    final resolver = ApiBaseUrlResolver(
      store: store,
      source: _FakeSource('https://api.luxeknox.com/v1/'),
      fallbackUrl: 'https://fallback/v1',
    );

    expect(await resolver.resolve(), 'https://api.luxeknox.com/v1');
    expect(store.read(), 'https://api.luxeknox.com/v1');
  });

  test('uses cache when Firestore returns null', () async {
    await store.write('https://cached');
    final resolver = ApiBaseUrlResolver(
      store: store,
      source: _FakeSource(null),
      fallbackUrl: 'https://fallback',
    );

    expect(await resolver.resolve(), 'https://cached/v1');
  });

  test('uses fallback when cache and Firestore are empty', () async {
    final resolver = ApiBaseUrlResolver(
      store: store,
      source: _FakeSource(null),
      fallbackUrl: 'https://fallback',
    );

    expect(await resolver.resolve(), 'https://fallback/v1');
  });

  test('normalize strips trailing slashes before appending /v1', () {
    expect(
      ApiBaseUrlResolver.normalize('https://api.luxeknox.com/'),
      'https://api.luxeknox.com/v1',
    );
    expect(
      ApiBaseUrlResolver.normalize('https://api.luxeknox.com/v1/'),
      'https://api.luxeknox.com/v1',
    );
  });
}
