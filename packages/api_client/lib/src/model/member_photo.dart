//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_photo.g.dart';

/// MemberPhoto
///
/// Properties:
/// * [id] 
/// * [memberId] 
/// * [photoUrl] 
/// * [isCurrentAvatar] 
/// * [capturedAt] - UTC ISO-8601
@BuiltValue()
abstract class MemberPhoto implements Built<MemberPhoto, MemberPhotoBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'photo_url')
  String get photoUrl;

  @BuiltValueField(wireName: r'is_current_avatar')
  bool? get isCurrentAvatar;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'captured_at')
  DateTime? get capturedAt;

  MemberPhoto._();

  factory MemberPhoto([void updates(MemberPhotoBuilder b)]) = _$MemberPhoto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberPhotoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberPhoto> get serializer => _$MemberPhotoSerializer();
}

class _$MemberPhotoSerializer implements PrimitiveSerializer<MemberPhoto> {
  @override
  final Iterable<Type> types = const [MemberPhoto, _$MemberPhoto];

  @override
  final String wireName = r'MemberPhoto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberPhoto object, {
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
    if (object.isCurrentAvatar != null) {
      yield r'is_current_avatar';
      yield serializers.serialize(
        object.isCurrentAvatar,
        specifiedType: const FullType(bool),
      );
    }
    if (object.capturedAt != null) {
      yield r'captured_at';
      yield serializers.serialize(
        object.capturedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MemberPhoto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberPhotoBuilder result,
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
        case r'is_current_avatar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isCurrentAvatar = valueDes;
          break;
        case r'captured_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.capturedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemberPhoto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberPhotoBuilder();
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


