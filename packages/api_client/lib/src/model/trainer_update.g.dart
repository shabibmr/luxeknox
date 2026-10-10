// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrainerUpdate extends TrainerUpdate {
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
  final String? bio;
  @override
  final BuiltList<String>? specializations;
  @override
  final String? hourlyRate;
  @override
  final int? maxClientsCapacity;
  @override
  final bool? isActive;

  factory _$TrainerUpdate([void Function(TrainerUpdateBuilder)? updates]) =>
      (TrainerUpdateBuilder()..update(updates))._build();

  _$TrainerUpdate._(
      {this.email,
      this.phoneNumber,
      this.firstName,
      this.lastName,
      this.gender,
      this.bio,
      this.specializations,
      this.hourlyRate,
      this.maxClientsCapacity,
      this.isActive})
      : super._();
  @override
  TrainerUpdate rebuild(void Function(TrainerUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainerUpdateBuilder toBuilder() => TrainerUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrainerUpdate &&
        email == other.email &&
        phoneNumber == other.phoneNumber &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        gender == other.gender &&
        bio == other.bio &&
        specializations == other.specializations &&
        hourlyRate == other.hourlyRate &&
        maxClientsCapacity == other.maxClientsCapacity &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, gender.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, specializations.hashCode);
    _$hash = $jc(_$hash, hourlyRate.hashCode);
    _$hash = $jc(_$hash, maxClientsCapacity.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TrainerUpdate')
          ..add('email', email)
          ..add('phoneNumber', phoneNumber)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('gender', gender)
          ..add('bio', bio)
          ..add('specializations', specializations)
          ..add('hourlyRate', hourlyRate)
          ..add('maxClientsCapacity', maxClientsCapacity)
          ..add('isActive', isActive))
        .toString();
  }
}

class TrainerUpdateBuilder
    implements Builder<TrainerUpdate, TrainerUpdateBuilder> {
  _$TrainerUpdate? _$v;

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

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  TrainerUpdateBuilder() {
    TrainerUpdate._defaults(this);
  }

  TrainerUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _phoneNumber = $v.phoneNumber;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _gender = $v.gender;
      _bio = $v.bio;
      _specializations = $v.specializations?.toBuilder();
      _hourlyRate = $v.hourlyRate;
      _maxClientsCapacity = $v.maxClientsCapacity;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrainerUpdate other) {
    _$v = other as _$TrainerUpdate;
  }

  @override
  void update(void Function(TrainerUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrainerUpdate build() => _build();

  _$TrainerUpdate _build() {
    _$TrainerUpdate _$result;
    try {
      _$result = _$v ??
          _$TrainerUpdate._(
            email: email,
            phoneNumber: phoneNumber,
            firstName: firstName,
            lastName: lastName,
            gender: gender,
            bio: bio,
            specializations: _specializations?.build(),
            hourlyRate: hourlyRate,
            maxClientsCapacity: maxClientsCapacity,
            isActive: isActive,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'specializations';
        _specializations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TrainerUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
