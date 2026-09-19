// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DietPlanStatusEnum _$dietPlanStatusEnum_draft =
    const DietPlanStatusEnum._('draft');
const DietPlanStatusEnum _$dietPlanStatusEnum_active =
    const DietPlanStatusEnum._('active');
const DietPlanStatusEnum _$dietPlanStatusEnum_archived =
    const DietPlanStatusEnum._('archived');

DietPlanStatusEnum _$dietPlanStatusEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$dietPlanStatusEnum_draft;
    case 'active':
      return _$dietPlanStatusEnum_active;
    case 'archived':
      return _$dietPlanStatusEnum_archived;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DietPlanStatusEnum> _$dietPlanStatusEnumValues =
    BuiltSet<DietPlanStatusEnum>(const <DietPlanStatusEnum>[
  _$dietPlanStatusEnum_draft,
  _$dietPlanStatusEnum_active,
  _$dietPlanStatusEnum_archived,
]);

Serializer<DietPlanStatusEnum> _$dietPlanStatusEnumSerializer =
    _$DietPlanStatusEnumSerializer();

class _$DietPlanStatusEnumSerializer
    implements PrimitiveSerializer<DietPlanStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'active': 'active',
    'archived': 'archived',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'active': 'active',
    'archived': 'archived',
  };

  @override
  final Iterable<Type> types = const <Type>[DietPlanStatusEnum];
  @override
  final String wireName = 'DietPlanStatusEnum';

  @override
  Object serialize(Serializers serializers, DietPlanStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DietPlanStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DietPlanStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DietPlan extends DietPlan {
  @override
  final int id;
  @override
  final String title;
  @override
  final int? memberId;
  @override
  final int? trainerId;
  @override
  final int? dailyCalorieTarget;
  @override
  final num? proteinTargetG;
  @override
  final num? carbsTargetG;
  @override
  final num? fatTargetG;
  @override
  final bool isTemplate;
  @override
  final DietPlanStatusEnum status;
  @override
  final DateTime? createdAt;
  @override
  final int rowVersion;
  @override
  final DietPlanVersion? currentVersion;

  factory _$DietPlan([void Function(DietPlanBuilder)? updates]) =>
      (DietPlanBuilder()..update(updates))._build();

  _$DietPlan._(
      {required this.id,
      required this.title,
      this.memberId,
      this.trainerId,
      this.dailyCalorieTarget,
      this.proteinTargetG,
      this.carbsTargetG,
      this.fatTargetG,
      required this.isTemplate,
      required this.status,
      this.createdAt,
      required this.rowVersion,
      this.currentVersion})
      : super._();
  @override
  DietPlan rebuild(void Function(DietPlanBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietPlanBuilder toBuilder() => DietPlanBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietPlan &&
        id == other.id &&
        title == other.title &&
        memberId == other.memberId &&
        trainerId == other.trainerId &&
        dailyCalorieTarget == other.dailyCalorieTarget &&
        proteinTargetG == other.proteinTargetG &&
        carbsTargetG == other.carbsTargetG &&
        fatTargetG == other.fatTargetG &&
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
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, dailyCalorieTarget.hashCode);
    _$hash = $jc(_$hash, proteinTargetG.hashCode);
    _$hash = $jc(_$hash, carbsTargetG.hashCode);
    _$hash = $jc(_$hash, fatTargetG.hashCode);
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
    return (newBuiltValueToStringHelper(r'DietPlan')
          ..add('id', id)
          ..add('title', title)
          ..add('memberId', memberId)
          ..add('trainerId', trainerId)
          ..add('dailyCalorieTarget', dailyCalorieTarget)
          ..add('proteinTargetG', proteinTargetG)
          ..add('carbsTargetG', carbsTargetG)
          ..add('fatTargetG', fatTargetG)
          ..add('isTemplate', isTemplate)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('rowVersion', rowVersion)
          ..add('currentVersion', currentVersion))
        .toString();
  }
}

class DietPlanBuilder implements Builder<DietPlan, DietPlanBuilder> {
  _$DietPlan? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  int? _dailyCalorieTarget;
  int? get dailyCalorieTarget => _$this._dailyCalorieTarget;
  set dailyCalorieTarget(int? dailyCalorieTarget) =>
      _$this._dailyCalorieTarget = dailyCalorieTarget;

  num? _proteinTargetG;
  num? get proteinTargetG => _$this._proteinTargetG;
  set proteinTargetG(num? proteinTargetG) =>
      _$this._proteinTargetG = proteinTargetG;

  num? _carbsTargetG;
  num? get carbsTargetG => _$this._carbsTargetG;
  set carbsTargetG(num? carbsTargetG) => _$this._carbsTargetG = carbsTargetG;

  num? _fatTargetG;
  num? get fatTargetG => _$this._fatTargetG;
  set fatTargetG(num? fatTargetG) => _$this._fatTargetG = fatTargetG;

  bool? _isTemplate;
  bool? get isTemplate => _$this._isTemplate;
  set isTemplate(bool? isTemplate) => _$this._isTemplate = isTemplate;

  DietPlanStatusEnum? _status;
  DietPlanStatusEnum? get status => _$this._status;
  set status(DietPlanStatusEnum? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  DietPlanVersionBuilder? _currentVersion;
  DietPlanVersionBuilder get currentVersion =>
      _$this._currentVersion ??= DietPlanVersionBuilder();
  set currentVersion(DietPlanVersionBuilder? currentVersion) =>
      _$this._currentVersion = currentVersion;

  DietPlanBuilder() {
    DietPlan._defaults(this);
  }

  DietPlanBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _memberId = $v.memberId;
      _trainerId = $v.trainerId;
      _dailyCalorieTarget = $v.dailyCalorieTarget;
      _proteinTargetG = $v.proteinTargetG;
      _carbsTargetG = $v.carbsTargetG;
      _fatTargetG = $v.fatTargetG;
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
  void replace(DietPlan other) {
    _$v = other as _$DietPlan;
  }

  @override
  void update(void Function(DietPlanBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietPlan build() => _build();

  _$DietPlan _build() {
    _$DietPlan _$result;
    try {
      _$result = _$v ??
          _$DietPlan._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'DietPlan', 'id'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'DietPlan', 'title'),
            memberId: memberId,
            trainerId: trainerId,
            dailyCalorieTarget: dailyCalorieTarget,
            proteinTargetG: proteinTargetG,
            carbsTargetG: carbsTargetG,
            fatTargetG: fatTargetG,
            isTemplate: BuiltValueNullFieldError.checkNotNull(
                isTemplate, r'DietPlan', 'isTemplate'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'DietPlan', 'status'),
            createdAt: createdAt,
            rowVersion: BuiltValueNullFieldError.checkNotNull(
                rowVersion, r'DietPlan', 'rowVersion'),
            currentVersion: _currentVersion?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'currentVersion';
        _currentVersion?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DietPlan', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
