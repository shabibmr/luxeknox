//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/setting.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settings_list.g.dart';

/// SettingsList
///
/// Properties:
/// * [data] 
@BuiltValue()
abstract class SettingsList implements Built<SettingsList, SettingsListBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Setting> get data;

  SettingsList._();

  factory SettingsList([void updates(SettingsListBuilder b)]) = _$SettingsList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingsListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingsList> get serializer => _$SettingsListSerializer();
}

class _$SettingsListSerializer implements PrimitiveSerializer<SettingsList> {
  @override
  final Iterable<Type> types = const [SettingsList, _$SettingsList];

  @override
  final String wireName = r'SettingsList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingsList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Setting)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingsList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettingsListBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Setting)]),
          ) as BuiltList<Setting>;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettingsList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingsListBuilder();
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


