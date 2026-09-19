//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/attendance_history.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'attendance_history_page.g.dart';

/// AttendanceHistoryPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class AttendanceHistoryPage implements Built<AttendanceHistoryPage, AttendanceHistoryPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<AttendanceHistory> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  AttendanceHistoryPage._();

  factory AttendanceHistoryPage([void updates(AttendanceHistoryPageBuilder b)]) = _$AttendanceHistoryPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AttendanceHistoryPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AttendanceHistoryPage> get serializer => _$AttendanceHistoryPageSerializer();
}

class _$AttendanceHistoryPageSerializer implements PrimitiveSerializer<AttendanceHistoryPage> {
  @override
  final Iterable<Type> types = const [AttendanceHistoryPage, _$AttendanceHistoryPage];

  @override
  final String wireName = r'AttendanceHistoryPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AttendanceHistoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(AttendanceHistory)]),
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
    AttendanceHistoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AttendanceHistoryPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AttendanceHistory)]),
          ) as BuiltList<AttendanceHistory>;
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
  AttendanceHistoryPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttendanceHistoryPageBuilder();
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


