//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assign_trainer_request.g.dart';

/// AssignTrainerRequest
///
/// Properties:
/// * [trainerId] 
/// * [overrideCapacity] 
/// * [reason] 
@BuiltValue()
abstract class AssignTrainerRequest implements Built<AssignTrainerRequest, AssignTrainerRequestBuilder> {
  @BuiltValueField(wireName: r'trainer_id')
  int get trainerId;

  @BuiltValueField(wireName: r'override_capacity')
  bool? get overrideCapacity;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AssignTrainerRequest._();

  factory AssignTrainerRequest([void updates(AssignTrainerRequestBuilder b)]) = _$AssignTrainerRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssignTrainerRequestBuilder b) => b
      ..overrideCapacity = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssignTrainerRequest> get serializer => _$AssignTrainerRequestSerializer();
}

class _$AssignTrainerRequestSerializer implements PrimitiveSerializer<AssignTrainerRequest> {
  @override
  final Iterable<Type> types = const [AssignTrainerRequest, _$AssignTrainerRequest];

  @override
  final String wireName = r'AssignTrainerRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssignTrainerRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'trainer_id';
    yield serializers.serialize(
      object.trainerId,
      specifiedType: const FullType(int),
    );
    if (object.overrideCapacity != null) {
      yield r'override_capacity';
      yield serializers.serialize(
        object.overrideCapacity,
        specifiedType: const FullType(bool),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AssignTrainerRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssignTrainerRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trainerId = valueDes;
          break;
        case r'override_capacity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.overrideCapacity = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssignTrainerRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssignTrainerRequestBuilder();
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


