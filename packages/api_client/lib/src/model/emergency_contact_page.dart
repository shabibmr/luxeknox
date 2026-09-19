//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/emergency_contact.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'emergency_contact_page.g.dart';

/// EmergencyContactPage
///
/// Properties:
/// * [data] 
/// * [meta] 
@BuiltValue()
abstract class EmergencyContactPage implements Built<EmergencyContactPage, EmergencyContactPageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<EmergencyContact> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  EmergencyContactPage._();

  factory EmergencyContactPage([void updates(EmergencyContactPageBuilder b)]) = _$EmergencyContactPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmergencyContactPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmergencyContactPage> get serializer => _$EmergencyContactPageSerializer();
}

class _$EmergencyContactPageSerializer implements PrimitiveSerializer<EmergencyContactPage> {
  @override
  final Iterable<Type> types = const [EmergencyContactPage, _$EmergencyContactPage];

  @override
  final String wireName = r'EmergencyContactPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmergencyContactPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(EmergencyContact)]),
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
    EmergencyContactPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmergencyContactPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EmergencyContact)]),
          ) as BuiltList<EmergencyContact>;
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
  EmergencyContactPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmergencyContactPageBuilder();
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


