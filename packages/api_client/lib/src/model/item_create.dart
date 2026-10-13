//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/item_kind.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'item_create.g.dart';

/// ItemCreate
///
/// Properties:
/// * [name] 
/// * [itemKind] 
/// * [incomeAccountId] 
/// * [expenseAccountId] 
/// * [taxCodeId] 
/// * [isActive] 
/// * [inventoryTracked] 
@BuiltValue()
abstract class ItemCreate implements Built<ItemCreate, ItemCreateBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'item_kind')
  ItemKind get itemKind;
  // enum itemKindEnum {  service,  goods,  };

  @BuiltValueField(wireName: r'income_account_id')
  int get incomeAccountId;

  @BuiltValueField(wireName: r'expense_account_id')
  int get expenseAccountId;

  @BuiltValueField(wireName: r'tax_code_id')
  int? get taxCodeId;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  @BuiltValueField(wireName: r'inventory_tracked')
  bool? get inventoryTracked;

  ItemCreate._();

  factory ItemCreate([void updates(ItemCreateBuilder b)]) = _$ItemCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ItemCreateBuilder b) => b
      ..isActive = true
      ..inventoryTracked = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<ItemCreate> get serializer => _$ItemCreateSerializer();
}

class _$ItemCreateSerializer implements PrimitiveSerializer<ItemCreate> {
  @override
  final Iterable<Type> types = const [ItemCreate, _$ItemCreate];

  @override
  final String wireName = r'ItemCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ItemCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'item_kind';
    yield serializers.serialize(
      object.itemKind,
      specifiedType: const FullType(ItemKind),
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
    ItemCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ItemCreateBuilder result,
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
        case r'item_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ItemKind),
          ) as ItemKind;
          result.itemKind = valueDes;
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
  ItemCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ItemCreateBuilder();
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


