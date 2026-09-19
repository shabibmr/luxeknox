// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietPlanWrite extends DietPlanWrite {
  @override
  final String? title;
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
  final bool? isTemplate;
  @override
  final int? rowVersion;

  factory _$DietPlanWrite([void Function(DietPlanWriteBuilder)? updates]) =>
      (DietPlanWriteBuilder()..update(updates))._build();

  _$DietPlanWrite._(
      {this.title,
      this.memberId,
      this.trainerId,
      this.dailyCalorieTarget,
      this.proteinTargetG,
      this.carbsTargetG,
      this.fatTargetG,
      this.isTemplate,
      this.rowVersion})
      : super._();
  @override
  DietPlanWrite rebuild(void Function(DietPlanWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietPlanWriteBuilder toBuilder() => DietPlanWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietPlanWrite &&
        title == other.title &&
        memberId == other.memberId &&
        trainerId == other.trainerId &&
        dailyCalorieTarget == other.dailyCalorieTarget &&
        proteinTargetG == other.proteinTargetG &&
        carbsTargetG == other.carbsTargetG &&
        fatTargetG == other.fatTargetG &&
        isTemplate == other.isTemplate &&
        rowVersion == other.rowVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, dailyCalorieTarget.hashCode);
    _$hash = $jc(_$hash, proteinTargetG.hashCode);
    _$hash = $jc(_$hash, carbsTargetG.hashCode);
    _$hash = $jc(_$hash, fatTargetG.hashCode);
    _$hash = $jc(_$hash, isTemplate.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DietPlanWrite')
          ..add('title', title)
          ..add('memberId', memberId)
          ..add('trainerId', trainerId)
          ..add('dailyCalorieTarget', dailyCalorieTarget)
          ..add('proteinTargetG', proteinTargetG)
          ..add('carbsTargetG', carbsTargetG)
          ..add('fatTargetG', fatTargetG)
          ..add('isTemplate', isTemplate)
          ..add('rowVersion', rowVersion))
        .toString();
  }
}

class DietPlanWriteBuilder
    implements Builder<DietPlanWrite, DietPlanWriteBuilder> {
  _$DietPlanWrite? _$v;

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

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  DietPlanWriteBuilder() {
    DietPlanWrite._defaults(this);
  }

  DietPlanWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _memberId = $v.memberId;
      _trainerId = $v.trainerId;
      _dailyCalorieTarget = $v.dailyCalorieTarget;
      _proteinTargetG = $v.proteinTargetG;
      _carbsTargetG = $v.carbsTargetG;
      _fatTargetG = $v.fatTargetG;
      _isTemplate = $v.isTemplate;
      _rowVersion = $v.rowVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietPlanWrite other) {
    _$v = other as _$DietPlanWrite;
  }

  @override
  void update(void Function(DietPlanWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietPlanWrite build() => _build();

  _$DietPlanWrite _build() {
    final _$result = _$v ??
        _$DietPlanWrite._(
          title: title,
          memberId: memberId,
          trainerId: trainerId,
          dailyCalorieTarget: dailyCalorieTarget,
          proteinTargetG: proteinTargetG,
          carbsTargetG: carbsTargetG,
          fatTargetG: fatTargetG,
          isTemplate: isTemplate,
          rowVersion: rowVersion,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
