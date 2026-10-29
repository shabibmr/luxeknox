//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_review_checklist.g.dart';

/// PtReviewChecklist
///
/// Properties:
/// * [goalsReviewed] 
/// * [measurementsReviewed] 
/// * [performanceReviewed] 
/// * [attendanceReviewed] 
/// * [programUpdated] 
/// * [nextGoalsAgreed] 
@BuiltValue()
abstract class PtReviewChecklist implements Built<PtReviewChecklist, PtReviewChecklistBuilder> {
  @BuiltValueField(wireName: r'goals_reviewed')
  bool? get goalsReviewed;

  @BuiltValueField(wireName: r'measurements_reviewed')
  bool? get measurementsReviewed;

  @BuiltValueField(wireName: r'performance_reviewed')
  bool? get performanceReviewed;

  @BuiltValueField(wireName: r'attendance_reviewed')
  bool? get attendanceReviewed;

  @BuiltValueField(wireName: r'program_updated')
  bool? get programUpdated;

  @BuiltValueField(wireName: r'next_goals_agreed')
  bool? get nextGoalsAgreed;

  PtReviewChecklist._();

  factory PtReviewChecklist([void updates(PtReviewChecklistBuilder b)]) = _$PtReviewChecklist;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtReviewChecklistBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtReviewChecklist> get serializer => _$PtReviewChecklistSerializer();
}

class _$PtReviewChecklistSerializer implements PrimitiveSerializer<PtReviewChecklist> {
  @override
  final Iterable<Type> types = const [PtReviewChecklist, _$PtReviewChecklist];

  @override
  final String wireName = r'PtReviewChecklist';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtReviewChecklist object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.goalsReviewed != null) {
      yield r'goals_reviewed';
      yield serializers.serialize(
        object.goalsReviewed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.measurementsReviewed != null) {
      yield r'measurements_reviewed';
      yield serializers.serialize(
        object.measurementsReviewed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.performanceReviewed != null) {
      yield r'performance_reviewed';
      yield serializers.serialize(
        object.performanceReviewed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.attendanceReviewed != null) {
      yield r'attendance_reviewed';
      yield serializers.serialize(
        object.attendanceReviewed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.programUpdated != null) {
      yield r'program_updated';
      yield serializers.serialize(
        object.programUpdated,
        specifiedType: const FullType(bool),
      );
    }
    if (object.nextGoalsAgreed != null) {
      yield r'next_goals_agreed';
      yield serializers.serialize(
        object.nextGoalsAgreed,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PtReviewChecklist object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtReviewChecklistBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'goals_reviewed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.goalsReviewed = valueDes;
          break;
        case r'measurements_reviewed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.measurementsReviewed = valueDes;
          break;
        case r'performance_reviewed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.performanceReviewed = valueDes;
          break;
        case r'attendance_reviewed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.attendanceReviewed = valueDes;
          break;
        case r'program_updated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.programUpdated = valueDes;
          break;
        case r'next_goals_agreed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.nextGoalsAgreed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PtReviewChecklist deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtReviewChecklistBuilder();
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


