// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberUpdate extends MemberUpdate {
  @override
  final String? email;
  @override
  final String? phoneNumber;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? gender;
  @override
  final Date? dateOfBirth;
  @override
  final String? address;
  @override
  final int? assignedTrainerId;
  @override
  final String? notes;

  factory _$MemberUpdate([void Function(MemberUpdateBuilder)? updates]) =>
      (MemberUpdateBuilder()..update(updates))._build();

  _$MemberUpdate._(
      {this.email,
      this.phoneNumber,
      this.firstName,
      this.lastName,
      this.gender,
      this.dateOfBirth,
      this.address,
      this.assignedTrainerId,
      this.notes})
      : super._();
  @override
  MemberUpdate rebuild(void Function(MemberUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberUpdateBuilder toBuilder() => MemberUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberUpdate &&
        email == other.email &&
        phoneNumber == other.phoneNumber &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        gender == other.gender &&
        dateOfBirth == other.dateOfBirth &&
        address == other.address &&
        assignedTrainerId == other.assignedTrainerId &&
        notes == other.notes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, gender.hashCode);
    _$hash = $jc(_$hash, dateOfBirth.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, assignedTrainerId.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberUpdate')
          ..add('email', email)
          ..add('phoneNumber', phoneNumber)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('gender', gender)
          ..add('dateOfBirth', dateOfBirth)
          ..add('address', address)
          ..add('assignedTrainerId', assignedTrainerId)
          ..add('notes', notes))
        .toString();
  }
}

class MemberUpdateBuilder
    implements Builder<MemberUpdate, MemberUpdateBuilder> {
  _$MemberUpdate? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _gender;
  String? get gender => _$this._gender;
  set gender(String? gender) => _$this._gender = gender;

  Date? _dateOfBirth;
  Date? get dateOfBirth => _$this._dateOfBirth;
  set dateOfBirth(Date? dateOfBirth) => _$this._dateOfBirth = dateOfBirth;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  int? _assignedTrainerId;
  int? get assignedTrainerId => _$this._assignedTrainerId;
  set assignedTrainerId(int? assignedTrainerId) =>
      _$this._assignedTrainerId = assignedTrainerId;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  MemberUpdateBuilder() {
    MemberUpdate._defaults(this);
  }

  MemberUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _phoneNumber = $v.phoneNumber;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _gender = $v.gender;
      _dateOfBirth = $v.dateOfBirth;
      _address = $v.address;
      _assignedTrainerId = $v.assignedTrainerId;
      _notes = $v.notes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberUpdate other) {
    _$v = other as _$MemberUpdate;
  }

  @override
  void update(void Function(MemberUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberUpdate build() => _build();

  _$MemberUpdate _build() {
    final _$result = _$v ??
        _$MemberUpdate._(
          email: email,
          phoneNumber: phoneNumber,
          firstName: firstName,
          lastName: lastName,
          gender: gender,
          dateOfBirth: dateOfBirth,
          address: address,
          assignedTrainerId: assignedTrainerId,
          notes: notes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
