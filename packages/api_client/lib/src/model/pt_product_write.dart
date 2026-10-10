//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_product_write.g.dart';

/// PtProductWrite
///
/// Properties:
/// * [name] 
/// * [code] 
/// * [description] 
/// * [durationDays] 
/// * [basePrice] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [taxPercentage] 
/// * [isActive] 
@BuiltValue()
abstract class PtProductWrite implements Built<PtProductWrite, PtProductWriteBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'duration_days')
  int get durationDays;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'base_price')
  String get basePrice;

  @BuiltValueField(wireName: r'tax_percentage')
  String? get taxPercentage;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  PtProductWrite._();

  factory PtProductWrite([void updates(PtProductWriteBuilder b)]) = _$PtProductWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtProductWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtProductWrite> get serializer => _$PtProductWriteSerializer();
}

class _$PtProductWriteSerializer implements PrimitiveSerializer<PtProductWrite> {
  @override
  final Iterable<Type> types = const [PtProductWrite, _$PtProductWrite];

  @override
  final String wireName = r'PtProductWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtProductWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    yield r'duration_days';
    yield serializers.serialize(
      object.durationDays,
      specifiedType: const FullType(int),
    );
    yield r'base_price';
    yield serializers.serialize(
      object.basePrice,
      specifiedType: const FullType(String),
    );
    if (object.taxPercentage != null) {
      yield r'tax_percentage';
      yield serializers.serialize(
        object.taxPercentage,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PtProductWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtProductWriteBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'duration_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationDays = valueDes;
          break;
        case r'base_price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.basePrice = valueDes;
          break;
        case r'tax_percentage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.taxPercentage = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActive = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PtProductWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtProductWriteBuilder();
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


