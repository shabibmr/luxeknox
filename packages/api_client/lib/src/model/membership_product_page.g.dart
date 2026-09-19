// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_product_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipProductPage extends MembershipProductPage {
  @override
  final BuiltList<MembershipProduct> data;
  @override
  final PageMeta meta;

  factory _$MembershipProductPage(
          [void Function(MembershipProductPageBuilder)? updates]) =>
      (MembershipProductPageBuilder()..update(updates))._build();

  _$MembershipProductPage._({required this.data, required this.meta})
      : super._();
  @override
  MembershipProductPage rebuild(
          void Function(MembershipProductPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipProductPageBuilder toBuilder() =>
      MembershipProductPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipProductPage &&
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
    return (newBuiltValueToStringHelper(r'MembershipProductPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class MembershipProductPageBuilder
    implements Builder<MembershipProductPage, MembershipProductPageBuilder> {
  _$MembershipProductPage? _$v;

  ListBuilder<MembershipProduct>? _data;
  ListBuilder<MembershipProduct> get data =>
      _$this._data ??= ListBuilder<MembershipProduct>();
  set data(ListBuilder<MembershipProduct>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  MembershipProductPageBuilder() {
    MembershipProductPage._defaults(this);
  }

  MembershipProductPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipProductPage other) {
    _$v = other as _$MembershipProductPage;
  }

  @override
  void update(void Function(MembershipProductPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipProductPage build() => _build();

  _$MembershipProductPage _build() {
    _$MembershipProductPage _$result;
    try {
      _$result = _$v ??
          _$MembershipProductPage._(
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
            r'MembershipProductPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
