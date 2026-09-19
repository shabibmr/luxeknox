//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/measurement.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'measurement_page.g.dart';

/// MeasurementPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class MeasurementPage implements Built<MeasurementPage, MeasurementPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<Measurement> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  MeasurementPage._();

  factory MeasurementPage([void updates(MeasurementPageBuilder b)]) = _$MeasurementPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeasurementPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MeasurementPage> get serializer => _$MeasurementPageSerializer();
}

class _$MeasurementPageSerializer implements PrimitiveSerializer<MeasurementPage> {
  @override
  final Iterable<Type> types = const [MeasurementPage, _$MeasurementPage];

  @override
  final String wireName = r'MeasurementPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MeasurementPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(Measurement)]),
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
    MeasurementPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MeasurementPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Measurement)]),
          ) as BuiltList<Measurement>;
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
  MeasurementPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeasurementPageBuilder();
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


