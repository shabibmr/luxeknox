import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/config/api_base_url_resolver.dart';
import 'package:luxeknox/core/config/firestore_app_config_source.dart';
import 'package:luxeknox/core/config/remote_api_base_url_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSource implements AppConfigRemoteSource {
  _FakeSource(this.fetch);

  final Future<String?> Function() fetch;

  int calls = 0;

  @override
  Future<String?> fetchApiBaseUrl() {
    calls++;
    return fetch();
  }
}

_FakeSource _returns(String? value) => _FakeSource(() async => value);

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
      source: _returns(' https://from.firestore '),
      fallbackUrl: 'https://fallback',
    );

    expect(await resolver.resolve(), 'https://from.firestore/v1');
    expect(store.read(), 'https://from.firestore/v1');
  });

  test('keeps an existing /v1 suffix', () async {
    final resolver = ApiBaseUrlResolver(
      store: store,
      source: _returns('https://api.luxeknox.com/v1/'),
      fallbackUrl: 'https://fallback/v1',
    );

    expect(await resolver.resolve(), 'https://api.luxeknox.com/v1');
    expect(store.read(), 'https://api.luxeknox.com/v1');
  });

  test(
    'returns the cache without waiting, then refreshes it for next launch',
    () async {
      await store.write('https://cached');
      final remote = Completer<String?>();
      final source = _FakeSource(() => remote.future);
      final resolver = ApiBaseUrlResolver(
        store: store,
        source: source,
        fallbackUrl: 'https://fallback',
      );

      expect(await resolver.resolve(), 'https://cached/v1');
      expect(source.calls, 1);

      remote.complete('https://new.firestore');
      await pumpEventQueue();
      expect(store.read(), 'https://new.firestore/v1');
    },
  );

  test('a failed background refresh keeps the cache', () async {
    await store.write('https://cached/v1');
    final resolver = ApiBaseUrlResolver(
      store: store,
      source: _FakeSource(() async => throw TimeoutException('slow')),
      fallbackUrl: 'https://fallback',
    );

    expect(await resolver.resolve(), 'https://cached/v1');
    await pumpEventQueue();
    expect(store.read(), 'https://cached/v1');
  });

  test('uses fallback when cache and Firestore are empty', () async {
    final resolver = ApiBaseUrlResolver(
      store: store,
      source: _returns('  '),
      fallbackUrl: 'https://fallback',
    );

    expect(await resolver.resolve(), 'https://fallback/v1');
    expect(store.read(), isNull);
  });

  test('uses fallback when there is no cache and Firestore throws', () async {
    final resolver = ApiBaseUrlResolver(
      store: store,
      source: _FakeSource(() async => throw StateError('no Firebase app')),
      fallbackUrl: 'https://fallback',
    );

    expect(await resolver.resolve(), 'https://fallback/v1');
  });

  test('a blank cached value is treated as missing', () async {
    await store.write('   ');
    final resolver = ApiBaseUrlResolver(
      store: store,
      source: _returns('https://from.firestore'),
      fallbackUrl: 'https://fallback',
    );

    expect(await resolver.resolve(), 'https://from.firestore/v1');
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

  test('normalize is stable and handles blank, whitespace and versions', () {
    const host = 'https://api.luxeknox.com';
    expect(ApiBaseUrlResolver.normalize(host), '$host/v1');
    expect(ApiBaseUrlResolver.normalize('  $host/v1  '), '$host/v1');
    expect(
      ApiBaseUrlResolver.normalize(ApiBaseUrlResolver.normalize(host)),
      '$host/v1',
    );
    expect(ApiBaseUrlResolver.normalize('/'), '');
    expect(ApiBaseUrlResolver.normalize('  '), '');
    expect(ApiBaseUrlResolver.normalize('$host/v2'), '$host/v2');
  });
}
