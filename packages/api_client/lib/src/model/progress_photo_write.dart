//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progress_photo_write.g.dart';

/// ProgressPhotoWrite
///
/// Properties:
/// * [photoUrl] 
/// * [pose] 
/// * [takenDate] 
/// * [isPrivate] 
@BuiltValue()
abstract class ProgressPhotoWrite implements Built<ProgressPhotoWrite, ProgressPhotoWriteBuilder> {
  @BuiltValueField(wireName: r'photo_url')
  String get photoUrl;

  @BuiltValueField(wireName: r'pose')
  ProgressPhotoWritePoseEnum get pose;
  // enum poseEnum {  front,  side,  back,  };

  @BuiltValueField(wireName: r'taken_date')
  Date? get takenDate;

  @BuiltValueField(wireName: r'is_private')
  bool? get isPrivate;

  ProgressPhotoWrite._();

  factory ProgressPhotoWrite([void updates(ProgressPhotoWriteBuilder b)]) = _$ProgressPhotoWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressPhotoWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressPhotoWrite> get serializer => _$ProgressPhotoWriteSerializer();
}

class _$ProgressPhotoWriteSerializer implements PrimitiveSerializer<ProgressPhotoWrite> {
  @override
  final Iterable<Type> types = const [ProgressPhotoWrite, _$ProgressPhotoWrite];

  @override
  final String wireName = r'ProgressPhotoWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressPhotoWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'photo_url';
    yield serializers.serialize(
      object.photoUrl,
      specifiedType: const FullType(String),
    );
    yield r'pose';
    yield serializers.serialize(
      object.pose,
      specifiedType: const FullType(ProgressPhotoWritePoseEnum),
    );
    if (object.takenDate != null) {
      yield r'taken_date';
      yield serializers.serialize(
        object.takenDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.isPrivate != null) {
      yield r'is_private';
      yield serializers.serialize(
        object.isPrivate,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProgressPhotoWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressPhotoWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'photo_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.photoUrl = valueDes;
          break;
        case r'pose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProgressPhotoWritePoseEnum),
          ) as ProgressPhotoWritePoseEnum;
          result.pose = valueDes;
          break;
        case r'taken_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.takenDate = valueDes;
          break;
        case r'is_private':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isPrivate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProgressPhotoWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressPhotoWriteBuilder();
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


class ProgressPhotoWritePoseEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'front')
  static const ProgressPhotoWritePoseEnum front = _$progressPhotoWritePoseEnum_front;
  @BuiltValueEnumConst(wireName: r'side')
  static const ProgressPhotoWritePoseEnum side = _$progressPhotoWritePoseEnum_side;
  @BuiltValueEnumConst(wireName: r'back')
  static const ProgressPhotoWritePoseEnum back = _$progressPhotoWritePoseEnum_back;

  static Serializer<ProgressPhotoWritePoseEnum> get serializer => _$progressPhotoWritePoseEnumSerializer;

  const ProgressPhotoWritePoseEnum._(String name): super(name);

  static BuiltSet<ProgressPhotoWritePoseEnum> get values => _$progressPhotoWritePoseEnumValues;
  static ProgressPhotoWritePoseEnum valueOf(String name) => _$progressPhotoWritePoseEnumValueOf(name);
}

