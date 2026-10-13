//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_code_component.g.dart';

/// TaxCodeComponent
///
/// Properties:
/// * [id] 
/// * [taxCodeId] 
/// * [name] 
/// * [ratePercent] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [outputAccountId] 
/// * [inputAccountId] 
@BuiltValue()
abstract class TaxCodeComponent implements Built<TaxCodeComponent, TaxCodeComponentBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'tax_code_id')
  int get taxCodeId;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'rate_percent')
  String get ratePercent;

  @BuiltValueField(wireName: r'output_account_id')
  int get outputAccountId;

  @BuiltValueField(wireName: r'input_account_id')
  int get inputAccountId;

  TaxCodeComponent._();

  factory TaxCodeComponent([void updates(TaxCodeComponentBuilder b)]) = _$TaxCodeComponent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaxCodeComponentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaxCodeComponent> get serializer => _$TaxCodeComponentSerializer();
}

class _$TaxCodeComponentSerializer implements PrimitiveSerializer<TaxCodeComponent> {
  @override
  final Iterable<Type> types = const [TaxCodeComponent, _$TaxCodeComponent];

  @override
  final String wireName = r'TaxCodeComponent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaxCodeComponent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'tax_code_id';
    yield serializers.serialize(
      object.taxCodeId,
      specifiedType: const FullType(int),
    );
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
    TaxCodeComponent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaxCodeComponentBuilder result,
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
        case r'tax_code_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.taxCodeId = valueDes;
          break;
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
  TaxCodeComponent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaxCodeComponentBuilder();
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


