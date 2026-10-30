// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_progress_review_draft_edit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PtProgressReviewDraftEditProgressHighlightsEnum
    _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedTechnique =
    const PtProgressReviewDraftEditProgressHighlightsEnum._(
        'improvedTechnique');
const PtProgressReviewDraftEditProgressHighlightsEnum
    _$ptProgressReviewDraftEditProgressHighlightsEnum_increasedStrength =
    const PtProgressReviewDraftEditProgressHighlightsEnum._(
        'increasedStrength');
const PtProgressReviewDraftEditProgressHighlightsEnum
    _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedConditioning =
    const PtProgressReviewDraftEditProgressHighlightsEnum._(
        'improvedConditioning');
const PtProgressReviewDraftEditProgressHighlightsEnum
    _$ptProgressReviewDraftEditProgressHighlightsEnum_betterConsistency =
    const PtProgressReviewDraftEditProgressHighlightsEnum._(
        'betterConsistency');
const PtProgressReviewDraftEditProgressHighlightsEnum
    _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedMobility =
    const PtProgressReviewDraftEditProgressHighlightsEnum._('improvedMobility');
const PtProgressReviewDraftEditProgressHighlightsEnum
    _$ptProgressReviewDraftEditProgressHighlightsEnum_goalMilestone =
    const PtProgressReviewDraftEditProgressHighlightsEnum._('goalMilestone');
const PtProgressReviewDraftEditProgressHighlightsEnum
    _$ptProgressReviewDraftEditProgressHighlightsEnum_other =
    const PtProgressReviewDraftEditProgressHighlightsEnum._('other');

PtProgressReviewDraftEditProgressHighlightsEnum
    _$ptProgressReviewDraftEditProgressHighlightsEnumValueOf(String name) {
  switch (name) {
    case 'improvedTechnique':
      return _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedTechnique;
    case 'increasedStrength':
      return _$ptProgressReviewDraftEditProgressHighlightsEnum_increasedStrength;
    case 'improvedConditioning':
      return _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedConditioning;
    case 'betterConsistency':
      return _$ptProgressReviewDraftEditProgressHighlightsEnum_betterConsistency;
    case 'improvedMobility':
      return _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedMobility;
    case 'goalMilestone':
      return _$ptProgressReviewDraftEditProgressHighlightsEnum_goalMilestone;
    case 'other':
      return _$ptProgressReviewDraftEditProgressHighlightsEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PtProgressReviewDraftEditProgressHighlightsEnum>
    _$ptProgressReviewDraftEditProgressHighlightsEnumValues = BuiltSet<
        PtProgressReviewDraftEditProgressHighlightsEnum>(const <PtProgressReviewDraftEditProgressHighlightsEnum>[
  _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedTechnique,
  _$ptProgressReviewDraftEditProgressHighlightsEnum_increasedStrength,
  _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedConditioning,
  _$ptProgressReviewDraftEditProgressHighlightsEnum_betterConsistency,
  _$ptProgressReviewDraftEditProgressHighlightsEnum_improvedMobility,
  _$ptProgressReviewDraftEditProgressHighlightsEnum_goalMilestone,
  _$ptProgressReviewDraftEditProgressHighlightsEnum_other,
]);

Serializer<PtProgressReviewDraftEditProgressHighlightsEnum>
    _$ptProgressReviewDraftEditProgressHighlightsEnumSerializer =
    _$PtProgressReviewDraftEditProgressHighlightsEnumSerializer();

class _$PtProgressReviewDraftEditProgressHighlightsEnumSerializer
    implements
        PrimitiveSerializer<PtProgressReviewDraftEditProgressHighlightsEnum> {
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
    PtProgressReviewDraftEditProgressHighlightsEnum
  ];
  @override
  final String wireName = 'PtProgressReviewDraftEditProgressHighlightsEnum';

  @override
  Object serialize(Serializers serializers,
          PtProgressReviewDraftEditProgressHighlightsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PtProgressReviewDraftEditProgressHighlightsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PtProgressReviewDraftEditProgressHighlightsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PtProgressReviewDraftEdit extends PtProgressReviewDraftEdit {
  @override
  final BuiltSet<PtProgressReviewDraftEditProgressHighlightsEnum>?
      progressHighlights;
  @override
  final String? highlightsOtherText;
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
  final PtReviewChecklist? reviewChecklist;

  factory _$PtProgressReviewDraftEdit(
          [void Function(PtProgressReviewDraftEditBuilder)? updates]) =>
      (PtProgressReviewDraftEditBuilder()..update(updates))._build();

  _$PtProgressReviewDraftEdit._(
      {this.progressHighlights,
      this.highlightsOtherText,
      this.trainerSummary,
      this.clientFeedback,
      this.nextPhaseGoal,
      this.nextPhaseTrainingFocus,
      this.nextReviewDate,
      this.reviewChecklist})
      : super._();
  @override
  PtProgressReviewDraftEdit rebuild(
          void Function(PtProgressReviewDraftEditBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtProgressReviewDraftEditBuilder toBuilder() =>
      PtProgressReviewDraftEditBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtProgressReviewDraftEdit &&
        progressHighlights == other.progressHighlights &&
        highlightsOtherText == other.highlightsOtherText &&
        trainerSummary == other.trainerSummary &&
        clientFeedback == other.clientFeedback &&
        nextPhaseGoal == other.nextPhaseGoal &&
        nextPhaseTrainingFocus == other.nextPhaseTrainingFocus &&
        nextReviewDate == other.nextReviewDate &&
        reviewChecklist == other.reviewChecklist;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, progressHighlights.hashCode);
    _$hash = $jc(_$hash, highlightsOtherText.hashCode);
    _$hash = $jc(_$hash, trainerSummary.hashCode);
    _$hash = $jc(_$hash, clientFeedback.hashCode);
    _$hash = $jc(_$hash, nextPhaseGoal.hashCode);
    _$hash = $jc(_$hash, nextPhaseTrainingFocus.hashCode);
    _$hash = $jc(_$hash, nextReviewDate.hashCode);
    _$hash = $jc(_$hash, reviewChecklist.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtProgressReviewDraftEdit')
          ..add('progressHighlights', progressHighlights)
          ..add('highlightsOtherText', highlightsOtherText)
          ..add('trainerSummary', trainerSummary)
          ..add('clientFeedback', clientFeedback)
          ..add('nextPhaseGoal', nextPhaseGoal)
          ..add('nextPhaseTrainingFocus', nextPhaseTrainingFocus)
          ..add('nextReviewDate', nextReviewDate)
          ..add('reviewChecklist', reviewChecklist))
        .toString();
  }
}

class PtProgressReviewDraftEditBuilder
    implements
        Builder<PtProgressReviewDraftEdit, PtProgressReviewDraftEditBuilder> {
  _$PtProgressReviewDraftEdit? _$v;

  SetBuilder<PtProgressReviewDraftEditProgressHighlightsEnum>?
      _progressHighlights;
  SetBuilder<PtProgressReviewDraftEditProgressHighlightsEnum>
      get progressHighlights => _$this._progressHighlights ??=
          SetBuilder<PtProgressReviewDraftEditProgressHighlightsEnum>();
  set progressHighlights(
          SetBuilder<PtProgressReviewDraftEditProgressHighlightsEnum>?
              progressHighlights) =>
      _$this._progressHighlights = progressHighlights;

  String? _highlightsOtherText;
  String? get highlightsOtherText => _$this._highlightsOtherText;
  set highlightsOtherText(String? highlightsOtherText) =>
      _$this._highlightsOtherText = highlightsOtherText;

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

  PtReviewChecklistBuilder? _reviewChecklist;
  PtReviewChecklistBuilder get reviewChecklist =>
      _$this._reviewChecklist ??= PtReviewChecklistBuilder();
  set reviewChecklist(PtReviewChecklistBuilder? reviewChecklist) =>
      _$this._reviewChecklist = reviewChecklist;

  PtProgressReviewDraftEditBuilder() {
    PtProgressReviewDraftEdit._defaults(this);
  }

  PtProgressReviewDraftEditBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _progressHighlights = $v.progressHighlights?.toBuilder();
      _highlightsOtherText = $v.highlightsOtherText;
      _trainerSummary = $v.trainerSummary;
      _clientFeedback = $v.clientFeedback;
      _nextPhaseGoal = $v.nextPhaseGoal;
      _nextPhaseTrainingFocus = $v.nextPhaseTrainingFocus;
      _nextReviewDate = $v.nextReviewDate;
      _reviewChecklist = $v.reviewChecklist?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtProgressReviewDraftEdit other) {
    _$v = other as _$PtProgressReviewDraftEdit;
  }

  @override
  void update(void Function(PtProgressReviewDraftEditBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtProgressReviewDraftEdit build() => _build();

  _$PtProgressReviewDraftEdit _build() {
    _$PtProgressReviewDraftEdit _$result;
    try {
      _$result = _$v ??
          _$PtProgressReviewDraftEdit._(
            progressHighlights: _progressHighlights?.build(),
            highlightsOtherText: highlightsOtherText,
            trainerSummary: trainerSummary,
            clientFeedback: clientFeedback,
            nextPhaseGoal: nextPhaseGoal,
            nextPhaseTrainingFocus: nextPhaseTrainingFocus,
            nextReviewDate: nextReviewDate,
            reviewChecklist: _reviewChecklist?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'progressHighlights';
        _progressHighlights?.build();

        _$failedField = 'reviewChecklist';
        _reviewChecklist?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PtProgressReviewDraftEdit', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
