// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentMethodWrite extends PaymentMethodWrite {
  @override
  final String methodName;
  @override
  final bool? isDigital;
  @override
  final bool? isActive;

  factory _$PaymentMethodWrite(
          [void Function(PaymentMethodWriteBuilder)? updates]) =>
      (PaymentMethodWriteBuilder()..update(updates))._build();

  _$PaymentMethodWrite._(
      {required this.methodName, this.isDigital, this.isActive})
      : super._();
  @override
  PaymentMethodWrite rebuild(
          void Function(PaymentMethodWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentMethodWriteBuilder toBuilder() =>
      PaymentMethodWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentMethodWrite &&
        methodName == other.methodName &&
        isDigital == other.isDigital &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, methodName.hashCode);
    _$hash = $jc(_$hash, isDigital.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentMethodWrite')
          ..add('methodName', methodName)
          ..add('isDigital', isDigital)
          ..add('isActive', isActive))
        .toString();
  }
}

class PaymentMethodWriteBuilder
    implements Builder<PaymentMethodWrite, PaymentMethodWriteBuilder> {
  _$PaymentMethodWrite? _$v;

  String? _methodName;
  String? get methodName => _$this._methodName;
  set methodName(String? methodName) => _$this._methodName = methodName;

  bool? _isDigital;
  bool? get isDigital => _$this._isDigital;
  set isDigital(bool? isDigital) => _$this._isDigital = isDigital;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  PaymentMethodWriteBuilder() {
    PaymentMethodWrite._defaults(this);
  }

  PaymentMethodWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _methodName = $v.methodName;
      _isDigital = $v.isDigital;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentMethodWrite other) {
    _$v = other as _$PaymentMethodWrite;
  }

  @override
  void update(void Function(PaymentMethodWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentMethodWrite build() => _build();

  _$PaymentMethodWrite _build() {
    final _$result = _$v ??
        _$PaymentMethodWrite._(
          methodName: BuiltValueNullFieldError.checkNotNull(
              methodName, r'PaymentMethodWrite', 'methodName'),
          isDigital: isDigital,
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
