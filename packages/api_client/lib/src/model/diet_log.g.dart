// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_log.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietLog extends DietLog {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final Date loggedDate;
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

  factory _$DietLog([void Function(DietLogBuilder)? updates]) =>
      (DietLogBuilder()..update(updates))._build();

  _$DietLog._(
      {required this.id,
      required this.memberId,
      required this.loggedDate,
      this.dietPlanId,
      this.totalCaloriesConsumed,
      this.adherenceScore,
      this.waterIntakeMl,
      this.memberNotes})
      : super._();
  @override
  DietLog rebuild(void Function(DietLogBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietLogBuilder toBuilder() => DietLogBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietLog &&
        id == other.id &&
        memberId == other.memberId &&
        loggedDate == other.loggedDate &&
        dietPlanId == other.dietPlanId &&
        totalCaloriesConsumed == other.totalCaloriesConsumed &&
        adherenceScore == other.adherenceScore &&
        waterIntakeMl == other.waterIntakeMl &&
        memberNotes == other.memberNotes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, loggedDate.hashCode);
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
    return (newBuiltValueToStringHelper(r'DietLog')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('loggedDate', loggedDate)
          ..add('dietPlanId', dietPlanId)
          ..add('totalCaloriesConsumed', totalCaloriesConsumed)
          ..add('adherenceScore', adherenceScore)
          ..add('waterIntakeMl', waterIntakeMl)
          ..add('memberNotes', memberNotes))
        .toString();
  }
}

class DietLogBuilder implements Builder<DietLog, DietLogBuilder> {
  _$DietLog? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  Date? _loggedDate;
  Date? get loggedDate => _$this._loggedDate;
  set loggedDate(Date? loggedDate) => _$this._loggedDate = loggedDate;

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

  DietLogBuilder() {
    DietLog._defaults(this);
  }

  DietLogBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _loggedDate = $v.loggedDate;
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
  void replace(DietLog other) {
    _$v = other as _$DietLog;
  }

  @override
  void update(void Function(DietLogBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietLog build() => _build();

  _$DietLog _build() {
    final _$result = _$v ??
        _$DietLog._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'DietLog', 'id'),
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'DietLog', 'memberId'),
          loggedDate: BuiltValueNullFieldError.checkNotNull(
              loggedDate, r'DietLog', 'loggedDate'),
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
