//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'schedule_status.g.dart';

class ScheduleStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'scheduled')
  static const ScheduleStatus scheduled = _$scheduled;
  @BuiltValueEnumConst(wireName: r'ongoing')
  static const ScheduleStatus ongoing = _$ongoing;
  @BuiltValueEnumConst(wireName: r'completed')
  static const ScheduleStatus completed = _$completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ScheduleStatus cancelled = _$cancelled;

  static Serializer<ScheduleStatus> get serializer => _$scheduleStatusSerializer;

  const ScheduleStatus._(String name): super(name);

  static BuiltSet<ScheduleStatus> get values => _$values;
  static ScheduleStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ScheduleStatusMixin = Object with _$ScheduleStatusMixin;

