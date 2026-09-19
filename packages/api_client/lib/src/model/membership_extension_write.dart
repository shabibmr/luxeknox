//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_extension_write.g.dart';

/// MembershipExtensionWrite
///
/// Properties:
/// * [daysExtended] 
/// * [reason] 
@BuiltValue()
abstract class MembershipExtensionWrite implements Built<MembershipExtensionWrite, MembershipExtensionWriteBuilder> {
  @BuiltValueField(wireName: r'days_extended')
  int get daysExtended;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  MembershipExtensionWrite._();

  factory MembershipExtensionWrite([void updates(MembershipExtensionWriteBuilder b)]) = _$MembershipExtensionWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipExtensionWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipExtensionWrite> get serializer => _$MembershipExtensionWriteSerializer();
}

class _$MembershipExtensionWriteSerializer implements PrimitiveSerializer<MembershipExtensionWrite> {
  @override
  final Iterable<Type> types = const [MembershipExtensionWrite, _$MembershipExtensionWrite];

  @override
  final String wireName = r'MembershipExtensionWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipExtensionWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'days_extended';
    yield serializers.serialize(
      object.daysExtended,
      specifiedType: const FullType(int),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MembershipExtensionWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipExtensionWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'days_extended':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.daysExtended = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MembershipExtensionWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipExtensionWriteBuilder();
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


