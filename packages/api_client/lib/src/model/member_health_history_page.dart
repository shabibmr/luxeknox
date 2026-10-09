//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/member_health_record.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_health_history_page.g.dart';

/// MemberHealthHistoryPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class MemberHealthHistoryPage implements Built<MemberHealthHistoryPage, MemberHealthHistoryPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<MemberHealthRecord> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  MemberHealthHistoryPage._();

  factory MemberHealthHistoryPage([void updates(MemberHealthHistoryPageBuilder b)]) = _$MemberHealthHistoryPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberHealthHistoryPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberHealthHistoryPage> get serializer => _$MemberHealthHistoryPageSerializer();
}

class _$MemberHealthHistoryPageSerializer implements PrimitiveSerializer<MemberHealthHistoryPage> {
  @override
  final Iterable<Type> types = const [MemberHealthHistoryPage, _$MemberHealthHistoryPage];

  @override
  final String wireName = r'MemberHealthHistoryPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberHealthHistoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(MemberHealthRecord)]),
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
    MemberHealthHistoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberHealthHistoryPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MemberHealthRecord)]),
          ) as BuiltList<MemberHealthRecord>;
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
  MemberHealthHistoryPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberHealthHistoryPageBuilder();
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


