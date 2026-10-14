// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_live_map_payment_method.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoLiveMapPaymentMethod extends GoLiveMapPaymentMethod {
  @override
  final int? accountId;

  factory _$GoLiveMapPaymentMethod(
          [void Function(GoLiveMapPaymentMethodBuilder)? updates]) =>
      (GoLiveMapPaymentMethodBuilder()..update(updates))._build();

  _$GoLiveMapPaymentMethod._({this.accountId}) : super._();
  @override
  GoLiveMapPaymentMethod rebuild(
          void Function(GoLiveMapPaymentMethodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoLiveMapPaymentMethodBuilder toBuilder() =>
      GoLiveMapPaymentMethodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoLiveMapPaymentMethod && accountId == other.accountId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoLiveMapPaymentMethod')
          ..add('accountId', accountId))
        .toString();
  }
}

class GoLiveMapPaymentMethodBuilder
    implements Builder<GoLiveMapPaymentMethod, GoLiveMapPaymentMethodBuilder> {
  _$GoLiveMapPaymentMethod? _$v;

  int? _accountId;
  int? get accountId => _$this._accountId;
  set accountId(int? accountId) => _$this._accountId = accountId;

  GoLiveMapPaymentMethodBuilder() {
    GoLiveMapPaymentMethod._defaults(this);
  }

  GoLiveMapPaymentMethodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoLiveMapPaymentMethod other) {
    _$v = other as _$GoLiveMapPaymentMethod;
  }

  @override
  void update(void Function(GoLiveMapPaymentMethodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoLiveMapPaymentMethod build() => _build();

  _$GoLiveMapPaymentMethod _build() {
    final _$result = _$v ??
        _$GoLiveMapPaymentMethod._(
          accountId: accountId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
