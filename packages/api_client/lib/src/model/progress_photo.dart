//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progress_photo.g.dart';

/// ProgressPhoto
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [photoUrl] 
/// * [pose] 
/// * [takenDate] 
/// * [isPrivate] 
@BuiltValue()
abstract class ProgressPhoto implements Built<ProgressPhoto, ProgressPhotoBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'photo_url')
  String get photoUrl;

  @BuiltValueField(wireName: r'pose')
  ProgressPhotoPoseEnum get pose;
  // enum poseEnum {  front,  side,  back,  };

  @BuiltValueField(wireName: r'taken_date')
  Date? get takenDate;

  @BuiltValueField(wireName: r'is_private')
  bool? get isPrivate;

  ProgressPhoto._();

  factory ProgressPhoto([void updates(ProgressPhotoBuilder b)]) = _$ProgressPhoto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressPhotoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressPhoto> get serializer => _$ProgressPhotoSerializer();
}

class _$ProgressPhotoSerializer implements PrimitiveSerializer<ProgressPhoto> {
  @override
  final Iterable<Type> types = const [ProgressPhoto, _$ProgressPhoto];

  @override
  final String wireName = r'ProgressPhoto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressPhoto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    yield r'photo_url';
    yield serializers.serialize(
      object.photoUrl,
      specifiedType: const FullType(String),
    );
    yield r'pose';
    yield serializers.serialize(
      object.pose,
      specifiedType: const FullType(ProgressPhotoPoseEnum),
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
    ProgressPhoto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressPhotoBuilder result,
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
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
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
            specifiedType: const FullType(ProgressPhotoPoseEnum),
          ) as ProgressPhotoPoseEnum;
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
  ProgressPhoto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressPhotoBuilder();
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


class ProgressPhotoPoseEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'front')
  static const ProgressPhotoPoseEnum front = _$progressPhotoPoseEnum_front;
  @BuiltValueEnumConst(wireName: r'side')
  static const ProgressPhotoPoseEnum side = _$progressPhotoPoseEnum_side;
  @BuiltValueEnumConst(wireName: r'back')
  static const ProgressPhotoPoseEnum back = _$progressPhotoPoseEnum_back;

  static Serializer<ProgressPhotoPoseEnum> get serializer => _$progressPhotoPoseEnumSerializer;

  const ProgressPhotoPoseEnum._(String name): super(name);

  static BuiltSet<ProgressPhotoPoseEnum> get values => _$progressPhotoPoseEnumValues;
  static ProgressPhotoPoseEnum valueOf(String name) => _$progressPhotoPoseEnumValueOf(name);
}

