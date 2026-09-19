//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:api_client/src/model/medical_history.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'medical_history_page.g.dart';

/// MedicalHistoryPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class MedicalHistoryPage implements Built<MedicalHistoryPage, MedicalHistoryPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<MedicalHistory> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  MedicalHistoryPage._();

  factory MedicalHistoryPage([void updates(MedicalHistoryPageBuilder b)]) = _$MedicalHistoryPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MedicalHistoryPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MedicalHistoryPage> get serializer => _$MedicalHistoryPageSerializer();
}

class _$MedicalHistoryPageSerializer implements PrimitiveSerializer<MedicalHistoryPage> {
  @override
  final Iterable<Type> types = const [MedicalHistoryPage, _$MedicalHistoryPage];

  @override
  final String wireName = r'MedicalHistoryPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MedicalHistoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(MedicalHistory)]),
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
    MedicalHistoryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MedicalHistoryPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MedicalHistory)]),
          ) as BuiltList<MedicalHistory>;
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
  MedicalHistoryPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MedicalHistoryPageBuilder();
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


