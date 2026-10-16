// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uom_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UomPage extends UomPage {
  @override
  final BuiltList<Uom> data;
  @override
  final PageMeta meta;

  factory _$UomPage([void Function(UomPageBuilder)? updates]) =>
      (UomPageBuilder()..update(updates))._build();

  _$UomPage._({required this.data, required this.meta}) : super._();
  @override
  UomPage rebuild(void Function(UomPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UomPageBuilder toBuilder() => UomPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UomPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'UomPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class UomPageBuilder implements Builder<UomPage, UomPageBuilder> {
  _$UomPage? _$v;

  ListBuilder<Uom>? _data;
  ListBuilder<Uom> get data => _$this._data ??= ListBuilder<Uom>();
  set data(ListBuilder<Uom>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  UomPageBuilder() {
    UomPage._defaults(this);
  }

  UomPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UomPage other) {
    _$v = other as _$UomPage;
  }

  @override
  void update(void Function(UomPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UomPage build() => _build();

  _$UomPage _build() {
    _$UomPage _$result;
    try {
      _$result = _$v ??
          _$UomPage._(
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
            r'UomPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
