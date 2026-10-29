//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'par_q_trainer_review.g.dart';

/// ParQTrainerReview
///
/// Properties:
/// * [trainerScreeningNotes] 
/// * [referralRequired] 
/// * [referralReason] - Required when `referral_required` is true.
@BuiltValue()
abstract class ParQTrainerReview implements Built<ParQTrainerReview, ParQTrainerReviewBuilder> {
  @BuiltValueField(wireName: r'trainer_screening_notes')
  String get trainerScreeningNotes;

  @BuiltValueField(wireName: r'referral_required')
  bool get referralRequired;

  /// Required when `referral_required` is true.
  @BuiltValueField(wireName: r'referral_reason')
  String? get referralReason;

  ParQTrainerReview._();

  factory ParQTrainerReview([void updates(ParQTrainerReviewBuilder b)]) = _$ParQTrainerReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ParQTrainerReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ParQTrainerReview> get serializer => _$ParQTrainerReviewSerializer();
}

class _$ParQTrainerReviewSerializer implements PrimitiveSerializer<ParQTrainerReview> {
  @override
  final Iterable<Type> types = const [ParQTrainerReview, _$ParQTrainerReview];

  @override
  final String wireName = r'ParQTrainerReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ParQTrainerReview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'trainer_screening_notes';
    yield serializers.serialize(
      object.trainerScreeningNotes,
      specifiedType: const FullType(String),
    );
    yield r'referral_required';
    yield serializers.serialize(
      object.referralRequired,
      specifiedType: const FullType(bool),
    );
    if (object.referralReason != null) {
      yield r'referral_reason';
      yield serializers.serialize(
        object.referralReason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ParQTrainerReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ParQTrainerReviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'trainer_screening_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.trainerScreeningNotes = valueDes;
          break;
        case r'referral_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.referralRequired = valueDes;
          break;
        case r'referral_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.referralReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ParQTrainerReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParQTrainerReviewBuilder();
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


