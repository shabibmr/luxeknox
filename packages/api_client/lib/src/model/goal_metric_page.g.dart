// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_metric_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoalMetricPage extends GoalMetricPage {
  @override
  final BuiltList<GoalMetric> data;
  @override
  final PageMeta meta;

  factory _$GoalMetricPage([void Function(GoalMetricPageBuilder)? updates]) =>
      (GoalMetricPageBuilder()..update(updates))._build();

  _$GoalMetricPage._({required this.data, required this.meta}) : super._();
  @override
  GoalMetricPage rebuild(void Function(GoalMetricPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoalMetricPageBuilder toBuilder() => GoalMetricPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoalMetricPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'GoalMetricPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class GoalMetricPageBuilder
    implements Builder<GoalMetricPage, GoalMetricPageBuilder> {
  _$GoalMetricPage? _$v;

  ListBuilder<GoalMetric>? _data;
  ListBuilder<GoalMetric> get data =>
      _$this._data ??= ListBuilder<GoalMetric>();
  set data(ListBuilder<GoalMetric>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  GoalMetricPageBuilder() {
    GoalMetricPage._defaults(this);
  }

  GoalMetricPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoalMetricPage other) {
    _$v = other as _$GoalMetricPage;
  }

  @override
  void update(void Function(GoalMetricPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoalMetricPage build() => _build();

  _$GoalMetricPage _build() {
    _$GoalMetricPage _$result;
    try {
      _$result = _$v ??
          _$GoalMetricPage._(
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
            r'GoalMetricPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
