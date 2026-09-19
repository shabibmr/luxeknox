//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_create.g.dart';

/// EmployeeCreate
///
/// Properties:
/// * [email] 
/// * [phoneNumber] 
/// * [password] 
/// * [firstName] 
/// * [lastName] 
/// * [jobTitle] 
/// * [department] 
/// * [hireDate] 
/// * [roleId] 
@BuiltValue()
abstract class EmployeeCreate implements Built<EmployeeCreate, EmployeeCreateBuilder> {
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

  @BuiltValueField(wireName: r'job_title')
  String get jobTitle;

  @BuiltValueField(wireName: r'department')
  String? get department;

  @BuiltValueField(wireName: r'hire_date')
  Date? get hireDate;

  @BuiltValueField(wireName: r'role_id')
  int get roleId;

  EmployeeCreate._();

  factory EmployeeCreate([void updates(EmployeeCreateBuilder b)]) = _$EmployeeCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeCreate> get serializer => _$EmployeeCreateSerializer();
}

class _$EmployeeCreateSerializer implements PrimitiveSerializer<EmployeeCreate> {
  @override
  final Iterable<Type> types = const [EmployeeCreate, _$EmployeeCreate];

  @override
  final String wireName = r'EmployeeCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeCreate object, {
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
    yield r'job_title';
    yield serializers.serialize(
      object.jobTitle,
      specifiedType: const FullType(String),
    );
    if (object.department != null) {
      yield r'department';
      yield serializers.serialize(
        object.department,
        specifiedType: const FullType(String),
      );
    }
    if (object.hireDate != null) {
      yield r'hire_date';
      yield serializers.serialize(
        object.hireDate,
        specifiedType: const FullType(Date),
      );
    }
    yield r'role_id';
    yield serializers.serialize(
      object.roleId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeCreateBuilder result,
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
        case r'job_title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.jobTitle = valueDes;
          break;
        case r'department':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.department = valueDes;
          break;
        case r'hire_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.hireDate = valueDes;
          break;
        case r'role_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.roleId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeCreateBuilder();
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


