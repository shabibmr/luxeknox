//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/schedule_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'schedule_type_page.g.dart';

/// ScheduleTypePage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class ScheduleTypePage implements Built<ScheduleTypePage, ScheduleTypePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<ScheduleType> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  ScheduleTypePage._();

  factory ScheduleTypePage([void updates(ScheduleTypePageBuilder b)]) = _$ScheduleTypePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduleTypePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScheduleTypePage> get serializer => _$ScheduleTypePageSerializer();
}

class _$ScheduleTypePageSerializer implements PrimitiveSerializer<ScheduleTypePage> {
  @override
  final Iterable<Type> types = const [ScheduleTypePage, _$ScheduleTypePage];

  @override
  final String wireName = r'ScheduleTypePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScheduleTypePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(ScheduleType)]),
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
    ScheduleTypePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScheduleTypePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ScheduleType)]),
          ) as BuiltList<ScheduleType>;
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
  ScheduleTypePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduleTypePageBuilder();
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


