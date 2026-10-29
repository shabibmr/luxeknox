// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkoutPlanStatusEnum _$workoutPlanStatusEnum_active =
    const WorkoutPlanStatusEnum._('active');
const WorkoutPlanStatusEnum _$workoutPlanStatusEnum_archived =
    const WorkoutPlanStatusEnum._('archived');
const WorkoutPlanStatusEnum _$workoutPlanStatusEnum_draft =
    const WorkoutPlanStatusEnum._('draft');

WorkoutPlanStatusEnum _$workoutPlanStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$workoutPlanStatusEnum_active;
    case 'archived':
      return _$workoutPlanStatusEnum_archived;
    case 'draft':
      return _$workoutPlanStatusEnum_draft;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkoutPlanStatusEnum> _$workoutPlanStatusEnumValues =
    BuiltSet<WorkoutPlanStatusEnum>(const <WorkoutPlanStatusEnum>[
  _$workoutPlanStatusEnum_active,
  _$workoutPlanStatusEnum_archived,
  _$workoutPlanStatusEnum_draft,
]);

const WorkoutPlanProgressionMethodsEnum
    _$workoutPlanProgressionMethodsEnum_load =
    const WorkoutPlanProgressionMethodsEnum._('load');
const WorkoutPlanProgressionMethodsEnum
    _$workoutPlanProgressionMethodsEnum_reps =
    const WorkoutPlanProgressionMethodsEnum._('reps');
const WorkoutPlanProgressionMethodsEnum
    _$workoutPlanProgressionMethodsEnum_volume =
    const WorkoutPlanProgressionMethodsEnum._('volume');
const WorkoutPlanProgressionMethodsEnum
    _$workoutPlanProgressionMethodsEnum_density =
    const WorkoutPlanProgressionMethodsEnum._('density');
const WorkoutPlanProgressionMethodsEnum
    _$workoutPlanProgressionMethodsEnum_technique =
    const WorkoutPlanProgressionMethodsEnum._('technique');

WorkoutPlanProgressionMethodsEnum _$workoutPlanProgressionMethodsEnumValueOf(
    String name) {
  switch (name) {
    case 'load':
      return _$workoutPlanProgressionMethodsEnum_load;
    case 'reps':
      return _$workoutPlanProgressionMethodsEnum_reps;
    case 'volume':
      return _$workoutPlanProgressionMethodsEnum_volume;
    case 'density':
      return _$workoutPlanProgressionMethodsEnum_density;
    case 'technique':
      return _$workoutPlanProgressionMethodsEnum_technique;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkoutPlanProgressionMethodsEnum>
    _$workoutPlanProgressionMethodsEnumValues = BuiltSet<
        WorkoutPlanProgressionMethodsEnum>(const <WorkoutPlanProgressionMethodsEnum>[
  _$workoutPlanProgressionMethodsEnum_load,
  _$workoutPlanProgressionMethodsEnum_reps,
  _$workoutPlanProgressionMethodsEnum_volume,
  _$workoutPlanProgressionMethodsEnum_density,
  _$workoutPlanProgressionMethodsEnum_technique,
]);

Serializer<WorkoutPlanStatusEnum> _$workoutPlanStatusEnumSerializer =
    _$WorkoutPlanStatusEnumSerializer();
Serializer<WorkoutPlanProgressionMethodsEnum>
    _$workoutPlanProgressionMethodsEnumSerializer =
    _$WorkoutPlanProgressionMethodsEnumSerializer();

class _$WorkoutPlanStatusEnumSerializer
    implements PrimitiveSerializer<WorkoutPlanStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'archived': 'archived',
    'draft': 'draft',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'archived': 'archived',
    'draft': 'draft',
  };

  @override
  final Iterable<Type> types = const <Type>[WorkoutPlanStatusEnum];
  @override
  final String wireName = 'WorkoutPlanStatusEnum';

  @override
  Object serialize(Serializers serializers, WorkoutPlanStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkoutPlanStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkoutPlanStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkoutPlanProgressionMethodsEnumSerializer
    implements PrimitiveSerializer<WorkoutPlanProgressionMethodsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'load': 'load',
    'reps': 'reps',
    'volume': 'volume',
    'density': 'density',
    'technique': 'technique',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'load': 'load',
    'reps': 'reps',
    'volume': 'volume',
    'density': 'density',
    'technique': 'technique',
  };

  @override
  final Iterable<Type> types = const <Type>[WorkoutPlanProgressionMethodsEnum];
  @override
  final String wireName = 'WorkoutPlanProgressionMethodsEnum';

  @override
  Object serialize(
          Serializers serializers, WorkoutPlanProgressionMethodsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkoutPlanProgressionMethodsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkoutPlanProgressionMethodsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkoutPlan extends WorkoutPlan {
  @override
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final int? memberId;
  @override
  final int? trainerId;
  @override
  final String? targetGoal;
  @override
  final String? difficulty;
  @override
  final int? durationWeeks;
  @override
  final bool isTemplate;
  @override
  final WorkoutPlanStatusEnum status;
  @override
  final DateTime? createdAt;
  @override
  final int rowVersion;
  @override
  final String? primaryObjective12w;
  @override
  final String? milestone4w;
  @override
  final int? sessionsPerWeek;
  @override
  final int? targetSessionDurationMinutes;
  @override
  final String? splitType;
  @override
  final String? cardioProtocol;
  @override
  final String? mobilityProtocol;
  @override
  final BuiltList<WorkoutPlanProgressionMethodsEnum>? progressionMethods;
  @override
  final String? mainSuccessMeasure;
  @override
  final String? trainerProgrammingNotes;
  @override
  final WorkoutPlanVersion? currentVersion;

  factory _$WorkoutPlan([void Function(WorkoutPlanBuilder)? updates]) =>
      (WorkoutPlanBuilder()..update(updates))._build();

  _$WorkoutPlan._(
      {required this.id,
      required this.title,
      this.description,
      this.memberId,
      this.trainerId,
      this.targetGoal,
      this.difficulty,
      this.durationWeeks,
      required this.isTemplate,
      required this.status,
      this.createdAt,
      required this.rowVersion,
      this.primaryObjective12w,
      this.milestone4w,
      this.sessionsPerWeek,
      this.targetSessionDurationMinutes,
      this.splitType,
      this.cardioProtocol,
      this.mobilityProtocol,
      this.progressionMethods,
      this.mainSuccessMeasure,
      this.trainerProgrammingNotes,
      this.currentVersion})
      : super._();
  @override
  WorkoutPlan rebuild(void Function(WorkoutPlanBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutPlanBuilder toBuilder() => WorkoutPlanBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutPlan &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        memberId == other.memberId &&
        trainerId == other.trainerId &&
        targetGoal == other.targetGoal &&
        difficulty == other.difficulty &&
        durationWeeks == other.durationWeeks &&
        isTemplate == other.isTemplate &&
        status == other.status &&
        createdAt == other.createdAt &&
        rowVersion == other.rowVersion &&
        primaryObjective12w == other.primaryObjective12w &&
        milestone4w == other.milestone4w &&
        sessionsPerWeek == other.sessionsPerWeek &&
        targetSessionDurationMinutes == other.targetSessionDurationMinutes &&
        splitType == other.splitType &&
        cardioProtocol == other.cardioProtocol &&
        mobilityProtocol == other.mobilityProtocol &&
        progressionMethods == other.progressionMethods &&
        mainSuccessMeasure == other.mainSuccessMeasure &&
        trainerProgrammingNotes == other.trainerProgrammingNotes &&
        currentVersion == other.currentVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, targetGoal.hashCode);
    _$hash = $jc(_$hash, difficulty.hashCode);
    _$hash = $jc(_$hash, durationWeeks.hashCode);
    _$hash = $jc(_$hash, isTemplate.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, primaryObjective12w.hashCode);
    _$hash = $jc(_$hash, milestone4w.hashCode);
    _$hash = $jc(_$hash, sessionsPerWeek.hashCode);
    _$hash = $jc(_$hash, targetSessionDurationMinutes.hashCode);
    _$hash = $jc(_$hash, splitType.hashCode);
    _$hash = $jc(_$hash, cardioProtocol.hashCode);
    _$hash = $jc(_$hash, mobilityProtocol.hashCode);
    _$hash = $jc(_$hash, progressionMethods.hashCode);
    _$hash = $jc(_$hash, mainSuccessMeasure.hashCode);
    _$hash = $jc(_$hash, trainerProgrammingNotes.hashCode);
    _$hash = $jc(_$hash, currentVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkoutPlan')
          ..add('id', id)
          ..add('title', title)
          ..add('description', description)
          ..add('memberId', memberId)
          ..add('trainerId', trainerId)
          ..add('targetGoal', targetGoal)
          ..add('difficulty', difficulty)
          ..add('durationWeeks', durationWeeks)
          ..add('isTemplate', isTemplate)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('rowVersion', rowVersion)
          ..add('primaryObjective12w', primaryObjective12w)
          ..add('milestone4w', milestone4w)
          ..add('sessionsPerWeek', sessionsPerWeek)
          ..add('targetSessionDurationMinutes', targetSessionDurationMinutes)
          ..add('splitType', splitType)
          ..add('cardioProtocol', cardioProtocol)
          ..add('mobilityProtocol', mobilityProtocol)
          ..add('progressionMethods', progressionMethods)
          ..add('mainSuccessMeasure', mainSuccessMeasure)
          ..add('trainerProgrammingNotes', trainerProgrammingNotes)
          ..add('currentVersion', currentVersion))
        .toString();
  }
}

class WorkoutPlanBuilder implements Builder<WorkoutPlan, WorkoutPlanBuilder> {
  _$WorkoutPlan? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  String? _targetGoal;
  String? get targetGoal => _$this._targetGoal;
  set targetGoal(String? targetGoal) => _$this._targetGoal = targetGoal;

  String? _difficulty;
  String? get difficulty => _$this._difficulty;
  set difficulty(String? difficulty) => _$this._difficulty = difficulty;

  int? _durationWeeks;
  int? get durationWeeks => _$this._durationWeeks;
  set durationWeeks(int? durationWeeks) =>
      _$this._durationWeeks = durationWeeks;

  bool? _isTemplate;
  bool? get isTemplate => _$this._isTemplate;
  set isTemplate(bool? isTemplate) => _$this._isTemplate = isTemplate;

  WorkoutPlanStatusEnum? _status;
  WorkoutPlanStatusEnum? get status => _$this._status;
  set status(WorkoutPlanStatusEnum? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  String? _primaryObjective12w;
  String? get primaryObjective12w => _$this._primaryObjective12w;
  set primaryObjective12w(String? primaryObjective12w) =>
      _$this._primaryObjective12w = primaryObjective12w;

  String? _milestone4w;
  String? get milestone4w => _$this._milestone4w;
  set milestone4w(String? milestone4w) => _$this._milestone4w = milestone4w;

  int? _sessionsPerWeek;
  int? get sessionsPerWeek => _$this._sessionsPerWeek;
  set sessionsPerWeek(int? sessionsPerWeek) =>
      _$this._sessionsPerWeek = sessionsPerWeek;

  int? _targetSessionDurationMinutes;
  int? get targetSessionDurationMinutes => _$this._targetSessionDurationMinutes;
  set targetSessionDurationMinutes(int? targetSessionDurationMinutes) =>
      _$this._targetSessionDurationMinutes = targetSessionDurationMinutes;

  String? _splitType;
  String? get splitType => _$this._splitType;
  set splitType(String? splitType) => _$this._splitType = splitType;

  String? _cardioProtocol;
  String? get cardioProtocol => _$this._cardioProtocol;
  set cardioProtocol(String? cardioProtocol) =>
      _$this._cardioProtocol = cardioProtocol;

  String? _mobilityProtocol;
  String? get mobilityProtocol => _$this._mobilityProtocol;
  set mobilityProtocol(String? mobilityProtocol) =>
      _$this._mobilityProtocol = mobilityProtocol;

  ListBuilder<WorkoutPlanProgressionMethodsEnum>? _progressionMethods;
  ListBuilder<WorkoutPlanProgressionMethodsEnum> get progressionMethods =>
      _$this._progressionMethods ??=
          ListBuilder<WorkoutPlanProgressionMethodsEnum>();
  set progressionMethods(
          ListBuilder<WorkoutPlanProgressionMethodsEnum>? progressionMethods) =>
      _$this._progressionMethods = progressionMethods;

  String? _mainSuccessMeasure;
  String? get mainSuccessMeasure => _$this._mainSuccessMeasure;
  set mainSuccessMeasure(String? mainSuccessMeasure) =>
      _$this._mainSuccessMeasure = mainSuccessMeasure;

  String? _trainerProgrammingNotes;
  String? get trainerProgrammingNotes => _$this._trainerProgrammingNotes;
  set trainerProgrammingNotes(String? trainerProgrammingNotes) =>
      _$this._trainerProgrammingNotes = trainerProgrammingNotes;

  WorkoutPlanVersionBuilder? _currentVersion;
  WorkoutPlanVersionBuilder get currentVersion =>
      _$this._currentVersion ??= WorkoutPlanVersionBuilder();
  set currentVersion(WorkoutPlanVersionBuilder? currentVersion) =>
      _$this._currentVersion = currentVersion;

  WorkoutPlanBuilder() {
    WorkoutPlan._defaults(this);
  }

  WorkoutPlanBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _description = $v.description;
      _memberId = $v.memberId;
      _trainerId = $v.trainerId;
      _targetGoal = $v.targetGoal;
      _difficulty = $v.difficulty;
      _durationWeeks = $v.durationWeeks;
      _isTemplate = $v.isTemplate;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _rowVersion = $v.rowVersion;
      _primaryObjective12w = $v.primaryObjective12w;
      _milestone4w = $v.milestone4w;
      _sessionsPerWeek = $v.sessionsPerWeek;
      _targetSessionDurationMinutes = $v.targetSessionDurationMinutes;
      _splitType = $v.splitType;
      _cardioProtocol = $v.cardioProtocol;
      _mobilityProtocol = $v.mobilityProtocol;
      _progressionMethods = $v.progressionMethods?.toBuilder();
      _mainSuccessMeasure = $v.mainSuccessMeasure;
      _trainerProgrammingNotes = $v.trainerProgrammingNotes;
      _currentVersion = $v.currentVersion?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutPlan other) {
    _$v = other as _$WorkoutPlan;
  }

  @override
  void update(void Function(WorkoutPlanBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutPlan build() => _build();

  _$WorkoutPlan _build() {
    _$WorkoutPlan _$result;
    try {
      _$result = _$v ??
          _$WorkoutPlan._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'WorkoutPlan', 'id'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'WorkoutPlan', 'title'),
            description: description,
            memberId: memberId,
            trainerId: trainerId,
            targetGoal: targetGoal,
            difficulty: difficulty,
            durationWeeks: durationWeeks,
            isTemplate: BuiltValueNullFieldError.checkNotNull(
                isTemplate, r'WorkoutPlan', 'isTemplate'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'WorkoutPlan', 'status'),
            createdAt: createdAt,
            rowVersion: BuiltValueNullFieldError.checkNotNull(
                rowVersion, r'WorkoutPlan', 'rowVersion'),
            primaryObjective12w: primaryObjective12w,
            milestone4w: milestone4w,
            sessionsPerWeek: sessionsPerWeek,
            targetSessionDurationMinutes: targetSessionDurationMinutes,
            splitType: splitType,
            cardioProtocol: cardioProtocol,
            mobilityProtocol: mobilityProtocol,
            progressionMethods: _progressionMethods?.build(),
            mainSuccessMeasure: mainSuccessMeasure,
            trainerProgrammingNotes: trainerProgrammingNotes,
            currentVersion: _currentVersion?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'progressionMethods';
        _progressionMethods?.build();

        _$failedField = 'currentVersion';
        _currentVersion?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkoutPlan', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
