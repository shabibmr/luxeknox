// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_freeze_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipFreezeWrite extends MembershipFreezeWrite {
  @override
  final Date startDate;
  @override
  final Date endDate;
  @override
  final String? reason;

  factory _$MembershipFreezeWrite(
          [void Function(MembershipFreezeWriteBuilder)? updates]) =>
      (MembershipFreezeWriteBuilder()..update(updates))._build();

  _$MembershipFreezeWrite._(
      {required this.startDate, required this.endDate, this.reason})
      : super._();
  @override
  MembershipFreezeWrite rebuild(
          void Function(MembershipFreezeWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipFreezeWriteBuilder toBuilder() =>
      MembershipFreezeWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipFreezeWrite &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipFreezeWrite')
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('reason', reason))
        .toString();
  }
}

class MembershipFreezeWriteBuilder
    implements Builder<MembershipFreezeWrite, MembershipFreezeWriteBuilder> {
  _$MembershipFreezeWrite? _$v;

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(Date? startDate) => _$this._startDate = startDate;

  Date? _endDate;
  Date? get endDate => _$this._endDate;
  set endDate(Date? endDate) => _$this._endDate = endDate;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  MembershipFreezeWriteBuilder() {
    MembershipFreezeWrite._defaults(this);
  }

  MembershipFreezeWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipFreezeWrite other) {
    _$v = other as _$MembershipFreezeWrite;
  }

  @override
  void update(void Function(MembershipFreezeWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipFreezeWrite build() => _build();

  _$MembershipFreezeWrite _build() {
    final _$result = _$v ??
        _$MembershipFreezeWrite._(
          startDate: BuiltValueNullFieldError.checkNotNull(
              startDate, r'MembershipFreezeWrite', 'startDate'),
          endDate: BuiltValueNullFieldError.checkNotNull(
              endDate, r'MembershipFreezeWrite', 'endDate'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
