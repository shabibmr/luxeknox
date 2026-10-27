import 'dart:convert';
import 'package:built_value/serializer.dart';
import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

// tests for AccountUpdate
void main() {
  group(AccountUpdate, () {
    test('serializes parent_id as null when clearParentId is true', () {
      final update = AccountUpdate((b) => b
        ..name = 'Vault'
        ..clearParentId = true);

      final serialized = standardSerializers.serialize(
        update,
        specifiedType: const FullType(AccountUpdate),
      ) as Map<String, dynamic>;

      expect(serialized.containsKey('parent_id'), isTrue);
      expect(serialized['parent_id'], isNull);
      expect(serialized['name'], 'Vault');
    });

    test('omits parent_id when parentId is null and clearParentId is false', () {
      final update = AccountUpdate((b) => b..name = 'Vault');

      final serialized = standardSerializers.serialize(
        update,
        specifiedType: const FullType(AccountUpdate),
      ) as Map<String, dynamic>;

      expect(serialized.containsKey('parent_id'), isFalse);
      expect(serialized['name'], 'Vault');
    });

    test('serializes parent_id when parentId is set', () {
      final update = AccountUpdate((b) => b
        ..name = 'Vault'
        ..parentId = 42);

      final serialized = standardSerializers.serialize(
        update,
        specifiedType: const FullType(AccountUpdate),
      ) as Map<String, dynamic>;

      expect(serialized['parent_id'], 42);
    });
  });
}
