//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/workout_plan_version.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_plan_version_page.g.dart';

/// WorkoutPlanVersionPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class WorkoutPlanVersionPage implements Built<WorkoutPlanVersionPage, WorkoutPlanVersionPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<WorkoutPlanVersion> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  WorkoutPlanVersionPage._();

  factory WorkoutPlanVersionPage([void updates(WorkoutPlanVersionPageBuilder b)]) = _$WorkoutPlanVersionPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutPlanVersionPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutPlanVersionPage> get serializer => _$WorkoutPlanVersionPageSerializer();
}

class _$WorkoutPlanVersionPageSerializer implements PrimitiveSerializer<WorkoutPlanVersionPage> {
  @override
  final Iterable<Type> types = const [WorkoutPlanVersionPage, _$WorkoutPlanVersionPage];

  @override
  final String wireName = r'WorkoutPlanVersionPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutPlanVersionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(WorkoutPlanVersion)]),
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
    WorkoutPlanVersionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutPlanVersionPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkoutPlanVersion)]),
          ) as BuiltList<WorkoutPlanVersion>;
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
  WorkoutPlanVersionPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutPlanVersionPageBuilder();
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


