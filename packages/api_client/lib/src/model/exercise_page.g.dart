// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExercisePage extends ExercisePage {
  @override
  final BuiltList<Exercise> data;
  @override
  final PageMeta meta;

  factory _$ExercisePage([void Function(ExercisePageBuilder)? updates]) =>
      (ExercisePageBuilder()..update(updates))._build();

  _$ExercisePage._({required this.data, required this.meta}) : super._();
  @override
  ExercisePage rebuild(void Function(ExercisePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExercisePageBuilder toBuilder() => ExercisePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExercisePage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'ExercisePage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class ExercisePageBuilder
    implements Builder<ExercisePage, ExercisePageBuilder> {
  _$ExercisePage? _$v;

  ListBuilder<Exercise>? _data;
  ListBuilder<Exercise> get data => _$this._data ??= ListBuilder<Exercise>();
  set data(ListBuilder<Exercise>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  ExercisePageBuilder() {
    ExercisePage._defaults(this);
  }

  ExercisePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExercisePage other) {
    _$v = other as _$ExercisePage;
  }

  @override
  void update(void Function(ExercisePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExercisePage build() => _build();

  _$ExercisePage _build() {
    _$ExercisePage _$result;
    try {
      _$result = _$v ??
          _$ExercisePage._(
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
            r'ExercisePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
