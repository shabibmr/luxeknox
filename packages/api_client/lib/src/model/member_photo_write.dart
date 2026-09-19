//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_photo_write.g.dart';

/// MemberPhotoWrite
///
/// Properties:
/// * [photoUrl] 
@BuiltValue()
abstract class MemberPhotoWrite implements Built<MemberPhotoWrite, MemberPhotoWriteBuilder> {
  @BuiltValueField(wireName: r'photo_url')
  String get photoUrl;

  MemberPhotoWrite._();

  factory MemberPhotoWrite([void updates(MemberPhotoWriteBuilder b)]) = _$MemberPhotoWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberPhotoWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberPhotoWrite> get serializer => _$MemberPhotoWriteSerializer();
}

class _$MemberPhotoWriteSerializer implements PrimitiveSerializer<MemberPhotoWrite> {
  @override
  final Iterable<Type> types = const [MemberPhotoWrite, _$MemberPhotoWrite];

  @override
  final String wireName = r'MemberPhotoWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberPhotoWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'photo_url';
    yield serializers.serialize(
      object.photoUrl,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MemberPhotoWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberPhotoWriteBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemberPhotoWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberPhotoWriteBuilder();
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


