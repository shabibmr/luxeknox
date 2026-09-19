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

Serializer<WorkoutPlanStatusEnum> _$workoutPlanStatusEnumSerializer =
    _$WorkoutPlanStatusEnumSerializer();

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
            currentVersion: _currentVersion?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
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
