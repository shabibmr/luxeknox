//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member.g.dart';

/// Member
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [membershipNumber] 
/// * [firstName] 
/// * [lastName] 
/// * [gender] 
/// * [dateOfBirth] 
/// * [address] 
/// * [assignedTrainerId] 
/// * [joinedDate] 
/// * [notes] 
/// * [user] 
@BuiltValue(instantiable: false)
abstract class Member  {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'user_id')
  int get userId;

  @BuiltValueField(wireName: r'membership_number')
  String get membershipNumber;

  @BuiltValueField(wireName: r'first_name')
  String get firstName;

  @BuiltValueField(wireName: r'last_name')
  String get lastName;

  @BuiltValueField(wireName: r'gender')
  String? get gender;

  @BuiltValueField(wireName: r'date_of_birth')
  Date? get dateOfBirth;

  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'assigned_trainer_id')
  int? get assignedTrainerId;

  @BuiltValueField(wireName: r'joined_date')
  Date? get joinedDate;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'user')
  User? get user;

  @BuiltValueSerializer(custom: true)
  static Serializer<Member> get serializer => _$MemberSerializer();
}

class _$MemberSerializer implements PrimitiveSerializer<Member> {
  @override
  final Iterable<Type> types = const [Member];

  @override
  final String wireName = r'Member';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Member object, {
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
    yield r'membership_number';
    yield serializers.serialize(
      object.membershipNumber,
      specifiedType: const FullType(String),
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
    if (object.gender != null) {
      yield r'gender';
      yield serializers.serialize(
        object.gender,
        specifiedType: const FullType(String),
      );
    }
    if (object.dateOfBirth != null) {
      yield r'date_of_birth';
      yield serializers.serialize(
        object.dateOfBirth,
        specifiedType: const FullType(Date),
      );
    }
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
        specifiedType: const FullType(String),
      );
    }
    if (object.assignedTrainerId != null) {
      yield r'assigned_trainer_id';
      yield serializers.serialize(
        object.assignedTrainerId,
        specifiedType: const FullType(int),
      );
    }
    if (object.joinedDate != null) {
      yield r'joined_date';
      yield serializers.serialize(
        object.joinedDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
    if (object.user != null) {
      yield r'user';
      yield serializers.serialize(
        object.user,
        specifiedType: const FullType(User),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Member object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  Member deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($Member)) as $Member;
  }
}


/// a concrete implementation of [Member], since [Member] is not instantiable
@BuiltValue(instantiable: true)
abstract class $Member implements Member, Built<$Member, $MemberBuilder> {
  $Member._();

  factory $Member([void Function($MemberBuilder)? updates]) = _$$Member;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($MemberBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$Member> get serializer => _$$MemberSerializer();
}

class _$$MemberSerializer implements PrimitiveSerializer<$Member> {
  @override
  final Iterable<Type> types = const [$Member, _$$Member];

  @override
  final String wireName = r'$Member';

  @override
  Object serialize(
    Serializers serializers,
    $Member object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(Member))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberBuilder result,
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
        case r'membership_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.membershipNumber = valueDes;
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
        case r'gender':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gender = valueDes;
          break;
        case r'date_of_birth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.dateOfBirth = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'assigned_trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.assignedTrainerId = valueDes;
          break;
        case r'joined_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.joinedDate = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(User),
          ) as User?;
          if (valueDes == null) continue;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $Member deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $MemberBuilder();
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

