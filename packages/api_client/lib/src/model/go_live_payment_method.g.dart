// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_live_payment_method.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoLivePaymentMethod extends GoLivePaymentMethod {
  @override
  final int id;
  @override
  final String methodName;
  @override
  final bool isActive;
  @override
  final bool isDigital;
  @override
  final int? accountId;
  @override
  final String? accountName;

  factory _$GoLivePaymentMethod(
          [void Function(GoLivePaymentMethodBuilder)? updates]) =>
      (GoLivePaymentMethodBuilder()..update(updates))._build();

  _$GoLivePaymentMethod._(
      {required this.id,
      required this.methodName,
      required this.isActive,
      required this.isDigital,
      this.accountId,
      this.accountName})
      : super._();
  @override
  GoLivePaymentMethod rebuild(
          void Function(GoLivePaymentMethodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoLivePaymentMethodBuilder toBuilder() =>
      GoLivePaymentMethodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoLivePaymentMethod &&
        id == other.id &&
        methodName == other.methodName &&
        isActive == other.isActive &&
        isDigital == other.isDigital &&
        accountId == other.accountId &&
        accountName == other.accountName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, methodName.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, isDigital.hashCode);
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, accountName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoLivePaymentMethod')
          ..add('id', id)
          ..add('methodName', methodName)
          ..add('isActive', isActive)
          ..add('isDigital', isDigital)
          ..add('accountId', accountId)
          ..add('accountName', accountName))
        .toString();
  }
}

class GoLivePaymentMethodBuilder
    implements Builder<GoLivePaymentMethod, GoLivePaymentMethodBuilder> {
  _$GoLivePaymentMethod? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _methodName;
  String? get methodName => _$this._methodName;
  set methodName(String? methodName) => _$this._methodName = methodName;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  bool? _isDigital;
  bool? get isDigital => _$this._isDigital;
  set isDigital(bool? isDigital) => _$this._isDigital = isDigital;

  int? _accountId;
  int? get accountId => _$this._accountId;
  set accountId(int? accountId) => _$this._accountId = accountId;

  String? _accountName;
  String? get accountName => _$this._accountName;
  set accountName(String? accountName) => _$this._accountName = accountName;

  GoLivePaymentMethodBuilder() {
    GoLivePaymentMethod._defaults(this);
  }

  GoLivePaymentMethodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _methodName = $v.methodName;
      _isActive = $v.isActive;
      _isDigital = $v.isDigital;
      _accountId = $v.accountId;
      _accountName = $v.accountName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoLivePaymentMethod other) {
    _$v = other as _$GoLivePaymentMethod;
  }

  @override
  void update(void Function(GoLivePaymentMethodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoLivePaymentMethod build() => _build();

  _$GoLivePaymentMethod _build() {
    final _$result = _$v ??
        _$GoLivePaymentMethod._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'GoLivePaymentMethod', 'id'),
          methodName: BuiltValueNullFieldError.checkNotNull(
              methodName, r'GoLivePaymentMethod', 'methodName'),
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'GoLivePaymentMethod', 'isActive'),
          isDigital: BuiltValueNullFieldError.checkNotNull(
              isDigital, r'GoLivePaymentMethod', 'isDigital'),
          accountId: accountId,
          accountName: accountName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
