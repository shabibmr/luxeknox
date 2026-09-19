// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GoalWriteStatusEnum _$goalWriteStatusEnum_inProgress =
    const GoalWriteStatusEnum._('inProgress');
const GoalWriteStatusEnum _$goalWriteStatusEnum_achieved =
    const GoalWriteStatusEnum._('achieved');
const GoalWriteStatusEnum _$goalWriteStatusEnum_abandoned =
    const GoalWriteStatusEnum._('abandoned');

GoalWriteStatusEnum _$goalWriteStatusEnumValueOf(String name) {
  switch (name) {
    case 'inProgress':
      return _$goalWriteStatusEnum_inProgress;
    case 'achieved':
      return _$goalWriteStatusEnum_achieved;
    case 'abandoned':
      return _$goalWriteStatusEnum_abandoned;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GoalWriteStatusEnum> _$goalWriteStatusEnumValues =
    BuiltSet<GoalWriteStatusEnum>(const <GoalWriteStatusEnum>[
  _$goalWriteStatusEnum_inProgress,
  _$goalWriteStatusEnum_achieved,
  _$goalWriteStatusEnum_abandoned,
]);

Serializer<GoalWriteStatusEnum> _$goalWriteStatusEnumSerializer =
    _$GoalWriteStatusEnumSerializer();

class _$GoalWriteStatusEnumSerializer
    implements PrimitiveSerializer<GoalWriteStatusEnum> {
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
  final Iterable<Type> types = const <Type>[GoalWriteStatusEnum];
  @override
  final String wireName = 'GoalWriteStatusEnum';

  @override
  Object serialize(Serializers serializers, GoalWriteStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GoalWriteStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GoalWriteStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GoalWrite extends GoalWrite {
  @override
  final int? metricId;
  @override
  final num? baselineValue;
  @override
  final num? targetValue;
  @override
  final Date? startDate;
  @override
  final Date? targetDate;
  @override
  final GoalWriteStatusEnum? status;

  factory _$GoalWrite([void Function(GoalWriteBuilder)? updates]) =>
      (GoalWriteBuilder()..update(updates))._build();

  _$GoalWrite._(
      {this.metricId,
      this.baselineValue,
      this.targetValue,
      this.startDate,
      this.targetDate,
      this.status})
      : super._();
  @override
  GoalWrite rebuild(void Function(GoalWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoalWriteBuilder toBuilder() => GoalWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoalWrite &&
        metricId == other.metricId &&
        baselineValue == other.baselineValue &&
        targetValue == other.targetValue &&
        startDate == other.startDate &&
        targetDate == other.targetDate &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, metricId.hashCode);
    _$hash = $jc(_$hash, baselineValue.hashCode);
    _$hash = $jc(_$hash, targetValue.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, targetDate.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoalWrite')
          ..add('metricId', metricId)
          ..add('baselineValue', baselineValue)
          ..add('targetValue', targetValue)
          ..add('startDate', startDate)
          ..add('targetDate', targetDate)
          ..add('status', status))
        .toString();
  }
}

class GoalWriteBuilder implements Builder<GoalWrite, GoalWriteBuilder> {
  _$GoalWrite? _$v;

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

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(Date? startDate) => _$this._startDate = startDate;

  Date? _targetDate;
  Date? get targetDate => _$this._targetDate;
  set targetDate(Date? targetDate) => _$this._targetDate = targetDate;

  GoalWriteStatusEnum? _status;
  GoalWriteStatusEnum? get status => _$this._status;
  set status(GoalWriteStatusEnum? status) => _$this._status = status;

  GoalWriteBuilder() {
    GoalWrite._defaults(this);
  }

  GoalWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _metricId = $v.metricId;
      _baselineValue = $v.baselineValue;
      _targetValue = $v.targetValue;
      _startDate = $v.startDate;
      _targetDate = $v.targetDate;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoalWrite other) {
    _$v = other as _$GoalWrite;
  }

  @override
  void update(void Function(GoalWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoalWrite build() => _build();

  _$GoalWrite _build() {
    final _$result = _$v ??
        _$GoalWrite._(
          metricId: metricId,
          baselineValue: baselineValue,
          targetValue: targetValue,
          startDate: startDate,
          targetDate: targetDate,
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
