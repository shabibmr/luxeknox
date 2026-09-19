// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RejectRequest extends RejectRequest {
  @override
  final String? reason;

  factory _$RejectRequest([void Function(RejectRequestBuilder)? updates]) =>
      (RejectRequestBuilder()..update(updates))._build();

  _$RejectRequest._({this.reason}) : super._();
  @override
  RejectRequest rebuild(void Function(RejectRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RejectRequestBuilder toBuilder() => RejectRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RejectRequest && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RejectRequest')
          ..add('reason', reason))
        .toString();
  }
}

class RejectRequestBuilder
    implements Builder<RejectRequest, RejectRequestBuilder> {
  _$RejectRequest? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  RejectRequestBuilder() {
    RejectRequest._defaults(this);
  }

  RejectRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RejectRequest other) {
    _$v = other as _$RejectRequest;
  }

  @override
  void update(void Function(RejectRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RejectRequest build() => _build();

  _$RejectRequest _build() {
    final _$result = _$v ??
        _$RejectRequest._(
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
