//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'item_kind.g.dart';

class ItemKind extends EnumClass {

  @BuiltValueEnumConst(wireName: r'service')
  static const ItemKind service = _$service;
  @BuiltValueEnumConst(wireName: r'goods')
  static const ItemKind goods = _$goods;

  static Serializer<ItemKind> get serializer => _$itemKindSerializer;

  const ItemKind._(String name): super(name);

  static BuiltSet<ItemKind> get values => _$values;
  static ItemKind valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ItemKindMixin = Object with _$ItemKindMixin;

