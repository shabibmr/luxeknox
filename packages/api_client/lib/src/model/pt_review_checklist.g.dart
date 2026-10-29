// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_review_checklist.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtReviewChecklist extends PtReviewChecklist {
  @override
  final bool? goalsReviewed;
  @override
  final bool? measurementsReviewed;
  @override
  final bool? performanceReviewed;
  @override
  final bool? attendanceReviewed;
  @override
  final bool? programUpdated;
  @override
  final bool? nextGoalsAgreed;

  factory _$PtReviewChecklist(
          [void Function(PtReviewChecklistBuilder)? updates]) =>
      (PtReviewChecklistBuilder()..update(updates))._build();

  _$PtReviewChecklist._(
      {this.goalsReviewed,
      this.measurementsReviewed,
      this.performanceReviewed,
      this.attendanceReviewed,
      this.programUpdated,
      this.nextGoalsAgreed})
      : super._();
  @override
  PtReviewChecklist rebuild(void Function(PtReviewChecklistBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtReviewChecklistBuilder toBuilder() =>
      PtReviewChecklistBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtReviewChecklist &&
        goalsReviewed == other.goalsReviewed &&
        measurementsReviewed == other.measurementsReviewed &&
        performanceReviewed == other.performanceReviewed &&
        attendanceReviewed == other.attendanceReviewed &&
        programUpdated == other.programUpdated &&
        nextGoalsAgreed == other.nextGoalsAgreed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, goalsReviewed.hashCode);
    _$hash = $jc(_$hash, measurementsReviewed.hashCode);
    _$hash = $jc(_$hash, performanceReviewed.hashCode);
    _$hash = $jc(_$hash, attendanceReviewed.hashCode);
    _$hash = $jc(_$hash, programUpdated.hashCode);
    _$hash = $jc(_$hash, nextGoalsAgreed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtReviewChecklist')
          ..add('goalsReviewed', goalsReviewed)
          ..add('measurementsReviewed', measurementsReviewed)
          ..add('performanceReviewed', performanceReviewed)
          ..add('attendanceReviewed', attendanceReviewed)
          ..add('programUpdated', programUpdated)
          ..add('nextGoalsAgreed', nextGoalsAgreed))
        .toString();
  }
}

class PtReviewChecklistBuilder
    implements Builder<PtReviewChecklist, PtReviewChecklistBuilder> {
  _$PtReviewChecklist? _$v;

  bool? _goalsReviewed;
  bool? get goalsReviewed => _$this._goalsReviewed;
  set goalsReviewed(bool? goalsReviewed) =>
      _$this._goalsReviewed = goalsReviewed;

  bool? _measurementsReviewed;
  bool? get measurementsReviewed => _$this._measurementsReviewed;
  set measurementsReviewed(bool? measurementsReviewed) =>
      _$this._measurementsReviewed = measurementsReviewed;

  bool? _performanceReviewed;
  bool? get performanceReviewed => _$this._performanceReviewed;
  set performanceReviewed(bool? performanceReviewed) =>
      _$this._performanceReviewed = performanceReviewed;

  bool? _attendanceReviewed;
  bool? get attendanceReviewed => _$this._attendanceReviewed;
  set attendanceReviewed(bool? attendanceReviewed) =>
      _$this._attendanceReviewed = attendanceReviewed;

  bool? _programUpdated;
  bool? get programUpdated => _$this._programUpdated;
  set programUpdated(bool? programUpdated) =>
      _$this._programUpdated = programUpdated;

  bool? _nextGoalsAgreed;
  bool? get nextGoalsAgreed => _$this._nextGoalsAgreed;
  set nextGoalsAgreed(bool? nextGoalsAgreed) =>
      _$this._nextGoalsAgreed = nextGoalsAgreed;

  PtReviewChecklistBuilder() {
    PtReviewChecklist._defaults(this);
  }

  PtReviewChecklistBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _goalsReviewed = $v.goalsReviewed;
      _measurementsReviewed = $v.measurementsReviewed;
      _performanceReviewed = $v.performanceReviewed;
      _attendanceReviewed = $v.attendanceReviewed;
      _programUpdated = $v.programUpdated;
      _nextGoalsAgreed = $v.nextGoalsAgreed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtReviewChecklist other) {
    _$v = other as _$PtReviewChecklist;
  }

  @override
  void update(void Function(PtReviewChecklistBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtReviewChecklist build() => _build();

  _$PtReviewChecklist _build() {
    final _$result = _$v ??
        _$PtReviewChecklist._(
          goalsReviewed: goalsReviewed,
          measurementsReviewed: measurementsReviewed,
          performanceReviewed: performanceReviewed,
          attendanceReviewed: attendanceReviewed,
          programUpdated: programUpdated,
          nextGoalsAgreed: nextGoalsAgreed,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
