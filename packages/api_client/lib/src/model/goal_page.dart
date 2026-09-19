//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/goal.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'goal_page.g.dart';

/// GoalPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class GoalPage implements Built<GoalPage, GoalPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Goal> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  GoalPage._();

  factory GoalPage([void updates(GoalPageBuilder b)]) = _$GoalPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoalPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoalPage> get serializer => _$GoalPageSerializer();
}

class _$GoalPageSerializer implements PrimitiveSerializer<GoalPage> {
  @override
  final Iterable<Type> types = const [GoalPage, _$GoalPage];

  @override
  final String wireName = r'GoalPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoalPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Goal)]),
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
    GoalPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoalPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Goal)]),
          ) as BuiltList<Goal>;
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
  GoalPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoalPageBuilder();
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


