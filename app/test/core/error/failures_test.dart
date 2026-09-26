import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';

void main() {
  group('Failure value equality', () {
    test('ValidationFailure with same details are equal', () {
      const failure1 = ValidationFailure(['error1', 'error2']);
      const failure2 = ValidationFailure(['error1', 'error2']);

      expect(failure1, equals(failure2));
      expect(failure1.hashCode, equals(failure2.hashCode));
    });

    test('ValidationFailure with different details are not equal', () {
      const failure1 = ValidationFailure(['error1']);
      const failure2 = ValidationFailure(['error2']);

      expect(failure1, isNot(equals(failure2)));
    });

    test('AuthFailure instances are equal', () {
      final failure1 = const AuthFailure();
      final failure2 = const AuthFailure();

      expect(failure1, equals(failure2));
      expect(failure1.hashCode, equals(failure2.hashCode));
    });

    test('PermissionFailure instances are equal', () {
      final failure1 = const PermissionFailure();
      final failure2 = const PermissionFailure();

      expect(failure1, equals(failure2));
    });

    test('NotFoundFailure instances are equal', () {
      final failure1 = const NotFoundFailure();
      final failure2 = const NotFoundFailure();

      expect(failure1, equals(failure2));
    });

    test('ConflictFailure instances are equal', () {
      final failure1 = const ConflictFailure();
      final failure2 = const ConflictFailure();

      expect(failure1, equals(failure2));
    });

    test('BusinessRuleFailure with same message are equal', () {
      const failure1 = BusinessRuleFailure('Cannot update archived item');
      const failure2 = BusinessRuleFailure('Cannot update archived item');

      expect(failure1, equals(failure2));
      expect(failure1.hashCode, equals(failure2.hashCode));
    });

    test('BusinessRuleFailure with different messages are not equal', () {
      const failure1 = BusinessRuleFailure('Message 1');
      const failure2 = BusinessRuleFailure('Message 2');

      expect(failure1, isNot(equals(failure2)));
    });

    test('RateLimitFailure instances are equal', () {
      final failure1 = const RateLimitFailure();
      final failure2 = const RateLimitFailure();

      expect(failure1, equals(failure2));
    });

    test('NetworkFailure instances are equal', () {
      final failure1 = const NetworkFailure();
      final failure2 = const NetworkFailure();

      expect(failure1, equals(failure2));
    });

    test('UnknownFailure instances are equal', () {
      final failure1 = const UnknownFailure();
      final failure2 = const UnknownFailure();

      expect(failure1, equals(failure2));
    });

    test('Different failure types are not equal', () {
      final failure1 = const AuthFailure();
      final failure2 = const PermissionFailure();

      expect(failure1, isNot(equals(failure2)));
    });
  });
}
