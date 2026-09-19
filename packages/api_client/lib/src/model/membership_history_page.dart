//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/membership_history.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_history_page.g.dart';

/// MembershipHistoryPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class MembershipHistoryPage implements Built<MembershipHistoryPage, MembershipHistoryPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<MembershipHistory> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  MembershipHistoryPage._();

  factory MembershipHistoryPage([void updates(MembershipHistoryPageBuilder b)]) = _$MembershipHistoryPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipHistoryPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipHistoryPage> get serializer => _$MembershipHistoryPageSerializer();
}

class _$MembershipHistoryPageSerializer implements PrimitiveSerializer<MembershipHistoryPage> {
  @override
  final Iterable<Type> types = const [MembershipHistoryPage, _$MembershipHistoryPage];

  @override
  final String wireName = r'MembershipHistoryPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipHistoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(MembershipHistory)]),
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
    MembershipHistoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipHistoryPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MembershipHistory)]),
          ) as BuiltList<MembershipHistory>;
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
  MembershipHistoryPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipHistoryPageBuilder();
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


