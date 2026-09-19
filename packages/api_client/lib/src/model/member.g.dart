// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract class MemberBuilder {
  void replace(Member other);
  void update(void Function(MemberBuilder) updates);
  int? get id;
  set id(int? id);

  int? get userId;
  set userId(int? userId);

  String? get membershipNumber;
  set membershipNumber(String? membershipNumber);

  String? get firstName;
  set firstName(String? firstName);

  String? get lastName;
  set lastName(String? lastName);

  String? get gender;
  set gender(String? gender);

  Date? get dateOfBirth;
  set dateOfBirth(Date? dateOfBirth);

  String? get address;
  set address(String? address);

  int? get assignedTrainerId;
  set assignedTrainerId(int? assignedTrainerId);

  Date? get joinedDate;
  set joinedDate(Date? joinedDate);

  String? get notes;
  set notes(String? notes);

  UserBuilder get user;
  set user(UserBuilder? user);
}

class _$$Member extends $Member {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String membershipNumber;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? gender;
  @override
  final Date? dateOfBirth;
  @override
  final String? address;
  @override
  final int? assignedTrainerId;
  @override
  final Date? joinedDate;
  @override
  final String? notes;
  @override
  final User? user;

  factory _$$Member([void Function($MemberBuilder)? updates]) =>
      ($MemberBuilder()..update(updates))._build();

  _$$Member._(
      {required this.id,
      required this.userId,
      required this.membershipNumber,
      required this.firstName,
      required this.lastName,
      this.gender,
      this.dateOfBirth,
      this.address,
      this.assignedTrainerId,
      this.joinedDate,
      this.notes,
      this.user})
      : super._();
  @override
  $Member rebuild(void Function($MemberBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $MemberBuilder toBuilder() => $MemberBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $Member &&
        id == other.id &&
        userId == other.userId &&
        membershipNumber == other.membershipNumber &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        gender == other.gender &&
        dateOfBirth == other.dateOfBirth &&
        address == other.address &&
        assignedTrainerId == other.assignedTrainerId &&
        joinedDate == other.joinedDate &&
        notes == other.notes &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, membershipNumber.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, gender.hashCode);
    _$hash = $jc(_$hash, dateOfBirth.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, assignedTrainerId.hashCode);
    _$hash = $jc(_$hash, joinedDate.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'$Member')
          ..add('id', id)
          ..add('userId', userId)
          ..add('membershipNumber', membershipNumber)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('gender', gender)
          ..add('dateOfBirth', dateOfBirth)
          ..add('address', address)
          ..add('assignedTrainerId', assignedTrainerId)
          ..add('joinedDate', joinedDate)
          ..add('notes', notes)
          ..add('user', user))
        .toString();
  }
}

class $MemberBuilder
    implements Builder<$Member, $MemberBuilder>, MemberBuilder {
  _$$Member? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(covariant int? id) => _$this._id = id;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(covariant int? userId) => _$this._userId = userId;

  String? _membershipNumber;
  String? get membershipNumber => _$this._membershipNumber;
  set membershipNumber(covariant String? membershipNumber) =>
      _$this._membershipNumber = membershipNumber;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(covariant String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(covariant String? lastName) => _$this._lastName = lastName;

  String? _gender;
  String? get gender => _$this._gender;
  set gender(covariant String? gender) => _$this._gender = gender;

  Date? _dateOfBirth;
  Date? get dateOfBirth => _$this._dateOfBirth;
  set dateOfBirth(covariant Date? dateOfBirth) =>
      _$this._dateOfBirth = dateOfBirth;

  String? _address;
  String? get address => _$this._address;
  set address(covariant String? address) => _$this._address = address;

  int? _assignedTrainerId;
  int? get assignedTrainerId => _$this._assignedTrainerId;
  set assignedTrainerId(covariant int? assignedTrainerId) =>
      _$this._assignedTrainerId = assignedTrainerId;

  Date? _joinedDate;
  Date? get joinedDate => _$this._joinedDate;
  set joinedDate(covariant Date? joinedDate) => _$this._joinedDate = joinedDate;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(covariant String? notes) => _$this._notes = notes;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= UserBuilder();
  set user(covariant UserBuilder? user) => _$this._user = user;

  $MemberBuilder() {
    $Member._defaults(this);
  }

  $MemberBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _membershipNumber = $v.membershipNumber;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _gender = $v.gender;
      _dateOfBirth = $v.dateOfBirth;
      _address = $v.address;
      _assignedTrainerId = $v.assignedTrainerId;
      _joinedDate = $v.joinedDate;
      _notes = $v.notes;
      _user = $v.user?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant $Member other) {
    _$v = other as _$$Member;
  }

  @override
  void update(void Function($MemberBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $Member build() => _build();

  _$$Member _build() {
    _$$Member _$result;
    try {
      _$result = _$v ??
          _$$Member._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'$Member', 'id'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'$Member', 'userId'),
            membershipNumber: BuiltValueNullFieldError.checkNotNull(
                membershipNumber, r'$Member', 'membershipNumber'),
            firstName: BuiltValueNullFieldError.checkNotNull(
                firstName, r'$Member', 'firstName'),
            lastName: BuiltValueNullFieldError.checkNotNull(
                lastName, r'$Member', 'lastName'),
            gender: gender,
            dateOfBirth: dateOfBirth,
            address: address,
            assignedTrainerId: assignedTrainerId,
            joinedDate: joinedDate,
            notes: notes,
            user: _user?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'$Member', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
