import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luxeknox/core/storage/token_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('TokenStorage', () {
    late MockFlutterSecureStorage mockStorage;
    late TokenStorage tokenStorage;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      tokenStorage = TokenStorage(storage: mockStorage);
    });

    group('writeAccessToken', () {
      test('writes access token to storage', () async {
        const token = 'test_access_token';

        when(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await tokenStorage.writeAccessToken(token);

        verify(
          () => mockStorage.write(key: 'access_token', value: token),
        ).called(1);
      });
    });

    group('writeRefreshToken', () {
      test('writes refresh token to storage', () async {
        const token = 'test_refresh_token';

        when(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await tokenStorage.writeRefreshToken(token);

        verify(
          () => mockStorage.write(key: 'refresh_token', value: token),
        ).called(1);
      });
    });

    group('readAccessToken', () {
      test('returns null when no token is stored', () async {
        when(
          () => mockStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => null);

        final result = await tokenStorage.readAccessToken();

        expect(result, isNull);
        verify(() => mockStorage.read(key: 'access_token')).called(1);
      });

      test('returns access token when stored', () async {
        const token = 'test_access_token';

        when(
          () => mockStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => token);

        final result = await tokenStorage.readAccessToken();

        expect(result, token);
        verify(() => mockStorage.read(key: 'access_token')).called(1);
      });
    });

    group('readRefreshToken', () {
      test('returns null when no token is stored', () async {
        when(
          () => mockStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => null);

        final result = await tokenStorage.readRefreshToken();

        expect(result, isNull);
        verify(() => mockStorage.read(key: 'refresh_token')).called(1);
      });

      test('returns refresh token when stored', () async {
        const token = 'test_refresh_token';

        when(
          () => mockStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => token);

        final result = await tokenStorage.readRefreshToken();

        expect(result, token);
        verify(() => mockStorage.read(key: 'refresh_token')).called(1);
      });
    });

    group('clear', () {
      test('deletes both access and refresh tokens', () async {
        when(
          () => mockStorage.delete(key: any(named: 'key')),
        ).thenAnswer((_) async {});

        await tokenStorage.clear();

        verify(() => mockStorage.delete(key: 'access_token')).called(1);
        verify(() => mockStorage.delete(key: 'refresh_token')).called(1);
      });
    });

    group('roundtrip', () {
      test('write then read access token returns written value', () async {
        const token = 'test_access_token_roundtrip';

        // Mock write and read for roundtrip
        when(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        when(() => mockStorage.read(key: any(named: 'key'))).thenAnswer((
          invocation,
        ) async {
          final key = invocation.namedArguments[const Symbol('key')];
          if (key == 'access_token') return token;
          return null;
        });

        await tokenStorage.writeAccessToken(token);
        final result = await tokenStorage.readAccessToken();

        expect(result, token);
      });

      test('write then read refresh token returns written value', () async {
        const token = 'test_refresh_token_roundtrip';

        when(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        when(() => mockStorage.read(key: any(named: 'key'))).thenAnswer((
          invocation,
        ) async {
          final key = invocation.namedArguments[const Symbol('key')];
          if (key == 'refresh_token') return token;
          return null;
        });

        await tokenStorage.writeRefreshToken(token);
        final result = await tokenStorage.readRefreshToken();

        expect(result, token);
      });
    });
  });
}
