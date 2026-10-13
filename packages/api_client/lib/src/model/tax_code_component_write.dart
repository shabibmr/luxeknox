//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_code_component_write.g.dart';

/// TaxCodeComponentWrite
///
/// Properties:
/// * [name] 
/// * [ratePercent] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [outputAccountId] 
/// * [inputAccountId] 
@BuiltValue()
abstract class TaxCodeComponentWrite implements Built<TaxCodeComponentWrite, TaxCodeComponentWriteBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'rate_percent')
  String get ratePercent;

  @BuiltValueField(wireName: r'output_account_id')
  int get outputAccountId;

  @BuiltValueField(wireName: r'input_account_id')
  int get inputAccountId;

  TaxCodeComponentWrite._();

  factory TaxCodeComponentWrite([void updates(TaxCodeComponentWriteBuilder b)]) = _$TaxCodeComponentWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaxCodeComponentWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaxCodeComponentWrite> get serializer => _$TaxCodeComponentWriteSerializer();
}

class _$TaxCodeComponentWriteSerializer implements PrimitiveSerializer<TaxCodeComponentWrite> {
  @override
  final Iterable<Type> types = const [TaxCodeComponentWrite, _$TaxCodeComponentWrite];

  @override
  final String wireName = r'TaxCodeComponentWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaxCodeComponentWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'rate_percent';
    yield serializers.serialize(
      object.ratePercent,
      specifiedType: const FullType(String),
    );
    yield r'output_account_id';
    yield serializers.serialize(
      object.outputAccountId,
      specifiedType: const FullType(int),
    );
    yield r'input_account_id';
    yield serializers.serialize(
      object.inputAccountId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TaxCodeComponentWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaxCodeComponentWriteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'rate_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ratePercent = valueDes;
          break;
        case r'output_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.outputAccountId = valueDes;
          break;
        case r'input_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.inputAccountId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TaxCodeComponentWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaxCodeComponentWriteBuilder();
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


