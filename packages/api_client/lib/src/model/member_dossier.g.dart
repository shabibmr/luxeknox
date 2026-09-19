// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_dossier.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberDossier extends MemberDossier {
  @override
  final Schedule? nextSchedule;
  @override
  final Membership? membership;
  @override
  final DateTime? lastCheckIn;
  @override
  final String? outstandingBalance;
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

  factory _$MemberDossier([void Function(MemberDossierBuilder)? updates]) =>
      (MemberDossierBuilder()..update(updates))._build();

  _$MemberDossier._(
      {this.nextSchedule,
      this.membership,
      this.lastCheckIn,
      this.outstandingBalance,
      required this.id,
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
  MemberDossier rebuild(void Function(MemberDossierBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberDossierBuilder toBuilder() => MemberDossierBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberDossier &&
        nextSchedule == other.nextSchedule &&
        membership == other.membership &&
        lastCheckIn == other.lastCheckIn &&
        outstandingBalance == other.outstandingBalance &&
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
    _$hash = $jc(_$hash, nextSchedule.hashCode);
    _$hash = $jc(_$hash, membership.hashCode);
    _$hash = $jc(_$hash, lastCheckIn.hashCode);
    _$hash = $jc(_$hash, outstandingBalance.hashCode);
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
    return (newBuiltValueToStringHelper(r'MemberDossier')
          ..add('nextSchedule', nextSchedule)
          ..add('membership', membership)
          ..add('lastCheckIn', lastCheckIn)
          ..add('outstandingBalance', outstandingBalance)
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

class MemberDossierBuilder
    implements Builder<MemberDossier, MemberDossierBuilder>, MemberBuilder {
  _$MemberDossier? _$v;

  ScheduleBuilder? _nextSchedule;
  ScheduleBuilder get nextSchedule =>
      _$this._nextSchedule ??= ScheduleBuilder();
  set nextSchedule(covariant ScheduleBuilder? nextSchedule) =>
      _$this._nextSchedule = nextSchedule;

  MembershipBuilder? _membership;
  MembershipBuilder get membership =>
      _$this._membership ??= MembershipBuilder();
  set membership(covariant MembershipBuilder? membership) =>
      _$this._membership = membership;

  DateTime? _lastCheckIn;
  DateTime? get lastCheckIn => _$this._lastCheckIn;
  set lastCheckIn(covariant DateTime? lastCheckIn) =>
      _$this._lastCheckIn = lastCheckIn;

  String? _outstandingBalance;
  String? get outstandingBalance => _$this._outstandingBalance;
  set outstandingBalance(covariant String? outstandingBalance) =>
      _$this._outstandingBalance = outstandingBalance;

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

  MemberDossierBuilder() {
    MemberDossier._defaults(this);
  }

  MemberDossierBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nextSchedule = $v.nextSchedule?.toBuilder();
      _membership = $v.membership?.toBuilder();
      _lastCheckIn = $v.lastCheckIn;
      _outstandingBalance = $v.outstandingBalance;
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
  void replace(covariant MemberDossier other) {
    _$v = other as _$MemberDossier;
  }

  @override
  void update(void Function(MemberDossierBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberDossier build() => _build();

  _$MemberDossier _build() {
    _$MemberDossier _$result;
    try {
      _$result = _$v ??
          _$MemberDossier._(
            nextSchedule: _nextSchedule?.build(),
            membership: _membership?.build(),
            lastCheckIn: lastCheckIn,
            outstandingBalance: outstandingBalance,
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'MemberDossier', 'id'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'MemberDossier', 'userId'),
            membershipNumber: BuiltValueNullFieldError.checkNotNull(
                membershipNumber, r'MemberDossier', 'membershipNumber'),
            firstName: BuiltValueNullFieldError.checkNotNull(
                firstName, r'MemberDossier', 'firstName'),
            lastName: BuiltValueNullFieldError.checkNotNull(
                lastName, r'MemberDossier', 'lastName'),
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
        _$failedField = 'nextSchedule';
        _nextSchedule?.build();
        _$failedField = 'membership';
        _membership?.build();

        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MemberDossier', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
