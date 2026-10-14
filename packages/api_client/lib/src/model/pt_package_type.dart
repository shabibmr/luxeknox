//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_package_type.g.dart';

/// A couple PT package is sold to two members; base_price is the total for both.
class PtPackageType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'single')
  static const PtPackageType single = _$single;
  @BuiltValueEnumConst(wireName: r'couple')
  static const PtPackageType couple = _$couple;

  static Serializer<PtPackageType> get serializer => _$ptPackageTypeSerializer;

  const PtPackageType._(String name): super(name);

  static BuiltSet<PtPackageType> get values => _$values;
  static PtPackageType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PtPackageTypeMixin = Object with _$PtPackageTypeMixin;

