//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/device.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'device_page.g.dart';

/// DevicePage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class DevicePage implements Built<DevicePage, DevicePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Device> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  DevicePage._();

  factory DevicePage([void updates(DevicePageBuilder b)]) = _$DevicePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DevicePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DevicePage> get serializer => _$DevicePageSerializer();
}

class _$DevicePageSerializer implements PrimitiveSerializer<DevicePage> {
  @override
  final Iterable<Type> types = const [DevicePage, _$DevicePage];

  @override
  final String wireName = r'DevicePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DevicePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Device)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(PageMeta),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DevicePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DevicePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Device)]),
          ) as BuiltList<Device>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageMeta),
          ) as PageMeta;
          result.meta.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DevicePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DevicePageBuilder();
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


