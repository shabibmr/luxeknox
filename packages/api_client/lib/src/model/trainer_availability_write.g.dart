// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer_availability_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrainerAvailabilityWrite extends TrainerAvailabilityWrite {
  @override
  final BuiltList<TrainerAvailability> slots;

  factory _$TrainerAvailabilityWrite(
          [void Function(TrainerAvailabilityWriteBuilder)? updates]) =>
      (TrainerAvailabilityWriteBuilder()..update(updates))._build();

  _$TrainerAvailabilityWrite._({required this.slots}) : super._();
  @override
  TrainerAvailabilityWrite rebuild(
          void Function(TrainerAvailabilityWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainerAvailabilityWriteBuilder toBuilder() =>
      TrainerAvailabilityWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrainerAvailabilityWrite && slots == other.slots;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, slots.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TrainerAvailabilityWrite')
          ..add('slots', slots))
        .toString();
  }
}

class TrainerAvailabilityWriteBuilder
    implements
        Builder<TrainerAvailabilityWrite, TrainerAvailabilityWriteBuilder> {
  _$TrainerAvailabilityWrite? _$v;

  ListBuilder<TrainerAvailability>? _slots;
  ListBuilder<TrainerAvailability> get slots =>
      _$this._slots ??= ListBuilder<TrainerAvailability>();
  set slots(ListBuilder<TrainerAvailability>? slots) => _$this._slots = slots;

  TrainerAvailabilityWriteBuilder() {
    TrainerAvailabilityWrite._defaults(this);
  }

  TrainerAvailabilityWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _slots = $v.slots.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrainerAvailabilityWrite other) {
    _$v = other as _$TrainerAvailabilityWrite;
  }

  @override
  void update(void Function(TrainerAvailabilityWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrainerAvailabilityWrite build() => _build();

  _$TrainerAvailabilityWrite _build() {
    _$TrainerAvailabilityWrite _$result;
    try {
      _$result = _$v ??
          _$TrainerAvailabilityWrite._(
            slots: slots.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'slots';
        slots.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TrainerAvailabilityWrite', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
