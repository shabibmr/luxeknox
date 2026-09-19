// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeCreate extends EmployeeCreate {
  @override
  final String email;
  @override
  final String? phoneNumber;
  @override
  final String? password;
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
  final int roleId;

  factory _$EmployeeCreate([void Function(EmployeeCreateBuilder)? updates]) =>
      (EmployeeCreateBuilder()..update(updates))._build();

  _$EmployeeCreate._(
      {required this.email,
      this.phoneNumber,
      this.password,
      required this.firstName,
      required this.lastName,
      required this.jobTitle,
      this.department,
      this.hireDate,
      required this.roleId})
      : super._();
  @override
  EmployeeCreate rebuild(void Function(EmployeeCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeeCreateBuilder toBuilder() => EmployeeCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeCreate &&
        email == other.email &&
        phoneNumber == other.phoneNumber &&
        password == other.password &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        jobTitle == other.jobTitle &&
        department == other.department &&
        hireDate == other.hireDate &&
        roleId == other.roleId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, jobTitle.hashCode);
    _$hash = $jc(_$hash, department.hashCode);
    _$hash = $jc(_$hash, hireDate.hashCode);
    _$hash = $jc(_$hash, roleId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeCreate')
          ..add('email', email)
          ..add('phoneNumber', phoneNumber)
          ..add('password', password)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('jobTitle', jobTitle)
          ..add('department', department)
          ..add('hireDate', hireDate)
          ..add('roleId', roleId))
        .toString();
  }
}

class EmployeeCreateBuilder
    implements Builder<EmployeeCreate, EmployeeCreateBuilder> {
  _$EmployeeCreate? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

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

  int? _roleId;
  int? get roleId => _$this._roleId;
  set roleId(int? roleId) => _$this._roleId = roleId;

  EmployeeCreateBuilder() {
    EmployeeCreate._defaults(this);
  }

  EmployeeCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _phoneNumber = $v.phoneNumber;
      _password = $v.password;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _jobTitle = $v.jobTitle;
      _department = $v.department;
      _hireDate = $v.hireDate;
      _roleId = $v.roleId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeCreate other) {
    _$v = other as _$EmployeeCreate;
  }

  @override
  void update(void Function(EmployeeCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeCreate build() => _build();

  _$EmployeeCreate _build() {
    final _$result = _$v ??
        _$EmployeeCreate._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'EmployeeCreate', 'email'),
          phoneNumber: phoneNumber,
          password: password,
          firstName: BuiltValueNullFieldError.checkNotNull(
              firstName, r'EmployeeCreate', 'firstName'),
          lastName: BuiltValueNullFieldError.checkNotNull(
              lastName, r'EmployeeCreate', 'lastName'),
          jobTitle: BuiltValueNullFieldError.checkNotNull(
              jobTitle, r'EmployeeCreate', 'jobTitle'),
          department: department,
          hireDate: hireDate,
          roleId: BuiltValueNullFieldError.checkNotNull(
              roleId, r'EmployeeCreate', 'roleId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
