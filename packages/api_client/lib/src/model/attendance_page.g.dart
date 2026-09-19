// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AttendancePage extends AttendancePage {
  @override
  final BuiltList<Attendance> data;
  @override
  final PageMeta meta;

  factory _$AttendancePage([void Function(AttendancePageBuilder)? updates]) =>
      (AttendancePageBuilder()..update(updates))._build();

  _$AttendancePage._({required this.data, required this.meta}) : super._();
  @override
  AttendancePage rebuild(void Function(AttendancePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttendancePageBuilder toBuilder() => AttendancePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttendancePage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'AttendancePage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class AttendancePageBuilder
    implements Builder<AttendancePage, AttendancePageBuilder> {
  _$AttendancePage? _$v;

  ListBuilder<Attendance>? _data;
  ListBuilder<Attendance> get data =>
      _$this._data ??= ListBuilder<Attendance>();
  set data(ListBuilder<Attendance>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  AttendancePageBuilder() {
    AttendancePage._defaults(this);
  }

  AttendancePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttendancePage other) {
    _$v = other as _$AttendancePage;
  }

  @override
  void update(void Function(AttendancePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttendancePage build() => _build();

  _$AttendancePage _build() {
    _$AttendancePage _$result;
    try {
      _$result = _$v ??
          _$AttendancePage._(
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
            r'AttendancePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
