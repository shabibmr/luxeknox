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
/// * [incomeAccountId] 
/// * [expenseAccountId] 
/// * [taxCodeId] 
/// * [isActive] 
/// * [inventoryTracked] 
@BuiltValue()
abstract class ItemUpdate implements Built<ItemUpdate, ItemUpdateBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'income_account_id')
  int? get incomeAccountId;

  @BuiltValueField(wireName: r'expense_account_id')
  int? get expenseAccountId;

  @BuiltValueField(wireName: r'tax_code_id')
  int? get taxCodeId;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  @BuiltValueField(wireName: r'inventory_tracked')
  bool? get inventoryTracked;

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


