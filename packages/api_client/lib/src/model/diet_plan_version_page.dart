//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/diet_plan_version.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_plan_version_page.g.dart';

/// DietPlanVersionPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class DietPlanVersionPage implements Built<DietPlanVersionPage, DietPlanVersionPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<DietPlanVersion> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  DietPlanVersionPage._();

  factory DietPlanVersionPage([void updates(DietPlanVersionPageBuilder b)]) = _$DietPlanVersionPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietPlanVersionPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietPlanVersionPage> get serializer => _$DietPlanVersionPageSerializer();
}

class _$DietPlanVersionPageSerializer implements PrimitiveSerializer<DietPlanVersionPage> {
  @override
  final Iterable<Type> types = const [DietPlanVersionPage, _$DietPlanVersionPage];

  @override
  final String wireName = r'DietPlanVersionPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietPlanVersionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(DietPlanVersion)]),
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
    DietPlanVersionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietPlanVersionPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DietPlanVersion)]),
          ) as BuiltList<DietPlanVersion>;
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
  DietPlanVersionPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietPlanVersionPageBuilder();
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


