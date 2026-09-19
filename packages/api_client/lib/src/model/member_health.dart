//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_health.g.dart';

/// MemberHealth
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [bloodGroup] 
/// * [heightCm] 
/// * [baselineWeightKg] 
/// * [allergies] 
/// * [dietaryPreferences] 
/// * [physicianName] 
/// * [physicianPhone] 
/// * [updatedAt] - UTC ISO-8601
@BuiltValue()
abstract class MemberHealth implements Built<MemberHealth, MemberHealthBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'blood_group')
  String? get bloodGroup;

  @BuiltValueField(wireName: r'height_cm')
  num? get heightCm;

  @BuiltValueField(wireName: r'baseline_weight_kg')
  num? get baselineWeightKg;

  @BuiltValueField(wireName: r'allergies')
  String? get allergies;

  @BuiltValueField(wireName: r'dietary_preferences')
  String? get dietaryPreferences;

  @BuiltValueField(wireName: r'physician_name')
  String? get physicianName;

  @BuiltValueField(wireName: r'physician_phone')
  String? get physicianPhone;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  MemberHealth._();

  factory MemberHealth([void updates(MemberHealthBuilder b)]) = _$MemberHealth;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberHealthBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberHealth> get serializer => _$MemberHealthSerializer();
}

class _$MemberHealthSerializer implements PrimitiveSerializer<MemberHealth> {
  @override
  final Iterable<Type> types = const [MemberHealth, _$MemberHealth];

  @override
  final String wireName = r'MemberHealth';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberHealth object, {
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
    if (object.bloodGroup != null) {
      yield r'blood_group';
      yield serializers.serialize(
        object.bloodGroup,
        specifiedType: const FullType(String),
      );
    }
    if (object.heightCm != null) {
      yield r'height_cm';
      yield serializers.serialize(
        object.heightCm,
        specifiedType: const FullType(num),
      );
    }
    if (object.baselineWeightKg != null) {
      yield r'baseline_weight_kg';
      yield serializers.serialize(
        object.baselineWeightKg,
        specifiedType: const FullType(num),
      );
    }
    if (object.allergies != null) {
      yield r'allergies';
      yield serializers.serialize(
        object.allergies,
        specifiedType: const FullType(String),
      );
    }
    if (object.dietaryPreferences != null) {
      yield r'dietary_preferences';
      yield serializers.serialize(
        object.dietaryPreferences,
        specifiedType: const FullType(String),
      );
    }
    if (object.physicianName != null) {
      yield r'physician_name';
      yield serializers.serialize(
        object.physicianName,
        specifiedType: const FullType(String),
      );
    }
    if (object.physicianPhone != null) {
      yield r'physician_phone';
      yield serializers.serialize(
        object.physicianPhone,
        specifiedType: const FullType(String),
      );
    }
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MemberHealth object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberHealthBuilder result,
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
        case r'blood_group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bloodGroup = valueDes;
          break;
        case r'height_cm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.heightCm = valueDes;
          break;
        case r'baseline_weight_kg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.baselineWeightKg = valueDes;
          break;
        case r'allergies':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.allergies = valueDes;
          break;
        case r'dietary_preferences':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.dietaryPreferences = valueDes;
          break;
        case r'physician_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.physicianName = valueDes;
          break;
        case r'physician_phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.physicianPhone = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemberHealth deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberHealthBuilder();
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


