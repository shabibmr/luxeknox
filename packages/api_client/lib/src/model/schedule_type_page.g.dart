// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_type_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScheduleTypePage extends ScheduleTypePage {
  @override
  final BuiltList<ScheduleType> data;
  @override
  final PageMeta meta;

  factory _$ScheduleTypePage(
          [void Function(ScheduleTypePageBuilder)? updates]) =>
      (ScheduleTypePageBuilder()..update(updates))._build();

  _$ScheduleTypePage._({required this.data, required this.meta}) : super._();
  @override
  ScheduleTypePage rebuild(void Function(ScheduleTypePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduleTypePageBuilder toBuilder() =>
      ScheduleTypePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScheduleTypePage &&
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
    return (newBuiltValueToStringHelper(r'ScheduleTypePage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class ScheduleTypePageBuilder
    implements Builder<ScheduleTypePage, ScheduleTypePageBuilder> {
  _$ScheduleTypePage? _$v;

  ListBuilder<ScheduleType>? _data;
  ListBuilder<ScheduleType> get data =>
      _$this._data ??= ListBuilder<ScheduleType>();
  set data(ListBuilder<ScheduleType>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  ScheduleTypePageBuilder() {
    ScheduleTypePage._defaults(this);
  }

  ScheduleTypePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScheduleTypePage other) {
    _$v = other as _$ScheduleTypePage;
  }

  @override
  void update(void Function(ScheduleTypePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScheduleTypePage build() => _build();

  _$ScheduleTypePage _build() {
    _$ScheduleTypePage _$result;
    try {
      _$result = _$v ??
          _$ScheduleTypePage._(
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
            r'ScheduleTypePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
