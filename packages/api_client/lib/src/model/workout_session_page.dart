//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/workout_session.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_session_page.g.dart';

/// WorkoutSessionPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class WorkoutSessionPage implements Built<WorkoutSessionPage, WorkoutSessionPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<WorkoutSession> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  WorkoutSessionPage._();

  factory WorkoutSessionPage([void updates(WorkoutSessionPageBuilder b)]) = _$WorkoutSessionPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutSessionPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutSessionPage> get serializer => _$WorkoutSessionPageSerializer();
}

class _$WorkoutSessionPageSerializer implements PrimitiveSerializer<WorkoutSessionPage> {
  @override
  final Iterable<Type> types = const [WorkoutSessionPage, _$WorkoutSessionPage];

  @override
  final String wireName = r'WorkoutSessionPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutSessionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(WorkoutSession)]),
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
    WorkoutSessionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutSessionPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkoutSession)]),
          ) as BuiltList<WorkoutSession>;
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
  WorkoutSessionPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutSessionPageBuilder();
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


