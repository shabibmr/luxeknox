//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'purchase_bill_status.g.dart';

class PurchaseBillStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'draft')
  static const PurchaseBillStatus draft = _$draft;
  @BuiltValueEnumConst(wireName: r'posted')
  static const PurchaseBillStatus posted = _$posted;
  @BuiltValueEnumConst(wireName: r'void')
  static const PurchaseBillStatus void_ = _$void_;

  static Serializer<PurchaseBillStatus> get serializer => _$purchaseBillStatusSerializer;

  const PurchaseBillStatus._(String name): super(name);

  static BuiltSet<PurchaseBillStatus> get values => _$values;
  static PurchaseBillStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PurchaseBillStatusMixin = Object with _$PurchaseBillStatusMixin;

