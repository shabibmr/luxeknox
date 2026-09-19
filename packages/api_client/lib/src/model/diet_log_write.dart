//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_log_write.g.dart';

/// DietLogWrite
///
/// Properties:
/// * [dietPlanId] 
/// * [totalCaloriesConsumed] 
/// * [adherenceScore] 
/// * [waterIntakeMl] 
/// * [memberNotes] 
@BuiltValue()
abstract class DietLogWrite implements Built<DietLogWrite, DietLogWriteBuilder> {
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

  DietLogWrite._();

  factory DietLogWrite([void updates(DietLogWriteBuilder b)]) = _$DietLogWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietLogWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietLogWrite> get serializer => _$DietLogWriteSerializer();
}

class _$DietLogWriteSerializer implements PrimitiveSerializer<DietLogWrite> {
  @override
  final Iterable<Type> types = const [DietLogWrite, _$DietLogWrite];

  @override
  final String wireName = r'DietLogWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietLogWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    DietLogWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietLogWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  DietLogWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietLogWriteBuilder();
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


