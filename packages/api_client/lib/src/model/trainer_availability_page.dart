//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/trainer_availability.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trainer_availability_page.g.dart';

/// TrainerAvailabilityPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class TrainerAvailabilityPage implements Built<TrainerAvailabilityPage, TrainerAvailabilityPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<TrainerAvailability> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  TrainerAvailabilityPage._();

  factory TrainerAvailabilityPage([void updates(TrainerAvailabilityPageBuilder b)]) = _$TrainerAvailabilityPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrainerAvailabilityPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrainerAvailabilityPage> get serializer => _$TrainerAvailabilityPageSerializer();
}

class _$TrainerAvailabilityPageSerializer implements PrimitiveSerializer<TrainerAvailabilityPage> {
  @override
  final Iterable<Type> types = const [TrainerAvailabilityPage, _$TrainerAvailabilityPage];

  @override
  final String wireName = r'TrainerAvailabilityPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrainerAvailabilityPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(TrainerAvailability)]),
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
    TrainerAvailabilityPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TrainerAvailabilityPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TrainerAvailability)]),
          ) as BuiltList<TrainerAvailability>;
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
  TrainerAvailabilityPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrainerAvailabilityPageBuilder();
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


