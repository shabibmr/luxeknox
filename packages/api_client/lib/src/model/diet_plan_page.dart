//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/diet_plan.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_plan_page.g.dart';

/// DietPlanPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class DietPlanPage implements Built<DietPlanPage, DietPlanPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<DietPlan> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  DietPlanPage._();

  factory DietPlanPage([void updates(DietPlanPageBuilder b)]) = _$DietPlanPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietPlanPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietPlanPage> get serializer => _$DietPlanPageSerializer();
}

class _$DietPlanPageSerializer implements PrimitiveSerializer<DietPlanPage> {
  @override
  final Iterable<Type> types = const [DietPlanPage, _$DietPlanPage];

  @override
  final String wireName = r'DietPlanPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietPlanPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(DietPlan)]),
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
    DietPlanPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietPlanPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DietPlan)]),
          ) as BuiltList<DietPlan>;
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
  DietPlanPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietPlanPageBuilder();
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


