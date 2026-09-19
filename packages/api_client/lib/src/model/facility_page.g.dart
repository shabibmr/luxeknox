// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FacilityPage extends FacilityPage {
  @override
  final BuiltList<Facility> data;
  @override
  final PageMeta meta;

  factory _$FacilityPage([void Function(FacilityPageBuilder)? updates]) =>
      (FacilityPageBuilder()..update(updates))._build();

  _$FacilityPage._({required this.data, required this.meta}) : super._();
  @override
  FacilityPage rebuild(void Function(FacilityPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FacilityPageBuilder toBuilder() => FacilityPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FacilityPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'FacilityPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class FacilityPageBuilder
    implements Builder<FacilityPage, FacilityPageBuilder> {
  _$FacilityPage? _$v;

  ListBuilder<Facility>? _data;
  ListBuilder<Facility> get data => _$this._data ??= ListBuilder<Facility>();
  set data(ListBuilder<Facility>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  FacilityPageBuilder() {
    FacilityPage._defaults(this);
  }

  FacilityPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FacilityPage other) {
    _$v = other as _$FacilityPage;
  }

  @override
  void update(void Function(FacilityPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FacilityPage build() => _build();

  _$FacilityPage _build() {
    _$FacilityPage _$result;
    try {
      _$result = _$v ??
          _$FacilityPage._(
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
            r'FacilityPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
