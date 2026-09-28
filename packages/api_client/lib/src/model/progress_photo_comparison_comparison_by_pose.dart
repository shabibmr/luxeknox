//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/progress_photo_comparison_pose_pair.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progress_photo_comparison_comparison_by_pose.g.dart';

/// ProgressPhotoComparisonComparisonByPose
///
/// Properties:
/// * [front] 
/// * [side] 
/// * [back] 
@BuiltValue()
abstract class ProgressPhotoComparisonComparisonByPose implements Built<ProgressPhotoComparisonComparisonByPose, ProgressPhotoComparisonComparisonByPoseBuilder> {
  @BuiltValueField(wireName: r'front')
  ProgressPhotoComparisonPosePair? get front;

  @BuiltValueField(wireName: r'side')
  ProgressPhotoComparisonPosePair? get side;

  @BuiltValueField(wireName: r'back')
  ProgressPhotoComparisonPosePair? get back;

  ProgressPhotoComparisonComparisonByPose._();

  factory ProgressPhotoComparisonComparisonByPose([void updates(ProgressPhotoComparisonComparisonByPoseBuilder b)]) = _$ProgressPhotoComparisonComparisonByPose;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressPhotoComparisonComparisonByPoseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressPhotoComparisonComparisonByPose> get serializer => _$ProgressPhotoComparisonComparisonByPoseSerializer();
}

class _$ProgressPhotoComparisonComparisonByPoseSerializer implements PrimitiveSerializer<ProgressPhotoComparisonComparisonByPose> {
  @override
  final Iterable<Type> types = const [ProgressPhotoComparisonComparisonByPose, _$ProgressPhotoComparisonComparisonByPose];

  @override
  final String wireName = r'ProgressPhotoComparisonComparisonByPose';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressPhotoComparisonComparisonByPose object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.front != null) {
      yield r'front';
      yield serializers.serialize(
        object.front,
        specifiedType: const FullType(ProgressPhotoComparisonPosePair),
      );
    }
    if (object.side != null) {
      yield r'side';
      yield serializers.serialize(
        object.side,
        specifiedType: const FullType(ProgressPhotoComparisonPosePair),
      );
    }
    if (object.back != null) {
      yield r'back';
      yield serializers.serialize(
        object.back,
        specifiedType: const FullType(ProgressPhotoComparisonPosePair),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProgressPhotoComparisonComparisonByPose object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressPhotoComparisonComparisonByPoseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'front':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProgressPhotoComparisonPosePair),
          ) as ProgressPhotoComparisonPosePair?;
          if (valueDes == null) continue;
          result.front.replace(valueDes);
          break;
        case r'side':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProgressPhotoComparisonPosePair),
          ) as ProgressPhotoComparisonPosePair?;
          if (valueDes == null) continue;
          result.side.replace(valueDes);
          break;
        case r'back':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProgressPhotoComparisonPosePair),
          ) as ProgressPhotoComparisonPosePair?;
          if (valueDes == null) continue;
          result.back.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProgressPhotoComparisonComparisonByPose deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressPhotoComparisonComparisonByPoseBuilder();
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


