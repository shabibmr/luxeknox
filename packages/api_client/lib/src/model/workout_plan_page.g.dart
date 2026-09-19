// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutPlanPage extends WorkoutPlanPage {
  @override
  final BuiltList<WorkoutPlan> data;
  @override
  final PageMeta meta;

  factory _$WorkoutPlanPage([void Function(WorkoutPlanPageBuilder)? updates]) =>
      (WorkoutPlanPageBuilder()..update(updates))._build();

  _$WorkoutPlanPage._({required this.data, required this.meta}) : super._();
  @override
  WorkoutPlanPage rebuild(void Function(WorkoutPlanPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutPlanPageBuilder toBuilder() => WorkoutPlanPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutPlanPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'WorkoutPlanPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class WorkoutPlanPageBuilder
    implements Builder<WorkoutPlanPage, WorkoutPlanPageBuilder> {
  _$WorkoutPlanPage? _$v;

  ListBuilder<WorkoutPlan>? _data;
  ListBuilder<WorkoutPlan> get data =>
      _$this._data ??= ListBuilder<WorkoutPlan>();
  set data(ListBuilder<WorkoutPlan>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  WorkoutPlanPageBuilder() {
    WorkoutPlanPage._defaults(this);
  }

  WorkoutPlanPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutPlanPage other) {
    _$v = other as _$WorkoutPlanPage;
  }

  @override
  void update(void Function(WorkoutPlanPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutPlanPage build() => _build();

  _$WorkoutPlanPage _build() {
    _$WorkoutPlanPage _$result;
    try {
      _$result = _$v ??
          _$WorkoutPlanPage._(
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
            r'WorkoutPlanPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
