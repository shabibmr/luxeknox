//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_plan_write.g.dart';

/// DietPlanWrite
///
/// Properties:
/// * [title] 
/// * [memberId] 
/// * [trainerId] 
/// * [dailyCalorieTarget] 
/// * [proteinTargetG] 
/// * [carbsTargetG] 
/// * [fatTargetG] 
/// * [isTemplate] 
/// * [rowVersion] 
@BuiltValue()
abstract class DietPlanWrite implements Built<DietPlanWrite, DietPlanWriteBuilder> {
  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'member_id')
  int? get memberId;

  @BuiltValueField(wireName: r'trainer_id')
  int? get trainerId;

  @BuiltValueField(wireName: r'daily_calorie_target')
  int? get dailyCalorieTarget;

  @BuiltValueField(wireName: r'protein_target_g')
  num? get proteinTargetG;

  @BuiltValueField(wireName: r'carbs_target_g')
  num? get carbsTargetG;

  @BuiltValueField(wireName: r'fat_target_g')
  num? get fatTargetG;

  @BuiltValueField(wireName: r'is_template')
  bool? get isTemplate;

  @BuiltValueField(wireName: r'row_version')
  int? get rowVersion;

  DietPlanWrite._();

  factory DietPlanWrite([void updates(DietPlanWriteBuilder b)]) = _$DietPlanWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietPlanWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietPlanWrite> get serializer => _$DietPlanWriteSerializer();
}

class _$DietPlanWriteSerializer implements PrimitiveSerializer<DietPlanWrite> {
  @override
  final Iterable<Type> types = const [DietPlanWrite, _$DietPlanWrite];

  @override
  final String wireName = r'DietPlanWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietPlanWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.memberId != null) {
      yield r'member_id';
      yield serializers.serialize(
        object.memberId,
        specifiedType: const FullType(int),
      );
    }
    if (object.trainerId != null) {
      yield r'trainer_id';
      yield serializers.serialize(
        object.trainerId,
        specifiedType: const FullType(int),
      );
    }
    if (object.dailyCalorieTarget != null) {
      yield r'daily_calorie_target';
      yield serializers.serialize(
        object.dailyCalorieTarget,
        specifiedType: const FullType(int),
      );
    }
    if (object.proteinTargetG != null) {
      yield r'protein_target_g';
      yield serializers.serialize(
        object.proteinTargetG,
        specifiedType: const FullType(num),
      );
    }
    if (object.carbsTargetG != null) {
      yield r'carbs_target_g';
      yield serializers.serialize(
        object.carbsTargetG,
        specifiedType: const FullType(num),
      );
    }
    if (object.fatTargetG != null) {
      yield r'fat_target_g';
      yield serializers.serialize(
        object.fatTargetG,
        specifiedType: const FullType(num),
      );
    }
    if (object.isTemplate != null) {
      yield r'is_template';
      yield serializers.serialize(
        object.isTemplate,
        specifiedType: const FullType(bool),
      );
    }
    if (object.rowVersion != null) {
      yield r'row_version';
      yield serializers.serialize(
        object.rowVersion,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DietPlanWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietPlanWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.memberId = valueDes;
          break;
        case r'trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.trainerId = valueDes;
          break;
        case r'daily_calorie_target':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.dailyCalorieTarget = valueDes;
          break;
        case r'protein_target_g':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.proteinTargetG = valueDes;
          break;
        case r'carbs_target_g':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.carbsTargetG = valueDes;
          break;
        case r'fat_target_g':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.fatTargetG = valueDes;
          break;
        case r'is_template':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isTemplate = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rowVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DietPlanWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietPlanWriteBuilder();
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


