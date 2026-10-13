// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorPage extends VendorPage {
  @override
  final BuiltList<Vendor> data;
  @override
  final PageMeta meta;

  factory _$VendorPage([void Function(VendorPageBuilder)? updates]) =>
      (VendorPageBuilder()..update(updates))._build();

  _$VendorPage._({required this.data, required this.meta}) : super._();
  @override
  VendorPage rebuild(void Function(VendorPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorPageBuilder toBuilder() => VendorPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'VendorPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class VendorPageBuilder implements Builder<VendorPage, VendorPageBuilder> {
  _$VendorPage? _$v;

  ListBuilder<Vendor>? _data;
  ListBuilder<Vendor> get data => _$this._data ??= ListBuilder<Vendor>();
  set data(ListBuilder<Vendor>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  VendorPageBuilder() {
    VendorPage._defaults(this);
  }

  VendorPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorPage other) {
    _$v = other as _$VendorPage;
  }

  @override
  void update(void Function(VendorPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorPage build() => _build();

  _$VendorPage _build() {
    _$VendorPage _$result;
    try {
      _$result = _$v ??
          _$VendorPage._(
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
            r'VendorPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
