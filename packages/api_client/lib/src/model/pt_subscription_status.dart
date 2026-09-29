//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_subscription_status.g.dart';

class PtSubscriptionStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'scheduled')
  static const PtSubscriptionStatus scheduled = _$scheduled;
  @BuiltValueEnumConst(wireName: r'active')
  static const PtSubscriptionStatus active = _$active;
  @BuiltValueEnumConst(wireName: r'completed')
  static const PtSubscriptionStatus completed = _$completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const PtSubscriptionStatus cancelled = _$cancelled;

  static Serializer<PtSubscriptionStatus> get serializer => _$ptSubscriptionStatusSerializer;

  const PtSubscriptionStatus._(String name): super(name);

  static BuiltSet<PtSubscriptionStatus> get values => _$values;
  static PtSubscriptionStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PtSubscriptionStatusMixin = Object with _$PtSubscriptionStatusMixin;

