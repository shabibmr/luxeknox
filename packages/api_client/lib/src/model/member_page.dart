//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/member.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_page.g.dart';

/// MemberPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class MemberPage implements Built<MemberPage, MemberPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Member> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  MemberPage._();

  factory MemberPage([void updates(MemberPageBuilder b)]) = _$MemberPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberPage> get serializer => _$MemberPageSerializer();
}

class _$MemberPageSerializer implements PrimitiveSerializer<MemberPage> {
  @override
  final Iterable<Type> types = const [MemberPage, _$MemberPage];

  @override
  final String wireName = r'MemberPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Member)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(PageMeta),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MemberPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Member)]),
          ) as BuiltList<Member>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageMeta),
          ) as PageMeta;
          result.meta.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemberPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberPageBuilder();
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


