// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_participant_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScheduleParticipantWrite extends ScheduleParticipantWrite {
  @override
  final int memberId;

  factory _$ScheduleParticipantWrite(
          [void Function(ScheduleParticipantWriteBuilder)? updates]) =>
      (ScheduleParticipantWriteBuilder()..update(updates))._build();

  _$ScheduleParticipantWrite._({required this.memberId}) : super._();
  @override
  ScheduleParticipantWrite rebuild(
          void Function(ScheduleParticipantWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduleParticipantWriteBuilder toBuilder() =>
      ScheduleParticipantWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScheduleParticipantWrite && memberId == other.memberId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScheduleParticipantWrite')
          ..add('memberId', memberId))
        .toString();
  }
}

class ScheduleParticipantWriteBuilder
    implements
        Builder<ScheduleParticipantWrite, ScheduleParticipantWriteBuilder> {
  _$ScheduleParticipantWrite? _$v;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  ScheduleParticipantWriteBuilder() {
    ScheduleParticipantWrite._defaults(this);
  }

  ScheduleParticipantWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScheduleParticipantWrite other) {
    _$v = other as _$ScheduleParticipantWrite;
  }

  @override
  void update(void Function(ScheduleParticipantWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScheduleParticipantWrite build() => _build();

  _$ScheduleParticipantWrite _build() {
    final _$result = _$v ??
        _$ScheduleParticipantWrite._(
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'ScheduleParticipantWrite', 'memberId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
