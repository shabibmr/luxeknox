//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_extension.g.dart';

/// MembershipExtension
///
/// Properties:
/// * [id] 
/// * [membershipId] 
/// * [daysExtended] 
/// * [reason] 
/// * [grantedByUserId] 
/// * [createdAt] - UTC ISO-8601
@BuiltValue()
abstract class MembershipExtension implements Built<MembershipExtension, MembershipExtensionBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'membership_id')
  int get membershipId;

  @BuiltValueField(wireName: r'days_extended')
  int get daysExtended;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'granted_by_user_id')
  int? get grantedByUserId;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  MembershipExtension._();

  factory MembershipExtension([void updates(MembershipExtensionBuilder b)]) = _$MembershipExtension;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipExtensionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipExtension> get serializer => _$MembershipExtensionSerializer();
}

class _$MembershipExtensionSerializer implements PrimitiveSerializer<MembershipExtension> {
  @override
  final Iterable<Type> types = const [MembershipExtension, _$MembershipExtension];

  @override
  final String wireName = r'MembershipExtension';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipExtension object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'membership_id';
    yield serializers.serialize(
      object.membershipId,
      specifiedType: const FullType(int),
    );
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
    if (object.grantedByUserId != null) {
      yield r'granted_by_user_id';
      yield serializers.serialize(
        object.grantedByUserId,
        specifiedType: const FullType(int),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MembershipExtension object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipExtensionBuilder result,
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
        case r'membership_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.membershipId = valueDes;
          break;
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
        case r'granted_by_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.grantedByUserId = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MembershipExtension deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipExtensionBuilder();
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


