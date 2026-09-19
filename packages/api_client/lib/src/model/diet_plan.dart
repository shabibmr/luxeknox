//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/diet_plan_version.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'diet_plan.g.dart';

/// DietPlan
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [memberId] 
/// * [trainerId] 
/// * [dailyCalorieTarget] 
/// * [proteinTargetG] 
/// * [carbsTargetG] 
/// * [fatTargetG] 
/// * [isTemplate] 
/// * [status] 
/// * [createdAt] - UTC ISO-8601
/// * [rowVersion] 
/// * [currentVersion] 
@BuiltValue()
abstract class DietPlan implements Built<DietPlan, DietPlanBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'title')
  String get title;

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
  bool get isTemplate;

  @BuiltValueField(wireName: r'status')
  DietPlanStatusEnum get status;
  // enum statusEnum {  draft,  active,  archived,  };

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'row_version')
  int get rowVersion;

  @BuiltValueField(wireName: r'current_version')
  DietPlanVersion? get currentVersion;

  DietPlan._();

  factory DietPlan([void updates(DietPlanBuilder b)]) = _$DietPlan;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DietPlanBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DietPlan> get serializer => _$DietPlanSerializer();
}

class _$DietPlanSerializer implements PrimitiveSerializer<DietPlan> {
  @override
  final Iterable<Type> types = const [DietPlan, _$DietPlan];

  @override
  final String wireName = r'DietPlan';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DietPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
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
    yield r'is_template';
    yield serializers.serialize(
      object.isTemplate,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DietPlanStatusEnum),
    );
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'row_version';
    yield serializers.serialize(
      object.rowVersion,
      specifiedType: const FullType(int),
    );
    if (object.currentVersion != null) {
      yield r'current_version';
      yield serializers.serialize(
        object.currentVersion,
        specifiedType: const FullType(DietPlanVersion),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DietPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DietPlanBuilder result,
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
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
            specifiedType: const FullType(bool),
          ) as bool;
          result.isTemplate = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DietPlanStatusEnum),
          ) as DietPlanStatusEnum;
          result.status = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rowVersion = valueDes;
          break;
        case r'current_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DietPlanVersion),
          ) as DietPlanVersion?;
          if (valueDes == null) continue;
          result.currentVersion.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DietPlan deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DietPlanBuilder();
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


class DietPlanStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'draft')
  static const DietPlanStatusEnum draft = _$dietPlanStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'active')
  static const DietPlanStatusEnum active = _$dietPlanStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'archived')
  static const DietPlanStatusEnum archived = _$dietPlanStatusEnum_archived;

  static Serializer<DietPlanStatusEnum> get serializer => _$dietPlanStatusEnumSerializer;

  const DietPlanStatusEnum._(String name): super(name);

  static BuiltSet<DietPlanStatusEnum> get values => _$dietPlanStatusEnumValues;
  static DietPlanStatusEnum valueOf(String name) => _$dietPlanStatusEnumValueOf(name);
}

