//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_update.g.dart';

/// EmployeeUpdate
///
/// Properties:
/// * [jobTitle] 
/// * [department] 
/// * [hireDate] 
@BuiltValue()
abstract class EmployeeUpdate implements Built<EmployeeUpdate, EmployeeUpdateBuilder> {
  @BuiltValueField(wireName: r'job_title')
  String? get jobTitle;

  @BuiltValueField(wireName: r'department')
  String? get department;

  @BuiltValueField(wireName: r'hire_date')
  Date? get hireDate;

  EmployeeUpdate._();

  factory EmployeeUpdate([void updates(EmployeeUpdateBuilder b)]) = _$EmployeeUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeUpdate> get serializer => _$EmployeeUpdateSerializer();
}

class _$EmployeeUpdateSerializer implements PrimitiveSerializer<EmployeeUpdate> {
  @override
  final Iterable<Type> types = const [EmployeeUpdate, _$EmployeeUpdate];

  @override
  final String wireName = r'EmployeeUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.jobTitle != null) {
      yield r'job_title';
      yield serializers.serialize(
        object.jobTitle,
        specifiedType: const FullType(String),
      );
    }
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
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'job_title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeUpdateBuilder();
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


