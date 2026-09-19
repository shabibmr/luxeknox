//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assign_plan_request.g.dart';

/// AssignPlanRequest
///
/// Properties:
/// * [memberId] 
@BuiltValue()
abstract class AssignPlanRequest implements Built<AssignPlanRequest, AssignPlanRequestBuilder> {
  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  AssignPlanRequest._();

  factory AssignPlanRequest([void updates(AssignPlanRequestBuilder b)]) = _$AssignPlanRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssignPlanRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssignPlanRequest> get serializer => _$AssignPlanRequestSerializer();
}

class _$AssignPlanRequestSerializer implements PrimitiveSerializer<AssignPlanRequest> {
  @override
  final Iterable<Type> types = const [AssignPlanRequest, _$AssignPlanRequest];

  @override
  final String wireName = r'AssignPlanRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssignPlanRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssignPlanRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssignPlanRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssignPlanRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssignPlanRequestBuilder();
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


