//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_product.g.dart';

/// PtProduct
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [code] 
/// * [description] 
/// * [durationDays] 
/// * [sessionsPerWeek] 
/// * [basePrice] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [taxPercentage] 
/// * [isActive] 
@BuiltValue()
abstract class PtProduct implements Built<PtProduct, PtProductBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'duration_days')
  int get durationDays;

  @BuiltValueField(wireName: r'sessions_per_week')
  int get sessionsPerWeek;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'base_price')
  String get basePrice;

  @BuiltValueField(wireName: r'tax_percentage')
  String? get taxPercentage;

  @BuiltValueField(wireName: r'is_active')
  bool get isActive;

  PtProduct._();

  factory PtProduct([void updates(PtProductBuilder b)]) = _$PtProduct;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtProductBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtProduct> get serializer => _$PtProductSerializer();
}

class _$PtProductSerializer implements PrimitiveSerializer<PtProduct> {
  @override
  final Iterable<Type> types = const [PtProduct, _$PtProduct];

  @override
  final String wireName = r'PtProduct';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
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
    yield r'sessions_per_week';
    yield serializers.serialize(
      object.sessionsPerWeek,
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
    yield r'is_active';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PtProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtProductBuilder result,
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
        case r'sessions_per_week':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sessionsPerWeek = valueDes;
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
            specifiedType: const FullType(bool),
          ) as bool;
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
  PtProduct deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtProductBuilder();
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


