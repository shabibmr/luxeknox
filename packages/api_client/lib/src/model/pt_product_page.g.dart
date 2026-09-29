// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_product_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtProductPage extends PtProductPage {
  @override
  final BuiltList<PtProduct> data;
  @override
  final PageMeta meta;

  factory _$PtProductPage([void Function(PtProductPageBuilder)? updates]) =>
      (PtProductPageBuilder()..update(updates))._build();

  _$PtProductPage._({required this.data, required this.meta}) : super._();
  @override
  PtProductPage rebuild(void Function(PtProductPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtProductPageBuilder toBuilder() => PtProductPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtProductPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'PtProductPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class PtProductPageBuilder
    implements Builder<PtProductPage, PtProductPageBuilder> {
  _$PtProductPage? _$v;

  ListBuilder<PtProduct>? _data;
  ListBuilder<PtProduct> get data => _$this._data ??= ListBuilder<PtProduct>();
  set data(ListBuilder<PtProduct>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  PtProductPageBuilder() {
    PtProductPage._defaults(this);
  }

  PtProductPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtProductPage other) {
    _$v = other as _$PtProductPage;
  }

  @override
  void update(void Function(PtProductPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtProductPage build() => _build();

  _$PtProductPage _build() {
    _$PtProductPage _$result;
    try {
      _$result = _$v ??
          _$PtProductPage._(
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
            r'PtProductPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
