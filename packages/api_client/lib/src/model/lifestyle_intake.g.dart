// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifestyle_intake.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LifestyleIntake extends LifestyleIntake {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final String? activityLevel;
  @override
  final String? trainingHistory;
  @override
  final String? currentPainDiscomfort;
  @override
  final String? sleepHoursTypical;
  @override
  final int stressLevel;
  @override
  final String? workActivityDemands;
  @override
  final int? typicalDailySteps;
  @override
  final String? nutritionApproach;
  @override
  final String? hydrationHabits;
  @override
  final String? recoveryHabits;
  @override
  final String? otherNotes;
  @override
  final BuiltList<LifestylePriority>? lifestylePriorities;
  @override
  final int? conductedByTrainerId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  factory _$LifestyleIntake([void Function(LifestyleIntakeBuilder)? updates]) =>
      (LifestyleIntakeBuilder()..update(updates))._build();

  _$LifestyleIntake._(
      {required this.id,
      required this.memberId,
      this.activityLevel,
      this.trainingHistory,
      this.currentPainDiscomfort,
      this.sleepHoursTypical,
      required this.stressLevel,
      this.workActivityDemands,
      this.typicalDailySteps,
      this.nutritionApproach,
      this.hydrationHabits,
      this.recoveryHabits,
      this.otherNotes,
      this.lifestylePriorities,
      this.conductedByTrainerId,
      required this.createdAt,
      this.updatedAt})
      : super._();
  @override
  LifestyleIntake rebuild(void Function(LifestyleIntakeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LifestyleIntakeBuilder toBuilder() => LifestyleIntakeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LifestyleIntake &&
        id == other.id &&
        memberId == other.memberId &&
        activityLevel == other.activityLevel &&
        trainingHistory == other.trainingHistory &&
        currentPainDiscomfort == other.currentPainDiscomfort &&
        sleepHoursTypical == other.sleepHoursTypical &&
        stressLevel == other.stressLevel &&
        workActivityDemands == other.workActivityDemands &&
        typicalDailySteps == other.typicalDailySteps &&
        nutritionApproach == other.nutritionApproach &&
        hydrationHabits == other.hydrationHabits &&
        recoveryHabits == other.recoveryHabits &&
        otherNotes == other.otherNotes &&
        lifestylePriorities == other.lifestylePriorities &&
        conductedByTrainerId == other.conductedByTrainerId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, activityLevel.hashCode);
    _$hash = $jc(_$hash, trainingHistory.hashCode);
    _$hash = $jc(_$hash, currentPainDiscomfort.hashCode);
    _$hash = $jc(_$hash, sleepHoursTypical.hashCode);
    _$hash = $jc(_$hash, stressLevel.hashCode);
    _$hash = $jc(_$hash, workActivityDemands.hashCode);
    _$hash = $jc(_$hash, typicalDailySteps.hashCode);
    _$hash = $jc(_$hash, nutritionApproach.hashCode);
    _$hash = $jc(_$hash, hydrationHabits.hashCode);
    _$hash = $jc(_$hash, recoveryHabits.hashCode);
    _$hash = $jc(_$hash, otherNotes.hashCode);
    _$hash = $jc(_$hash, lifestylePriorities.hashCode);
    _$hash = $jc(_$hash, conductedByTrainerId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LifestyleIntake')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('activityLevel', activityLevel)
          ..add('trainingHistory', trainingHistory)
          ..add('currentPainDiscomfort', currentPainDiscomfort)
          ..add('sleepHoursTypical', sleepHoursTypical)
          ..add('stressLevel', stressLevel)
          ..add('workActivityDemands', workActivityDemands)
          ..add('typicalDailySteps', typicalDailySteps)
          ..add('nutritionApproach', nutritionApproach)
          ..add('hydrationHabits', hydrationHabits)
          ..add('recoveryHabits', recoveryHabits)
          ..add('otherNotes', otherNotes)
          ..add('lifestylePriorities', lifestylePriorities)
          ..add('conductedByTrainerId', conductedByTrainerId)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class LifestyleIntakeBuilder
    implements Builder<LifestyleIntake, LifestyleIntakeBuilder> {
  _$LifestyleIntake? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  String? _activityLevel;
  String? get activityLevel => _$this._activityLevel;
  set activityLevel(String? activityLevel) =>
      _$this._activityLevel = activityLevel;

  String? _trainingHistory;
  String? get trainingHistory => _$this._trainingHistory;
  set trainingHistory(String? trainingHistory) =>
      _$this._trainingHistory = trainingHistory;

  String? _currentPainDiscomfort;
  String? get currentPainDiscomfort => _$this._currentPainDiscomfort;
  set currentPainDiscomfort(String? currentPainDiscomfort) =>
      _$this._currentPainDiscomfort = currentPainDiscomfort;

  String? _sleepHoursTypical;
  String? get sleepHoursTypical => _$this._sleepHoursTypical;
  set sleepHoursTypical(String? sleepHoursTypical) =>
      _$this._sleepHoursTypical = sleepHoursTypical;

  int? _stressLevel;
  int? get stressLevel => _$this._stressLevel;
  set stressLevel(int? stressLevel) => _$this._stressLevel = stressLevel;

  String? _workActivityDemands;
  String? get workActivityDemands => _$this._workActivityDemands;
  set workActivityDemands(String? workActivityDemands) =>
      _$this._workActivityDemands = workActivityDemands;

  int? _typicalDailySteps;
  int? get typicalDailySteps => _$this._typicalDailySteps;
  set typicalDailySteps(int? typicalDailySteps) =>
      _$this._typicalDailySteps = typicalDailySteps;

  String? _nutritionApproach;
  String? get nutritionApproach => _$this._nutritionApproach;
  set nutritionApproach(String? nutritionApproach) =>
      _$this._nutritionApproach = nutritionApproach;

  String? _hydrationHabits;
  String? get hydrationHabits => _$this._hydrationHabits;
  set hydrationHabits(String? hydrationHabits) =>
      _$this._hydrationHabits = hydrationHabits;

  String? _recoveryHabits;
  String? get recoveryHabits => _$this._recoveryHabits;
  set recoveryHabits(String? recoveryHabits) =>
      _$this._recoveryHabits = recoveryHabits;

  String? _otherNotes;
  String? get otherNotes => _$this._otherNotes;
  set otherNotes(String? otherNotes) => _$this._otherNotes = otherNotes;

  ListBuilder<LifestylePriority>? _lifestylePriorities;
  ListBuilder<LifestylePriority> get lifestylePriorities =>
      _$this._lifestylePriorities ??= ListBuilder<LifestylePriority>();
  set lifestylePriorities(
          ListBuilder<LifestylePriority>? lifestylePriorities) =>
      _$this._lifestylePriorities = lifestylePriorities;

  int? _conductedByTrainerId;
  int? get conductedByTrainerId => _$this._conductedByTrainerId;
  set conductedByTrainerId(int? conductedByTrainerId) =>
      _$this._conductedByTrainerId = conductedByTrainerId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  LifestyleIntakeBuilder() {
    LifestyleIntake._defaults(this);
  }

  LifestyleIntakeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _activityLevel = $v.activityLevel;
      _trainingHistory = $v.trainingHistory;
      _currentPainDiscomfort = $v.currentPainDiscomfort;
      _sleepHoursTypical = $v.sleepHoursTypical;
      _stressLevel = $v.stressLevel;
      _workActivityDemands = $v.workActivityDemands;
      _typicalDailySteps = $v.typicalDailySteps;
      _nutritionApproach = $v.nutritionApproach;
      _hydrationHabits = $v.hydrationHabits;
      _recoveryHabits = $v.recoveryHabits;
      _otherNotes = $v.otherNotes;
      _lifestylePriorities = $v.lifestylePriorities?.toBuilder();
      _conductedByTrainerId = $v.conductedByTrainerId;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LifestyleIntake other) {
    _$v = other as _$LifestyleIntake;
  }

  @override
  void update(void Function(LifestyleIntakeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LifestyleIntake build() => _build();

  _$LifestyleIntake _build() {
    _$LifestyleIntake _$result;
    try {
      _$result = _$v ??
          _$LifestyleIntake._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'LifestyleIntake', 'id'),
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'LifestyleIntake', 'memberId'),
            activityLevel: activityLevel,
            trainingHistory: trainingHistory,
            currentPainDiscomfort: currentPainDiscomfort,
            sleepHoursTypical: sleepHoursTypical,
            stressLevel: BuiltValueNullFieldError.checkNotNull(
                stressLevel, r'LifestyleIntake', 'stressLevel'),
            workActivityDemands: workActivityDemands,
            typicalDailySteps: typicalDailySteps,
            nutritionApproach: nutritionApproach,
            hydrationHabits: hydrationHabits,
            recoveryHabits: recoveryHabits,
            otherNotes: otherNotes,
            lifestylePriorities: _lifestylePriorities?.build(),
            conductedByTrainerId: conductedByTrainerId,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'LifestyleIntake', 'createdAt'),
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lifestylePriorities';
        _lifestylePriorities?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LifestyleIntake', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
