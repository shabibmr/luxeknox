//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_log.g.dart';

/// DietLog
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [loggedDate] 
/// * [dietPlanId] 
/// * [totalCaloriesConsumed] 
/// * [adherenceScore] 
/// * [waterIntakeMl] 
/// * [memberNotes] 
@BuiltValue()
abstract class DietLog implements Built<DietLog, DietLogBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'logged_date')
  Date get loggedDate;

  @BuiltValueField(wireName: r'diet_plan_id')
  int? get dietPlanId;

  @BuiltValueField(wireName: r'total_calories_consumed')
  num? get totalCaloriesConsumed;

  @BuiltValueField(wireName: r'adherence_score')
  num? get adherenceScore;

  @BuiltValueField(wireName: r'water_intake_ml')
  int? get waterIntakeMl;

  @BuiltValueField(wireName: r'member_notes')
  String? get memberNotes;

  DietLog._();

  factory DietLog([void updates(DietLogBuilder b)]) = _$DietLog;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietLogBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietLog> get serializer => _$DietLogSerializer();
}

class _$DietLogSerializer implements PrimitiveSerializer<DietLog> {
  @override
  final Iterable<Type> types = const [DietLog, _$DietLog];

  @override
  final String wireName = r'DietLog';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietLog object, {
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
    yield r'logged_date';
    yield serializers.serialize(
      object.loggedDate,
      specifiedType: const FullType(Date),
    );
    if (object.dietPlanId != null) {
      yield r'diet_plan_id';
      yield serializers.serialize(
        object.dietPlanId,
        specifiedType: const FullType(int),
      );
    }
    if (object.totalCaloriesConsumed != null) {
      yield r'total_calories_consumed';
      yield serializers.serialize(
        object.totalCaloriesConsumed,
        specifiedType: const FullType(num),
      );
    }
    if (object.adherenceScore != null) {
      yield r'adherence_score';
      yield serializers.serialize(
        object.adherenceScore,
        specifiedType: const FullType(num),
      );
    }
    if (object.waterIntakeMl != null) {
      yield r'water_intake_ml';
      yield serializers.serialize(
        object.waterIntakeMl,
        specifiedType: const FullType(int),
      );
    }
    if (object.memberNotes != null) {
      yield r'member_notes';
      yield serializers.serialize(
        object.memberNotes,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DietLog object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietLogBuilder result,
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
        case r'logged_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.loggedDate = valueDes;
          break;
        case r'diet_plan_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.dietPlanId = valueDes;
          break;
        case r'total_calories_consumed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.totalCaloriesConsumed = valueDes;
          break;
        case r'adherence_score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.adherenceScore = valueDes;
          break;
        case r'water_intake_ml':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.waterIntakeMl = valueDes;
          break;
        case r'member_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.memberNotes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DietLog deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietLogBuilder();
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


