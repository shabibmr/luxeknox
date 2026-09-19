// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer_availability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrainerAvailability extends TrainerAvailability {
  @override
  final int id;
  @override
  final int trainerId;
  @override
  final int? dayOfWeek;
  @override
  final String? startTime;
  @override
  final String? endTime;
  @override
  final bool? isRecurring;
  @override
  final Date? overrideDate;
  @override
  final bool isAvailable;

  factory _$TrainerAvailability(
          [void Function(TrainerAvailabilityBuilder)? updates]) =>
      (TrainerAvailabilityBuilder()..update(updates))._build();

  _$TrainerAvailability._(
      {required this.id,
      required this.trainerId,
      this.dayOfWeek,
      this.startTime,
      this.endTime,
      this.isRecurring,
      this.overrideDate,
      required this.isAvailable})
      : super._();
  @override
  TrainerAvailability rebuild(
          void Function(TrainerAvailabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainerAvailabilityBuilder toBuilder() =>
      TrainerAvailabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrainerAvailability &&
        id == other.id &&
        trainerId == other.trainerId &&
        dayOfWeek == other.dayOfWeek &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        isRecurring == other.isRecurring &&
        overrideDate == other.overrideDate &&
        isAvailable == other.isAvailable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, dayOfWeek.hashCode);
    _$hash = $jc(_$hash, startTime.hashCode);
    _$hash = $jc(_$hash, endTime.hashCode);
    _$hash = $jc(_$hash, isRecurring.hashCode);
    _$hash = $jc(_$hash, overrideDate.hashCode);
    _$hash = $jc(_$hash, isAvailable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TrainerAvailability')
          ..add('id', id)
          ..add('trainerId', trainerId)
          ..add('dayOfWeek', dayOfWeek)
          ..add('startTime', startTime)
          ..add('endTime', endTime)
          ..add('isRecurring', isRecurring)
          ..add('overrideDate', overrideDate)
          ..add('isAvailable', isAvailable))
        .toString();
  }
}

class TrainerAvailabilityBuilder
    implements Builder<TrainerAvailability, TrainerAvailabilityBuilder> {
  _$TrainerAvailability? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  int? _dayOfWeek;
  int? get dayOfWeek => _$this._dayOfWeek;
  set dayOfWeek(int? dayOfWeek) => _$this._dayOfWeek = dayOfWeek;

  String? _startTime;
  String? get startTime => _$this._startTime;
  set startTime(String? startTime) => _$this._startTime = startTime;

  String? _endTime;
  String? get endTime => _$this._endTime;
  set endTime(String? endTime) => _$this._endTime = endTime;

  bool? _isRecurring;
  bool? get isRecurring => _$this._isRecurring;
  set isRecurring(bool? isRecurring) => _$this._isRecurring = isRecurring;

  Date? _overrideDate;
  Date? get overrideDate => _$this._overrideDate;
  set overrideDate(Date? overrideDate) => _$this._overrideDate = overrideDate;

  bool? _isAvailable;
  bool? get isAvailable => _$this._isAvailable;
  set isAvailable(bool? isAvailable) => _$this._isAvailable = isAvailable;

  TrainerAvailabilityBuilder() {
    TrainerAvailability._defaults(this);
  }

  TrainerAvailabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _trainerId = $v.trainerId;
      _dayOfWeek = $v.dayOfWeek;
      _startTime = $v.startTime;
      _endTime = $v.endTime;
      _isRecurring = $v.isRecurring;
      _overrideDate = $v.overrideDate;
      _isAvailable = $v.isAvailable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrainerAvailability other) {
    _$v = other as _$TrainerAvailability;
  }

  @override
  void update(void Function(TrainerAvailabilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrainerAvailability build() => _build();

  _$TrainerAvailability _build() {
    final _$result = _$v ??
        _$TrainerAvailability._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'TrainerAvailability', 'id'),
          trainerId: BuiltValueNullFieldError.checkNotNull(
              trainerId, r'TrainerAvailability', 'trainerId'),
          dayOfWeek: dayOfWeek,
          startTime: startTime,
          endTime: endTime,
          isRecurring: isRecurring,
          overrideDate: overrideDate,
          isAvailable: BuiltValueNullFieldError.checkNotNull(
              isAvailable, r'TrainerAvailability', 'isAvailable'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
