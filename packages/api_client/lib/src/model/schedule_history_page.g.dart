// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_history_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScheduleHistoryPage extends ScheduleHistoryPage {
  @override
  final BuiltList<ScheduleHistory> data;
  @override
  final PageMeta meta;

  factory _$ScheduleHistoryPage(
          [void Function(ScheduleHistoryPageBuilder)? updates]) =>
      (ScheduleHistoryPageBuilder()..update(updates))._build();

  _$ScheduleHistoryPage._({required this.data, required this.meta}) : super._();
  @override
  ScheduleHistoryPage rebuild(
          void Function(ScheduleHistoryPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduleHistoryPageBuilder toBuilder() =>
      ScheduleHistoryPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScheduleHistoryPage &&
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
    return (newBuiltValueToStringHelper(r'ScheduleHistoryPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class ScheduleHistoryPageBuilder
    implements Builder<ScheduleHistoryPage, ScheduleHistoryPageBuilder> {
  _$ScheduleHistoryPage? _$v;

  ListBuilder<ScheduleHistory>? _data;
  ListBuilder<ScheduleHistory> get data =>
      _$this._data ??= ListBuilder<ScheduleHistory>();
  set data(ListBuilder<ScheduleHistory>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  ScheduleHistoryPageBuilder() {
    ScheduleHistoryPage._defaults(this);
  }

  ScheduleHistoryPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScheduleHistoryPage other) {
    _$v = other as _$ScheduleHistoryPage;
  }

  @override
  void update(void Function(ScheduleHistoryPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScheduleHistoryPage build() => _build();

  _$ScheduleHistoryPage _build() {
    _$ScheduleHistoryPage _$result;
    try {
      _$result = _$v ??
          _$ScheduleHistoryPage._(
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
            r'ScheduleHistoryPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
