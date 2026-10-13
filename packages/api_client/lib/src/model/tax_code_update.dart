//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/tax_code_component_write.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_code_update.g.dart';

/// TaxCodeUpdate
///
/// Properties:
/// * [name] 
/// * [ratePercent] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [isActive] 
/// * [components] 
@BuiltValue()
abstract class TaxCodeUpdate implements Built<TaxCodeUpdate, TaxCodeUpdateBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'rate_percent')
  String? get ratePercent;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  @BuiltValueField(wireName: r'components')
  BuiltList<TaxCodeComponentWrite>? get components;

  TaxCodeUpdate._();

  factory TaxCodeUpdate([void updates(TaxCodeUpdateBuilder b)]) = _$TaxCodeUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaxCodeUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaxCodeUpdate> get serializer => _$TaxCodeUpdateSerializer();
}

class _$TaxCodeUpdateSerializer implements PrimitiveSerializer<TaxCodeUpdate> {
  @override
  final Iterable<Type> types = const [TaxCodeUpdate, _$TaxCodeUpdate];

  @override
  final String wireName = r'TaxCodeUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaxCodeUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.ratePercent != null) {
      yield r'rate_percent';
      yield serializers.serialize(
        object.ratePercent,
        specifiedType: const FullType(String),
      );
    }
    if (object.isActive != null) {
      yield r'is_active';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
    if (object.components != null) {
      yield r'components';
      yield serializers.serialize(
        object.components,
        specifiedType: const FullType(BuiltList, [FullType(TaxCodeComponentWrite)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TaxCodeUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaxCodeUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'rate_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ratePercent = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActive = valueDes;
          break;
        case r'components':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(TaxCodeComponentWrite)]),
          ) as BuiltList<TaxCodeComponentWrite>?;
          if (valueDes == null) continue;
          result.components.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TaxCodeUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaxCodeUpdateBuilder();
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


