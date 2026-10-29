// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkoutPlanWriteProgressionMethodsEnum
    _$workoutPlanWriteProgressionMethodsEnum_load =
    const WorkoutPlanWriteProgressionMethodsEnum._('load');
const WorkoutPlanWriteProgressionMethodsEnum
    _$workoutPlanWriteProgressionMethodsEnum_reps =
    const WorkoutPlanWriteProgressionMethodsEnum._('reps');
const WorkoutPlanWriteProgressionMethodsEnum
    _$workoutPlanWriteProgressionMethodsEnum_volume =
    const WorkoutPlanWriteProgressionMethodsEnum._('volume');
const WorkoutPlanWriteProgressionMethodsEnum
    _$workoutPlanWriteProgressionMethodsEnum_density =
    const WorkoutPlanWriteProgressionMethodsEnum._('density');
const WorkoutPlanWriteProgressionMethodsEnum
    _$workoutPlanWriteProgressionMethodsEnum_technique =
    const WorkoutPlanWriteProgressionMethodsEnum._('technique');

WorkoutPlanWriteProgressionMethodsEnum
    _$workoutPlanWriteProgressionMethodsEnumValueOf(String name) {
  switch (name) {
    case 'load':
      return _$workoutPlanWriteProgressionMethodsEnum_load;
    case 'reps':
      return _$workoutPlanWriteProgressionMethodsEnum_reps;
    case 'volume':
      return _$workoutPlanWriteProgressionMethodsEnum_volume;
    case 'density':
      return _$workoutPlanWriteProgressionMethodsEnum_density;
    case 'technique':
      return _$workoutPlanWriteProgressionMethodsEnum_technique;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkoutPlanWriteProgressionMethodsEnum>
    _$workoutPlanWriteProgressionMethodsEnumValues = BuiltSet<
        WorkoutPlanWriteProgressionMethodsEnum>(const <WorkoutPlanWriteProgressionMethodsEnum>[
  _$workoutPlanWriteProgressionMethodsEnum_load,
  _$workoutPlanWriteProgressionMethodsEnum_reps,
  _$workoutPlanWriteProgressionMethodsEnum_volume,
  _$workoutPlanWriteProgressionMethodsEnum_density,
  _$workoutPlanWriteProgressionMethodsEnum_technique,
]);

Serializer<WorkoutPlanWriteProgressionMethodsEnum>
    _$workoutPlanWriteProgressionMethodsEnumSerializer =
    _$WorkoutPlanWriteProgressionMethodsEnumSerializer();

class _$WorkoutPlanWriteProgressionMethodsEnumSerializer
    implements PrimitiveSerializer<WorkoutPlanWriteProgressionMethodsEnum> {
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
  final Iterable<Type> types = const <Type>[
    WorkoutPlanWriteProgressionMethodsEnum
  ];
  @override
  final String wireName = 'WorkoutPlanWriteProgressionMethodsEnum';

  @override
  Object serialize(Serializers serializers,
          WorkoutPlanWriteProgressionMethodsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkoutPlanWriteProgressionMethodsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkoutPlanWriteProgressionMethodsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkoutPlanWrite extends WorkoutPlanWrite {
  @override
  final String? title;
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
  final bool? isTemplate;
  @override
  final int? rowVersion;
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
  final BuiltList<WorkoutPlanWriteProgressionMethodsEnum>? progressionMethods;
  @override
  final String? mainSuccessMeasure;
  @override
  final String? trainerProgrammingNotes;

  factory _$WorkoutPlanWrite(
          [void Function(WorkoutPlanWriteBuilder)? updates]) =>
      (WorkoutPlanWriteBuilder()..update(updates))._build();

  _$WorkoutPlanWrite._(
      {this.title,
      this.description,
      this.memberId,
      this.trainerId,
      this.targetGoal,
      this.difficulty,
      this.durationWeeks,
      this.isTemplate,
      this.rowVersion,
      this.primaryObjective12w,
      this.milestone4w,
      this.sessionsPerWeek,
      this.targetSessionDurationMinutes,
      this.splitType,
      this.cardioProtocol,
      this.mobilityProtocol,
      this.progressionMethods,
      this.mainSuccessMeasure,
      this.trainerProgrammingNotes})
      : super._();
  @override
  WorkoutPlanWrite rebuild(void Function(WorkoutPlanWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutPlanWriteBuilder toBuilder() =>
      WorkoutPlanWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutPlanWrite &&
        title == other.title &&
        description == other.description &&
        memberId == other.memberId &&
        trainerId == other.trainerId &&
        targetGoal == other.targetGoal &&
        difficulty == other.difficulty &&
        durationWeeks == other.durationWeeks &&
        isTemplate == other.isTemplate &&
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
        trainerProgrammingNotes == other.trainerProgrammingNotes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, targetGoal.hashCode);
    _$hash = $jc(_$hash, difficulty.hashCode);
    _$hash = $jc(_$hash, durationWeeks.hashCode);
    _$hash = $jc(_$hash, isTemplate.hashCode);
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkoutPlanWrite')
          ..add('title', title)
          ..add('description', description)
          ..add('memberId', memberId)
          ..add('trainerId', trainerId)
          ..add('targetGoal', targetGoal)
          ..add('difficulty', difficulty)
          ..add('durationWeeks', durationWeeks)
          ..add('isTemplate', isTemplate)
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
          ..add('trainerProgrammingNotes', trainerProgrammingNotes))
        .toString();
  }
}

class WorkoutPlanWriteBuilder
    implements Builder<WorkoutPlanWrite, WorkoutPlanWriteBuilder> {
  _$WorkoutPlanWrite? _$v;

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

  ListBuilder<WorkoutPlanWriteProgressionMethodsEnum>? _progressionMethods;
  ListBuilder<WorkoutPlanWriteProgressionMethodsEnum> get progressionMethods =>
      _$this._progressionMethods ??=
          ListBuilder<WorkoutPlanWriteProgressionMethodsEnum>();
  set progressionMethods(
          ListBuilder<WorkoutPlanWriteProgressionMethodsEnum>?
              progressionMethods) =>
      _$this._progressionMethods = progressionMethods;

  String? _mainSuccessMeasure;
  String? get mainSuccessMeasure => _$this._mainSuccessMeasure;
  set mainSuccessMeasure(String? mainSuccessMeasure) =>
      _$this._mainSuccessMeasure = mainSuccessMeasure;

  String? _trainerProgrammingNotes;
  String? get trainerProgrammingNotes => _$this._trainerProgrammingNotes;
  set trainerProgrammingNotes(String? trainerProgrammingNotes) =>
      _$this._trainerProgrammingNotes = trainerProgrammingNotes;

  WorkoutPlanWriteBuilder() {
    WorkoutPlanWrite._defaults(this);
  }

  WorkoutPlanWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _description = $v.description;
      _memberId = $v.memberId;
      _trainerId = $v.trainerId;
      _targetGoal = $v.targetGoal;
      _difficulty = $v.difficulty;
      _durationWeeks = $v.durationWeeks;
      _isTemplate = $v.isTemplate;
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutPlanWrite other) {
    _$v = other as _$WorkoutPlanWrite;
  }

  @override
  void update(void Function(WorkoutPlanWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkoutPlanWrite build() => _build();

  _$WorkoutPlanWrite _build() {
    _$WorkoutPlanWrite _$result;
    try {
      _$result = _$v ??
          _$WorkoutPlanWrite._(
            title: title,
            description: description,
            memberId: memberId,
            trainerId: trainerId,
            targetGoal: targetGoal,
            difficulty: difficulty,
            durationWeeks: durationWeeks,
            isTemplate: isTemplate,
            rowVersion: rowVersion,
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
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'progressionMethods';
        _progressionMethods?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkoutPlanWrite', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
