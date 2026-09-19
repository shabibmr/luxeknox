// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentPage extends PaymentPage {
  @override
  final BuiltList<Payment> data;
  @override
  final PageMeta meta;

  factory _$PaymentPage([void Function(PaymentPageBuilder)? updates]) =>
      (PaymentPageBuilder()..update(updates))._build();

  _$PaymentPage._({required this.data, required this.meta}) : super._();
  @override
  PaymentPage rebuild(void Function(PaymentPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentPageBuilder toBuilder() => PaymentPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'PaymentPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class PaymentPageBuilder implements Builder<PaymentPage, PaymentPageBuilder> {
  _$PaymentPage? _$v;

  ListBuilder<Payment>? _data;
  ListBuilder<Payment> get data => _$this._data ??= ListBuilder<Payment>();
  set data(ListBuilder<Payment>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  PaymentPageBuilder() {
    PaymentPage._defaults(this);
  }

  PaymentPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentPage other) {
    _$v = other as _$PaymentPage;
  }

  @override
  void update(void Function(PaymentPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentPage build() => _build();

  _$PaymentPage _build() {
    _$PaymentPage _$result;
    try {
      _$result = _$v ??
          _$PaymentPage._(
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
            r'PaymentPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
