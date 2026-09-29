//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_change_slot_request.g.dart';

/// PtChangeSlotRequest
///
/// Properties:
/// * [weekdays] 
/// * [slotStart] 
/// * [trainerId] - Optionally move to another same-gender trainer in the same re-plan.
/// * [effectiveDate] 
/// * [reason] 
@BuiltValue()
abstract class PtChangeSlotRequest implements Built<PtChangeSlotRequest, PtChangeSlotRequestBuilder> {
  @BuiltValueField(wireName: r'weekdays')
  BuiltList<int> get weekdays;

  @BuiltValueField(wireName: r'slot_start')
  String get slotStart;

  /// Optionally move to another same-gender trainer in the same re-plan.
  @BuiltValueField(wireName: r'trainer_id')
  int? get trainerId;

  @BuiltValueField(wireName: r'effective_date')
  Date get effectiveDate;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  PtChangeSlotRequest._();

  factory PtChangeSlotRequest([void updates(PtChangeSlotRequestBuilder b)]) = _$PtChangeSlotRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtChangeSlotRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtChangeSlotRequest> get serializer => _$PtChangeSlotRequestSerializer();
}

class _$PtChangeSlotRequestSerializer implements PrimitiveSerializer<PtChangeSlotRequest> {
  @override
  final Iterable<Type> types = const [PtChangeSlotRequest, _$PtChangeSlotRequest];

  @override
  final String wireName = r'PtChangeSlotRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtChangeSlotRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'weekdays';
    yield serializers.serialize(
      object.weekdays,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'slot_start';
    yield serializers.serialize(
      object.slotStart,
      specifiedType: const FullType(String),
    );
    if (object.trainerId != null) {
      yield r'trainer_id';
      yield serializers.serialize(
        object.trainerId,
        specifiedType: const FullType(int),
      );
    }
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
    PtChangeSlotRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtChangeSlotRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'weekdays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.weekdays.replace(valueDes);
          break;
        case r'slot_start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slotStart = valueDes;
          break;
        case r'trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
  PtChangeSlotRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtChangeSlotRequestBuilder();
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


