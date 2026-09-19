//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_health_write.g.dart';

/// MemberHealthWrite
///
/// Properties:
/// * [bloodGroup] 
/// * [heightCm] 
/// * [baselineWeightKg] 
/// * [allergies] 
/// * [dietaryPreferences] 
/// * [physicianName] 
/// * [physicianPhone] 
@BuiltValue()
abstract class MemberHealthWrite implements Built<MemberHealthWrite, MemberHealthWriteBuilder> {
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

  MemberHealthWrite._();

  factory MemberHealthWrite([void updates(MemberHealthWriteBuilder b)]) = _$MemberHealthWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberHealthWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberHealthWrite> get serializer => _$MemberHealthWriteSerializer();
}

class _$MemberHealthWriteSerializer implements PrimitiveSerializer<MemberHealthWrite> {
  @override
  final Iterable<Type> types = const [MemberHealthWrite, _$MemberHealthWrite];

  @override
  final String wireName = r'MemberHealthWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberHealthWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    MemberHealthWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberHealthWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemberHealthWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberHealthWriteBuilder();
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


