//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/diet_log.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_log_page.g.dart';

/// DietLogPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class DietLogPage implements Built<DietLogPage, DietLogPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<DietLog> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  DietLogPage._();

  factory DietLogPage([void updates(DietLogPageBuilder b)]) = _$DietLogPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietLogPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietLogPage> get serializer => _$DietLogPageSerializer();
}

class _$DietLogPageSerializer implements PrimitiveSerializer<DietLogPage> {
  @override
  final Iterable<Type> types = const [DietLogPage, _$DietLogPage];

  @override
  final String wireName = r'DietLogPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietLogPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(DietLog)]),
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
    DietLogPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietLogPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DietLog)]),
          ) as BuiltList<DietLog>;
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
  DietLogPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietLogPageBuilder();
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


