//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_freeze_write.g.dart';

/// MembershipFreezeWrite
///
/// Properties:
/// * [startDate] 
/// * [endDate] 
/// * [reason] 
@BuiltValue()
abstract class MembershipFreezeWrite implements Built<MembershipFreezeWrite, MembershipFreezeWriteBuilder> {
  @BuiltValueField(wireName: r'start_date')
  Date get startDate;

  @BuiltValueField(wireName: r'end_date')
  Date get endDate;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  MembershipFreezeWrite._();

  factory MembershipFreezeWrite([void updates(MembershipFreezeWriteBuilder b)]) = _$MembershipFreezeWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipFreezeWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipFreezeWrite> get serializer => _$MembershipFreezeWriteSerializer();
}

class _$MembershipFreezeWriteSerializer implements PrimitiveSerializer<MembershipFreezeWrite> {
  @override
  final Iterable<Type> types = const [MembershipFreezeWrite, _$MembershipFreezeWrite];

  @override
  final String wireName = r'MembershipFreezeWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipFreezeWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'start_date';
    yield serializers.serialize(
      object.startDate,
      specifiedType: const FullType(Date),
    );
    yield r'end_date';
    yield serializers.serialize(
      object.endDate,
      specifiedType: const FullType(Date),
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
    MembershipFreezeWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipFreezeWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'start_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.startDate = valueDes;
          break;
        case r'end_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.endDate = valueDes;
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
  MembershipFreezeWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipFreezeWriteBuilder();
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


