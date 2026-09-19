// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_action_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipActionRequest extends MembershipActionRequest {
  @override
  final int? productId;
  @override
  final int? rowVersion;
  @override
  final String? reason;

  factory _$MembershipActionRequest(
          [void Function(MembershipActionRequestBuilder)? updates]) =>
      (MembershipActionRequestBuilder()..update(updates))._build();

  _$MembershipActionRequest._({this.productId, this.rowVersion, this.reason})
      : super._();
  @override
  MembershipActionRequest rebuild(
          void Function(MembershipActionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipActionRequestBuilder toBuilder() =>
      MembershipActionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipActionRequest &&
        productId == other.productId &&
        rowVersion == other.rowVersion &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipActionRequest')
          ..add('productId', productId)
          ..add('rowVersion', rowVersion)
          ..add('reason', reason))
        .toString();
  }
}

class MembershipActionRequestBuilder
    implements
        Builder<MembershipActionRequest, MembershipActionRequestBuilder> {
  _$MembershipActionRequest? _$v;

  int? _productId;
  int? get productId => _$this._productId;
  set productId(int? productId) => _$this._productId = productId;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  MembershipActionRequestBuilder() {
    MembershipActionRequest._defaults(this);
  }

  MembershipActionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _rowVersion = $v.rowVersion;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipActionRequest other) {
    _$v = other as _$MembershipActionRequest;
  }

  @override
  void update(void Function(MembershipActionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipActionRequest build() => _build();

  _$MembershipActionRequest _build() {
    final _$result = _$v ??
        _$MembershipActionRequest._(
          productId: productId,
          rowVersion: rowVersion,
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
