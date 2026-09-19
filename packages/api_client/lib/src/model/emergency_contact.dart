//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'emergency_contact.g.dart';

/// EmergencyContact
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [contactName] 
/// * [relationship] 
/// * [phonePrimary] 
/// * [phoneSecondary] 
/// * [isPrimary] 
@BuiltValue()
abstract class EmergencyContact implements Built<EmergencyContact, EmergencyContactBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'user_id')
  int get userId;

  @BuiltValueField(wireName: r'contact_name')
  String get contactName;

  @BuiltValueField(wireName: r'relationship')
  String? get relationship;

  @BuiltValueField(wireName: r'phone_primary')
  String get phonePrimary;

  @BuiltValueField(wireName: r'phone_secondary')
  String? get phoneSecondary;

  @BuiltValueField(wireName: r'is_primary')
  bool get isPrimary;

  EmergencyContact._();

  factory EmergencyContact([void updates(EmergencyContactBuilder b)]) = _$EmergencyContact;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmergencyContactBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmergencyContact> get serializer => _$EmergencyContactSerializer();
}

class _$EmergencyContactSerializer implements PrimitiveSerializer<EmergencyContact> {
  @override
  final Iterable<Type> types = const [EmergencyContact, _$EmergencyContact];

  @override
  final String wireName = r'EmergencyContact';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmergencyContact object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(int),
    );
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
    yield r'is_primary';
    yield serializers.serialize(
      object.isPrimary,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmergencyContact object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmergencyContactBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userId = valueDes;
          break;
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
            specifiedType: const FullType(bool),
          ) as bool;
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
  EmergencyContact deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmergencyContactBuilder();
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


