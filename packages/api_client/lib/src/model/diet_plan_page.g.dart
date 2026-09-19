// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietPlanPage extends DietPlanPage {
  @override
  final BuiltList<DietPlan> data;
  @override
  final PageMeta meta;

  factory _$DietPlanPage([void Function(DietPlanPageBuilder)? updates]) =>
      (DietPlanPageBuilder()..update(updates))._build();

  _$DietPlanPage._({required this.data, required this.meta}) : super._();
  @override
  DietPlanPage rebuild(void Function(DietPlanPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietPlanPageBuilder toBuilder() => DietPlanPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietPlanPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'DietPlanPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class DietPlanPageBuilder
    implements Builder<DietPlanPage, DietPlanPageBuilder> {
  _$DietPlanPage? _$v;

  ListBuilder<DietPlan>? _data;
  ListBuilder<DietPlan> get data => _$this._data ??= ListBuilder<DietPlan>();
  set data(ListBuilder<DietPlan>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  DietPlanPageBuilder() {
    DietPlanPage._defaults(this);
  }

  DietPlanPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietPlanPage other) {
    _$v = other as _$DietPlanPage;
  }

  @override
  void update(void Function(DietPlanPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietPlanPage build() => _build();

  _$DietPlanPage _build() {
    _$DietPlanPage _$result;
    try {
      _$result = _$v ??
          _$DietPlanPage._(
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
            r'DietPlanPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
