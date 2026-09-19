// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentMethod extends PaymentMethod {
  @override
  final int id;
  @override
  final String methodName;
  @override
  final bool? isDigital;
  @override
  final bool isActive;

  factory _$PaymentMethod([void Function(PaymentMethodBuilder)? updates]) =>
      (PaymentMethodBuilder()..update(updates))._build();

  _$PaymentMethod._(
      {required this.id,
      required this.methodName,
      this.isDigital,
      required this.isActive})
      : super._();
  @override
  PaymentMethod rebuild(void Function(PaymentMethodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentMethodBuilder toBuilder() => PaymentMethodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentMethod &&
        id == other.id &&
        methodName == other.methodName &&
        isDigital == other.isDigital &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, methodName.hashCode);
    _$hash = $jc(_$hash, isDigital.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentMethod')
          ..add('id', id)
          ..add('methodName', methodName)
          ..add('isDigital', isDigital)
          ..add('isActive', isActive))
        .toString();
  }
}

class PaymentMethodBuilder
    implements Builder<PaymentMethod, PaymentMethodBuilder> {
  _$PaymentMethod? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _methodName;
  String? get methodName => _$this._methodName;
  set methodName(String? methodName) => _$this._methodName = methodName;

  bool? _isDigital;
  bool? get isDigital => _$this._isDigital;
  set isDigital(bool? isDigital) => _$this._isDigital = isDigital;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  PaymentMethodBuilder() {
    PaymentMethod._defaults(this);
  }

  PaymentMethodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _methodName = $v.methodName;
      _isDigital = $v.isDigital;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentMethod other) {
    _$v = other as _$PaymentMethod;
  }

  @override
  void update(void Function(PaymentMethodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentMethod build() => _build();

  _$PaymentMethod _build() {
    final _$result = _$v ??
        _$PaymentMethod._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'PaymentMethod', 'id'),
          methodName: BuiltValueNullFieldError.checkNotNull(
              methodName, r'PaymentMethod', 'methodName'),
          isDigital: isDigital,
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'PaymentMethod', 'isActive'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
