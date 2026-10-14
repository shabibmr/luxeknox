// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_live_unearned_match.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoLiveUnearnedMatch extends GoLiveUnearnedMatch {
  @override
  final String preview;
  @override
  final String actual;
  @override
  final bool matched;

  factory _$GoLiveUnearnedMatch(
          [void Function(GoLiveUnearnedMatchBuilder)? updates]) =>
      (GoLiveUnearnedMatchBuilder()..update(updates))._build();

  _$GoLiveUnearnedMatch._(
      {required this.preview, required this.actual, required this.matched})
      : super._();
  @override
  GoLiveUnearnedMatch rebuild(
          void Function(GoLiveUnearnedMatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoLiveUnearnedMatchBuilder toBuilder() =>
      GoLiveUnearnedMatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoLiveUnearnedMatch &&
        preview == other.preview &&
        actual == other.actual &&
        matched == other.matched;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, preview.hashCode);
    _$hash = $jc(_$hash, actual.hashCode);
    _$hash = $jc(_$hash, matched.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoLiveUnearnedMatch')
          ..add('preview', preview)
          ..add('actual', actual)
          ..add('matched', matched))
        .toString();
  }
}

class GoLiveUnearnedMatchBuilder
    implements Builder<GoLiveUnearnedMatch, GoLiveUnearnedMatchBuilder> {
  _$GoLiveUnearnedMatch? _$v;

  String? _preview;
  String? get preview => _$this._preview;
  set preview(String? preview) => _$this._preview = preview;

  String? _actual;
  String? get actual => _$this._actual;
  set actual(String? actual) => _$this._actual = actual;

  bool? _matched;
  bool? get matched => _$this._matched;
  set matched(bool? matched) => _$this._matched = matched;

  GoLiveUnearnedMatchBuilder() {
    GoLiveUnearnedMatch._defaults(this);
  }

  GoLiveUnearnedMatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _preview = $v.preview;
      _actual = $v.actual;
      _matched = $v.matched;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoLiveUnearnedMatch other) {
    _$v = other as _$GoLiveUnearnedMatch;
  }

  @override
  void update(void Function(GoLiveUnearnedMatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoLiveUnearnedMatch build() => _build();

  _$GoLiveUnearnedMatch _build() {
    final _$result = _$v ??
        _$GoLiveUnearnedMatch._(
          preview: BuiltValueNullFieldError.checkNotNull(
              preview, r'GoLiveUnearnedMatch', 'preview'),
          actual: BuiltValueNullFieldError.checkNotNull(
              actual, r'GoLiveUnearnedMatch', 'actual'),
          matched: BuiltValueNullFieldError.checkNotNull(
              matched, r'GoLiveUnearnedMatch', 'matched'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
