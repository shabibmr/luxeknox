// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoalPage extends GoalPage {
  @override
  final BuiltList<Goal> data;
  @override
  final PageMeta meta;

  factory _$GoalPage([void Function(GoalPageBuilder)? updates]) =>
      (GoalPageBuilder()..update(updates))._build();

  _$GoalPage._({required this.data, required this.meta}) : super._();
  @override
  GoalPage rebuild(void Function(GoalPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoalPageBuilder toBuilder() => GoalPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoalPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'GoalPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class GoalPageBuilder implements Builder<GoalPage, GoalPageBuilder> {
  _$GoalPage? _$v;

  ListBuilder<Goal>? _data;
  ListBuilder<Goal> get data => _$this._data ??= ListBuilder<Goal>();
  set data(ListBuilder<Goal>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  GoalPageBuilder() {
    GoalPage._defaults(this);
  }

  GoalPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoalPage other) {
    _$v = other as _$GoalPage;
  }

  @override
  void update(void Function(GoalPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoalPage build() => _build();

  _$GoalPage _build() {
    _$GoalPage _$result;
    try {
      _$result = _$v ??
          _$GoalPage._(
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
            r'GoalPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
