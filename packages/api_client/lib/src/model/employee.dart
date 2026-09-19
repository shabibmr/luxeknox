//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/employee_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee.g.dart';

/// Employee
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [jobTitle] 
/// * [department] 
/// * [hireDate] 
/// * [status] 
/// * [roleId] 
/// * [user] 
@BuiltValue()
abstract class Employee implements Built<Employee, EmployeeBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'user_id')
  int get userId;

  @BuiltValueField(wireName: r'job_title')
  String get jobTitle;

  @BuiltValueField(wireName: r'department')
  String? get department;

  @BuiltValueField(wireName: r'hire_date')
  Date? get hireDate;

  @BuiltValueField(wireName: r'status')
  EmployeeStatus get status;
  // enum statusEnum {  active,  on_probation,  suspended,  terminated,  };

  @BuiltValueField(wireName: r'role_id')
  int? get roleId;

  @BuiltValueField(wireName: r'user')
  User? get user;

  Employee._();

  factory Employee([void updates(EmployeeBuilder b)]) = _$Employee;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Employee> get serializer => _$EmployeeSerializer();
}

class _$EmployeeSerializer implements PrimitiveSerializer<Employee> {
  @override
  final Iterable<Type> types = const [Employee, _$Employee];

  @override
  final String wireName = r'Employee';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Employee object, {
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(EmployeeStatus),
    );
    if (object.roleId != null) {
      yield r'role_id';
      yield serializers.serialize(
        object.roleId,
        specifiedType: const FullType(int),
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
    Employee object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeStatus),
          ) as EmployeeStatus;
          result.status = valueDes;
          break;
        case r'role_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.roleId = valueDes;
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
  Employee deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeBuilder();
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


