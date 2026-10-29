//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'lifestyle_priority.g.dart';

/// LifestylePriority
///
/// Properties:
/// * [priority] 
/// * [currentStatus] 
/// * [firstAction] 
@BuiltValue()
abstract class LifestylePriority implements Built<LifestylePriority, LifestylePriorityBuilder> {
  @BuiltValueField(wireName: r'priority')
  LifestylePriorityPriorityEnum get priority;
  // enum priorityEnum {  sleep,  nutrition,  activity,  recovery,  };

  @BuiltValueField(wireName: r'current_status')
  String get currentStatus;

  @BuiltValueField(wireName: r'first_action')
  String get firstAction;

  LifestylePriority._();

  factory LifestylePriority([void updates(LifestylePriorityBuilder b)]) = _$LifestylePriority;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LifestylePriorityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LifestylePriority> get serializer => _$LifestylePrioritySerializer();
}

class _$LifestylePrioritySerializer implements PrimitiveSerializer<LifestylePriority> {
  @override
  final Iterable<Type> types = const [LifestylePriority, _$LifestylePriority];

  @override
  final String wireName = r'LifestylePriority';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LifestylePriority object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'priority';
    yield serializers.serialize(
      object.priority,
      specifiedType: const FullType(LifestylePriorityPriorityEnum),
    );
    yield r'current_status';
    yield serializers.serialize(
      object.currentStatus,
      specifiedType: const FullType(String),
    );
    yield r'first_action';
    yield serializers.serialize(
      object.firstAction,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LifestylePriority object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LifestylePriorityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'priority':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LifestylePriorityPriorityEnum),
          ) as LifestylePriorityPriorityEnum;
          result.priority = valueDes;
          break;
        case r'current_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currentStatus = valueDes;
          break;
        case r'first_action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstAction = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LifestylePriority deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LifestylePriorityBuilder();
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


class LifestylePriorityPriorityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'sleep')
  static const LifestylePriorityPriorityEnum sleep = _$lifestylePriorityPriorityEnum_sleep;
  @BuiltValueEnumConst(wireName: r'nutrition')
  static const LifestylePriorityPriorityEnum nutrition = _$lifestylePriorityPriorityEnum_nutrition;
  @BuiltValueEnumConst(wireName: r'activity')
  static const LifestylePriorityPriorityEnum activity = _$lifestylePriorityPriorityEnum_activity;
  @BuiltValueEnumConst(wireName: r'recovery')
  static const LifestylePriorityPriorityEnum recovery = _$lifestylePriorityPriorityEnum_recovery;

  static Serializer<LifestylePriorityPriorityEnum> get serializer => _$lifestylePriorityPriorityEnumSerializer;

  const LifestylePriorityPriorityEnum._(String name): super(name);

  static BuiltSet<LifestylePriorityPriorityEnum> get values => _$lifestylePriorityPriorityEnumValues;
  static LifestylePriorityPriorityEnum valueOf(String name) => _$lifestylePriorityPriorityEnumValueOf(name);
}

