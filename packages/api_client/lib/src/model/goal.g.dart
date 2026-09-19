// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GoalStatusEnum _$goalStatusEnum_inProgress =
    const GoalStatusEnum._('inProgress');
const GoalStatusEnum _$goalStatusEnum_achieved =
    const GoalStatusEnum._('achieved');
const GoalStatusEnum _$goalStatusEnum_abandoned =
    const GoalStatusEnum._('abandoned');

GoalStatusEnum _$goalStatusEnumValueOf(String name) {
  switch (name) {
    case 'inProgress':
      return _$goalStatusEnum_inProgress;
    case 'achieved':
      return _$goalStatusEnum_achieved;
    case 'abandoned':
      return _$goalStatusEnum_abandoned;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GoalStatusEnum> _$goalStatusEnumValues =
    BuiltSet<GoalStatusEnum>(const <GoalStatusEnum>[
  _$goalStatusEnum_inProgress,
  _$goalStatusEnum_achieved,
  _$goalStatusEnum_abandoned,
]);

Serializer<GoalStatusEnum> _$goalStatusEnumSerializer =
    _$GoalStatusEnumSerializer();

class _$GoalStatusEnumSerializer
    implements PrimitiveSerializer<GoalStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'inProgress': 'in_progress',
    'achieved': 'achieved',
    'abandoned': 'abandoned',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'in_progress': 'inProgress',
    'achieved': 'achieved',
    'abandoned': 'abandoned',
  };

  @override
  final Iterable<Type> types = const <Type>[GoalStatusEnum];
  @override
  final String wireName = 'GoalStatusEnum';

  @override
  Object serialize(Serializers serializers, GoalStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GoalStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GoalStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$Goal extends Goal {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final int metricId;
  @override
  final num? baselineValue;
  @override
  final num? targetValue;
  @override
  final num? currentValue;
  @override
  final Date? startDate;
  @override
  final Date? targetDate;
  @override
  final GoalStatusEnum status;
  @override
  final GoalMetric? metric;

  factory _$Goal([void Function(GoalBuilder)? updates]) =>
      (GoalBuilder()..update(updates))._build();

  _$Goal._(
      {required this.id,
      required this.memberId,
      required this.metricId,
      this.baselineValue,
      this.targetValue,
      this.currentValue,
      this.startDate,
      this.targetDate,
      required this.status,
      this.metric})
      : super._();
  @override
  Goal rebuild(void Function(GoalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoalBuilder toBuilder() => GoalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Goal &&
        id == other.id &&
        memberId == other.memberId &&
        metricId == other.metricId &&
        baselineValue == other.baselineValue &&
        targetValue == other.targetValue &&
        currentValue == other.currentValue &&
        startDate == other.startDate &&
        targetDate == other.targetDate &&
        status == other.status &&
        metric == other.metric;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, metricId.hashCode);
    _$hash = $jc(_$hash, baselineValue.hashCode);
    _$hash = $jc(_$hash, targetValue.hashCode);
    _$hash = $jc(_$hash, currentValue.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, targetDate.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, metric.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Goal')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('metricId', metricId)
          ..add('baselineValue', baselineValue)
          ..add('targetValue', targetValue)
          ..add('currentValue', currentValue)
          ..add('startDate', startDate)
          ..add('targetDate', targetDate)
          ..add('status', status)
          ..add('metric', metric))
        .toString();
  }
}

class GoalBuilder implements Builder<Goal, GoalBuilder> {
  _$Goal? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _metricId;
  int? get metricId => _$this._metricId;
  set metricId(int? metricId) => _$this._metricId = metricId;

  num? _baselineValue;
  num? get baselineValue => _$this._baselineValue;
  set baselineValue(num? baselineValue) =>
      _$this._baselineValue = baselineValue;

  num? _targetValue;
  num? get targetValue => _$this._targetValue;
  set targetValue(num? targetValue) => _$this._targetValue = targetValue;

  num? _currentValue;
  num? get currentValue => _$this._currentValue;
  set currentValue(num? currentValue) => _$this._currentValue = currentValue;

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(Date? startDate) => _$this._startDate = startDate;

  Date? _targetDate;
  Date? get targetDate => _$this._targetDate;
  set targetDate(Date? targetDate) => _$this._targetDate = targetDate;

  GoalStatusEnum? _status;
  GoalStatusEnum? get status => _$this._status;
  set status(GoalStatusEnum? status) => _$this._status = status;

  GoalMetricBuilder? _metric;
  GoalMetricBuilder get metric => _$this._metric ??= GoalMetricBuilder();
  set metric(GoalMetricBuilder? metric) => _$this._metric = metric;

  GoalBuilder() {
    Goal._defaults(this);
  }

  GoalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _metricId = $v.metricId;
      _baselineValue = $v.baselineValue;
      _targetValue = $v.targetValue;
      _currentValue = $v.currentValue;
      _startDate = $v.startDate;
      _targetDate = $v.targetDate;
      _status = $v.status;
      _metric = $v.metric?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Goal other) {
    _$v = other as _$Goal;
  }

  @override
  void update(void Function(GoalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Goal build() => _build();

  _$Goal _build() {
    _$Goal _$result;
    try {
      _$result = _$v ??
          _$Goal._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Goal', 'id'),
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'Goal', 'memberId'),
            metricId: BuiltValueNullFieldError.checkNotNull(
                metricId, r'Goal', 'metricId'),
            baselineValue: baselineValue,
            targetValue: targetValue,
            currentValue: currentValue,
            startDate: startDate,
            targetDate: targetDate,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'Goal', 'status'),
            metric: _metric?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'metric';
        _metric?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Goal', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
