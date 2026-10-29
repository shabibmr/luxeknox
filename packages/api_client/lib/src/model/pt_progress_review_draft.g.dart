// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_progress_review_draft.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtProgressReviewDraft extends PtProgressReviewDraft {
  @override
  final Date reviewPeriodStart;
  @override
  final Date reviewPeriodEnd;
  @override
  final String? trainerSummary;
  @override
  final String? clientFeedback;
  @override
  final String? nextPhaseGoal;
  @override
  final String? nextPhaseTrainingFocus;
  @override
  final Date? nextReviewDate;

  factory _$PtProgressReviewDraft(
          [void Function(PtProgressReviewDraftBuilder)? updates]) =>
      (PtProgressReviewDraftBuilder()..update(updates))._build();

  _$PtProgressReviewDraft._(
      {required this.reviewPeriodStart,
      required this.reviewPeriodEnd,
      this.trainerSummary,
      this.clientFeedback,
      this.nextPhaseGoal,
      this.nextPhaseTrainingFocus,
      this.nextReviewDate})
      : super._();
  @override
  PtProgressReviewDraft rebuild(
          void Function(PtProgressReviewDraftBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtProgressReviewDraftBuilder toBuilder() =>
      PtProgressReviewDraftBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtProgressReviewDraft &&
        reviewPeriodStart == other.reviewPeriodStart &&
        reviewPeriodEnd == other.reviewPeriodEnd &&
        trainerSummary == other.trainerSummary &&
        clientFeedback == other.clientFeedback &&
        nextPhaseGoal == other.nextPhaseGoal &&
        nextPhaseTrainingFocus == other.nextPhaseTrainingFocus &&
        nextReviewDate == other.nextReviewDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reviewPeriodStart.hashCode);
    _$hash = $jc(_$hash, reviewPeriodEnd.hashCode);
    _$hash = $jc(_$hash, trainerSummary.hashCode);
    _$hash = $jc(_$hash, clientFeedback.hashCode);
    _$hash = $jc(_$hash, nextPhaseGoal.hashCode);
    _$hash = $jc(_$hash, nextPhaseTrainingFocus.hashCode);
    _$hash = $jc(_$hash, nextReviewDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtProgressReviewDraft')
          ..add('reviewPeriodStart', reviewPeriodStart)
          ..add('reviewPeriodEnd', reviewPeriodEnd)
          ..add('trainerSummary', trainerSummary)
          ..add('clientFeedback', clientFeedback)
          ..add('nextPhaseGoal', nextPhaseGoal)
          ..add('nextPhaseTrainingFocus', nextPhaseTrainingFocus)
          ..add('nextReviewDate', nextReviewDate))
        .toString();
  }
}

class PtProgressReviewDraftBuilder
    implements Builder<PtProgressReviewDraft, PtProgressReviewDraftBuilder> {
  _$PtProgressReviewDraft? _$v;

  Date? _reviewPeriodStart;
  Date? get reviewPeriodStart => _$this._reviewPeriodStart;
  set reviewPeriodStart(Date? reviewPeriodStart) =>
      _$this._reviewPeriodStart = reviewPeriodStart;

  Date? _reviewPeriodEnd;
  Date? get reviewPeriodEnd => _$this._reviewPeriodEnd;
  set reviewPeriodEnd(Date? reviewPeriodEnd) =>
      _$this._reviewPeriodEnd = reviewPeriodEnd;

  String? _trainerSummary;
  String? get trainerSummary => _$this._trainerSummary;
  set trainerSummary(String? trainerSummary) =>
      _$this._trainerSummary = trainerSummary;

  String? _clientFeedback;
  String? get clientFeedback => _$this._clientFeedback;
  set clientFeedback(String? clientFeedback) =>
      _$this._clientFeedback = clientFeedback;

  String? _nextPhaseGoal;
  String? get nextPhaseGoal => _$this._nextPhaseGoal;
  set nextPhaseGoal(String? nextPhaseGoal) =>
      _$this._nextPhaseGoal = nextPhaseGoal;

  String? _nextPhaseTrainingFocus;
  String? get nextPhaseTrainingFocus => _$this._nextPhaseTrainingFocus;
  set nextPhaseTrainingFocus(String? nextPhaseTrainingFocus) =>
      _$this._nextPhaseTrainingFocus = nextPhaseTrainingFocus;

  Date? _nextReviewDate;
  Date? get nextReviewDate => _$this._nextReviewDate;
  set nextReviewDate(Date? nextReviewDate) =>
      _$this._nextReviewDate = nextReviewDate;

  PtProgressReviewDraftBuilder() {
    PtProgressReviewDraft._defaults(this);
  }

  PtProgressReviewDraftBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reviewPeriodStart = $v.reviewPeriodStart;
      _reviewPeriodEnd = $v.reviewPeriodEnd;
      _trainerSummary = $v.trainerSummary;
      _clientFeedback = $v.clientFeedback;
      _nextPhaseGoal = $v.nextPhaseGoal;
      _nextPhaseTrainingFocus = $v.nextPhaseTrainingFocus;
      _nextReviewDate = $v.nextReviewDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtProgressReviewDraft other) {
    _$v = other as _$PtProgressReviewDraft;
  }

  @override
  void update(void Function(PtProgressReviewDraftBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtProgressReviewDraft build() => _build();

  _$PtProgressReviewDraft _build() {
    final _$result = _$v ??
        _$PtProgressReviewDraft._(
          reviewPeriodStart: BuiltValueNullFieldError.checkNotNull(
              reviewPeriodStart, r'PtProgressReviewDraft', 'reviewPeriodStart'),
          reviewPeriodEnd: BuiltValueNullFieldError.checkNotNull(
              reviewPeriodEnd, r'PtProgressReviewDraft', 'reviewPeriodEnd'),
          trainerSummary: trainerSummary,
          clientFeedback: clientFeedback,
          nextPhaseGoal: nextPhaseGoal,
          nextPhaseTrainingFocus: nextPhaseTrainingFocus,
          nextReviewDate: nextReviewDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
