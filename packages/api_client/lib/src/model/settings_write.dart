//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/settings_write_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settings_write.g.dart';

/// SettingsWrite
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class SettingsWrite implements Built<SettingsWrite, SettingsWriteBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<SettingsWriteItemsInner> get items;

  SettingsWrite._();

  factory SettingsWrite([void updates(SettingsWriteBuilder b)]) = _$SettingsWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingsWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingsWrite> get serializer => _$SettingsWriteSerializer();
}

class _$SettingsWriteSerializer implements PrimitiveSerializer<SettingsWrite> {
  @override
  final Iterable<Type> types = const [SettingsWrite, _$SettingsWrite];

  @override
  final String wireName = r'SettingsWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingsWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(SettingsWriteItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingsWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettingsWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SettingsWriteItemsInner)]),
          ) as BuiltList<SettingsWriteItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettingsWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingsWriteBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


