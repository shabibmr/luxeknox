// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_code_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaxCodePage extends TaxCodePage {
  @override
  final BuiltList<TaxCode> data;
  @override
  final PageMeta meta;

  factory _$TaxCodePage([void Function(TaxCodePageBuilder)? updates]) =>
      (TaxCodePageBuilder()..update(updates))._build();

  _$TaxCodePage._({required this.data, required this.meta}) : super._();
  @override
  TaxCodePage rebuild(void Function(TaxCodePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxCodePageBuilder toBuilder() => TaxCodePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxCodePage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'TaxCodePage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class TaxCodePageBuilder implements Builder<TaxCodePage, TaxCodePageBuilder> {
  _$TaxCodePage? _$v;

  ListBuilder<TaxCode>? _data;
  ListBuilder<TaxCode> get data => _$this._data ??= ListBuilder<TaxCode>();
  set data(ListBuilder<TaxCode>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  TaxCodePageBuilder() {
    TaxCodePage._defaults(this);
  }

  TaxCodePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxCodePage other) {
    _$v = other as _$TaxCodePage;
  }

  @override
  void update(void Function(TaxCodePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxCodePage build() => _build();

  _$TaxCodePage _build() {
    _$TaxCodePage _$result;
    try {
      _$result = _$v ??
          _$TaxCodePage._(
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
            r'TaxCodePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
