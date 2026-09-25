//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/progress_photo.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progress_photo_comparison_pose_pair.g.dart';

/// ProgressPhotoComparisonPosePair
///
/// Properties:
/// * [date1] 
/// * [date2] 
@BuiltValue()
abstract class ProgressPhotoComparisonPosePair implements Built<ProgressPhotoComparisonPosePair, ProgressPhotoComparisonPosePairBuilder> {
  @BuiltValueField(wireName: r'date1')
  ProgressPhoto? get date1;

  @BuiltValueField(wireName: r'date2')
  ProgressPhoto? get date2;

  ProgressPhotoComparisonPosePair._();

  factory ProgressPhotoComparisonPosePair([void updates(ProgressPhotoComparisonPosePairBuilder b)]) = _$ProgressPhotoComparisonPosePair;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressPhotoComparisonPosePairBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressPhotoComparisonPosePair> get serializer => _$ProgressPhotoComparisonPosePairSerializer();
}

class _$ProgressPhotoComparisonPosePairSerializer implements PrimitiveSerializer<ProgressPhotoComparisonPosePair> {
  @override
  final Iterable<Type> types = const [ProgressPhotoComparisonPosePair, _$ProgressPhotoComparisonPosePair];

  @override
  final String wireName = r'ProgressPhotoComparisonPosePair';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressPhotoComparisonPosePair object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.date1 != null) {
      yield r'date1';
      yield serializers.serialize(
        object.date1,
        specifiedType: const FullType(ProgressPhoto),
      );
    }
    if (object.date2 != null) {
      yield r'date2';
      yield serializers.serialize(
        object.date2,
        specifiedType: const FullType(ProgressPhoto),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProgressPhotoComparisonPosePair object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressPhotoComparisonPosePairBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProgressPhoto),
          ) as ProgressPhoto?;
          if (valueDes == null) continue;
          result.date1.replace(valueDes);
          break;
        case r'date2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProgressPhoto),
          ) as ProgressPhoto?;
          if (valueDes == null) continue;
          result.date2.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProgressPhotoComparisonPosePair deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressPhotoComparisonPosePairBuilder();
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


