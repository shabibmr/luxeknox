// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_progress_review_draft.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PtProgressReviewDraftProgressHighlightsEnum
    _$ptProgressReviewDraftProgressHighlightsEnum_improvedTechnique =
    const PtProgressReviewDraftProgressHighlightsEnum._('improvedTechnique');
const PtProgressReviewDraftProgressHighlightsEnum
    _$ptProgressReviewDraftProgressHighlightsEnum_increasedStrength =
    const PtProgressReviewDraftProgressHighlightsEnum._('increasedStrength');
const PtProgressReviewDraftProgressHighlightsEnum
    _$ptProgressReviewDraftProgressHighlightsEnum_improvedConditioning =
    const PtProgressReviewDraftProgressHighlightsEnum._('improvedConditioning');
const PtProgressReviewDraftProgressHighlightsEnum
    _$ptProgressReviewDraftProgressHighlightsEnum_betterConsistency =
    const PtProgressReviewDraftProgressHighlightsEnum._('betterConsistency');
const PtProgressReviewDraftProgressHighlightsEnum
    _$ptProgressReviewDraftProgressHighlightsEnum_improvedMobility =
    const PtProgressReviewDraftProgressHighlightsEnum._('improvedMobility');
const PtProgressReviewDraftProgressHighlightsEnum
    _$ptProgressReviewDraftProgressHighlightsEnum_goalMilestone =
    const PtProgressReviewDraftProgressHighlightsEnum._('goalMilestone');
const PtProgressReviewDraftProgressHighlightsEnum
    _$ptProgressReviewDraftProgressHighlightsEnum_other =
    const PtProgressReviewDraftProgressHighlightsEnum._('other');

PtProgressReviewDraftProgressHighlightsEnum
    _$ptProgressReviewDraftProgressHighlightsEnumValueOf(String name) {
  switch (name) {
    case 'improvedTechnique':
      return _$ptProgressReviewDraftProgressHighlightsEnum_improvedTechnique;
    case 'increasedStrength':
      return _$ptProgressReviewDraftProgressHighlightsEnum_increasedStrength;
    case 'improvedConditioning':
      return _$ptProgressReviewDraftProgressHighlightsEnum_improvedConditioning;
    case 'betterConsistency':
      return _$ptProgressReviewDraftProgressHighlightsEnum_betterConsistency;
    case 'improvedMobility':
      return _$ptProgressReviewDraftProgressHighlightsEnum_improvedMobility;
    case 'goalMilestone':
      return _$ptProgressReviewDraftProgressHighlightsEnum_goalMilestone;
    case 'other':
      return _$ptProgressReviewDraftProgressHighlightsEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PtProgressReviewDraftProgressHighlightsEnum>
    _$ptProgressReviewDraftProgressHighlightsEnumValues = BuiltSet<
        PtProgressReviewDraftProgressHighlightsEnum>(const <PtProgressReviewDraftProgressHighlightsEnum>[
  _$ptProgressReviewDraftProgressHighlightsEnum_improvedTechnique,
  _$ptProgressReviewDraftProgressHighlightsEnum_increasedStrength,
  _$ptProgressReviewDraftProgressHighlightsEnum_improvedConditioning,
  _$ptProgressReviewDraftProgressHighlightsEnum_betterConsistency,
  _$ptProgressReviewDraftProgressHighlightsEnum_improvedMobility,
  _$ptProgressReviewDraftProgressHighlightsEnum_goalMilestone,
  _$ptProgressReviewDraftProgressHighlightsEnum_other,
]);

Serializer<PtProgressReviewDraftProgressHighlightsEnum>
    _$ptProgressReviewDraftProgressHighlightsEnumSerializer =
    _$PtProgressReviewDraftProgressHighlightsEnumSerializer();

class _$PtProgressReviewDraftProgressHighlightsEnumSerializer
    implements
        PrimitiveSerializer<PtProgressReviewDraftProgressHighlightsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'improvedTechnique': 'improved_technique',
    'increasedStrength': 'increased_strength',
    'improvedConditioning': 'improved_conditioning',
    'betterConsistency': 'better_consistency',
    'improvedMobility': 'improved_mobility',
    'goalMilestone': 'goal_milestone',
    'other': 'other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'improved_technique': 'improvedTechnique',
    'increased_strength': 'increasedStrength',
    'improved_conditioning': 'improvedConditioning',
    'better_consistency': 'betterConsistency',
    'improved_mobility': 'improvedMobility',
    'goal_milestone': 'goalMilestone',
    'other': 'other',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PtProgressReviewDraftProgressHighlightsEnum
  ];
  @override
  final String wireName = 'PtProgressReviewDraftProgressHighlightsEnum';

  @override
  Object serialize(Serializers serializers,
          PtProgressReviewDraftProgressHighlightsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PtProgressReviewDraftProgressHighlightsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PtProgressReviewDraftProgressHighlightsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

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
  @override
  final BuiltSet<PtProgressReviewDraftProgressHighlightsEnum>?
      progressHighlights;
  @override
  final String? highlightsOtherText;

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
      this.nextReviewDate,
      this.progressHighlights,
      this.highlightsOtherText})
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
        nextReviewDate == other.nextReviewDate &&
        progressHighlights == other.progressHighlights &&
        highlightsOtherText == other.highlightsOtherText;
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
    _$hash = $jc(_$hash, progressHighlights.hashCode);
    _$hash = $jc(_$hash, highlightsOtherText.hashCode);
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
          ..add('nextReviewDate', nextReviewDate)
          ..add('progressHighlights', progressHighlights)
          ..add('highlightsOtherText', highlightsOtherText))
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

  SetBuilder<PtProgressReviewDraftProgressHighlightsEnum>? _progressHighlights;
  SetBuilder<PtProgressReviewDraftProgressHighlightsEnum>
      get progressHighlights => _$this._progressHighlights ??=
          SetBuilder<PtProgressReviewDraftProgressHighlightsEnum>();
  set progressHighlights(
          SetBuilder<PtProgressReviewDraftProgressHighlightsEnum>?
              progressHighlights) =>
      _$this._progressHighlights = progressHighlights;

  String? _highlightsOtherText;
  String? get highlightsOtherText => _$this._highlightsOtherText;
  set highlightsOtherText(String? highlightsOtherText) =>
      _$this._highlightsOtherText = highlightsOtherText;

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
      _progressHighlights = $v.progressHighlights?.toBuilder();
      _highlightsOtherText = $v.highlightsOtherText;
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
    _$PtProgressReviewDraft _$result;
    try {
      _$result = _$v ??
          _$PtProgressReviewDraft._(
            reviewPeriodStart: BuiltValueNullFieldError.checkNotNull(
                reviewPeriodStart,
                r'PtProgressReviewDraft',
                'reviewPeriodStart'),
            reviewPeriodEnd: BuiltValueNullFieldError.checkNotNull(
                reviewPeriodEnd, r'PtProgressReviewDraft', 'reviewPeriodEnd'),
            trainerSummary: trainerSummary,
            clientFeedback: clientFeedback,
            nextPhaseGoal: nextPhaseGoal,
            nextPhaseTrainingFocus: nextPhaseTrainingFocus,
            nextReviewDate: nextReviewDate,
            progressHighlights: _progressHighlights?.build(),
            highlightsOtherText: highlightsOtherText,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'progressHighlights';
        _progressHighlights?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PtProgressReviewDraft', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
