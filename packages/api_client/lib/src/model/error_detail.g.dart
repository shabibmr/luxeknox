// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ErrorDetail extends ErrorDetail {
  @override
  final String? field;
  @override
  final String? issue;

  factory _$ErrorDetail([void Function(ErrorDetailBuilder)? updates]) =>
      (ErrorDetailBuilder()..update(updates))._build();

  _$ErrorDetail._({this.field, this.issue}) : super._();
  @override
  ErrorDetail rebuild(void Function(ErrorDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorDetailBuilder toBuilder() => ErrorDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorDetail && field == other.field && issue == other.issue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, field.hashCode);
    _$hash = $jc(_$hash, issue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ErrorDetail')
          ..add('field', field)
          ..add('issue', issue))
        .toString();
  }
}

class ErrorDetailBuilder implements Builder<ErrorDetail, ErrorDetailBuilder> {
  _$ErrorDetail? _$v;

  String? _field;
  String? get field => _$this._field;
  set field(String? field) => _$this._field = field;

  String? _issue;
  String? get issue => _$this._issue;
  set issue(String? issue) => _$this._issue = issue;

  ErrorDetailBuilder() {
    ErrorDetail._defaults(this);
  }

  ErrorDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _field = $v.field;
      _issue = $v.issue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorDetail other) {
    _$v = other as _$ErrorDetail;
  }

  @override
  void update(void Function(ErrorDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ErrorDetail build() => _build();

  _$ErrorDetail _build() {
    final _$result = _$v ??
        _$ErrorDetail._(
          field: field,
          issue: issue,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
