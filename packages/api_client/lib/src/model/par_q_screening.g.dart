// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'par_q_screening.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ParQScreeningClearanceStatusEnum
    _$parQScreeningClearanceStatusEnum_passed =
    const ParQScreeningClearanceStatusEnum._('passed');
const ParQScreeningClearanceStatusEnum
    _$parQScreeningClearanceStatusEnum_pendingClearance =
    const ParQScreeningClearanceStatusEnum._('pendingClearance');
const ParQScreeningClearanceStatusEnum
    _$parQScreeningClearanceStatusEnum_cleared =
    const ParQScreeningClearanceStatusEnum._('cleared');
const ParQScreeningClearanceStatusEnum
    _$parQScreeningClearanceStatusEnum_rejected =
    const ParQScreeningClearanceStatusEnum._('rejected');

ParQScreeningClearanceStatusEnum _$parQScreeningClearanceStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'passed':
      return _$parQScreeningClearanceStatusEnum_passed;
    case 'pendingClearance':
      return _$parQScreeningClearanceStatusEnum_pendingClearance;
    case 'cleared':
      return _$parQScreeningClearanceStatusEnum_cleared;
    case 'rejected':
      return _$parQScreeningClearanceStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ParQScreeningClearanceStatusEnum>
    _$parQScreeningClearanceStatusEnumValues = BuiltSet<
        ParQScreeningClearanceStatusEnum>(const <ParQScreeningClearanceStatusEnum>[
  _$parQScreeningClearanceStatusEnum_passed,
  _$parQScreeningClearanceStatusEnum_pendingClearance,
  _$parQScreeningClearanceStatusEnum_cleared,
  _$parQScreeningClearanceStatusEnum_rejected,
]);

Serializer<ParQScreeningClearanceStatusEnum>
    _$parQScreeningClearanceStatusEnumSerializer =
    _$ParQScreeningClearanceStatusEnumSerializer();

class _$ParQScreeningClearanceStatusEnumSerializer
    implements PrimitiveSerializer<ParQScreeningClearanceStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'passed': 'passed',
    'pendingClearance': 'pending_clearance',
    'cleared': 'cleared',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'passed': 'passed',
    'pending_clearance': 'pendingClearance',
    'cleared': 'cleared',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[ParQScreeningClearanceStatusEnum];
  @override
  final String wireName = 'ParQScreeningClearanceStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ParQScreeningClearanceStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ParQScreeningClearanceStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ParQScreeningClearanceStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ParQScreening extends ParQScreening {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final String version;
  @override
  final bool q1HeartCondition;
  @override
  final String? q1Details;
  @override
  final bool q2ChestPainActivity;
  @override
  final String? q2Details;
  @override
  final bool q3ChestPainRest;
  @override
  final String? q3Details;
  @override
  final bool q4DizzinessConsciousness;
  @override
  final String? q4Details;
  @override
  final bool q5BoneJointProblem;
  @override
  final String? q5Details;
  @override
  final bool q6MedicationCondition;
  @override
  final String? q6Details;
  @override
  final bool q7OtherReason;
  @override
  final String? q7Details;
  @override
  final bool hasPositiveAnswer;
  @override
  final String? trainerScreeningNotes;
  @override
  final bool referralRequired;
  @override
  final String? referralReason;
  @override
  final bool declarationAccepted;
  @override
  final DateTime? clientSignedAt;
  @override
  final DateTime? trainerSignedAt;
  @override
  final ParQScreeningClearanceStatusEnum clearanceStatus;
  @override
  final DateTime? clearedAt;
  @override
  final int? clearedByUserId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  factory _$ParQScreening([void Function(ParQScreeningBuilder)? updates]) =>
      (ParQScreeningBuilder()..update(updates))._build();

  _$ParQScreening._(
      {required this.id,
      required this.memberId,
      required this.version,
      required this.q1HeartCondition,
      this.q1Details,
      required this.q2ChestPainActivity,
      this.q2Details,
      required this.q3ChestPainRest,
      this.q3Details,
      required this.q4DizzinessConsciousness,
      this.q4Details,
      required this.q5BoneJointProblem,
      this.q5Details,
      required this.q6MedicationCondition,
      this.q6Details,
      required this.q7OtherReason,
      this.q7Details,
      required this.hasPositiveAnswer,
      this.trainerScreeningNotes,
      required this.referralRequired,
      this.referralReason,
      required this.declarationAccepted,
      this.clientSignedAt,
      this.trainerSignedAt,
      required this.clearanceStatus,
      this.clearedAt,
      this.clearedByUserId,
      required this.createdAt,
      this.updatedAt})
      : super._();
  @override
  ParQScreening rebuild(void Function(ParQScreeningBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParQScreeningBuilder toBuilder() => ParQScreeningBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParQScreening &&
        id == other.id &&
        memberId == other.memberId &&
        version == other.version &&
        q1HeartCondition == other.q1HeartCondition &&
        q1Details == other.q1Details &&
        q2ChestPainActivity == other.q2ChestPainActivity &&
        q2Details == other.q2Details &&
        q3ChestPainRest == other.q3ChestPainRest &&
        q3Details == other.q3Details &&
        q4DizzinessConsciousness == other.q4DizzinessConsciousness &&
        q4Details == other.q4Details &&
        q5BoneJointProblem == other.q5BoneJointProblem &&
        q5Details == other.q5Details &&
        q6MedicationCondition == other.q6MedicationCondition &&
        q6Details == other.q6Details &&
        q7OtherReason == other.q7OtherReason &&
        q7Details == other.q7Details &&
        hasPositiveAnswer == other.hasPositiveAnswer &&
        trainerScreeningNotes == other.trainerScreeningNotes &&
        referralRequired == other.referralRequired &&
        referralReason == other.referralReason &&
        declarationAccepted == other.declarationAccepted &&
        clientSignedAt == other.clientSignedAt &&
        trainerSignedAt == other.trainerSignedAt &&
        clearanceStatus == other.clearanceStatus &&
        clearedAt == other.clearedAt &&
        clearedByUserId == other.clearedByUserId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, q1HeartCondition.hashCode);
    _$hash = $jc(_$hash, q1Details.hashCode);
    _$hash = $jc(_$hash, q2ChestPainActivity.hashCode);
    _$hash = $jc(_$hash, q2Details.hashCode);
    _$hash = $jc(_$hash, q3ChestPainRest.hashCode);
    _$hash = $jc(_$hash, q3Details.hashCode);
    _$hash = $jc(_$hash, q4DizzinessConsciousness.hashCode);
    _$hash = $jc(_$hash, q4Details.hashCode);
    _$hash = $jc(_$hash, q5BoneJointProblem.hashCode);
    _$hash = $jc(_$hash, q5Details.hashCode);
    _$hash = $jc(_$hash, q6MedicationCondition.hashCode);
    _$hash = $jc(_$hash, q6Details.hashCode);
    _$hash = $jc(_$hash, q7OtherReason.hashCode);
    _$hash = $jc(_$hash, q7Details.hashCode);
    _$hash = $jc(_$hash, hasPositiveAnswer.hashCode);
    _$hash = $jc(_$hash, trainerScreeningNotes.hashCode);
    _$hash = $jc(_$hash, referralRequired.hashCode);
    _$hash = $jc(_$hash, referralReason.hashCode);
    _$hash = $jc(_$hash, declarationAccepted.hashCode);
    _$hash = $jc(_$hash, clientSignedAt.hashCode);
    _$hash = $jc(_$hash, trainerSignedAt.hashCode);
    _$hash = $jc(_$hash, clearanceStatus.hashCode);
    _$hash = $jc(_$hash, clearedAt.hashCode);
    _$hash = $jc(_$hash, clearedByUserId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParQScreening')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('version', version)
          ..add('q1HeartCondition', q1HeartCondition)
          ..add('q1Details', q1Details)
          ..add('q2ChestPainActivity', q2ChestPainActivity)
          ..add('q2Details', q2Details)
          ..add('q3ChestPainRest', q3ChestPainRest)
          ..add('q3Details', q3Details)
          ..add('q4DizzinessConsciousness', q4DizzinessConsciousness)
          ..add('q4Details', q4Details)
          ..add('q5BoneJointProblem', q5BoneJointProblem)
          ..add('q5Details', q5Details)
          ..add('q6MedicationCondition', q6MedicationCondition)
          ..add('q6Details', q6Details)
          ..add('q7OtherReason', q7OtherReason)
          ..add('q7Details', q7Details)
          ..add('hasPositiveAnswer', hasPositiveAnswer)
          ..add('trainerScreeningNotes', trainerScreeningNotes)
          ..add('referralRequired', referralRequired)
          ..add('referralReason', referralReason)
          ..add('declarationAccepted', declarationAccepted)
          ..add('clientSignedAt', clientSignedAt)
          ..add('trainerSignedAt', trainerSignedAt)
          ..add('clearanceStatus', clearanceStatus)
          ..add('clearedAt', clearedAt)
          ..add('clearedByUserId', clearedByUserId)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ParQScreeningBuilder
    implements Builder<ParQScreening, ParQScreeningBuilder> {
  _$ParQScreening? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  bool? _q1HeartCondition;
  bool? get q1HeartCondition => _$this._q1HeartCondition;
  set q1HeartCondition(bool? q1HeartCondition) =>
      _$this._q1HeartCondition = q1HeartCondition;

  String? _q1Details;
  String? get q1Details => _$this._q1Details;
  set q1Details(String? q1Details) => _$this._q1Details = q1Details;

  bool? _q2ChestPainActivity;
  bool? get q2ChestPainActivity => _$this._q2ChestPainActivity;
  set q2ChestPainActivity(bool? q2ChestPainActivity) =>
      _$this._q2ChestPainActivity = q2ChestPainActivity;

  String? _q2Details;
  String? get q2Details => _$this._q2Details;
  set q2Details(String? q2Details) => _$this._q2Details = q2Details;

  bool? _q3ChestPainRest;
  bool? get q3ChestPainRest => _$this._q3ChestPainRest;
  set q3ChestPainRest(bool? q3ChestPainRest) =>
      _$this._q3ChestPainRest = q3ChestPainRest;

  String? _q3Details;
  String? get q3Details => _$this._q3Details;
  set q3Details(String? q3Details) => _$this._q3Details = q3Details;

  bool? _q4DizzinessConsciousness;
  bool? get q4DizzinessConsciousness => _$this._q4DizzinessConsciousness;
  set q4DizzinessConsciousness(bool? q4DizzinessConsciousness) =>
      _$this._q4DizzinessConsciousness = q4DizzinessConsciousness;

  String? _q4Details;
  String? get q4Details => _$this._q4Details;
  set q4Details(String? q4Details) => _$this._q4Details = q4Details;

  bool? _q5BoneJointProblem;
  bool? get q5BoneJointProblem => _$this._q5BoneJointProblem;
  set q5BoneJointProblem(bool? q5BoneJointProblem) =>
      _$this._q5BoneJointProblem = q5BoneJointProblem;

  String? _q5Details;
  String? get q5Details => _$this._q5Details;
  set q5Details(String? q5Details) => _$this._q5Details = q5Details;

  bool? _q6MedicationCondition;
  bool? get q6MedicationCondition => _$this._q6MedicationCondition;
  set q6MedicationCondition(bool? q6MedicationCondition) =>
      _$this._q6MedicationCondition = q6MedicationCondition;

  String? _q6Details;
  String? get q6Details => _$this._q6Details;
  set q6Details(String? q6Details) => _$this._q6Details = q6Details;

  bool? _q7OtherReason;
  bool? get q7OtherReason => _$this._q7OtherReason;
  set q7OtherReason(bool? q7OtherReason) =>
      _$this._q7OtherReason = q7OtherReason;

  String? _q7Details;
  String? get q7Details => _$this._q7Details;
  set q7Details(String? q7Details) => _$this._q7Details = q7Details;

  bool? _hasPositiveAnswer;
  bool? get hasPositiveAnswer => _$this._hasPositiveAnswer;
  set hasPositiveAnswer(bool? hasPositiveAnswer) =>
      _$this._hasPositiveAnswer = hasPositiveAnswer;

  String? _trainerScreeningNotes;
  String? get trainerScreeningNotes => _$this._trainerScreeningNotes;
  set trainerScreeningNotes(String? trainerScreeningNotes) =>
      _$this._trainerScreeningNotes = trainerScreeningNotes;

  bool? _referralRequired;
  bool? get referralRequired => _$this._referralRequired;
  set referralRequired(bool? referralRequired) =>
      _$this._referralRequired = referralRequired;

  String? _referralReason;
  String? get referralReason => _$this._referralReason;
  set referralReason(String? referralReason) =>
      _$this._referralReason = referralReason;

  bool? _declarationAccepted;
  bool? get declarationAccepted => _$this._declarationAccepted;
  set declarationAccepted(bool? declarationAccepted) =>
      _$this._declarationAccepted = declarationAccepted;

  DateTime? _clientSignedAt;
  DateTime? get clientSignedAt => _$this._clientSignedAt;
  set clientSignedAt(DateTime? clientSignedAt) =>
      _$this._clientSignedAt = clientSignedAt;

  DateTime? _trainerSignedAt;
  DateTime? get trainerSignedAt => _$this._trainerSignedAt;
  set trainerSignedAt(DateTime? trainerSignedAt) =>
      _$this._trainerSignedAt = trainerSignedAt;

  ParQScreeningClearanceStatusEnum? _clearanceStatus;
  ParQScreeningClearanceStatusEnum? get clearanceStatus =>
      _$this._clearanceStatus;
  set clearanceStatus(ParQScreeningClearanceStatusEnum? clearanceStatus) =>
      _$this._clearanceStatus = clearanceStatus;

  DateTime? _clearedAt;
  DateTime? get clearedAt => _$this._clearedAt;
  set clearedAt(DateTime? clearedAt) => _$this._clearedAt = clearedAt;

  int? _clearedByUserId;
  int? get clearedByUserId => _$this._clearedByUserId;
  set clearedByUserId(int? clearedByUserId) =>
      _$this._clearedByUserId = clearedByUserId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ParQScreeningBuilder() {
    ParQScreening._defaults(this);
  }

  ParQScreeningBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _version = $v.version;
      _q1HeartCondition = $v.q1HeartCondition;
      _q1Details = $v.q1Details;
      _q2ChestPainActivity = $v.q2ChestPainActivity;
      _q2Details = $v.q2Details;
      _q3ChestPainRest = $v.q3ChestPainRest;
      _q3Details = $v.q3Details;
      _q4DizzinessConsciousness = $v.q4DizzinessConsciousness;
      _q4Details = $v.q4Details;
      _q5BoneJointProblem = $v.q5BoneJointProblem;
      _q5Details = $v.q5Details;
      _q6MedicationCondition = $v.q6MedicationCondition;
      _q6Details = $v.q6Details;
      _q7OtherReason = $v.q7OtherReason;
      _q7Details = $v.q7Details;
      _hasPositiveAnswer = $v.hasPositiveAnswer;
      _trainerScreeningNotes = $v.trainerScreeningNotes;
      _referralRequired = $v.referralRequired;
      _referralReason = $v.referralReason;
      _declarationAccepted = $v.declarationAccepted;
      _clientSignedAt = $v.clientSignedAt;
      _trainerSignedAt = $v.trainerSignedAt;
      _clearanceStatus = $v.clearanceStatus;
      _clearedAt = $v.clearedAt;
      _clearedByUserId = $v.clearedByUserId;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParQScreening other) {
    _$v = other as _$ParQScreening;
  }

  @override
  void update(void Function(ParQScreeningBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParQScreening build() => _build();

  _$ParQScreening _build() {
    final _$result = _$v ??
        _$ParQScreening._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ParQScreening', 'id'),
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'ParQScreening', 'memberId'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'ParQScreening', 'version'),
          q1HeartCondition: BuiltValueNullFieldError.checkNotNull(
              q1HeartCondition, r'ParQScreening', 'q1HeartCondition'),
          q1Details: q1Details,
          q2ChestPainActivity: BuiltValueNullFieldError.checkNotNull(
              q2ChestPainActivity, r'ParQScreening', 'q2ChestPainActivity'),
          q2Details: q2Details,
          q3ChestPainRest: BuiltValueNullFieldError.checkNotNull(
              q3ChestPainRest, r'ParQScreening', 'q3ChestPainRest'),
          q3Details: q3Details,
          q4DizzinessConsciousness: BuiltValueNullFieldError.checkNotNull(
              q4DizzinessConsciousness,
              r'ParQScreening',
              'q4DizzinessConsciousness'),
          q4Details: q4Details,
          q5BoneJointProblem: BuiltValueNullFieldError.checkNotNull(
              q5BoneJointProblem, r'ParQScreening', 'q5BoneJointProblem'),
          q5Details: q5Details,
          q6MedicationCondition: BuiltValueNullFieldError.checkNotNull(
              q6MedicationCondition, r'ParQScreening', 'q6MedicationCondition'),
          q6Details: q6Details,
          q7OtherReason: BuiltValueNullFieldError.checkNotNull(
              q7OtherReason, r'ParQScreening', 'q7OtherReason'),
          q7Details: q7Details,
          hasPositiveAnswer: BuiltValueNullFieldError.checkNotNull(
              hasPositiveAnswer, r'ParQScreening', 'hasPositiveAnswer'),
          trainerScreeningNotes: trainerScreeningNotes,
          referralRequired: BuiltValueNullFieldError.checkNotNull(
              referralRequired, r'ParQScreening', 'referralRequired'),
          referralReason: referralReason,
          declarationAccepted: BuiltValueNullFieldError.checkNotNull(
              declarationAccepted, r'ParQScreening', 'declarationAccepted'),
          clientSignedAt: clientSignedAt,
          trainerSignedAt: trainerSignedAt,
          clearanceStatus: BuiltValueNullFieldError.checkNotNull(
              clearanceStatus, r'ParQScreening', 'clearanceStatus'),
          clearedAt: clearedAt,
          clearedByUserId: clearedByUserId,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ParQScreening', 'createdAt'),
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
