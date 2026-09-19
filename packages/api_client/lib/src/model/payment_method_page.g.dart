// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentMethodPage extends PaymentMethodPage {
  @override
  final BuiltList<PaymentMethod> data;
  @override
  final PageMeta meta;

  factory _$PaymentMethodPage(
          [void Function(PaymentMethodPageBuilder)? updates]) =>
      (PaymentMethodPageBuilder()..update(updates))._build();

  _$PaymentMethodPage._({required this.data, required this.meta}) : super._();
  @override
  PaymentMethodPage rebuild(void Function(PaymentMethodPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentMethodPageBuilder toBuilder() =>
      PaymentMethodPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentMethodPage &&
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
    return (newBuiltValueToStringHelper(r'PaymentMethodPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class PaymentMethodPageBuilder
    implements Builder<PaymentMethodPage, PaymentMethodPageBuilder> {
  _$PaymentMethodPage? _$v;

  ListBuilder<PaymentMethod>? _data;
  ListBuilder<PaymentMethod> get data =>
      _$this._data ??= ListBuilder<PaymentMethod>();
  set data(ListBuilder<PaymentMethod>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  PaymentMethodPageBuilder() {
    PaymentMethodPage._defaults(this);
  }

  PaymentMethodPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentMethodPage other) {
    _$v = other as _$PaymentMethodPage;
  }

  @override
  void update(void Function(PaymentMethodPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentMethodPage build() => _build();

  _$PaymentMethodPage _build() {
    _$PaymentMethodPage _$result;
    try {
      _$result = _$v ??
          _$PaymentMethodPage._(
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
            r'PaymentMethodPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
