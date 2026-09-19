//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'attendance_history.g.dart';

/// AttendanceHistory
///
/// Properties:
/// * [id] 
/// * [date] 
/// * [totalMemberCheckins] 
/// * [totalTrainerCheckins] 
/// * [peakHour] 
/// * [peakCount] 
@BuiltValue()
abstract class AttendanceHistory implements Built<AttendanceHistory, AttendanceHistoryBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'total_member_checkins')
  int get totalMemberCheckins;

  @BuiltValueField(wireName: r'total_trainer_checkins')
  int? get totalTrainerCheckins;

  @BuiltValueField(wireName: r'peak_hour')
  int? get peakHour;

  @BuiltValueField(wireName: r'peak_count')
  int? get peakCount;

  AttendanceHistory._();

  factory AttendanceHistory([void updates(AttendanceHistoryBuilder b)]) = _$AttendanceHistory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AttendanceHistoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AttendanceHistory> get serializer => _$AttendanceHistorySerializer();
}

class _$AttendanceHistorySerializer implements PrimitiveSerializer<AttendanceHistory> {
  @override
  final Iterable<Type> types = const [AttendanceHistory, _$AttendanceHistory];

  @override
  final String wireName = r'AttendanceHistory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AttendanceHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'total_member_checkins';
    yield serializers.serialize(
      object.totalMemberCheckins,
      specifiedType: const FullType(int),
    );
    if (object.totalTrainerCheckins != null) {
      yield r'total_trainer_checkins';
      yield serializers.serialize(
        object.totalTrainerCheckins,
        specifiedType: const FullType(int),
      );
    }
    if (object.peakHour != null) {
      yield r'peak_hour';
      yield serializers.serialize(
        object.peakHour,
        specifiedType: const FullType(int),
      );
    }
    if (object.peakCount != null) {
      yield r'peak_count';
      yield serializers.serialize(
        object.peakCount,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AttendanceHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AttendanceHistoryBuilder result,
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
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'total_member_checkins':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalMemberCheckins = valueDes;
          break;
        case r'total_trainer_checkins':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalTrainerCheckins = valueDes;
          break;
        case r'peak_hour':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.peakHour = valueDes;
          break;
        case r'peak_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.peakCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AttendanceHistory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttendanceHistoryBuilder();
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


