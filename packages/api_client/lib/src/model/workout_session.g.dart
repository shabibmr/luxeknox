// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkoutSession extends WorkoutSession {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final int? workoutPlanId;
  @override
  final int? workoutPlanVersionId;
  @override
  final int? trainerId;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;
  @override
  final num? totalVolumeKg;
  @override
  final int? durationMinutes;
  @override
  final int? clientFeedbackRating;
  @override
  final int? effortRating;
  @override
  final int? satisfactionRating;
  @override
  final int? painDiscomfortScore;
  @override
  final String? painNotes;
  @override
  final String? sessionFocus;
  @override
  final String? warmupProtocol;
  @override
  final String? cooldownProtocol;
  @override
  final String? trainerNotes;
  @override
  final String? nextSessionPlan;
  @override
  final DateTime? clientSignedAt;
  @override
  final DateTime? trainerSignedAt;
  @override
  final String? notes;
  @override
  final BuiltList<WorkoutSessionExercise>? sets;

  factory _$WorkoutSession([void Function(WorkoutSessionBuilder)? updates]) =>
      (WorkoutSessionBuilder()..update(updates))._build();

  _$WorkoutSession._(
      {required this.id,
      required this.memberId,
      this.workoutPlanId,
      this.workoutPlanVersionId,
      this.trainerId,
      required this.startedAt,
      this.completedAt,
      this.totalVolumeKg,
      this.durationMinutes,
      this.clientFeedbackRating,
      this.effortRating,
      this.satisfactionRating,
      this.painDiscomfortScore,
      this.painNotes,
      this.sessionFocus,
      this.warmupProtocol,
      this.cooldownProtocol,
      this.trainerNotes,
      this.nextSessionPlan,
      this.clientSignedAt,
      this.trainerSignedAt,
      this.notes,
      this.sets})
      : super._();
  @override
  WorkoutSession rebuild(void Function(WorkoutSessionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutSessionBuilder toBuilder() => WorkoutSessionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutSession &&
        id == other.id &&
        memberId == other.memberId &&
        workoutPlanId == other.workoutPlanId &&
        workoutPlanVersionId == other.workoutPlanVersionId &&
        trainerId == other.trainerId &&
        startedAt == other.startedAt &&
        completedAt == other.completedAt &&
        totalVolumeKg == other.totalVolumeKg &&
        durationMinutes == other.durationMinutes &&
        clientFeedbackRating == other.clientFeedbackRating &&
        effortRating == other.effortRating &&
        satisfactionRating == other.satisfactionRating &&
        painDiscomfortScore == other.painDiscomfortScore &&
        painNotes == other.painNotes &&
        sessionFocus == other.sessionFocus &&
        warmupProtocol == other.warmupProtocol &&
        cooldownProtocol == other.cooldownProtocol &&
        trainerNotes == other.trainerNotes &&
        nextSessionPlan == other.nextSessionPlan &&
        clientSignedAt == other.clientSignedAt &&
        trainerSignedAt == other.trainerSignedAt &&
        notes == other.notes &&
        sets == other.sets;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, workoutPlanId.hashCode);
    _$hash = $jc(_$hash, workoutPlanVersionId.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, totalVolumeKg.hashCode);
    _$hash = $jc(_$hash, durationMinutes.hashCode);
    _$hash = $jc(_$hash, clientFeedbackRating.hashCode);
    _$hash = $jc(_$hash, effortRating.hashCode);
    _$hash = $jc(_$hash, satisfactionRating.hashCode);
    _$hash = $jc(_$hash, painDiscomfortScore.hashCode);
    _$hash = $jc(_$hash, painNotes.hashCode);
    _$hash = $jc(_$hash, sessionFocus.hashCode);
    _$hash = $jc(_$hash, warmupProtocol.hashCode);
    _$hash = $jc(_$hash, cooldownProtocol.hashCode);
    _$hash = $jc(_$hash, trainerNotes.hashCode);
    _$hash = $jc(_$hash, nextSessionPlan.hashCode);
    _$hash = $jc(_$hash, clientSignedAt.hashCode);
    _$hash = $jc(_$hash, trainerSignedAt.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, sets.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkoutSession')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('workoutPlanId', workoutPlanId)
          ..add('workoutPlanVersionId', workoutPlanVersionId)
          ..add('trainerId', trainerId)
          ..add('startedAt', startedAt)
          ..add('completedAt', completedAt)
          ..add('totalVolumeKg', totalVolumeKg)
          ..add('durationMinutes', durationMinutes)
          ..add('clientFeedbackRating', clientFeedbackRating)
          ..add('effortRating', effortRating)
          ..add('satisfactionRating', satisfactionRating)
          ..add('painDiscomfortScore', painDiscomfortScore)
          ..add('painNotes', painNotes)
          ..add('sessionFocus', sessionFocus)
          ..add('warmupProtocol', warmupProtocol)
          ..add('cooldownProtocol', cooldownProtocol)
          ..add('trainerNotes', trainerNotes)
          ..add('nextSessionPlan', nextSessionPlan)
          ..add('clientSignedAt', clientSignedAt)
          ..add('trainerSignedAt', trainerSignedAt)
          ..add('notes', notes)
          ..add('sets', sets))
        .toString();
  }
}

class WorkoutSessionBuilder
    implements Builder<WorkoutSession, WorkoutSessionBuilder> {
  _$WorkoutSession? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _workoutPlanId;
  int? get workoutPlanId => _$this._workoutPlanId;
  set workoutPlanId(int? workoutPlanId) =>
      _$this._workoutPlanId = workoutPlanId;

  int? _workoutPlanVersionId;
  int? get workoutPlanVersionId => _$this._workoutPlanVersionId;
  set workoutPlanVersionId(int? workoutPlanVersionId) =>
      _$this._workoutPlanVersionId = workoutPlanVersionId;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  num? _totalVolumeKg;
  num? get totalVolumeKg => _$this._totalVolumeKg;
  set totalVolumeKg(num? totalVolumeKg) =>
      _$this._totalVolumeKg = totalVolumeKg;

  int? _durationMinutes;
  int? get durationMinutes => _$this._durationMinutes;
  set durationMinutes(int? durationMinutes) =>
      _$this._durationMinutes = durationMinutes;

  int? _clientFeedbackRating;
  int? get clientFeedbackRating => _$this._clientFeedbackRating;
  set clientFeedbackRating(int? clientFeedbackRating) =>
      _$this._clientFeedbackRating = clientFeedbackRating;

  int? _effortRating;
  int? get effortRating => _$this._effortRating;
  set effortRating(int? effortRating) => _$this._effortRating = effortRating;

  int? _satisfactionRating;
  int? get satisfactionRating => _$this._satisfactionRating;
  set satisfactionRating(int? satisfactionRating) =>
      _$this._satisfactionRating = satisfactionRating;

  int? _painDiscomfortScore;
  int? get painDiscomfortScore => _$this._painDiscomfortScore;
  set painDiscomfortScore(int? painDiscomfortScore) =>
      _$this._painDiscomfortScore = painDiscomfortScore;

  String? _painNotes;
  String? get painNotes => _$this._painNotes;
  set painNotes(String? painNotes) => _$this._painNotes = painNotes;

  String? _sessionFocus;
  String? get sessionFocus => _$this._sessionFocus;
  set sessionFocus(String? sessionFocus) => _$this._sessionFocus = sessionFocus;

  String? _warmupProtocol;
  String? get warmupProtocol => _$this._warmupProtocol;
  set warmupProtocol(String? warmupProtocol) =>
      _$this._warmupProtocol = warmupProtocol;

  String? _cooldownProtocol;
  String? get cooldownProtocol => _$this._cooldownProtocol;
  set cooldownProtocol(String? cooldownProtocol) =>
      _$this._cooldownProtocol = cooldownProtocol;

  String? _trainerNotes;
  String? get trainerNotes => _$this._trainerNotes;
  set trainerNotes(String? trainerNotes) => _$this._trainerNotes = trainerNotes;

  String? _nextSessionPlan;
  String? get nextSessionPlan => _$this._nextSessionPlan;
  set nextSessionPlan(String? nextSessionPlan) =>
      _$this._nextSessionPlan = nextSessionPlan;

  DateTime? _clientSignedAt;
  DateTime? get clientSignedAt => _$this._clientSignedAt;
  set clientSignedAt(DateTime? clientSignedAt) =>
      _$this._clientSignedAt = clientSignedAt;

  DateTime? _trainerSignedAt;
  DateTime? get trainerSignedAt => _$this._trainerSignedAt;
  set trainerSignedAt(DateTime? trainerSignedAt) =>
      _$this._trainerSignedAt = trainerSignedAt;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  ListBuilder<WorkoutSessionExercise>? _sets;
  ListBuilder<WorkoutSessionExercise> get sets =>
      _$this._sets ??= ListBuilder<WorkoutSessionExercise>();
  set sets(ListBuilder<WorkoutSessionExercise>? sets) => _$this._sets = sets;

  WorkoutSessionBuilder() {
    WorkoutSession._defaults(this);
  }

  WorkoutSessionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _workoutPlanId = $v.workoutPlanId;
      _workoutPlanVersionId = $v.workoutPlanVersionId;
      _trainerId = $v.trainerId;
      _startedAt = $v.startedAt;
      _completedAt = $v.completedAt;
      _totalVolumeKg = $v.totalVolumeKg;
      _durationMinutes = $v.durationMinutes;
      _clientFeedbackRating = $v.clientFeedbackRating;
      _effortRating = $v.effortRating;
      _satisfactionRating = $v.satisfactionRating;
      _painDiscomfortScore = $v.painDiscomfortScore;
      _painNotes = $v.painNotes;
      _sessionFocus = $v.sessionFocus;
      _warmupProtocol = $v.warmupProtocol;
      _cooldownProtocol = $v.cooldownProtocol;
      _trainerNotes = $v.trainerNotes;
      _nextSessionPlan = $v.nextSessionPlan;
      _clientSignedAt = $v.clientSignedAt;
      _trainerSignedAt = $v.trainerSignedAt;
      _notes = $v.notes;
      _sets = $v.sets?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutSession other) {
    _$v = other as _$WorkoutSession;
  }

  @override
  void update(void Function(WorkoutSessionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutSession build() => _build();

  _$WorkoutSession _build() {
    _$WorkoutSession _$result;
    try {
      _$result = _$v ??
          _$WorkoutSession._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'WorkoutSession', 'id'),
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'WorkoutSession', 'memberId'),
            workoutPlanId: workoutPlanId,
            workoutPlanVersionId: workoutPlanVersionId,
            trainerId: trainerId,
            startedAt: BuiltValueNullFieldError.checkNotNull(
                startedAt, r'WorkoutSession', 'startedAt'),
            completedAt: completedAt,
            totalVolumeKg: totalVolumeKg,
            durationMinutes: durationMinutes,
            clientFeedbackRating: clientFeedbackRating,
            effortRating: effortRating,
            satisfactionRating: satisfactionRating,
            painDiscomfortScore: painDiscomfortScore,
            painNotes: painNotes,
            sessionFocus: sessionFocus,
            warmupProtocol: warmupProtocol,
            cooldownProtocol: cooldownProtocol,
            trainerNotes: trainerNotes,
            nextSessionPlan: nextSessionPlan,
            clientSignedAt: clientSignedAt,
            trainerSignedAt: trainerSignedAt,
            notes: notes,
            sets: _sets?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sets';
        _sets?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkoutSession', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
