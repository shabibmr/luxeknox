//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_status.g.dart';

class MembershipStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'active')
  static const MembershipStatus active = _$active;
  @BuiltValueEnumConst(wireName: r'expired')
  static const MembershipStatus expired = _$expired;
  @BuiltValueEnumConst(wireName: r'frozen')
  static const MembershipStatus frozen = _$frozen;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const MembershipStatus cancelled = _$cancelled;

  static Serializer<MembershipStatus> get serializer => _$membershipStatusSerializer;

  const MembershipStatus._(String name): super(name);

  static BuiltSet<MembershipStatus> get values => _$values;
  static MembershipStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MembershipStatusMixin = Object with _$MembershipStatusMixin;

