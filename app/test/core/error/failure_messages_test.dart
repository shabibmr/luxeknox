import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/error/failure_messages.dart';

void main() {
  group('failureMessage exhaustive mapping', () {
    test('ValidationFailure returns non-empty message', () {
      const failure = ValidationFailure([
        'Email is required',
        'Phone is invalid',
      ]);
      final message = failureMessage(failure);

      expect(message, isNotEmpty);
      expect(message, contains('Validation error'));
    });

    test('ValidationFailure with empty details returns non-empty message', () {
      const failure = ValidationFailure([]);
      final message = failureMessage(failure);

      expect(message, isNotEmpty);
    });

    test('AuthFailure returns non-empty message', () {
      final failure = const AuthFailure();
      final message = failureMessage(failure);

      expect(message, isNotEmpty);
      expect(message, contains('Authentication'));
    });

    test('PermissionFailure returns non-empty message', () {
      final failure = const PermissionFailure();
      final message = failureMessage(failure);

      expect(message, isNotEmpty);
      expect(message, contains('permission'));
    });

    test('NotFoundFailure returns non-empty message', () {
      final failure = const NotFoundFailure();
      final message = failureMessage(failure);

      expect(message, isNotEmpty);
      expect(message, contains('not found'));
    });

    test('ConflictFailure returns non-empty message', () {
      final failure = const ConflictFailure();
      final message = failureMessage(failure);

      expect(message, isNotEmpty);
      expect(message, contains('conflict'));
    });

    test('BusinessRuleFailure returns server message verbatim', () {
      const serverMessage = 'Cannot archive a membership with active sessions';
      const failure = BusinessRuleFailure(serverMessage);
      final message = failureMessage(failure);

      expect(message, equals(serverMessage));
      expect(message, isNotEmpty);
    });

    test('RateLimitFailure returns non-empty message', () {
      final failure = const RateLimitFailure();
      final message = failureMessage(failure);

      expect(message, isNotEmpty);
      expect(message.toLowerCase(), contains('too many'));
    });

    test('NetworkFailure returns non-empty message', () {
      final failure = const NetworkFailure();
      final message = failureMessage(failure);

      expect(message, isNotEmpty);
      expect(message, contains('Network'));
    });

    test('UnknownFailure returns non-empty message', () {
      final failure = const UnknownFailure();
      final message = failureMessage(failure);

      expect(message, isNotEmpty);
      expect(message, contains('unexpected'));
    });

    test('All failure types return non-empty messages', () {
      const failures = [
        ValidationFailure(['test']),
        AuthFailure(),
        PermissionFailure(),
        NotFoundFailure(),
        ConflictFailure(),
        BusinessRuleFailure('Server message'),
        RateLimitFailure(),
        NetworkFailure(),
        UnknownFailure(),
      ];

      for (final failure in failures) {
        final message = failureMessage(failure);
        expect(
          message,
          isNotEmpty,
          reason: 'Message for $failure should not be empty',
        );
      }
    });
  });
}
