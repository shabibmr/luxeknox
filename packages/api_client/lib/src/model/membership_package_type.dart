//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_package_type.g.dart';

/// A couple package is sold to two members; base_price is the total for both.
class MembershipPackageType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'single')
  static const MembershipPackageType single = _$single;
  @BuiltValueEnumConst(wireName: r'couple')
  static const MembershipPackageType couple = _$couple;

  static Serializer<MembershipPackageType> get serializer => _$membershipPackageTypeSerializer;

  const MembershipPackageType._(String name): super(name);

  static BuiltSet<MembershipPackageType> get values => _$values;
  static MembershipPackageType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MembershipPackageTypeMixin = Object with _$MembershipPackageTypeMixin;

