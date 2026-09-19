//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/user.dart';
import 'package:api_client/src/model/employee.dart';
import 'package:api_client/src/model/member.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/employee_status.dart';
import 'package:api_client/src/model/trainer.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'me_response_profile.g.dart';

/// Null for Super Admin without an employee row (FR-AUTH-009) and until PEOPLE exists.
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
/// * [bio] 
/// * [specializations] 
/// * [hourlyRate] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [rating] 
/// * [maxClientsCapacity] 
/// * [isActive] 
/// * [assignedActiveCount] 
/// * [jobTitle] 
/// * [department] 
/// * [hireDate] 
/// * [status] 
/// * [roleId] 
@BuiltValue()
abstract class MeResponseProfile implements Built<MeResponseProfile, MeResponseProfileBuilder> {
  /// One Of [Employee], [Member], [Trainer]
  OneOf get oneOf;

  MeResponseProfile._();

  factory MeResponseProfile([void updates(MeResponseProfileBuilder b)]) = _$MeResponseProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeResponseProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MeResponseProfile> get serializer => _$MeResponseProfileSerializer();
}

class _$MeResponseProfileSerializer implements PrimitiveSerializer<MeResponseProfile> {
  @override
  final Iterable<Type> types = const [MeResponseProfile, _$MeResponseProfile];

  @override
  final String wireName = r'MeResponseProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MeResponseProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    MeResponseProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(oneOf.value, specifiedType: FullType(oneOf.valueType))!;
  }

  @override
  MeResponseProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeResponseProfileBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [FullType(Member), FullType(Trainer), FullType(Employee), ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(oneOfDataSrc, specifiedType: targetType) as OneOf;
    return result.build();
  }
}


