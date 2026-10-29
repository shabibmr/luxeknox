//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'workout_session_complete.g.dart';

/// Post-workout feedback. an explicit `*_signed_at` wins; otherwise `client_signed: true` (or a member caller) stamps now and `false` clears it. 
///
/// Properties:
/// * [clientFeedbackRating] 
/// * [effortRating] 
/// * [satisfactionRating] 
/// * [painDiscomfortScore] 
/// * [painNotes] 
/// * [notes] 
/// * [trainerNotes] 
/// * [nextSessionPlan] 
/// * [sessionFocus] 
/// * [warmupProtocol] 
/// * [cooldownProtocol] 
/// * [clientSigned] 
/// * [trainerSigned] 
/// * [clientSignedAt] 
/// * [trainerSignedAt] 
@BuiltValue()
abstract class WorkoutSessionComplete implements Built<WorkoutSessionComplete, WorkoutSessionCompleteBuilder> {
  @BuiltValueField(wireName: r'client_feedback_rating')
  int? get clientFeedbackRating;

  @BuiltValueField(wireName: r'effort_rating')
  int? get effortRating;

  @BuiltValueField(wireName: r'satisfaction_rating')
  int? get satisfactionRating;

  @BuiltValueField(wireName: r'pain_discomfort_score')
  int? get painDiscomfortScore;

  @BuiltValueField(wireName: r'pain_notes')
  String? get painNotes;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  @BuiltValueField(wireName: r'trainer_notes')
  String? get trainerNotes;

  @BuiltValueField(wireName: r'next_session_plan')
  String? get nextSessionPlan;

  @BuiltValueField(wireName: r'session_focus')
  String? get sessionFocus;

  @BuiltValueField(wireName: r'warmup_protocol')
  String? get warmupProtocol;

  @BuiltValueField(wireName: r'cooldown_protocol')
  String? get cooldownProtocol;

  @BuiltValueField(wireName: r'client_signed')
  bool? get clientSigned;

  @BuiltValueField(wireName: r'trainer_signed')
  bool? get trainerSigned;

  @BuiltValueField(wireName: r'client_signed_at')
  DateTime? get clientSignedAt;

  @BuiltValueField(wireName: r'trainer_signed_at')
  DateTime? get trainerSignedAt;

  WorkoutSessionComplete._();

  factory WorkoutSessionComplete([void updates(WorkoutSessionCompleteBuilder b)]) = _$WorkoutSessionComplete;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkoutSessionCompleteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkoutSessionComplete> get serializer => _$WorkoutSessionCompleteSerializer();
}

class _$WorkoutSessionCompleteSerializer implements PrimitiveSerializer<WorkoutSessionComplete> {
  @override
  final Iterable<Type> types = const [WorkoutSessionComplete, _$WorkoutSessionComplete];

  @override
  final String wireName = r'WorkoutSessionComplete';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkoutSessionComplete object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.clientFeedbackRating != null) {
      yield r'client_feedback_rating';
      yield serializers.serialize(
        object.clientFeedbackRating,
        specifiedType: const FullType(int),
      );
    }
    if (object.effortRating != null) {
      yield r'effort_rating';
      yield serializers.serialize(
        object.effortRating,
        specifiedType: const FullType(int),
      );
    }
    if (object.satisfactionRating != null) {
      yield r'satisfaction_rating';
      yield serializers.serialize(
        object.satisfactionRating,
        specifiedType: const FullType(int),
      );
    }
    if (object.painDiscomfortScore != null) {
      yield r'pain_discomfort_score';
      yield serializers.serialize(
        object.painDiscomfortScore,
        specifiedType: const FullType(int),
      );
    }
    if (object.painNotes != null) {
      yield r'pain_notes';
      yield serializers.serialize(
        object.painNotes,
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
    if (object.trainerNotes != null) {
      yield r'trainer_notes';
      yield serializers.serialize(
        object.trainerNotes,
        specifiedType: const FullType(String),
      );
    }
    if (object.nextSessionPlan != null) {
      yield r'next_session_plan';
      yield serializers.serialize(
        object.nextSessionPlan,
        specifiedType: const FullType(String),
      );
    }
    if (object.sessionFocus != null) {
      yield r'session_focus';
      yield serializers.serialize(
        object.sessionFocus,
        specifiedType: const FullType(String),
      );
    }
    if (object.warmupProtocol != null) {
      yield r'warmup_protocol';
      yield serializers.serialize(
        object.warmupProtocol,
        specifiedType: const FullType(String),
      );
    }
    if (object.cooldownProtocol != null) {
      yield r'cooldown_protocol';
      yield serializers.serialize(
        object.cooldownProtocol,
        specifiedType: const FullType(String),
      );
    }
    if (object.clientSigned != null) {
      yield r'client_signed';
      yield serializers.serialize(
        object.clientSigned,
        specifiedType: const FullType(bool),
      );
    }
    if (object.trainerSigned != null) {
      yield r'trainer_signed';
      yield serializers.serialize(
        object.trainerSigned,
        specifiedType: const FullType(bool),
      );
    }
    if (object.clientSignedAt != null) {
      yield r'client_signed_at';
      yield serializers.serialize(
        object.clientSignedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.trainerSignedAt != null) {
      yield r'trainer_signed_at';
      yield serializers.serialize(
        object.trainerSignedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkoutSessionComplete object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkoutSessionCompleteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'client_feedback_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.clientFeedbackRating = valueDes;
          break;
        case r'effort_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.effortRating = valueDes;
          break;
        case r'satisfaction_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.satisfactionRating = valueDes;
          break;
        case r'pain_discomfort_score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.painDiscomfortScore = valueDes;
          break;
        case r'pain_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.painNotes = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        case r'trainer_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.trainerNotes = valueDes;
          break;
        case r'next_session_plan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextSessionPlan = valueDes;
          break;
        case r'session_focus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sessionFocus = valueDes;
          break;
        case r'warmup_protocol':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.warmupProtocol = valueDes;
          break;
        case r'cooldown_protocol':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cooldownProtocol = valueDes;
          break;
        case r'client_signed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.clientSigned = valueDes;
          break;
        case r'trainer_signed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.trainerSigned = valueDes;
          break;
        case r'client_signed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.clientSignedAt = valueDes;
          break;
        case r'trainer_signed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.trainerSignedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkoutSessionComplete deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkoutSessionCompleteBuilder();
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


