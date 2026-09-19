//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/workout_plan.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_plan_page.g.dart';

/// WorkoutPlanPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class WorkoutPlanPage implements Built<WorkoutPlanPage, WorkoutPlanPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<WorkoutPlan> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  WorkoutPlanPage._();

  factory WorkoutPlanPage([void updates(WorkoutPlanPageBuilder b)]) = _$WorkoutPlanPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutPlanPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutPlanPage> get serializer => _$WorkoutPlanPageSerializer();
}

class _$WorkoutPlanPageSerializer implements PrimitiveSerializer<WorkoutPlanPage> {
  @override
  final Iterable<Type> types = const [WorkoutPlanPage, _$WorkoutPlanPage];

  @override
  final String wireName = r'WorkoutPlanPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutPlanPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(WorkoutPlan)]),
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
    WorkoutPlanPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutPlanPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkoutPlan)]),
          ) as BuiltList<WorkoutPlan>;
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
  WorkoutPlanPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutPlanPageBuilder();
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


