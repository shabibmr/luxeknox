// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrainerCreate extends TrainerCreate {
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
  final String? bio;
  @override
  final BuiltList<String>? specializations;
  @override
  final String? hourlyRate;
  @override
  final int? maxClientsCapacity;

  factory _$TrainerCreate([void Function(TrainerCreateBuilder)? updates]) =>
      (TrainerCreateBuilder()..update(updates))._build();

  _$TrainerCreate._(
      {required this.email,
      this.phoneNumber,
      this.password,
      required this.firstName,
      required this.lastName,
      this.bio,
      this.specializations,
      this.hourlyRate,
      this.maxClientsCapacity})
      : super._();
  @override
  TrainerCreate rebuild(void Function(TrainerCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainerCreateBuilder toBuilder() => TrainerCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrainerCreate &&
        email == other.email &&
        phoneNumber == other.phoneNumber &&
        password == other.password &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        bio == other.bio &&
        specializations == other.specializations &&
        hourlyRate == other.hourlyRate &&
        maxClientsCapacity == other.maxClientsCapacity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, specializations.hashCode);
    _$hash = $jc(_$hash, hourlyRate.hashCode);
    _$hash = $jc(_$hash, maxClientsCapacity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TrainerCreate')
          ..add('email', email)
          ..add('phoneNumber', phoneNumber)
          ..add('password', password)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('bio', bio)
          ..add('specializations', specializations)
          ..add('hourlyRate', hourlyRate)
          ..add('maxClientsCapacity', maxClientsCapacity))
        .toString();
  }
}

class TrainerCreateBuilder
    implements Builder<TrainerCreate, TrainerCreateBuilder> {
  _$TrainerCreate? _$v;

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

  String? _bio;
  String? get bio => _$this._bio;
  set bio(String? bio) => _$this._bio = bio;

  ListBuilder<String>? _specializations;
  ListBuilder<String> get specializations =>
      _$this._specializations ??= ListBuilder<String>();
  set specializations(ListBuilder<String>? specializations) =>
      _$this._specializations = specializations;

  String? _hourlyRate;
  String? get hourlyRate => _$this._hourlyRate;
  set hourlyRate(String? hourlyRate) => _$this._hourlyRate = hourlyRate;

  int? _maxClientsCapacity;
  int? get maxClientsCapacity => _$this._maxClientsCapacity;
  set maxClientsCapacity(int? maxClientsCapacity) =>
      _$this._maxClientsCapacity = maxClientsCapacity;

  TrainerCreateBuilder() {
    TrainerCreate._defaults(this);
  }

  TrainerCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _phoneNumber = $v.phoneNumber;
      _password = $v.password;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _bio = $v.bio;
      _specializations = $v.specializations?.toBuilder();
      _hourlyRate = $v.hourlyRate;
      _maxClientsCapacity = $v.maxClientsCapacity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrainerCreate other) {
    _$v = other as _$TrainerCreate;
  }

  @override
  void update(void Function(TrainerCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrainerCreate build() => _build();

  _$TrainerCreate _build() {
    _$TrainerCreate _$result;
    try {
      _$result = _$v ??
          _$TrainerCreate._(
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'TrainerCreate', 'email'),
            phoneNumber: phoneNumber,
            password: password,
            firstName: BuiltValueNullFieldError.checkNotNull(
                firstName, r'TrainerCreate', 'firstName'),
            lastName: BuiltValueNullFieldError.checkNotNull(
                lastName, r'TrainerCreate', 'lastName'),
            bio: bio,
            specializations: _specializations?.build(),
            hourlyRate: hourlyRate,
            maxClientsCapacity: maxClientsCapacity,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'specializations';
        _specializations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TrainerCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
