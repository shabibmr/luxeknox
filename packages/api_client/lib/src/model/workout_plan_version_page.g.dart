// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_version_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutPlanVersionPage extends WorkoutPlanVersionPage {
  @override
  final BuiltList<WorkoutPlanVersion> data;
  @override
  final PageMeta meta;

  factory _$WorkoutPlanVersionPage(
          [void Function(WorkoutPlanVersionPageBuilder)? updates]) =>
      (WorkoutPlanVersionPageBuilder()..update(updates))._build();

  _$WorkoutPlanVersionPage._({required this.data, required this.meta})
      : super._();
  @override
  WorkoutPlanVersionPage rebuild(
          void Function(WorkoutPlanVersionPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutPlanVersionPageBuilder toBuilder() =>
      WorkoutPlanVersionPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutPlanVersionPage &&
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
    return (newBuiltValueToStringHelper(r'WorkoutPlanVersionPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class WorkoutPlanVersionPageBuilder
    implements Builder<WorkoutPlanVersionPage, WorkoutPlanVersionPageBuilder> {
  _$WorkoutPlanVersionPage? _$v;

  ListBuilder<WorkoutPlanVersion>? _data;
  ListBuilder<WorkoutPlanVersion> get data =>
      _$this._data ??= ListBuilder<WorkoutPlanVersion>();
  set data(ListBuilder<WorkoutPlanVersion>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  WorkoutPlanVersionPageBuilder() {
    WorkoutPlanVersionPage._defaults(this);
  }

  WorkoutPlanVersionPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutPlanVersionPage other) {
    _$v = other as _$WorkoutPlanVersionPage;
  }

  @override
  void update(void Function(WorkoutPlanVersionPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutPlanVersionPage build() => _build();

  _$WorkoutPlanVersionPage _build() {
    _$WorkoutPlanVersionPage _$result;
    try {
      _$result = _$v ??
          _$WorkoutPlanVersionPage._(
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
            r'WorkoutPlanVersionPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
