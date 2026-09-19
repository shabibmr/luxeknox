// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_condition.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HealthCondition extends HealthCondition {
  @override
  final int id;
  @override
  final String conditionName;
  @override
  final String? riskLevel;
  @override
  final String? contraindications;

  factory _$HealthCondition([void Function(HealthConditionBuilder)? updates]) =>
      (HealthConditionBuilder()..update(updates))._build();

  _$HealthCondition._(
      {required this.id,
      required this.conditionName,
      this.riskLevel,
      this.contraindications})
      : super._();
  @override
  HealthCondition rebuild(void Function(HealthConditionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthConditionBuilder toBuilder() => HealthConditionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthCondition &&
        id == other.id &&
        conditionName == other.conditionName &&
        riskLevel == other.riskLevel &&
        contraindications == other.contraindications;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, conditionName.hashCode);
    _$hash = $jc(_$hash, riskLevel.hashCode);
    _$hash = $jc(_$hash, contraindications.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HealthCondition')
          ..add('id', id)
          ..add('conditionName', conditionName)
          ..add('riskLevel', riskLevel)
          ..add('contraindications', contraindications))
        .toString();
  }
}

class HealthConditionBuilder
    implements Builder<HealthCondition, HealthConditionBuilder> {
  _$HealthCondition? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _conditionName;
  String? get conditionName => _$this._conditionName;
  set conditionName(String? conditionName) =>
      _$this._conditionName = conditionName;

  String? _riskLevel;
  String? get riskLevel => _$this._riskLevel;
  set riskLevel(String? riskLevel) => _$this._riskLevel = riskLevel;

  String? _contraindications;
  String? get contraindications => _$this._contraindications;
  set contraindications(String? contraindications) =>
      _$this._contraindications = contraindications;

  HealthConditionBuilder() {
    HealthCondition._defaults(this);
  }

  HealthConditionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _conditionName = $v.conditionName;
      _riskLevel = $v.riskLevel;
      _contraindications = $v.contraindications;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthCondition other) {
    _$v = other as _$HealthCondition;
  }

  @override
  void update(void Function(HealthConditionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthCondition build() => _build();

  _$HealthCondition _build() {
    final _$result = _$v ??
        _$HealthCondition._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'HealthCondition', 'id'),
          conditionName: BuiltValueNullFieldError.checkNotNull(
              conditionName, r'HealthCondition', 'conditionName'),
          riskLevel: riskLevel,
          contraindications: contraindications,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
