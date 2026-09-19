//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ready.g.dart';

/// Ready
///
/// Properties:
/// * [status] 
/// * [database] 
@BuiltValue()
abstract class Ready implements Built<Ready, ReadyBuilder> {
  @BuiltValueField(wireName: r'status')
  ReadyStatusEnum get status;
  // enum statusEnum {  ok,  degraded,  };

  @BuiltValueField(wireName: r'database')
  ReadyDatabaseEnum get database;
  // enum databaseEnum {  up,  down,  };

  Ready._();

  factory Ready([void updates(ReadyBuilder b)]) = _$Ready;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReadyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Ready> get serializer => _$ReadySerializer();
}

class _$ReadySerializer implements PrimitiveSerializer<Ready> {
  @override
  final Iterable<Type> types = const [Ready, _$Ready];

  @override
  final String wireName = r'Ready';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Ready object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ReadyStatusEnum),
    );
    yield r'database';
    yield serializers.serialize(
      object.database,
      specifiedType: const FullType(ReadyDatabaseEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Ready object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReadyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReadyStatusEnum),
          ) as ReadyStatusEnum;
          result.status = valueDes;
          break;
        case r'database':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReadyDatabaseEnum),
          ) as ReadyDatabaseEnum;
          result.database = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Ready deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReadyBuilder();
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


class ReadyStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ok')
  static const ReadyStatusEnum ok = _$readyStatusEnum_ok;
  @BuiltValueEnumConst(wireName: r'degraded')
  static const ReadyStatusEnum degraded = _$readyStatusEnum_degraded;

  static Serializer<ReadyStatusEnum> get serializer => _$readyStatusEnumSerializer;

  const ReadyStatusEnum._(String name): super(name);

  static BuiltSet<ReadyStatusEnum> get values => _$readyStatusEnumValues;
  static ReadyStatusEnum valueOf(String name) => _$readyStatusEnumValueOf(name);
}

class ReadyDatabaseEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'up')
  static const ReadyDatabaseEnum up = _$readyDatabaseEnum_up;
  @BuiltValueEnumConst(wireName: r'down')
  static const ReadyDatabaseEnum down = _$readyDatabaseEnum_down;

  static Serializer<ReadyDatabaseEnum> get serializer => _$readyDatabaseEnumSerializer;

  const ReadyDatabaseEnum._(String name): super(name);

  static BuiltSet<ReadyDatabaseEnum> get values => _$readyDatabaseEnumValues;
  static ReadyDatabaseEnum valueOf(String name) => _$readyDatabaseEnumValueOf(name);
}

