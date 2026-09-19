//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'attendance_summary.g.dart';

/// AttendanceSummary
///
/// Properties:
/// * [streakDays] 
/// * [lastCheckIn] - UTC ISO-8601
/// * [visitsThisMonth] 
@BuiltValue()
abstract class AttendanceSummary implements Built<AttendanceSummary, AttendanceSummaryBuilder> {
  @BuiltValueField(wireName: r'streak_days')
  int? get streakDays;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'last_check_in')
  DateTime? get lastCheckIn;

  @BuiltValueField(wireName: r'visits_this_month')
  int? get visitsThisMonth;

  AttendanceSummary._();

  factory AttendanceSummary([void updates(AttendanceSummaryBuilder b)]) = _$AttendanceSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AttendanceSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AttendanceSummary> get serializer => _$AttendanceSummarySerializer();
}

class _$AttendanceSummarySerializer implements PrimitiveSerializer<AttendanceSummary> {
  @override
  final Iterable<Type> types = const [AttendanceSummary, _$AttendanceSummary];

  @override
  final String wireName = r'AttendanceSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AttendanceSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.streakDays != null) {
      yield r'streak_days';
      yield serializers.serialize(
        object.streakDays,
        specifiedType: const FullType(int),
      );
    }
    if (object.lastCheckIn != null) {
      yield r'last_check_in';
      yield serializers.serialize(
        object.lastCheckIn,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.visitsThisMonth != null) {
      yield r'visits_this_month';
      yield serializers.serialize(
        object.visitsThisMonth,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AttendanceSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AttendanceSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'streak_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.streakDays = valueDes;
          break;
        case r'last_check_in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastCheckIn = valueDes;
          break;
        case r'visits_this_month':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.visitsThisMonth = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AttendanceSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttendanceSummaryBuilder();
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


