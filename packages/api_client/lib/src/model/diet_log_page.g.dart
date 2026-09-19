// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_log_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietLogPage extends DietLogPage {
  @override
  final BuiltList<DietLog> data;
  @override
  final PageMeta meta;

  factory _$DietLogPage([void Function(DietLogPageBuilder)? updates]) =>
      (DietLogPageBuilder()..update(updates))._build();

  _$DietLogPage._({required this.data, required this.meta}) : super._();
  @override
  DietLogPage rebuild(void Function(DietLogPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietLogPageBuilder toBuilder() => DietLogPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietLogPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'DietLogPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class DietLogPageBuilder implements Builder<DietLogPage, DietLogPageBuilder> {
  _$DietLogPage? _$v;

  ListBuilder<DietLog>? _data;
  ListBuilder<DietLog> get data => _$this._data ??= ListBuilder<DietLog>();
  set data(ListBuilder<DietLog>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  DietLogPageBuilder() {
    DietLogPage._defaults(this);
  }

  DietLogPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietLogPage other) {
    _$v = other as _$DietLogPage;
  }

  @override
  void update(void Function(DietLogPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietLogPage build() => _build();

  _$DietLogPage _build() {
    _$DietLogPage _$result;
    try {
      _$result = _$v ??
          _$DietLogPage._(
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
            r'DietLogPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
