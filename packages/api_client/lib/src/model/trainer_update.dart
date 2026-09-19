//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trainer_update.g.dart';

/// TrainerUpdate
///
/// Properties:
/// * [phoneNumber] 
/// * [firstName] 
/// * [lastName] 
/// * [bio] 
/// * [specializations] 
/// * [hourlyRate] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [maxClientsCapacity] 
/// * [isActive] 
@BuiltValue()
abstract class TrainerUpdate implements Built<TrainerUpdate, TrainerUpdateBuilder> {
  @BuiltValueField(wireName: r'phone_number')
  String? get phoneNumber;

  @BuiltValueField(wireName: r'first_name')
  String? get firstName;

  @BuiltValueField(wireName: r'last_name')
  String? get lastName;

  @BuiltValueField(wireName: r'bio')
  String? get bio;

  @BuiltValueField(wireName: r'specializations')
  BuiltList<String>? get specializations;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'hourly_rate')
  String? get hourlyRate;

  @BuiltValueField(wireName: r'max_clients_capacity')
  int? get maxClientsCapacity;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  TrainerUpdate._();

  factory TrainerUpdate([void updates(TrainerUpdateBuilder b)]) = _$TrainerUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainerUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrainerUpdate> get serializer => _$TrainerUpdateSerializer();
}

class _$TrainerUpdateSerializer implements PrimitiveSerializer<TrainerUpdate> {
  @override
  final Iterable<Type> types = const [TrainerUpdate, _$TrainerUpdate];

  @override
  final String wireName = r'TrainerUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrainerUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.phoneNumber != null) {
      yield r'phone_number';
      yield serializers.serialize(
        object.phoneNumber,
        specifiedType: const FullType(String),
      );
    }
    if (object.firstName != null) {
      yield r'first_name';
      yield serializers.serialize(
        object.firstName,
        specifiedType: const FullType(String),
      );
    }
    if (object.lastName != null) {
      yield r'last_name';
      yield serializers.serialize(
        object.lastName,
        specifiedType: const FullType(String),
      );
    }
    if (object.bio != null) {
      yield r'bio';
      yield serializers.serialize(
        object.bio,
        specifiedType: const FullType(String),
      );
    }
    if (object.specializations != null) {
      yield r'specializations';
      yield serializers.serialize(
        object.specializations,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.hourlyRate != null) {
      yield r'hourly_rate';
      yield serializers.serialize(
        object.hourlyRate,
        specifiedType: const FullType(String),
      );
    }
    if (object.maxClientsCapacity != null) {
      yield r'max_clients_capacity';
      yield serializers.serialize(
        object.maxClientsCapacity,
        specifiedType: const FullType(int),
      );
    }
    if (object.isActive != null) {
      yield r'is_active';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TrainerUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TrainerUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phoneNumber = valueDes;
          break;
        case r'first_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.firstName = valueDes;
          break;
        case r'last_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastName = valueDes;
          break;
        case r'bio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bio = valueDes;
          break;
        case r'specializations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.specializations.replace(valueDes);
          break;
        case r'hourly_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.hourlyRate = valueDes;
          break;
        case r'max_clients_capacity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxClientsCapacity = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActive = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TrainerUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainerUpdateBuilder();
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


