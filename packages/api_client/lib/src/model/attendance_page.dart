//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/attendance.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'attendance_page.g.dart';

/// AttendancePage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class AttendancePage implements Built<AttendancePage, AttendancePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Attendance> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  AttendancePage._();

  factory AttendancePage([void updates(AttendancePageBuilder b)]) = _$AttendancePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AttendancePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AttendancePage> get serializer => _$AttendancePageSerializer();
}

class _$AttendancePageSerializer implements PrimitiveSerializer<AttendancePage> {
  @override
  final Iterable<Type> types = const [AttendancePage, _$AttendancePage];

  @override
  final String wireName = r'AttendancePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AttendancePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Attendance)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(PageMeta),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AttendancePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AttendancePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Attendance)]),
          ) as BuiltList<Attendance>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageMeta),
          ) as PageMeta;
          result.meta.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AttendancePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttendancePageBuilder();
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


