// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_condition_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HealthConditionPage extends HealthConditionPage {
  @override
  final BuiltList<HealthCondition> data;
  @override
  final PageMeta meta;

  factory _$HealthConditionPage(
          [void Function(HealthConditionPageBuilder)? updates]) =>
      (HealthConditionPageBuilder()..update(updates))._build();

  _$HealthConditionPage._({required this.data, required this.meta}) : super._();
  @override
  HealthConditionPage rebuild(
          void Function(HealthConditionPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthConditionPageBuilder toBuilder() =>
      HealthConditionPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthConditionPage &&
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
    return (newBuiltValueToStringHelper(r'HealthConditionPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class HealthConditionPageBuilder
    implements Builder<HealthConditionPage, HealthConditionPageBuilder> {
  _$HealthConditionPage? _$v;

  ListBuilder<HealthCondition>? _data;
  ListBuilder<HealthCondition> get data =>
      _$this._data ??= ListBuilder<HealthCondition>();
  set data(ListBuilder<HealthCondition>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  HealthConditionPageBuilder() {
    HealthConditionPage._defaults(this);
  }

  HealthConditionPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthConditionPage other) {
    _$v = other as _$HealthConditionPage;
  }

  @override
  void update(void Function(HealthConditionPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthConditionPage build() => _build();

  _$HealthConditionPage _build() {
    _$HealthConditionPage _$result;
    try {
      _$result = _$v ??
          _$HealthConditionPage._(
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
            r'HealthConditionPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
