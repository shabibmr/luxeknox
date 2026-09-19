//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trainer.g.dart';

/// Trainer
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [firstName] 
/// * [lastName] 
/// * [bio] 
/// * [specializations] 
/// * [hourlyRate] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [rating] 
/// * [maxClientsCapacity] 
/// * [isActive] 
/// * [assignedActiveCount] 
@BuiltValue()
abstract class Trainer implements Built<Trainer, TrainerBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'user_id')
  int get userId;

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

  @BuiltValueField(wireName: r'rating')
  num? get rating;

  @BuiltValueField(wireName: r'max_clients_capacity')
  int? get maxClientsCapacity;

  @BuiltValueField(wireName: r'is_active')
  bool get isActive;

  @BuiltValueField(wireName: r'assigned_active_count')
  int? get assignedActiveCount;

  Trainer._();

  factory Trainer([void updates(TrainerBuilder b)]) = _$Trainer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Trainer> get serializer => _$TrainerSerializer();
}

class _$TrainerSerializer implements PrimitiveSerializer<Trainer> {
  @override
  final Iterable<Type> types = const [Trainer, _$Trainer];

  @override
  final String wireName = r'Trainer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Trainer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(int),
    );
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
    if (object.rating != null) {
      yield r'rating';
      yield serializers.serialize(
        object.rating,
        specifiedType: const FullType(num),
      );
    }
    if (object.maxClientsCapacity != null) {
      yield r'max_clients_capacity';
      yield serializers.serialize(
        object.maxClientsCapacity,
        specifiedType: const FullType(int),
      );
    }
    yield r'is_active';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
    if (object.assignedActiveCount != null) {
      yield r'assigned_active_count';
      yield serializers.serialize(
        object.assignedActiveCount,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Trainer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TrainerBuilder result,
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
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userId = valueDes;
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
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.rating = valueDes;
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
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        case r'assigned_active_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.assignedActiveCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Trainer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainerBuilder();
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


