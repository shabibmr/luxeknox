// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_version_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietPlanVersionPage extends DietPlanVersionPage {
  @override
  final BuiltList<DietPlanVersion> data;
  @override
  final PageMeta meta;

  factory _$DietPlanVersionPage(
          [void Function(DietPlanVersionPageBuilder)? updates]) =>
      (DietPlanVersionPageBuilder()..update(updates))._build();

  _$DietPlanVersionPage._({required this.data, required this.meta}) : super._();
  @override
  DietPlanVersionPage rebuild(
          void Function(DietPlanVersionPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietPlanVersionPageBuilder toBuilder() =>
      DietPlanVersionPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietPlanVersionPage &&
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
    return (newBuiltValueToStringHelper(r'DietPlanVersionPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class DietPlanVersionPageBuilder
    implements Builder<DietPlanVersionPage, DietPlanVersionPageBuilder> {
  _$DietPlanVersionPage? _$v;

  ListBuilder<DietPlanVersion>? _data;
  ListBuilder<DietPlanVersion> get data =>
      _$this._data ??= ListBuilder<DietPlanVersion>();
  set data(ListBuilder<DietPlanVersion>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  DietPlanVersionPageBuilder() {
    DietPlanVersionPage._defaults(this);
  }

  DietPlanVersionPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietPlanVersionPage other) {
    _$v = other as _$DietPlanVersionPage;
  }

  @override
  void update(void Function(DietPlanVersionPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietPlanVersionPage build() => _build();

  _$DietPlanVersionPage _build() {
    _$DietPlanVersionPage _$result;
    try {
      _$result = _$v ??
          _$DietPlanVersionPage._(
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
            r'DietPlanVersionPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
