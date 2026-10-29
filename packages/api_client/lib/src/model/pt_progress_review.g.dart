// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_progress_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PtProgressReviewStatusEnum _$ptProgressReviewStatusEnum_draft =
    const PtProgressReviewStatusEnum._('draft');
const PtProgressReviewStatusEnum
    _$ptProgressReviewStatusEnum_pendingClientSign =
    const PtProgressReviewStatusEnum._('pendingClientSign');
const PtProgressReviewStatusEnum
    _$ptProgressReviewStatusEnum_pendingManagerApproval =
    const PtProgressReviewStatusEnum._('pendingManagerApproval');
const PtProgressReviewStatusEnum _$ptProgressReviewStatusEnum_approved =
    const PtProgressReviewStatusEnum._('approved');
const PtProgressReviewStatusEnum _$ptProgressReviewStatusEnum_archived =
    const PtProgressReviewStatusEnum._('archived');

PtProgressReviewStatusEnum _$ptProgressReviewStatusEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$ptProgressReviewStatusEnum_draft;
    case 'pendingClientSign':
      return _$ptProgressReviewStatusEnum_pendingClientSign;
    case 'pendingManagerApproval':
      return _$ptProgressReviewStatusEnum_pendingManagerApproval;
    case 'approved':
      return _$ptProgressReviewStatusEnum_approved;
    case 'archived':
      return _$ptProgressReviewStatusEnum_archived;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PtProgressReviewStatusEnum> _$ptProgressReviewStatusEnumValues =
    BuiltSet<PtProgressReviewStatusEnum>(const <PtProgressReviewStatusEnum>[
  _$ptProgressReviewStatusEnum_draft,
  _$ptProgressReviewStatusEnum_pendingClientSign,
  _$ptProgressReviewStatusEnum_pendingManagerApproval,
  _$ptProgressReviewStatusEnum_approved,
  _$ptProgressReviewStatusEnum_archived,
]);

Serializer<PtProgressReviewStatusEnum> _$ptProgressReviewStatusEnumSerializer =
    _$PtProgressReviewStatusEnumSerializer();

class _$PtProgressReviewStatusEnumSerializer
    implements PrimitiveSerializer<PtProgressReviewStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'pendingClientSign': 'pending_client_sign',
    'pendingManagerApproval': 'pending_manager_approval',
    'approved': 'approved',
    'archived': 'archived',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'pending_client_sign': 'pendingClientSign',
    'pending_manager_approval': 'pendingManagerApproval',
    'approved': 'approved',
    'archived': 'archived',
  };

  @override
  final Iterable<Type> types = const <Type>[PtProgressReviewStatusEnum];
  @override
  final String wireName = 'PtProgressReviewStatusEnum';

  @override
  Object serialize(Serializers serializers, PtProgressReviewStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PtProgressReviewStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PtProgressReviewStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PtProgressReview extends PtProgressReview {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final int trainerId;
  @override
  final Date reviewPeriodStart;
  @override
  final Date reviewPeriodEnd;
  @override
  final BuiltList<BodyMetricSnapshot>? bodyMetricsSnapshot;
  @override
  final BuiltList<PerformanceMarkerSnapshot>? performanceMarkersSnapshot;
  @override
  final BuiltList<String>? progressHighlights;
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
  @override
  final String? finalReviewNotes;
  @override
  final DateTime? clientSignedAt;
  @override
  final DateTime? trainerSignedAt;
  @override
  final int? managerUserId;
  @override
  final DateTime? managerSignedAt;
  @override
  final PtProgressReviewStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  factory _$PtProgressReview(
          [void Function(PtProgressReviewBuilder)? updates]) =>
      (PtProgressReviewBuilder()..update(updates))._build();

  _$PtProgressReview._(
      {required this.id,
      required this.memberId,
      required this.trainerId,
      required this.reviewPeriodStart,
      required this.reviewPeriodEnd,
      this.bodyMetricsSnapshot,
      this.performanceMarkersSnapshot,
      this.progressHighlights,
      this.highlightsOtherText,
      this.trainerSummary,
      this.clientFeedback,
      this.nextPhaseGoal,
      this.nextPhaseTrainingFocus,
      this.nextReviewDate,
      this.reviewChecklist,
      this.finalReviewNotes,
      this.clientSignedAt,
      this.trainerSignedAt,
      this.managerUserId,
      this.managerSignedAt,
      required this.status,
      required this.createdAt,
      this.updatedAt})
      : super._();
  @override
  PtProgressReview rebuild(void Function(PtProgressReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtProgressReviewBuilder toBuilder() =>
      PtProgressReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtProgressReview &&
        id == other.id &&
        memberId == other.memberId &&
        trainerId == other.trainerId &&
        reviewPeriodStart == other.reviewPeriodStart &&
        reviewPeriodEnd == other.reviewPeriodEnd &&
        bodyMetricsSnapshot == other.bodyMetricsSnapshot &&
        performanceMarkersSnapshot == other.performanceMarkersSnapshot &&
        progressHighlights == other.progressHighlights &&
        highlightsOtherText == other.highlightsOtherText &&
        trainerSummary == other.trainerSummary &&
        clientFeedback == other.clientFeedback &&
        nextPhaseGoal == other.nextPhaseGoal &&
        nextPhaseTrainingFocus == other.nextPhaseTrainingFocus &&
        nextReviewDate == other.nextReviewDate &&
        reviewChecklist == other.reviewChecklist &&
        finalReviewNotes == other.finalReviewNotes &&
        clientSignedAt == other.clientSignedAt &&
        trainerSignedAt == other.trainerSignedAt &&
        managerUserId == other.managerUserId &&
        managerSignedAt == other.managerSignedAt &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, reviewPeriodStart.hashCode);
    _$hash = $jc(_$hash, reviewPeriodEnd.hashCode);
    _$hash = $jc(_$hash, bodyMetricsSnapshot.hashCode);
    _$hash = $jc(_$hash, performanceMarkersSnapshot.hashCode);
    _$hash = $jc(_$hash, progressHighlights.hashCode);
    _$hash = $jc(_$hash, highlightsOtherText.hashCode);
    _$hash = $jc(_$hash, trainerSummary.hashCode);
    _$hash = $jc(_$hash, clientFeedback.hashCode);
    _$hash = $jc(_$hash, nextPhaseGoal.hashCode);
    _$hash = $jc(_$hash, nextPhaseTrainingFocus.hashCode);
    _$hash = $jc(_$hash, nextReviewDate.hashCode);
    _$hash = $jc(_$hash, reviewChecklist.hashCode);
    _$hash = $jc(_$hash, finalReviewNotes.hashCode);
    _$hash = $jc(_$hash, clientSignedAt.hashCode);
    _$hash = $jc(_$hash, trainerSignedAt.hashCode);
    _$hash = $jc(_$hash, managerUserId.hashCode);
    _$hash = $jc(_$hash, managerSignedAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtProgressReview')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('trainerId', trainerId)
          ..add('reviewPeriodStart', reviewPeriodStart)
          ..add('reviewPeriodEnd', reviewPeriodEnd)
          ..add('bodyMetricsSnapshot', bodyMetricsSnapshot)
          ..add('performanceMarkersSnapshot', performanceMarkersSnapshot)
          ..add('progressHighlights', progressHighlights)
          ..add('highlightsOtherText', highlightsOtherText)
          ..add('trainerSummary', trainerSummary)
          ..add('clientFeedback', clientFeedback)
          ..add('nextPhaseGoal', nextPhaseGoal)
          ..add('nextPhaseTrainingFocus', nextPhaseTrainingFocus)
          ..add('nextReviewDate', nextReviewDate)
          ..add('reviewChecklist', reviewChecklist)
          ..add('finalReviewNotes', finalReviewNotes)
          ..add('clientSignedAt', clientSignedAt)
          ..add('trainerSignedAt', trainerSignedAt)
          ..add('managerUserId', managerUserId)
          ..add('managerSignedAt', managerSignedAt)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PtProgressReviewBuilder
    implements Builder<PtProgressReview, PtProgressReviewBuilder> {
  _$PtProgressReview? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  Date? _reviewPeriodStart;
  Date? get reviewPeriodStart => _$this._reviewPeriodStart;
  set reviewPeriodStart(Date? reviewPeriodStart) =>
      _$this._reviewPeriodStart = reviewPeriodStart;

  Date? _reviewPeriodEnd;
  Date? get reviewPeriodEnd => _$this._reviewPeriodEnd;
  set reviewPeriodEnd(Date? reviewPeriodEnd) =>
      _$this._reviewPeriodEnd = reviewPeriodEnd;

  ListBuilder<BodyMetricSnapshot>? _bodyMetricsSnapshot;
  ListBuilder<BodyMetricSnapshot> get bodyMetricsSnapshot =>
      _$this._bodyMetricsSnapshot ??= ListBuilder<BodyMetricSnapshot>();
  set bodyMetricsSnapshot(
          ListBuilder<BodyMetricSnapshot>? bodyMetricsSnapshot) =>
      _$this._bodyMetricsSnapshot = bodyMetricsSnapshot;

  ListBuilder<PerformanceMarkerSnapshot>? _performanceMarkersSnapshot;
  ListBuilder<PerformanceMarkerSnapshot> get performanceMarkersSnapshot =>
      _$this._performanceMarkersSnapshot ??=
          ListBuilder<PerformanceMarkerSnapshot>();
  set performanceMarkersSnapshot(
          ListBuilder<PerformanceMarkerSnapshot>? performanceMarkersSnapshot) =>
      _$this._performanceMarkersSnapshot = performanceMarkersSnapshot;

  ListBuilder<String>? _progressHighlights;
  ListBuilder<String> get progressHighlights =>
      _$this._progressHighlights ??= ListBuilder<String>();
  set progressHighlights(ListBuilder<String>? progressHighlights) =>
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

  String? _finalReviewNotes;
  String? get finalReviewNotes => _$this._finalReviewNotes;
  set finalReviewNotes(String? finalReviewNotes) =>
      _$this._finalReviewNotes = finalReviewNotes;

  DateTime? _clientSignedAt;
  DateTime? get clientSignedAt => _$this._clientSignedAt;
  set clientSignedAt(DateTime? clientSignedAt) =>
      _$this._clientSignedAt = clientSignedAt;

  DateTime? _trainerSignedAt;
  DateTime? get trainerSignedAt => _$this._trainerSignedAt;
  set trainerSignedAt(DateTime? trainerSignedAt) =>
      _$this._trainerSignedAt = trainerSignedAt;

  int? _managerUserId;
  int? get managerUserId => _$this._managerUserId;
  set managerUserId(int? managerUserId) =>
      _$this._managerUserId = managerUserId;

  DateTime? _managerSignedAt;
  DateTime? get managerSignedAt => _$this._managerSignedAt;
  set managerSignedAt(DateTime? managerSignedAt) =>
      _$this._managerSignedAt = managerSignedAt;

  PtProgressReviewStatusEnum? _status;
  PtProgressReviewStatusEnum? get status => _$this._status;
  set status(PtProgressReviewStatusEnum? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  PtProgressReviewBuilder() {
    PtProgressReview._defaults(this);
  }

  PtProgressReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _trainerId = $v.trainerId;
      _reviewPeriodStart = $v.reviewPeriodStart;
      _reviewPeriodEnd = $v.reviewPeriodEnd;
      _bodyMetricsSnapshot = $v.bodyMetricsSnapshot?.toBuilder();
      _performanceMarkersSnapshot = $v.performanceMarkersSnapshot?.toBuilder();
      _progressHighlights = $v.progressHighlights?.toBuilder();
      _highlightsOtherText = $v.highlightsOtherText;
      _trainerSummary = $v.trainerSummary;
      _clientFeedback = $v.clientFeedback;
      _nextPhaseGoal = $v.nextPhaseGoal;
      _nextPhaseTrainingFocus = $v.nextPhaseTrainingFocus;
      _nextReviewDate = $v.nextReviewDate;
      _reviewChecklist = $v.reviewChecklist?.toBuilder();
      _finalReviewNotes = $v.finalReviewNotes;
      _clientSignedAt = $v.clientSignedAt;
      _trainerSignedAt = $v.trainerSignedAt;
      _managerUserId = $v.managerUserId;
      _managerSignedAt = $v.managerSignedAt;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtProgressReview other) {
    _$v = other as _$PtProgressReview;
  }

  @override
  void update(void Function(PtProgressReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtProgressReview build() => _build();

  _$PtProgressReview _build() {
    _$PtProgressReview _$result;
    try {
      _$result = _$v ??
          _$PtProgressReview._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PtProgressReview', 'id'),
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'PtProgressReview', 'memberId'),
            trainerId: BuiltValueNullFieldError.checkNotNull(
                trainerId, r'PtProgressReview', 'trainerId'),
            reviewPeriodStart: BuiltValueNullFieldError.checkNotNull(
                reviewPeriodStart, r'PtProgressReview', 'reviewPeriodStart'),
            reviewPeriodEnd: BuiltValueNullFieldError.checkNotNull(
                reviewPeriodEnd, r'PtProgressReview', 'reviewPeriodEnd'),
            bodyMetricsSnapshot: _bodyMetricsSnapshot?.build(),
            performanceMarkersSnapshot: _performanceMarkersSnapshot?.build(),
            progressHighlights: _progressHighlights?.build(),
            highlightsOtherText: highlightsOtherText,
            trainerSummary: trainerSummary,
            clientFeedback: clientFeedback,
            nextPhaseGoal: nextPhaseGoal,
            nextPhaseTrainingFocus: nextPhaseTrainingFocus,
            nextReviewDate: nextReviewDate,
            reviewChecklist: _reviewChecklist?.build(),
            finalReviewNotes: finalReviewNotes,
            clientSignedAt: clientSignedAt,
            trainerSignedAt: trainerSignedAt,
            managerUserId: managerUserId,
            managerSignedAt: managerSignedAt,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PtProgressReview', 'status'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PtProgressReview', 'createdAt'),
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bodyMetricsSnapshot';
        _bodyMetricsSnapshot?.build();
        _$failedField = 'performanceMarkersSnapshot';
        _performanceMarkersSnapshot?.build();
        _$failedField = 'progressHighlights';
        _progressHighlights?.build();

        _$failedField = 'reviewChecklist';
        _reviewChecklist?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PtProgressReview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
