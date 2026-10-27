// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_payment_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtPaymentPreview extends PtPaymentPreview {
  @override
  final String subtotal;
  @override
  final String discount;
  @override
  final String tax;
  @override
  final String total;

  factory _$PtPaymentPreview(
          [void Function(PtPaymentPreviewBuilder)? updates]) =>
      (PtPaymentPreviewBuilder()..update(updates))._build();

  _$PtPaymentPreview._(
      {required this.subtotal,
      required this.discount,
      required this.tax,
      required this.total})
      : super._();
  @override
  PtPaymentPreview rebuild(void Function(PtPaymentPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtPaymentPreviewBuilder toBuilder() =>
      PtPaymentPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtPaymentPreview &&
        subtotal == other.subtotal &&
        discount == other.discount &&
        tax == other.tax &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subtotal.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, tax.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtPaymentPreview')
          ..add('subtotal', subtotal)
          ..add('discount', discount)
          ..add('tax', tax)
          ..add('total', total))
        .toString();
  }
}

class PtPaymentPreviewBuilder
    implements Builder<PtPaymentPreview, PtPaymentPreviewBuilder> {
  _$PtPaymentPreview? _$v;

  String? _subtotal;
  String? get subtotal => _$this._subtotal;
  set subtotal(String? subtotal) => _$this._subtotal = subtotal;

  String? _discount;
  String? get discount => _$this._discount;
  set discount(String? discount) => _$this._discount = discount;

  String? _tax;
  String? get tax => _$this._tax;
  set tax(String? tax) => _$this._tax = tax;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  PtPaymentPreviewBuilder() {
    PtPaymentPreview._defaults(this);
  }

  PtPaymentPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subtotal = $v.subtotal;
      _discount = $v.discount;
      _tax = $v.tax;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtPaymentPreview other) {
    _$v = other as _$PtPaymentPreview;
  }

  @override
  void update(void Function(PtPaymentPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtPaymentPreview build() => _build();

  _$PtPaymentPreview _build() {
    final _$result = _$v ??
        _$PtPaymentPreview._(
          subtotal: BuiltValueNullFieldError.checkNotNull(
              subtotal, r'PtPaymentPreview', 'subtotal'),
          discount: BuiltValueNullFieldError.checkNotNull(
              discount, r'PtPaymentPreview', 'discount'),
          tax: BuiltValueNullFieldError.checkNotNull(
              tax, r'PtPaymentPreview', 'tax'),
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'PtPaymentPreview', 'total'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
