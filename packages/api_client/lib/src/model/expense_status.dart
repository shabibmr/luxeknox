//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'expense_status.g.dart';

class ExpenseStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'draft')
  static const ExpenseStatus draft = _$draft;
  @BuiltValueEnumConst(wireName: r'posted')
  static const ExpenseStatus posted = _$posted;

  static Serializer<ExpenseStatus> get serializer => _$expenseStatusSerializer;

  const ExpenseStatus._(String name): super(name);

  static BuiltSet<ExpenseStatus> get values => _$values;
  static ExpenseStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ExpenseStatusMixin = Object with _$ExpenseStatusMixin;

