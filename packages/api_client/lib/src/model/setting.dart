//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/setting_category.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'setting.g.dart';

/// Setting
///
/// Properties:
/// * [id] 
/// * [settingKey] 
/// * [settingValue] 
/// * [category] 
@BuiltValue()
abstract class Setting implements Built<Setting, SettingBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'setting_key')
  String get settingKey;

  @BuiltValueField(wireName: r'setting_value')
  String get settingValue;

  @BuiltValueField(wireName: r'category')
  SettingCategory get category;
  // enum categoryEnum {  general,  membership,  attendance_gate,  booking_rules,  billing,  workout,  diet,  notification,  measurement,  };

  Setting._();

  factory Setting([void updates(SettingBuilder b)]) = _$Setting;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Setting> get serializer => _$SettingSerializer();
}

class _$SettingSerializer implements PrimitiveSerializer<Setting> {
  @override
  final Iterable<Type> types = const [Setting, _$Setting];

  @override
  final String wireName = r'Setting';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Setting object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
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
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(SettingCategory),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Setting object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
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
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SettingCategory),
          ) as SettingCategory;
          result.category = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Setting deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingBuilder();
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


