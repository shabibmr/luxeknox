// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeUpdate extends EmployeeUpdate {
  @override
  final String? jobTitle;
  @override
  final String? department;
  @override
  final Date? hireDate;

  factory _$EmployeeUpdate([void Function(EmployeeUpdateBuilder)? updates]) =>
      (EmployeeUpdateBuilder()..update(updates))._build();

  _$EmployeeUpdate._({this.jobTitle, this.department, this.hireDate})
      : super._();
  @override
  EmployeeUpdate rebuild(void Function(EmployeeUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeeUpdateBuilder toBuilder() => EmployeeUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeUpdate &&
        jobTitle == other.jobTitle &&
        department == other.department &&
        hireDate == other.hireDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, jobTitle.hashCode);
    _$hash = $jc(_$hash, department.hashCode);
    _$hash = $jc(_$hash, hireDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeUpdate')
          ..add('jobTitle', jobTitle)
          ..add('department', department)
          ..add('hireDate', hireDate))
        .toString();
  }
}

class EmployeeUpdateBuilder
    implements Builder<EmployeeUpdate, EmployeeUpdateBuilder> {
  _$EmployeeUpdate? _$v;

  String? _jobTitle;
  String? get jobTitle => _$this._jobTitle;
  set jobTitle(String? jobTitle) => _$this._jobTitle = jobTitle;

  String? _department;
  String? get department => _$this._department;
  set department(String? department) => _$this._department = department;

  Date? _hireDate;
  Date? get hireDate => _$this._hireDate;
  set hireDate(Date? hireDate) => _$this._hireDate = hireDate;

  EmployeeUpdateBuilder() {
    EmployeeUpdate._defaults(this);
  }

  EmployeeUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _jobTitle = $v.jobTitle;
      _department = $v.department;
      _hireDate = $v.hireDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeUpdate other) {
    _$v = other as _$EmployeeUpdate;
  }

  @override
  void update(void Function(EmployeeUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeUpdate build() => _build();

  _$EmployeeUpdate _build() {
    final _$result = _$v ??
        _$EmployeeUpdate._(
          jobTitle: jobTitle,
          department: department,
          hireDate: hireDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
