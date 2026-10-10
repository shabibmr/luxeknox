// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_aggregate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProgressAggregate extends ProgressAggregate {
  @override
  final int activeGoals;
  @override
  final int achievedGoals;
  @override
  final int membersMeasured30d;
  @override
  final int photos30d;

  factory _$ProgressAggregate(
          [void Function(ProgressAggregateBuilder)? updates]) =>
      (ProgressAggregateBuilder()..update(updates))._build();

  _$ProgressAggregate._(
      {required this.activeGoals,
      required this.achievedGoals,
      required this.membersMeasured30d,
      required this.photos30d})
      : super._();
  @override
  ProgressAggregate rebuild(void Function(ProgressAggregateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressAggregateBuilder toBuilder() =>
      ProgressAggregateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressAggregate &&
        activeGoals == other.activeGoals &&
        achievedGoals == other.achievedGoals &&
        membersMeasured30d == other.membersMeasured30d &&
        photos30d == other.photos30d;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, activeGoals.hashCode);
    _$hash = $jc(_$hash, achievedGoals.hashCode);
    _$hash = $jc(_$hash, membersMeasured30d.hashCode);
    _$hash = $jc(_$hash, photos30d.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProgressAggregate')
          ..add('activeGoals', activeGoals)
          ..add('achievedGoals', achievedGoals)
          ..add('membersMeasured30d', membersMeasured30d)
          ..add('photos30d', photos30d))
        .toString();
  }
}

class ProgressAggregateBuilder
    implements Builder<ProgressAggregate, ProgressAggregateBuilder> {
  _$ProgressAggregate? _$v;

  int? _activeGoals;
  int? get activeGoals => _$this._activeGoals;
  set activeGoals(int? activeGoals) => _$this._activeGoals = activeGoals;

  int? _achievedGoals;
  int? get achievedGoals => _$this._achievedGoals;
  set achievedGoals(int? achievedGoals) =>
      _$this._achievedGoals = achievedGoals;

  int? _membersMeasured30d;
  int? get membersMeasured30d => _$this._membersMeasured30d;
  set membersMeasured30d(int? membersMeasured30d) =>
      _$this._membersMeasured30d = membersMeasured30d;

  int? _photos30d;
  int? get photos30d => _$this._photos30d;
  set photos30d(int? photos30d) => _$this._photos30d = photos30d;

  ProgressAggregateBuilder() {
    ProgressAggregate._defaults(this);
  }

  ProgressAggregateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _activeGoals = $v.activeGoals;
      _achievedGoals = $v.achievedGoals;
      _membersMeasured30d = $v.membersMeasured30d;
      _photos30d = $v.photos30d;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressAggregate other) {
    _$v = other as _$ProgressAggregate;
  }

  @override
  void update(void Function(ProgressAggregateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressAggregate build() => _build();

  _$ProgressAggregate _build() {
    final _$result = _$v ??
        _$ProgressAggregate._(
          activeGoals: BuiltValueNullFieldError.checkNotNull(
              activeGoals, r'ProgressAggregate', 'activeGoals'),
          achievedGoals: BuiltValueNullFieldError.checkNotNull(
              achievedGoals, r'ProgressAggregate', 'achievedGoals'),
          membersMeasured30d: BuiltValueNullFieldError.checkNotNull(
              membersMeasured30d, r'ProgressAggregate', 'membersMeasured30d'),
          photos30d: BuiltValueNullFieldError.checkNotNull(
              photos30d, r'ProgressAggregate', 'photos30d'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
