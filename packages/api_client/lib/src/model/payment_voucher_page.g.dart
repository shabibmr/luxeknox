// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_voucher_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentVoucherPage extends PaymentVoucherPage {
  @override
  final BuiltList<PaymentVoucher> data;
  @override
  final PageMeta meta;

  factory _$PaymentVoucherPage(
          [void Function(PaymentVoucherPageBuilder)? updates]) =>
      (PaymentVoucherPageBuilder()..update(updates))._build();

  _$PaymentVoucherPage._({required this.data, required this.meta}) : super._();
  @override
  PaymentVoucherPage rebuild(
          void Function(PaymentVoucherPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentVoucherPageBuilder toBuilder() =>
      PaymentVoucherPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentVoucherPage &&
        data == other.data &&
        meta == other.meta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentVoucherPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class PaymentVoucherPageBuilder
    implements Builder<PaymentVoucherPage, PaymentVoucherPageBuilder> {
  _$PaymentVoucherPage? _$v;

  ListBuilder<PaymentVoucher>? _data;
  ListBuilder<PaymentVoucher> get data =>
      _$this._data ??= ListBuilder<PaymentVoucher>();
  set data(ListBuilder<PaymentVoucher>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  PaymentVoucherPageBuilder() {
    PaymentVoucherPage._defaults(this);
  }

  PaymentVoucherPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentVoucherPage other) {
    _$v = other as _$PaymentVoucherPage;
  }

  @override
  void update(void Function(PaymentVoucherPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentVoucherPage build() => _build();

  _$PaymentVoucherPage _build() {
    _$PaymentVoucherPage _$result;
    try {
      _$result = _$v ??
          _$PaymentVoucherPage._(
            data: data.build(),
            meta: meta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaymentVoucherPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
