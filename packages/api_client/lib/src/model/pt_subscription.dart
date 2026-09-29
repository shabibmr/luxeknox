//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/pt_subscription_status.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_subscription.g.dart';

/// PtSubscription
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [ptProductId] 
/// * [trainerId] 
/// * [membershipId] 
/// * [renewedFromId] 
/// * [startDate] 
/// * [endDate] 
/// * [weekdays] - 0=Sunday … 6=Saturday
/// * [slotStart] - Gym wall-clock \"HH:00:00\"; the slot is one hour.
/// * [status] 
/// * [rowVersion] 
/// * [productName] 
/// * [sessionsPerWeek] 
/// * [trainerName] 
/// * [slotLabel] - e.g. \"17:00-18:00\"
@BuiltValue()
abstract class PtSubscription implements Built<PtSubscription, PtSubscriptionBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'pt_product_id')
  int get ptProductId;

  @BuiltValueField(wireName: r'trainer_id')
  int get trainerId;

  @BuiltValueField(wireName: r'membership_id')
  int? get membershipId;

  @BuiltValueField(wireName: r'renewed_from_id')
  int? get renewedFromId;

  @BuiltValueField(wireName: r'start_date')
  Date get startDate;

  @BuiltValueField(wireName: r'end_date')
  Date get endDate;

  /// 0=Sunday … 6=Saturday
  @BuiltValueField(wireName: r'weekdays')
  BuiltList<int> get weekdays;

  /// Gym wall-clock \"HH:00:00\"; the slot is one hour.
  @BuiltValueField(wireName: r'slot_start')
  String get slotStart;

  @BuiltValueField(wireName: r'status')
  PtSubscriptionStatus get status;
  // enum statusEnum {  scheduled,  active,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'row_version')
  int get rowVersion;

  @BuiltValueField(wireName: r'product_name')
  String get productName;

  @BuiltValueField(wireName: r'sessions_per_week')
  int get sessionsPerWeek;

  @BuiltValueField(wireName: r'trainer_name')
  String get trainerName;

  /// e.g. \"17:00-18:00\"
  @BuiltValueField(wireName: r'slot_label')
  String get slotLabel;

  PtSubscription._();

  factory PtSubscription([void updates(PtSubscriptionBuilder b)]) = _$PtSubscription;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtSubscriptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtSubscription> get serializer => _$PtSubscriptionSerializer();
}

class _$PtSubscriptionSerializer implements PrimitiveSerializer<PtSubscription> {
  @override
  final Iterable<Type> types = const [PtSubscription, _$PtSubscription];

  @override
  final String wireName = r'PtSubscription';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtSubscription object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    yield r'pt_product_id';
    yield serializers.serialize(
      object.ptProductId,
      specifiedType: const FullType(int),
    );
    yield r'trainer_id';
    yield serializers.serialize(
      object.trainerId,
      specifiedType: const FullType(int),
    );
    if (object.membershipId != null) {
      yield r'membership_id';
      yield serializers.serialize(
        object.membershipId,
        specifiedType: const FullType(int),
      );
    }
    if (object.renewedFromId != null) {
      yield r'renewed_from_id';
      yield serializers.serialize(
        object.renewedFromId,
        specifiedType: const FullType(int),
      );
    }
    yield r'start_date';
    yield serializers.serialize(
      object.startDate,
      specifiedType: const FullType(Date),
    );
    yield r'end_date';
    yield serializers.serialize(
      object.endDate,
      specifiedType: const FullType(Date),
    );
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PtSubscriptionStatus),
    );
    yield r'row_version';
    yield serializers.serialize(
      object.rowVersion,
      specifiedType: const FullType(int),
    );
    yield r'product_name';
    yield serializers.serialize(
      object.productName,
      specifiedType: const FullType(String),
    );
    yield r'sessions_per_week';
    yield serializers.serialize(
      object.sessionsPerWeek,
      specifiedType: const FullType(int),
    );
    yield r'trainer_name';
    yield serializers.serialize(
      object.trainerName,
      specifiedType: const FullType(String),
    );
    yield r'slot_label';
    yield serializers.serialize(
      object.slotLabel,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PtSubscription object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtSubscriptionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        case r'pt_product_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ptProductId = valueDes;
          break;
        case r'trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trainerId = valueDes;
          break;
        case r'membership_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.membershipId = valueDes;
          break;
        case r'renewed_from_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.renewedFromId = valueDes;
          break;
        case r'start_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.startDate = valueDes;
          break;
        case r'end_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.endDate = valueDes;
          break;
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PtSubscriptionStatus),
          ) as PtSubscriptionStatus;
          result.status = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rowVersion = valueDes;
          break;
        case r'product_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.productName = valueDes;
          break;
        case r'sessions_per_week':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sessionsPerWeek = valueDes;
          break;
        case r'trainer_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.trainerName = valueDes;
          break;
        case r'slot_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slotLabel = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PtSubscription deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtSubscriptionBuilder();
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


