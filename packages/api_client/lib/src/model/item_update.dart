//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'item_update.g.dart';

/// ItemUpdate
///
/// Properties:
/// * [name] 
/// * [uomId] 
/// * [incomeAccountId] 
/// * [expenseAccountId] 
/// * [sku] 
/// * [hsnSac] 
/// * [categoryId] 
/// * [saleRate] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [purchaseRate] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [reorderLevel] - DECIMAL(14,3) quantity as a three-decimal string. Never a JSON number.
/// * [taxCodeId] 
/// * [isActive] 
/// * [inventoryTracked] 
/// * [inventoryAccountId] 
/// * [cogsAccountId] 
@BuiltValue()
abstract class ItemUpdate implements Built<ItemUpdate, ItemUpdateBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'uom_id')
  int? get uomId;

  @BuiltValueField(wireName: r'income_account_id')
  int? get incomeAccountId;

  @BuiltValueField(wireName: r'expense_account_id')
  int? get expenseAccountId;

  @BuiltValueField(wireName: r'sku')
  String? get sku;

  @BuiltValueField(wireName: r'hsn_sac')
  String? get hsnSac;

  @BuiltValueField(wireName: r'category_id')
  int? get categoryId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'sale_rate')
  String? get saleRate;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'purchase_rate')
  String? get purchaseRate;

  /// DECIMAL(14,3) quantity as a three-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'reorder_level')
  String? get reorderLevel;

  @BuiltValueField(wireName: r'tax_code_id')
  int? get taxCodeId;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  @BuiltValueField(wireName: r'inventory_tracked')
  bool? get inventoryTracked;

  @BuiltValueField(wireName: r'inventory_account_id')
  int? get inventoryAccountId;

  @BuiltValueField(wireName: r'cogs_account_id')
  int? get cogsAccountId;

  ItemUpdate._();

  factory ItemUpdate([void updates(ItemUpdateBuilder b)]) = _$ItemUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ItemUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ItemUpdate> get serializer => _$ItemUpdateSerializer();
}

class _$ItemUpdateSerializer implements PrimitiveSerializer<ItemUpdate> {
  @override
  final Iterable<Type> types = const [ItemUpdate, _$ItemUpdate];

  @override
  final String wireName = r'ItemUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ItemUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.uomId != null) {
      yield r'uom_id';
      yield serializers.serialize(
        object.uomId,
        specifiedType: const FullType(int),
      );
    }
    if (object.incomeAccountId != null) {
      yield r'income_account_id';
      yield serializers.serialize(
        object.incomeAccountId,
        specifiedType: const FullType(int),
      );
    }
    if (object.expenseAccountId != null) {
      yield r'expense_account_id';
      yield serializers.serialize(
        object.expenseAccountId,
        specifiedType: const FullType(int),
      );
    }
    if (object.sku != null) {
      yield r'sku';
      yield serializers.serialize(
        object.sku,
        specifiedType: const FullType(String),
      );
    }
    if (object.hsnSac != null) {
      yield r'hsn_sac';
      yield serializers.serialize(
        object.hsnSac,
        specifiedType: const FullType(String),
      );
    }
    if (object.categoryId != null) {
      yield r'category_id';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType(int),
      );
    }
    if (object.saleRate != null) {
      yield r'sale_rate';
      yield serializers.serialize(
        object.saleRate,
        specifiedType: const FullType(String),
      );
    }
    if (object.purchaseRate != null) {
      yield r'purchase_rate';
      yield serializers.serialize(
        object.purchaseRate,
        specifiedType: const FullType(String),
      );
    }
    if (object.reorderLevel != null) {
      yield r'reorder_level';
      yield serializers.serialize(
        object.reorderLevel,
        specifiedType: const FullType(String),
      );
    }
    if (object.taxCodeId != null) {
      yield r'tax_code_id';
      yield serializers.serialize(
        object.taxCodeId,
        specifiedType: const FullType(int),
      );
    }
    if (object.isActive != null) {
      yield r'is_active';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
    if (object.inventoryTracked != null) {
      yield r'inventory_tracked';
      yield serializers.serialize(
        object.inventoryTracked,
        specifiedType: const FullType(bool),
      );
    }
    if (object.inventoryAccountId != null) {
      yield r'inventory_account_id';
      yield serializers.serialize(
        object.inventoryAccountId,
        specifiedType: const FullType(int),
      );
    }
    if (object.cogsAccountId != null) {
      yield r'cogs_account_id';
      yield serializers.serialize(
        object.cogsAccountId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ItemUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ItemUpdateBuilder result,
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
        case r'uom_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.uomId = valueDes;
          break;
        case r'income_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.incomeAccountId = valueDes;
          break;
        case r'expense_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.expenseAccountId = valueDes;
          break;
        case r'sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sku = valueDes;
          break;
        case r'hsn_sac':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.hsnSac = valueDes;
          break;
        case r'category_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.categoryId = valueDes;
          break;
        case r'sale_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.saleRate = valueDes;
          break;
        case r'purchase_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.purchaseRate = valueDes;
          break;
        case r'reorder_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reorderLevel = valueDes;
          break;
        case r'tax_code_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.taxCodeId = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActive = valueDes;
          break;
        case r'inventory_tracked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.inventoryTracked = valueDes;
          break;
        case r'inventory_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.inventoryAccountId = valueDes;
          break;
        case r'cogs_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.cogsAccountId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ItemUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ItemUpdateBuilder();
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


