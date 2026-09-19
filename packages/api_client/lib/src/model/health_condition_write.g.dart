// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_condition_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HealthConditionWrite extends HealthConditionWrite {
  @override
  final String conditionName;
  @override
  final String? riskLevel;
  @override
  final String? contraindications;

  factory _$HealthConditionWrite(
          [void Function(HealthConditionWriteBuilder)? updates]) =>
      (HealthConditionWriteBuilder()..update(updates))._build();

  _$HealthConditionWrite._(
      {required this.conditionName, this.riskLevel, this.contraindications})
      : super._();
  @override
  HealthConditionWrite rebuild(
          void Function(HealthConditionWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthConditionWriteBuilder toBuilder() =>
      HealthConditionWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthConditionWrite &&
        conditionName == other.conditionName &&
        riskLevel == other.riskLevel &&
        contraindications == other.contraindications;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, conditionName.hashCode);
    _$hash = $jc(_$hash, riskLevel.hashCode);
    _$hash = $jc(_$hash, contraindications.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HealthConditionWrite')
          ..add('conditionName', conditionName)
          ..add('riskLevel', riskLevel)
          ..add('contraindications', contraindications))
        .toString();
  }
}

class HealthConditionWriteBuilder
    implements Builder<HealthConditionWrite, HealthConditionWriteBuilder> {
  _$HealthConditionWrite? _$v;

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

  HealthConditionWriteBuilder() {
    HealthConditionWrite._defaults(this);
  }

  HealthConditionWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _conditionName = $v.conditionName;
      _riskLevel = $v.riskLevel;
      _contraindications = $v.contraindications;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthConditionWrite other) {
    _$v = other as _$HealthConditionWrite;
  }

  @override
  void update(void Function(HealthConditionWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthConditionWrite build() => _build();

  _$HealthConditionWrite _build() {
    final _$result = _$v ??
        _$HealthConditionWrite._(
          conditionName: BuiltValueNullFieldError.checkNotNull(
              conditionName, r'HealthConditionWrite', 'conditionName'),
          riskLevel: riskLevel,
          contraindications: contraindications,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
