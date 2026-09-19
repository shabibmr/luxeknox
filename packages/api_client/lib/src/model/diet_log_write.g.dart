// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_log_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietLogWrite extends DietLogWrite {
  @override
  final int? dietPlanId;
  @override
  final num? totalCaloriesConsumed;
  @override
  final num? adherenceScore;
  @override
  final int? waterIntakeMl;
  @override
  final String? memberNotes;

  factory _$DietLogWrite([void Function(DietLogWriteBuilder)? updates]) =>
      (DietLogWriteBuilder()..update(updates))._build();

  _$DietLogWrite._(
      {this.dietPlanId,
      this.totalCaloriesConsumed,
      this.adherenceScore,
      this.waterIntakeMl,
      this.memberNotes})
      : super._();
  @override
  DietLogWrite rebuild(void Function(DietLogWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietLogWriteBuilder toBuilder() => DietLogWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietLogWrite &&
        dietPlanId == other.dietPlanId &&
        totalCaloriesConsumed == other.totalCaloriesConsumed &&
        adherenceScore == other.adherenceScore &&
        waterIntakeMl == other.waterIntakeMl &&
        memberNotes == other.memberNotes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dietPlanId.hashCode);
    _$hash = $jc(_$hash, totalCaloriesConsumed.hashCode);
    _$hash = $jc(_$hash, adherenceScore.hashCode);
    _$hash = $jc(_$hash, waterIntakeMl.hashCode);
    _$hash = $jc(_$hash, memberNotes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DietLogWrite')
          ..add('dietPlanId', dietPlanId)
          ..add('totalCaloriesConsumed', totalCaloriesConsumed)
          ..add('adherenceScore', adherenceScore)
          ..add('waterIntakeMl', waterIntakeMl)
          ..add('memberNotes', memberNotes))
        .toString();
  }
}

class DietLogWriteBuilder
    implements Builder<DietLogWrite, DietLogWriteBuilder> {
  _$DietLogWrite? _$v;

  int? _dietPlanId;
  int? get dietPlanId => _$this._dietPlanId;
  set dietPlanId(int? dietPlanId) => _$this._dietPlanId = dietPlanId;

  num? _totalCaloriesConsumed;
  num? get totalCaloriesConsumed => _$this._totalCaloriesConsumed;
  set totalCaloriesConsumed(num? totalCaloriesConsumed) =>
      _$this._totalCaloriesConsumed = totalCaloriesConsumed;

  num? _adherenceScore;
  num? get adherenceScore => _$this._adherenceScore;
  set adherenceScore(num? adherenceScore) =>
      _$this._adherenceScore = adherenceScore;

  int? _waterIntakeMl;
  int? get waterIntakeMl => _$this._waterIntakeMl;
  set waterIntakeMl(int? waterIntakeMl) =>
      _$this._waterIntakeMl = waterIntakeMl;

  String? _memberNotes;
  String? get memberNotes => _$this._memberNotes;
  set memberNotes(String? memberNotes) => _$this._memberNotes = memberNotes;

  DietLogWriteBuilder() {
    DietLogWrite._defaults(this);
  }

  DietLogWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dietPlanId = $v.dietPlanId;
      _totalCaloriesConsumed = $v.totalCaloriesConsumed;
      _adherenceScore = $v.adherenceScore;
      _waterIntakeMl = $v.waterIntakeMl;
      _memberNotes = $v.memberNotes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietLogWrite other) {
    _$v = other as _$DietLogWrite;
  }

  @override
  void update(void Function(DietLogWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietLogWrite build() => _build();

  _$DietLogWrite _build() {
    final _$result = _$v ??
        _$DietLogWrite._(
          dietPlanId: dietPlanId,
          totalCaloriesConsumed: totalCaloriesConsumed,
          adherenceScore: adherenceScore,
          waterIntakeMl: waterIntakeMl,
          memberNotes: memberNotes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
