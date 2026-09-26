// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Employee extends Employee {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String jobTitle;
  @override
  final String? department;
  @override
  final Date? hireDate;
  @override
  final EmployeeStatus status;
  @override
  final int roleId;

  factory _$Employee([void Function(EmployeeBuilder)? updates]) =>
      (EmployeeBuilder()..update(updates))._build();

  _$Employee._(
      {required this.id,
      required this.userId,
      required this.firstName,
      required this.lastName,
      required this.jobTitle,
      this.department,
      this.hireDate,
      required this.status,
      required this.roleId})
      : super._();
  @override
  Employee rebuild(void Function(EmployeeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeeBuilder toBuilder() => EmployeeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Employee &&
        id == other.id &&
        userId == other.userId &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        jobTitle == other.jobTitle &&
        department == other.department &&
        hireDate == other.hireDate &&
        status == other.status &&
        roleId == other.roleId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, jobTitle.hashCode);
    _$hash = $jc(_$hash, department.hashCode);
    _$hash = $jc(_$hash, hireDate.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, roleId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Employee')
          ..add('id', id)
          ..add('userId', userId)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('jobTitle', jobTitle)
          ..add('department', department)
          ..add('hireDate', hireDate)
          ..add('status', status)
          ..add('roleId', roleId))
        .toString();
  }
}

class EmployeeBuilder implements Builder<Employee, EmployeeBuilder> {
  _$Employee? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _jobTitle;
  String? get jobTitle => _$this._jobTitle;
  set jobTitle(String? jobTitle) => _$this._jobTitle = jobTitle;

  String? _department;
  String? get department => _$this._department;
  set department(String? department) => _$this._department = department;

  Date? _hireDate;
  Date? get hireDate => _$this._hireDate;
  set hireDate(Date? hireDate) => _$this._hireDate = hireDate;

  EmployeeStatus? _status;
  EmployeeStatus? get status => _$this._status;
  set status(EmployeeStatus? status) => _$this._status = status;

  int? _roleId;
  int? get roleId => _$this._roleId;
  set roleId(int? roleId) => _$this._roleId = roleId;

  EmployeeBuilder() {
    Employee._defaults(this);
  }

  EmployeeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _jobTitle = $v.jobTitle;
      _department = $v.department;
      _hireDate = $v.hireDate;
      _status = $v.status;
      _roleId = $v.roleId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Employee other) {
    _$v = other as _$Employee;
  }

  @override
  void update(void Function(EmployeeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Employee build() => _build();

  _$Employee _build() {
    final _$result = _$v ??
        _$Employee._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Employee', 'id'),
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'Employee', 'userId'),
          firstName: BuiltValueNullFieldError.checkNotNull(
              firstName, r'Employee', 'firstName'),
          lastName: BuiltValueNullFieldError.checkNotNull(
              lastName, r'Employee', 'lastName'),
          jobTitle: BuiltValueNullFieldError.checkNotNull(
              jobTitle, r'Employee', 'jobTitle'),
          department: department,
          hireDate: hireDate,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'Employee', 'status'),
          roleId: BuiltValueNullFieldError.checkNotNull(
              roleId, r'Employee', 'roleId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
