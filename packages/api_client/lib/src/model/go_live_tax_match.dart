//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'go_live_tax_match.g.dart';

/// GoLiveTaxMatch
///
/// Properties:
/// * [gymTaxRate] 
/// * [defaultTaxCode] 
/// * [defaultTaxRate] 
/// * [matched] 
@BuiltValue()
abstract class GoLiveTaxMatch implements Built<GoLiveTaxMatch, GoLiveTaxMatchBuilder> {
  @BuiltValueField(wireName: r'gym_tax_rate')
  String get gymTaxRate;

  @BuiltValueField(wireName: r'default_tax_code')
  String get defaultTaxCode;

  @BuiltValueField(wireName: r'default_tax_rate')
  String get defaultTaxRate;

  @BuiltValueField(wireName: r'matched')
  bool get matched;

  GoLiveTaxMatch._();

  factory GoLiveTaxMatch([void updates(GoLiveTaxMatchBuilder b)]) = _$GoLiveTaxMatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoLiveTaxMatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoLiveTaxMatch> get serializer => _$GoLiveTaxMatchSerializer();
}

class _$GoLiveTaxMatchSerializer implements PrimitiveSerializer<GoLiveTaxMatch> {
  @override
  final Iterable<Type> types = const [GoLiveTaxMatch, _$GoLiveTaxMatch];

  @override
  final String wireName = r'GoLiveTaxMatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoLiveTaxMatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'gym_tax_rate';
    yield serializers.serialize(
      object.gymTaxRate,
      specifiedType: const FullType(String),
    );
    yield r'default_tax_code';
    yield serializers.serialize(
      object.defaultTaxCode,
      specifiedType: const FullType(String),
    );
    yield r'default_tax_rate';
    yield serializers.serialize(
      object.defaultTaxRate,
      specifiedType: const FullType(String),
    );
    yield r'matched';
    yield serializers.serialize(
      object.matched,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GoLiveTaxMatch object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoLiveTaxMatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'gym_tax_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.gymTaxRate = valueDes;
          break;
        case r'default_tax_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.defaultTaxCode = valueDes;
          break;
        case r'default_tax_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.defaultTaxRate = valueDes;
          break;
        case r'matched':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.matched = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoLiveTaxMatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoLiveTaxMatchBuilder();
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


