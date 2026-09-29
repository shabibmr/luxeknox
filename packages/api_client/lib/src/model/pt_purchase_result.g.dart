// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_purchase_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtPurchaseResult extends PtPurchaseResult {
  @override
  final PtSubscription subscription;
  @override
  final Payment payment;

  factory _$PtPurchaseResult(
          [void Function(PtPurchaseResultBuilder)? updates]) =>
      (PtPurchaseResultBuilder()..update(updates))._build();

  _$PtPurchaseResult._({required this.subscription, required this.payment})
      : super._();
  @override
  PtPurchaseResult rebuild(void Function(PtPurchaseResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtPurchaseResultBuilder toBuilder() =>
      PtPurchaseResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtPurchaseResult &&
        subscription == other.subscription &&
        payment == other.payment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subscription.hashCode);
    _$hash = $jc(_$hash, payment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtPurchaseResult')
          ..add('subscription', subscription)
          ..add('payment', payment))
        .toString();
  }
}

class PtPurchaseResultBuilder
    implements Builder<PtPurchaseResult, PtPurchaseResultBuilder> {
  _$PtPurchaseResult? _$v;

  PtSubscriptionBuilder? _subscription;
  PtSubscriptionBuilder get subscription =>
      _$this._subscription ??= PtSubscriptionBuilder();
  set subscription(PtSubscriptionBuilder? subscription) =>
      _$this._subscription = subscription;

  PaymentBuilder? _payment;
  PaymentBuilder get payment => _$this._payment ??= PaymentBuilder();
  set payment(PaymentBuilder? payment) => _$this._payment = payment;

  PtPurchaseResultBuilder() {
    PtPurchaseResult._defaults(this);
  }

  PtPurchaseResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subscription = $v.subscription.toBuilder();
      _payment = $v.payment.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtPurchaseResult other) {
    _$v = other as _$PtPurchaseResult;
  }

  @override
  void update(void Function(PtPurchaseResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtPurchaseResult build() => _build();

  _$PtPurchaseResult _build() {
    _$PtPurchaseResult _$result;
    try {
      _$result = _$v ??
          _$PtPurchaseResult._(
            subscription: subscription.build(),
            payment: payment.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'subscription';
        subscription.build();
        _$failedField = 'payment';
        payment.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PtPurchaseResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
