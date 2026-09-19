//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/schedule_history.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'schedule_history_page.g.dart';

/// ScheduleHistoryPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class ScheduleHistoryPage implements Built<ScheduleHistoryPage, ScheduleHistoryPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<ScheduleHistory> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  ScheduleHistoryPage._();

  factory ScheduleHistoryPage([void updates(ScheduleHistoryPageBuilder b)]) = _$ScheduleHistoryPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduleHistoryPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScheduleHistoryPage> get serializer => _$ScheduleHistoryPageSerializer();
}

class _$ScheduleHistoryPageSerializer implements PrimitiveSerializer<ScheduleHistoryPage> {
  @override
  final Iterable<Type> types = const [ScheduleHistoryPage, _$ScheduleHistoryPage];

  @override
  final String wireName = r'ScheduleHistoryPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScheduleHistoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(ScheduleHistory)]),
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
    ScheduleHistoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScheduleHistoryPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ScheduleHistory)]),
          ) as BuiltList<ScheduleHistory>;
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
  ScheduleHistoryPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduleHistoryPageBuilder();
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


