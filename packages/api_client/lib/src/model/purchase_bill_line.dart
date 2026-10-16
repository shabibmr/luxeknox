//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'purchase_bill_line.g.dart';

/// PurchaseBillLine
///
/// Properties:
/// * [id] 
/// * [purchaseBillId] 
/// * [itemId] 
/// * [itemName] 
/// * [uomCode] 
/// * [inventoryTracked] 
/// * [returnedQuantity] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [accountId] 
/// * [description] 
/// * [quantity] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [rate] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [taxCodeId] 
/// * [netAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [taxAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class PurchaseBillLine implements Built<PurchaseBillLine, PurchaseBillLineBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'purchase_bill_id')
  int get purchaseBillId;

  @BuiltValueField(wireName: r'item_id')
  int? get itemId;

  @BuiltValueField(wireName: r'item_name')
  String get itemName;

  @BuiltValueField(wireName: r'uom_code')
  String get uomCode;

  @BuiltValueField(wireName: r'inventory_tracked')
  bool get inventoryTracked;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'returned_quantity')
  String get returnedQuantity;

  @BuiltValueField(wireName: r'account_id')
  int get accountId;

  @BuiltValueField(wireName: r'description')
  String? get description;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'quantity')
  String get quantity;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'rate')
  String get rate;

  @BuiltValueField(wireName: r'tax_code_id')
  int? get taxCodeId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'net_amount')
  String get netAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'tax_amount')
  String get taxAmount;

  PurchaseBillLine._();

  factory PurchaseBillLine([void updates(PurchaseBillLineBuilder b)]) = _$PurchaseBillLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PurchaseBillLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PurchaseBillLine> get serializer => _$PurchaseBillLineSerializer();
}

class _$PurchaseBillLineSerializer implements PrimitiveSerializer<PurchaseBillLine> {
  @override
  final Iterable<Type> types = const [PurchaseBillLine, _$PurchaseBillLine];

  @override
  final String wireName = r'PurchaseBillLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PurchaseBillLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'purchase_bill_id';
    yield serializers.serialize(
      object.purchaseBillId,
      specifiedType: const FullType(int),
    );
    if (object.itemId != null) {
      yield r'item_id';
      yield serializers.serialize(
        object.itemId,
        specifiedType: const FullType(int),
      );
    }
    yield r'item_name';
    yield serializers.serialize(
      object.itemName,
      specifiedType: const FullType(String),
    );
    yield r'uom_code';
    yield serializers.serialize(
      object.uomCode,
      specifiedType: const FullType(String),
    );
    yield r'inventory_tracked';
    yield serializers.serialize(
      object.inventoryTracked,
      specifiedType: const FullType(bool),
    );
    yield r'returned_quantity';
    yield serializers.serialize(
      object.returnedQuantity,
      specifiedType: const FullType(String),
    );
    yield r'account_id';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(int),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(String),
    );
    yield r'rate';
    yield serializers.serialize(
      object.rate,
      specifiedType: const FullType(String),
    );
    if (object.taxCodeId != null) {
      yield r'tax_code_id';
      yield serializers.serialize(
        object.taxCodeId,
        specifiedType: const FullType(int),
      );
    }
    yield r'net_amount';
    yield serializers.serialize(
      object.netAmount,
      specifiedType: const FullType(String),
    );
    yield r'tax_amount';
    yield serializers.serialize(
      object.taxAmount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PurchaseBillLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PurchaseBillLineBuilder result,
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
        case r'purchase_bill_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.purchaseBillId = valueDes;
          break;
        case r'item_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.itemId = valueDes;
          break;
        case r'item_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.itemName = valueDes;
          break;
        case r'uom_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uomCode = valueDes;
          break;
        case r'inventory_tracked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.inventoryTracked = valueDes;
          break;
        case r'returned_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.returnedQuantity = valueDes;
          break;
        case r'account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.accountId = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantity = valueDes;
          break;
        case r'rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rate = valueDes;
          break;
        case r'tax_code_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.taxCodeId = valueDes;
          break;
        case r'net_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.netAmount = valueDes;
          break;
        case r'tax_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taxAmount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PurchaseBillLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PurchaseBillLineBuilder();
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


