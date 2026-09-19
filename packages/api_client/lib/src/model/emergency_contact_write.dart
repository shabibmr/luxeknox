//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'emergency_contact_write.g.dart';

/// EmergencyContactWrite
///
/// Properties:
/// * [contactName] 
/// * [relationship] 
/// * [phonePrimary] 
/// * [phoneSecondary] 
/// * [isPrimary] 
@BuiltValue()
abstract class EmergencyContactWrite implements Built<EmergencyContactWrite, EmergencyContactWriteBuilder> {
  @BuiltValueField(wireName: r'contact_name')
  String get contactName;

  @BuiltValueField(wireName: r'relationship')
  String? get relationship;

  @BuiltValueField(wireName: r'phone_primary')
  String get phonePrimary;

  @BuiltValueField(wireName: r'phone_secondary')
  String? get phoneSecondary;

  @BuiltValueField(wireName: r'is_primary')
  bool? get isPrimary;

  EmergencyContactWrite._();

  factory EmergencyContactWrite([void updates(EmergencyContactWriteBuilder b)]) = _$EmergencyContactWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmergencyContactWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmergencyContactWrite> get serializer => _$EmergencyContactWriteSerializer();
}

class _$EmergencyContactWriteSerializer implements PrimitiveSerializer<EmergencyContactWrite> {
  @override
  final Iterable<Type> types = const [EmergencyContactWrite, _$EmergencyContactWrite];

  @override
  final String wireName = r'EmergencyContactWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmergencyContactWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contact_name';
    yield serializers.serialize(
      object.contactName,
      specifiedType: const FullType(String),
    );
    if (object.relationship != null) {
      yield r'relationship';
      yield serializers.serialize(
        object.relationship,
        specifiedType: const FullType(String),
      );
    }
    yield r'phone_primary';
    yield serializers.serialize(
      object.phonePrimary,
      specifiedType: const FullType(String),
    );
    if (object.phoneSecondary != null) {
      yield r'phone_secondary';
      yield serializers.serialize(
        object.phoneSecondary,
        specifiedType: const FullType(String),
      );
    }
    if (object.isPrimary != null) {
      yield r'is_primary';
      yield serializers.serialize(
        object.isPrimary,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EmergencyContactWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmergencyContactWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contact_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactName = valueDes;
          break;
        case r'relationship':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.relationship = valueDes;
          break;
        case r'phone_primary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phonePrimary = valueDes;
          break;
        case r'phone_secondary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phoneSecondary = valueDes;
          break;
        case r'is_primary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isPrimary = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmergencyContactWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmergencyContactWriteBuilder();
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


