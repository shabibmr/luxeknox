// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_extension_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipExtensionWrite extends MembershipExtensionWrite {
  @override
  final int daysExtended;
  @override
  final String? reason;

  factory _$MembershipExtensionWrite(
          [void Function(MembershipExtensionWriteBuilder)? updates]) =>
      (MembershipExtensionWriteBuilder()..update(updates))._build();

  _$MembershipExtensionWrite._({required this.daysExtended, this.reason})
      : super._();
  @override
  MembershipExtensionWrite rebuild(
          void Function(MembershipExtensionWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipExtensionWriteBuilder toBuilder() =>
      MembershipExtensionWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipExtensionWrite &&
        daysExtended == other.daysExtended &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, daysExtended.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipExtensionWrite')
          ..add('daysExtended', daysExtended)
          ..add('reason', reason))
        .toString();
  }
}

class MembershipExtensionWriteBuilder
    implements
        Builder<MembershipExtensionWrite, MembershipExtensionWriteBuilder> {
  _$MembershipExtensionWrite? _$v;

  int? _daysExtended;
  int? get daysExtended => _$this._daysExtended;
  set daysExtended(int? daysExtended) => _$this._daysExtended = daysExtended;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  MembershipExtensionWriteBuilder() {
    MembershipExtensionWrite._defaults(this);
  }

  MembershipExtensionWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _daysExtended = $v.daysExtended;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipExtensionWrite other) {
    _$v = other as _$MembershipExtensionWrite;
  }

  @override
  void update(void Function(MembershipExtensionWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipExtensionWrite build() => _build();

  _$MembershipExtensionWrite _build() {
    final _$result = _$v ??
        _$MembershipExtensionWrite._(
          daysExtended: BuiltValueNullFieldError.checkNotNull(
              daysExtended, r'MembershipExtensionWrite', 'daysExtended'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
