//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/membership.dart';
import 'package:api_client/src/model/user.dart';
import 'package:api_client/src/model/schedule.dart';
import 'package:api_client/src/model/member.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_dossier.g.dart';

/// MemberDossier
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
/// * [membership] 
/// * [outstandingBalance] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [lastCheckIn] - UTC ISO-8601
/// * [nextSchedule] 
@BuiltValue()
abstract class MemberDossier implements Member, Built<MemberDossier, MemberDossierBuilder> {
  @BuiltValueField(wireName: r'next_schedule')
  Schedule? get nextSchedule;

  @BuiltValueField(wireName: r'membership')
  Membership? get membership;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'last_check_in')
  DateTime? get lastCheckIn;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'outstanding_balance')
  String? get outstandingBalance;

  MemberDossier._();

  factory MemberDossier([void updates(MemberDossierBuilder b)]) = _$MemberDossier;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberDossierBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberDossier> get serializer => _$MemberDossierSerializer();
}

class _$MemberDossierSerializer implements PrimitiveSerializer<MemberDossier> {
  @override
  final Iterable<Type> types = const [MemberDossier, _$MemberDossier];

  @override
  final String wireName = r'MemberDossier';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberDossier object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'last_name';
    yield serializers.serialize(
      object.lastName,
      specifiedType: const FullType(String),
    );
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
        specifiedType: const FullType(String),
      );
    }
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
      );
    }
    if (object.gender != null) {
      yield r'gender';
      yield serializers.serialize(
        object.gender,
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
    if (object.dateOfBirth != null) {
      yield r'date_of_birth';
      yield serializers.serialize(
        object.dateOfBirth,
        specifiedType: const FullType(Date),
      );
    }
    if (object.membership != null) {
      yield r'membership';
      yield serializers.serialize(
        object.membership,
        specifiedType: const FullType(Membership),
      );
    }
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(int),
    );
    if (object.joinedDate != null) {
      yield r'joined_date';
      yield serializers.serialize(
        object.joinedDate,
        specifiedType: const FullType(Date),
      );
    }
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
    if (object.nextSchedule != null) {
      yield r'next_schedule';
      yield serializers.serialize(
        object.nextSchedule,
        specifiedType: const FullType(Schedule),
      );
    }
    if (object.lastCheckIn != null) {
      yield r'last_check_in';
      yield serializers.serialize(
        object.lastCheckIn,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    if (object.user != null) {
      yield r'user';
      yield serializers.serialize(
        object.user,
        specifiedType: const FullType(User),
      );
    }
    if (object.outstandingBalance != null) {
      yield r'outstanding_balance';
      yield serializers.serialize(
        object.outstandingBalance,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MemberDossier object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberDossierBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'last_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastName = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'gender':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gender = valueDes;
          break;
        case r'assigned_trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.assignedTrainerId = valueDes;
          break;
        case r'date_of_birth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.dateOfBirth = valueDes;
          break;
        case r'membership':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Membership),
          ) as Membership?;
          if (valueDes == null) continue;
          result.membership.replace(valueDes);
          break;
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userId = valueDes;
          break;
        case r'joined_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.joinedDate = valueDes;
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
        case r'next_schedule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Schedule),
          ) as Schedule?;
          if (valueDes == null) continue;
          result.nextSchedule.replace(valueDes);
          break;
        case r'last_check_in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastCheckIn = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(User),
          ) as User?;
          if (valueDes == null) continue;
          result.user.replace(valueDes);
          break;
        case r'outstanding_balance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.outstandingBalance = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemberDossier deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberDossierBuilder();
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


