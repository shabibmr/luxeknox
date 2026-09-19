// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Trainer extends Trainer {
  @override
  final int id;
  @override
  final int userId;
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
  final num? rating;
  @override
  final int? maxClientsCapacity;
  @override
  final bool isActive;
  @override
  final int? assignedActiveCount;

  factory _$Trainer([void Function(TrainerBuilder)? updates]) =>
      (TrainerBuilder()..update(updates))._build();

  _$Trainer._(
      {required this.id,
      required this.userId,
      required this.firstName,
      required this.lastName,
      this.bio,
      this.specializations,
      this.hourlyRate,
      this.rating,
      this.maxClientsCapacity,
      required this.isActive,
      this.assignedActiveCount})
      : super._();
  @override
  Trainer rebuild(void Function(TrainerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainerBuilder toBuilder() => TrainerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Trainer &&
        id == other.id &&
        userId == other.userId &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        bio == other.bio &&
        specializations == other.specializations &&
        hourlyRate == other.hourlyRate &&
        rating == other.rating &&
        maxClientsCapacity == other.maxClientsCapacity &&
        isActive == other.isActive &&
        assignedActiveCount == other.assignedActiveCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, specializations.hashCode);
    _$hash = $jc(_$hash, hourlyRate.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, maxClientsCapacity.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, assignedActiveCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Trainer')
          ..add('id', id)
          ..add('userId', userId)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('bio', bio)
          ..add('specializations', specializations)
          ..add('hourlyRate', hourlyRate)
          ..add('rating', rating)
          ..add('maxClientsCapacity', maxClientsCapacity)
          ..add('isActive', isActive)
          ..add('assignedActiveCount', assignedActiveCount))
        .toString();
  }
}

class TrainerBuilder implements Builder<Trainer, TrainerBuilder> {
  _$Trainer? _$v;

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

  num? _rating;
  num? get rating => _$this._rating;
  set rating(num? rating) => _$this._rating = rating;

  int? _maxClientsCapacity;
  int? get maxClientsCapacity => _$this._maxClientsCapacity;
  set maxClientsCapacity(int? maxClientsCapacity) =>
      _$this._maxClientsCapacity = maxClientsCapacity;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  int? _assignedActiveCount;
  int? get assignedActiveCount => _$this._assignedActiveCount;
  set assignedActiveCount(int? assignedActiveCount) =>
      _$this._assignedActiveCount = assignedActiveCount;

  TrainerBuilder() {
    Trainer._defaults(this);
  }

  TrainerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _bio = $v.bio;
      _specializations = $v.specializations?.toBuilder();
      _hourlyRate = $v.hourlyRate;
      _rating = $v.rating;
      _maxClientsCapacity = $v.maxClientsCapacity;
      _isActive = $v.isActive;
      _assignedActiveCount = $v.assignedActiveCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Trainer other) {
    _$v = other as _$Trainer;
  }

  @override
  void update(void Function(TrainerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Trainer build() => _build();

  _$Trainer _build() {
    _$Trainer _$result;
    try {
      _$result = _$v ??
          _$Trainer._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Trainer', 'id'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'Trainer', 'userId'),
            firstName: BuiltValueNullFieldError.checkNotNull(
                firstName, r'Trainer', 'firstName'),
            lastName: BuiltValueNullFieldError.checkNotNull(
                lastName, r'Trainer', 'lastName'),
            bio: bio,
            specializations: _specializations?.build(),
            hourlyRate: hourlyRate,
            rating: rating,
            maxClientsCapacity: maxClientsCapacity,
            isActive: BuiltValueNullFieldError.checkNotNull(
                isActive, r'Trainer', 'isActive'),
            assignedActiveCount: assignedActiveCount,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'specializations';
        _specializations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Trainer', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
