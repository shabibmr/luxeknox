// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutSessionPage extends WorkoutSessionPage {
  @override
  final BuiltList<WorkoutSession> data;
  @override
  final PageMeta meta;

  factory _$WorkoutSessionPage(
          [void Function(WorkoutSessionPageBuilder)? updates]) =>
      (WorkoutSessionPageBuilder()..update(updates))._build();

  _$WorkoutSessionPage._({required this.data, required this.meta}) : super._();
  @override
  WorkoutSessionPage rebuild(
          void Function(WorkoutSessionPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutSessionPageBuilder toBuilder() =>
      WorkoutSessionPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutSessionPage &&
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
    return (newBuiltValueToStringHelper(r'WorkoutSessionPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class WorkoutSessionPageBuilder
    implements Builder<WorkoutSessionPage, WorkoutSessionPageBuilder> {
  _$WorkoutSessionPage? _$v;

  ListBuilder<WorkoutSession>? _data;
  ListBuilder<WorkoutSession> get data =>
      _$this._data ??= ListBuilder<WorkoutSession>();
  set data(ListBuilder<WorkoutSession>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  WorkoutSessionPageBuilder() {
    WorkoutSessionPage._defaults(this);
  }

  WorkoutSessionPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutSessionPage other) {
    _$v = other as _$WorkoutSessionPage;
  }

  @override
  void update(void Function(WorkoutSessionPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutSessionPage build() => _build();

  _$WorkoutSessionPage _build() {
    _$WorkoutSessionPage _$result;
    try {
      _$result = _$v ??
          _$WorkoutSessionPage._(
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
            r'WorkoutSessionPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
