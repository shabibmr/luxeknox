// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_live_enable_posting.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoLiveEnablePosting extends GoLiveEnablePosting {
  @override
  final Date? goLiveDate;

  factory _$GoLiveEnablePosting(
          [void Function(GoLiveEnablePostingBuilder)? updates]) =>
      (GoLiveEnablePostingBuilder()..update(updates))._build();

  _$GoLiveEnablePosting._({this.goLiveDate}) : super._();
  @override
  GoLiveEnablePosting rebuild(
          void Function(GoLiveEnablePostingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoLiveEnablePostingBuilder toBuilder() =>
      GoLiveEnablePostingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoLiveEnablePosting && goLiveDate == other.goLiveDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, goLiveDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoLiveEnablePosting')
          ..add('goLiveDate', goLiveDate))
        .toString();
  }
}

class GoLiveEnablePostingBuilder
    implements Builder<GoLiveEnablePosting, GoLiveEnablePostingBuilder> {
  _$GoLiveEnablePosting? _$v;

  Date? _goLiveDate;
  Date? get goLiveDate => _$this._goLiveDate;
  set goLiveDate(Date? goLiveDate) => _$this._goLiveDate = goLiveDate;

  GoLiveEnablePostingBuilder() {
    GoLiveEnablePosting._defaults(this);
  }

  GoLiveEnablePostingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _goLiveDate = $v.goLiveDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoLiveEnablePosting other) {
    _$v = other as _$GoLiveEnablePosting;
  }

  @override
  void update(void Function(GoLiveEnablePostingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoLiveEnablePosting build() => _build();

  _$GoLiveEnablePosting _build() {
    final _$result = _$v ??
        _$GoLiveEnablePosting._(
          goLiveDate: goLiveDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
