import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luxeknox/features/auth/data/services/firebase_auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockUserCredential extends Mock implements UserCredential {}

class FakeAuthCredential extends Fake implements AuthCredential {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late FirebaseAuthService service;

  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    service = FirebaseAuthServiceImpl.forTesting(
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
    );
  });

  group('FirebaseAuthService', () {
    test('returns null when user cancels native Google sign in', () async {
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      final result = await service.signInWithGoogle();

      expect(result, isNull);
      verify(() => mockGoogleSignIn.signIn()).called(1);
      verifyNever(() => mockFirebaseAuth.signInWithCredential(any()));
    });

    test(
      'returns UserCredential on successful native Google sign in',
      () async {
        final mockAccount = MockGoogleSignInAccount();
        final mockAuth = MockGoogleSignInAuthentication();
        final mockCredential = MockUserCredential();

        when(
          () => mockGoogleSignIn.signIn(),
        ).thenAnswer((_) async => mockAccount);
        when(
          () => mockAccount.authentication,
        ).thenAnswer((_) async => mockAuth);
        when(() => mockAuth.accessToken).thenReturn('test-access-token');
        when(() => mockAuth.idToken).thenReturn('test-id-token');
        when(
          () => mockFirebaseAuth.signInWithCredential(any()),
        ).thenAnswer((_) async => mockCredential);

        final result = await service.signInWithGoogle();

        expect(result, equals(mockCredential));
        verify(() => mockGoogleSignIn.signIn()).called(1);
        verify(() => mockFirebaseAuth.signInWithCredential(any())).called(1);
      },
    );

    test('signOut signs out from both FirebaseAuth and GoogleSignIn', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

      await service.signOut();

      verify(() => mockFirebaseAuth.signOut()).called(1);
      verify(() => mockGoogleSignIn.signOut()).called(1);
    });

    test(
      'skips GoogleSignIn when client_id / native plugin is unavailable',
      () async {
        service = FirebaseAuthServiceImpl.forTesting(
          firebaseAuth: mockFirebaseAuth,
        );

        expect(await service.signInWithGoogle(), isNull);

        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});
        await service.signOut();
        verify(() => mockFirebaseAuth.signOut()).called(1);
        verifyNever(() => mockGoogleSignIn.signOut());
      },
    );
  });

  group('googleSignInForPlatform', () {
    test('skips plugin on web so missing OAuth client_id is not asserted', () {
      expect(googleSignInForPlatform(isWeb: true), isNull);
    });

    test('skips plugin on Windows and Linux', () {
      expect(
        googleSignInForPlatform(isWeb: false, platform: TargetPlatform.windows),
        isNull,
      );
      expect(
        googleSignInForPlatform(isWeb: false, platform: TargetPlatform.linux),
        isNull,
      );
    });
  });
}
