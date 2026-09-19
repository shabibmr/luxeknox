// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_history_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AttendanceHistoryPage extends AttendanceHistoryPage {
  @override
  final BuiltList<AttendanceHistory> data;
  @override
  final PageMeta meta;

  factory _$AttendanceHistoryPage(
          [void Function(AttendanceHistoryPageBuilder)? updates]) =>
      (AttendanceHistoryPageBuilder()..update(updates))._build();

  _$AttendanceHistoryPage._({required this.data, required this.meta})
      : super._();
  @override
  AttendanceHistoryPage rebuild(
          void Function(AttendanceHistoryPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttendanceHistoryPageBuilder toBuilder() =>
      AttendanceHistoryPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttendanceHistoryPage &&
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
    return (newBuiltValueToStringHelper(r'AttendanceHistoryPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class AttendanceHistoryPageBuilder
    implements Builder<AttendanceHistoryPage, AttendanceHistoryPageBuilder> {
  _$AttendanceHistoryPage? _$v;

  ListBuilder<AttendanceHistory>? _data;
  ListBuilder<AttendanceHistory> get data =>
      _$this._data ??= ListBuilder<AttendanceHistory>();
  set data(ListBuilder<AttendanceHistory>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  AttendanceHistoryPageBuilder() {
    AttendanceHistoryPage._defaults(this);
  }

  AttendanceHistoryPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttendanceHistoryPage other) {
    _$v = other as _$AttendanceHistoryPage;
  }

  @override
  void update(void Function(AttendanceHistoryPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttendanceHistoryPage build() => _build();

  _$AttendanceHistoryPage _build() {
    _$AttendanceHistoryPage _$result;
    try {
      _$result = _$v ??
          _$AttendanceHistoryPage._(
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
            r'AttendanceHistoryPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
