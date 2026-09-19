//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/trainer.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trainer_page.g.dart';

/// TrainerPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class TrainerPage implements Built<TrainerPage, TrainerPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Trainer> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  TrainerPage._();

  factory TrainerPage([void updates(TrainerPageBuilder b)]) = _$TrainerPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainerPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrainerPage> get serializer => _$TrainerPageSerializer();
}

class _$TrainerPageSerializer implements PrimitiveSerializer<TrainerPage> {
  @override
  final Iterable<Type> types = const [TrainerPage, _$TrainerPage];

  @override
  final String wireName = r'TrainerPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrainerPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Trainer)]),
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
    TrainerPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TrainerPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Trainer)]),
          ) as BuiltList<Trainer>;
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
  TrainerPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainerPageBuilder();
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


