// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeePage extends EmployeePage {
  @override
  final BuiltList<Employee> data;
  @override
  final PageMeta meta;

  factory _$EmployeePage([void Function(EmployeePageBuilder)? updates]) =>
      (EmployeePageBuilder()..update(updates))._build();

  _$EmployeePage._({required this.data, required this.meta}) : super._();
  @override
  EmployeePage rebuild(void Function(EmployeePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeePageBuilder toBuilder() => EmployeePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeePage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'EmployeePage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class EmployeePageBuilder
    implements Builder<EmployeePage, EmployeePageBuilder> {
  _$EmployeePage? _$v;

  ListBuilder<Employee>? _data;
  ListBuilder<Employee> get data => _$this._data ??= ListBuilder<Employee>();
  set data(ListBuilder<Employee>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  EmployeePageBuilder() {
    EmployeePage._defaults(this);
  }

  EmployeePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeePage other) {
    _$v = other as _$EmployeePage;
  }

  @override
  void update(void Function(EmployeePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeePage build() => _build();

  _$EmployeePage _build() {
    _$EmployeePage _$result;
    try {
      _$result = _$v ??
          _$EmployeePage._(
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
            r'EmployeePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
