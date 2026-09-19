//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settings_write_items_inner.g.dart';

/// SettingsWriteItemsInner
///
/// Properties:
/// * [settingKey] 
/// * [settingValue] 
@BuiltValue()
abstract class SettingsWriteItemsInner implements Built<SettingsWriteItemsInner, SettingsWriteItemsInnerBuilder> {
  @BuiltValueField(wireName: r'setting_key')
  String get settingKey;

  @BuiltValueField(wireName: r'setting_value')
  String get settingValue;

  SettingsWriteItemsInner._();

  factory SettingsWriteItemsInner([void updates(SettingsWriteItemsInnerBuilder b)]) = _$SettingsWriteItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingsWriteItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingsWriteItemsInner> get serializer => _$SettingsWriteItemsInnerSerializer();
}

class _$SettingsWriteItemsInnerSerializer implements PrimitiveSerializer<SettingsWriteItemsInner> {
  @override
  final Iterable<Type> types = const [SettingsWriteItemsInner, _$SettingsWriteItemsInner];

  @override
  final String wireName = r'SettingsWriteItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingsWriteItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'setting_key';
    yield serializers.serialize(
      object.settingKey,
      specifiedType: const FullType(String),
    );
    yield r'setting_value';
    yield serializers.serialize(
      object.settingValue,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingsWriteItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettingsWriteItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'setting_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.settingKey = valueDes;
          break;
        case r'setting_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.settingValue = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettingsWriteItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingsWriteItemsInnerBuilder();
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


