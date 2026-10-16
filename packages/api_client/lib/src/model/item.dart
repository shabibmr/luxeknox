//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/item_kind.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'item.g.dart';

/// Item
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [sku] 
/// * [hsnSac] 
/// * [itemKind] 
/// * [categoryId] 
/// * [uomId] 
/// * [saleRate] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [purchaseRate] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [reorderLevel] - DECIMAL(14,3) quantity as a three-decimal string. Never a JSON number.
/// * [inventoryTracked] 
/// * [incomeAccountId] 
/// * [expenseAccountId] 
/// * [inventoryAccountId] 
/// * [cogsAccountId] 
/// * [taxCodeId] 
/// * [isActive] 
/// * [rowVersion] 
/// * [createdAt] - UTC ISO-8601
/// * [updatedAt] 
@BuiltValue()
abstract class Item implements Built<Item, ItemBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'sku')
  String? get sku;

  @BuiltValueField(wireName: r'hsn_sac')
  String? get hsnSac;

  @BuiltValueField(wireName: r'item_kind')
  ItemKind get itemKind;
  // enum itemKindEnum {  service,  goods,  };

  @BuiltValueField(wireName: r'category_id')
  int? get categoryId;

  @BuiltValueField(wireName: r'uom_id')
  int get uomId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'sale_rate')
  String? get saleRate;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'purchase_rate')
  String? get purchaseRate;

  /// DECIMAL(14,3) quantity as a three-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'reorder_level')
  String? get reorderLevel;

  @BuiltValueField(wireName: r'inventory_tracked')
  bool get inventoryTracked;

  @BuiltValueField(wireName: r'income_account_id')
  int get incomeAccountId;

  @BuiltValueField(wireName: r'expense_account_id')
  int get expenseAccountId;

  @BuiltValueField(wireName: r'inventory_account_id')
  int? get inventoryAccountId;

  @BuiltValueField(wireName: r'cogs_account_id')
  int? get cogsAccountId;

  @BuiltValueField(wireName: r'tax_code_id')
  int? get taxCodeId;

  @BuiltValueField(wireName: r'is_active')
  bool get isActive;

  @BuiltValueField(wireName: r'row_version')
  int get rowVersion;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  Item._();

  factory Item([void updates(ItemBuilder b)]) = _$Item;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Item> get serializer => _$ItemSerializer();
}

class _$ItemSerializer implements PrimitiveSerializer<Item> {
  @override
  final Iterable<Type> types = const [Item, _$Item];

  @override
  final String wireName = r'Item';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Item object, {
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
    yield r'item_kind';
    yield serializers.serialize(
      object.itemKind,
      specifiedType: const FullType(ItemKind),
    );
    if (object.categoryId != null) {
      yield r'category_id';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType(int),
      );
    }
    yield r'uom_id';
    yield serializers.serialize(
      object.uomId,
      specifiedType: const FullType(int),
    );
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
    yield r'inventory_tracked';
    yield serializers.serialize(
      object.inventoryTracked,
      specifiedType: const FullType(bool),
    );
    yield r'income_account_id';
    yield serializers.serialize(
      object.incomeAccountId,
      specifiedType: const FullType(int),
    );
    yield r'expense_account_id';
    yield serializers.serialize(
      object.expenseAccountId,
      specifiedType: const FullType(int),
    );
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
    if (object.taxCodeId != null) {
      yield r'tax_code_id';
      yield serializers.serialize(
        object.taxCodeId,
        specifiedType: const FullType(int),
      );
    }
    yield r'is_active';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
    yield r'row_version';
    yield serializers.serialize(
      object.rowVersion,
      specifiedType: const FullType(int),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Item object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ItemBuilder result,
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
        case r'item_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ItemKind),
          ) as ItemKind;
          result.itemKind = valueDes;
          break;
        case r'category_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.categoryId = valueDes;
          break;
        case r'uom_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.uomId = valueDes;
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
        case r'inventory_tracked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.inventoryTracked = valueDes;
          break;
        case r'income_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.incomeAccountId = valueDes;
          break;
        case r'expense_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expenseAccountId = valueDes;
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
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rowVersion = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Item deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ItemBuilder();
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


