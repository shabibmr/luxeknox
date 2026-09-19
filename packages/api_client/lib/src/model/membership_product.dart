//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_product.g.dart';

/// MembershipProduct
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [code] 
/// * [description] 
/// * [durationDays] 
/// * [basePrice] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [taxPercentage] 
/// * [maxFreezeDays] 
/// * [ptSessionsIncluded] 
/// * [accessFacilities] 
/// * [isActive] 
@BuiltValue()
abstract class MembershipProduct implements Built<MembershipProduct, MembershipProductBuilder> {
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

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'base_price')
  String get basePrice;

  @BuiltValueField(wireName: r'tax_percentage')
  String? get taxPercentage;

  @BuiltValueField(wireName: r'max_freeze_days')
  int? get maxFreezeDays;

  @BuiltValueField(wireName: r'pt_sessions_included')
  int? get ptSessionsIncluded;

  @BuiltValueField(wireName: r'access_facilities')
  BuiltList<String>? get accessFacilities;

  @BuiltValueField(wireName: r'is_active')
  bool get isActive;

  MembershipProduct._();

  factory MembershipProduct([void updates(MembershipProductBuilder b)]) = _$MembershipProduct;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MembershipProductBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MembershipProduct> get serializer => _$MembershipProductSerializer();
}

class _$MembershipProductSerializer implements PrimitiveSerializer<MembershipProduct> {
  @override
  final Iterable<Type> types = const [MembershipProduct, _$MembershipProduct];

  @override
  final String wireName = r'MembershipProduct';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MembershipProduct object, {
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
    if (object.maxFreezeDays != null) {
      yield r'max_freeze_days';
      yield serializers.serialize(
        object.maxFreezeDays,
        specifiedType: const FullType(int),
      );
    }
    if (object.ptSessionsIncluded != null) {
      yield r'pt_sessions_included';
      yield serializers.serialize(
        object.ptSessionsIncluded,
        specifiedType: const FullType(int),
      );
    }
    if (object.accessFacilities != null) {
      yield r'access_facilities';
      yield serializers.serialize(
        object.accessFacilities,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    MembershipProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MembershipProductBuilder result,
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
        case r'max_freeze_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxFreezeDays = valueDes;
          break;
        case r'pt_sessions_included':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ptSessionsIncluded = valueDes;
          break;
        case r'access_facilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.accessFacilities.replace(valueDes);
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
  MembershipProduct deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MembershipProductBuilder();
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


