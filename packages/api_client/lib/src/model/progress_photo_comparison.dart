//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/progress_photo_comparison_comparison_by_pose.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/progress_photo.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progress_photo_comparison.g.dart';

/// ProgressPhotoComparison
///
/// Properties:
/// * [date1] 
/// * [date2] 
/// * [date1Photos] 
/// * [date2Photos] 
/// * [comparisonByPose] 
@BuiltValue()
abstract class ProgressPhotoComparison implements Built<ProgressPhotoComparison, ProgressPhotoComparisonBuilder> {
  @BuiltValueField(wireName: r'date1')
  Date get date1;

  @BuiltValueField(wireName: r'date2')
  Date get date2;

  @BuiltValueField(wireName: r'date1_photos')
  BuiltList<ProgressPhoto> get date1Photos;

  @BuiltValueField(wireName: r'date2_photos')
  BuiltList<ProgressPhoto> get date2Photos;

  @BuiltValueField(wireName: r'comparison_by_pose')
  ProgressPhotoComparisonComparisonByPose get comparisonByPose;

  ProgressPhotoComparison._();

  factory ProgressPhotoComparison([void updates(ProgressPhotoComparisonBuilder b)]) = _$ProgressPhotoComparison;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressPhotoComparisonBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressPhotoComparison> get serializer => _$ProgressPhotoComparisonSerializer();
}

class _$ProgressPhotoComparisonSerializer implements PrimitiveSerializer<ProgressPhotoComparison> {
  @override
  final Iterable<Type> types = const [ProgressPhotoComparison, _$ProgressPhotoComparison];

  @override
  final String wireName = r'ProgressPhotoComparison';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressPhotoComparison object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date1';
    yield serializers.serialize(
      object.date1,
      specifiedType: const FullType(Date),
    );
    yield r'date2';
    yield serializers.serialize(
      object.date2,
      specifiedType: const FullType(Date),
    );
    yield r'date1_photos';
    yield serializers.serialize(
      object.date1Photos,
      specifiedType: const FullType(BuiltList, [FullType(ProgressPhoto)]),
    );
    yield r'date2_photos';
    yield serializers.serialize(
      object.date2Photos,
      specifiedType: const FullType(BuiltList, [FullType(ProgressPhoto)]),
    );
    yield r'comparison_by_pose';
    yield serializers.serialize(
      object.comparisonByPose,
      specifiedType: const FullType(ProgressPhotoComparisonComparisonByPose),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProgressPhotoComparison object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressPhotoComparisonBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date1 = valueDes;
          break;
        case r'date2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date2 = valueDes;
          break;
        case r'date1_photos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProgressPhoto)]),
          ) as BuiltList<ProgressPhoto>;
          result.date1Photos.replace(valueDes);
          break;
        case r'date2_photos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProgressPhoto)]),
          ) as BuiltList<ProgressPhoto>;
          result.date2Photos.replace(valueDes);
          break;
        case r'comparison_by_pose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProgressPhotoComparisonComparisonByPose),
          ) as ProgressPhotoComparisonComparisonByPose;
          result.comparisonByPose.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProgressPhotoComparison deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressPhotoComparisonBuilder();
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


