//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_reassign_trainer_request.g.dart';

/// PtReassignTrainerRequest
///
/// Properties:
/// * [trainerId] 
/// * [effectiveDate] 
/// * [reason] 
@BuiltValue()
abstract class PtReassignTrainerRequest implements Built<PtReassignTrainerRequest, PtReassignTrainerRequestBuilder> {
  @BuiltValueField(wireName: r'trainer_id')
  int get trainerId;

  @BuiltValueField(wireName: r'effective_date')
  Date get effectiveDate;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  PtReassignTrainerRequest._();

  factory PtReassignTrainerRequest([void updates(PtReassignTrainerRequestBuilder b)]) = _$PtReassignTrainerRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtReassignTrainerRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtReassignTrainerRequest> get serializer => _$PtReassignTrainerRequestSerializer();
}

class _$PtReassignTrainerRequestSerializer implements PrimitiveSerializer<PtReassignTrainerRequest> {
  @override
  final Iterable<Type> types = const [PtReassignTrainerRequest, _$PtReassignTrainerRequest];

  @override
  final String wireName = r'PtReassignTrainerRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtReassignTrainerRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'trainer_id';
    yield serializers.serialize(
      object.trainerId,
      specifiedType: const FullType(int),
    );
    yield r'effective_date';
    yield serializers.serialize(
      object.effectiveDate,
      specifiedType: const FullType(Date),
    );
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
    PtReassignTrainerRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtReassignTrainerRequestBuilder result,
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
        case r'effective_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.effectiveDate = valueDes;
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
  PtReassignTrainerRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtReassignTrainerRequestBuilder();
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


