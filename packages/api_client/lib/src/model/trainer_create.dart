//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trainer_create.g.dart';

/// TrainerCreate
///
/// Properties:
/// * [email] 
/// * [phoneNumber] 
/// * [password] 
/// * [firstName] 
/// * [lastName] 
/// * [bio] 
/// * [specializations] 
/// * [hourlyRate] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [maxClientsCapacity] 
@BuiltValue()
abstract class TrainerCreate implements Built<TrainerCreate, TrainerCreateBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'phone_number')
  String? get phoneNumber;

  @BuiltValueField(wireName: r'password')
  String? get password;

  @BuiltValueField(wireName: r'first_name')
  String get firstName;

  @BuiltValueField(wireName: r'last_name')
  String get lastName;

  @BuiltValueField(wireName: r'bio')
  String? get bio;

  @BuiltValueField(wireName: r'specializations')
  BuiltList<String>? get specializations;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'hourly_rate')
  String? get hourlyRate;

  @BuiltValueField(wireName: r'max_clients_capacity')
  int? get maxClientsCapacity;

  TrainerCreate._();

  factory TrainerCreate([void updates(TrainerCreateBuilder b)]) = _$TrainerCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainerCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrainerCreate> get serializer => _$TrainerCreateSerializer();
}

class _$TrainerCreateSerializer implements PrimitiveSerializer<TrainerCreate> {
  @override
  final Iterable<Type> types = const [TrainerCreate, _$TrainerCreate];

  @override
  final String wireName = r'TrainerCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrainerCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    if (object.phoneNumber != null) {
      yield r'phone_number';
      yield serializers.serialize(
        object.phoneNumber,
        specifiedType: const FullType(String),
      );
    }
    if (object.password != null) {
      yield r'password';
      yield serializers.serialize(
        object.password,
        specifiedType: const FullType(String),
      );
    }
    yield r'first_name';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    yield r'last_name';
    yield serializers.serialize(
      object.lastName,
      specifiedType: const FullType(String),
    );
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
  }

  @override
  Object serialize(
    Serializers serializers,
    TrainerCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TrainerCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'phone_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phoneNumber = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.password = valueDes;
          break;
        case r'first_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'last_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TrainerCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainerCreateBuilder();
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


