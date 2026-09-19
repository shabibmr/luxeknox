//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/employee_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'employee_status_request.g.dart';

/// EmployeeStatusRequest
///
/// Properties:
/// * [status] 
@BuiltValue()
abstract class EmployeeStatusRequest implements Built<EmployeeStatusRequest, EmployeeStatusRequestBuilder> {
  @BuiltValueField(wireName: r'status')
  EmployeeStatus get status;
  // enum statusEnum {  active,  on_probation,  suspended,  terminated,  };

  EmployeeStatusRequest._();

  factory EmployeeStatusRequest([void updates(EmployeeStatusRequestBuilder b)]) = _$EmployeeStatusRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmployeeStatusRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmployeeStatusRequest> get serializer => _$EmployeeStatusRequestSerializer();
}

class _$EmployeeStatusRequestSerializer implements PrimitiveSerializer<EmployeeStatusRequest> {
  @override
  final Iterable<Type> types = const [EmployeeStatusRequest, _$EmployeeStatusRequest];

  @override
  final String wireName = r'EmployeeStatusRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmployeeStatusRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(EmployeeStatus),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmployeeStatusRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmployeeStatusRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EmployeeStatus),
          ) as EmployeeStatus;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmployeeStatusRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmployeeStatusRequestBuilder();
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


