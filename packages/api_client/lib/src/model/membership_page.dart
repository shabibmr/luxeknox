//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/membership.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_page.g.dart';

/// MembershipPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class MembershipPage implements Built<MembershipPage, MembershipPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Membership> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  MembershipPage._();

  factory MembershipPage([void updates(MembershipPageBuilder b)]) = _$MembershipPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipPage> get serializer => _$MembershipPageSerializer();
}

class _$MembershipPageSerializer implements PrimitiveSerializer<MembershipPage> {
  @override
  final Iterable<Type> types = const [MembershipPage, _$MembershipPage];

  @override
  final String wireName = r'MembershipPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Membership)]),
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
    MembershipPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Membership)]),
          ) as BuiltList<Membership>;
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
  MembershipPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipPageBuilder();
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


