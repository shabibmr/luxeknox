//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_type.g.dart';

class AccountType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'asset')
  static const AccountType asset = _$asset;
  @BuiltValueEnumConst(wireName: r'liability')
  static const AccountType liability = _$liability;
  @BuiltValueEnumConst(wireName: r'equity')
  static const AccountType equity = _$equity;
  @BuiltValueEnumConst(wireName: r'income')
  static const AccountType income = _$income;
  @BuiltValueEnumConst(wireName: r'expense')
  static const AccountType expense = _$expense;

  static Serializer<AccountType> get serializer => _$accountTypeSerializer;

  const AccountType._(String name): super(name);

  static BuiltSet<AccountType> get values => _$values;
  static AccountType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AccountTypeMixin = Object with _$AccountTypeMixin;

