import 'package:app/session/domain/entities/capabilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Capabilities', () {
    test('can() should return true when slug is present', () {
      const capabilities = Capabilities(
        slugs: ['exercises.read', 'exercises.update', 'exercises.create'],
      );

      expect(capabilities.can('exercises.update'), isTrue);
    });

    test('can() should return false when slug is not present', () {
      const capabilities = Capabilities(
        slugs: ['exercises.read', 'exercises.update'],
      );

      expect(capabilities.can('exercises.create'), isFalse);
    });

    test('can() should return false for empty capabilities', () {
      const capabilities = Capabilities(slugs: []);

      expect(capabilities.can('exercises.read'), isFalse);
    });

    test('should support value equality', () {
      const capabilities1 = Capabilities(
        slugs: ['exercises.read', 'exercises.update'],
      );

      const capabilities2 = Capabilities(
        slugs: ['exercises.read', 'exercises.update'],
      );

      expect(capabilities1, equals(capabilities2));
    });

    test('should not be equal when slugs differ', () {
      const capabilities1 = Capabilities(
        slugs: ['exercises.read', 'exercises.update'],
      );

      const capabilities2 = Capabilities(
        slugs: ['exercises.read', 'exercises.create'],
      );

      expect(capabilities1, isNot(equals(capabilities2)));
    });

    test('can() should be case-sensitive', () {
      const capabilities = Capabilities(slugs: ['exercises.update']);

      expect(capabilities.can('exercises.UPDATE'), isFalse);
      expect(capabilities.can('exercises.update'), isTrue);
    });
  });
}
