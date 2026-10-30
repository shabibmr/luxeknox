// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'par_q_submit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ParQSubmitDeclarationAcceptedEnum
    _$parQSubmitDeclarationAcceptedEnum_true_ =
    const ParQSubmitDeclarationAcceptedEnum._('true_');

ParQSubmitDeclarationAcceptedEnum _$parQSubmitDeclarationAcceptedEnumValueOf(
    String name) {
  switch (name) {
    case 'true_':
      return _$parQSubmitDeclarationAcceptedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ParQSubmitDeclarationAcceptedEnum>
    _$parQSubmitDeclarationAcceptedEnumValues = BuiltSet<
        ParQSubmitDeclarationAcceptedEnum>(const <ParQSubmitDeclarationAcceptedEnum>[
  _$parQSubmitDeclarationAcceptedEnum_true_,
]);

Serializer<ParQSubmitDeclarationAcceptedEnum>
    _$parQSubmitDeclarationAcceptedEnumSerializer =
    _$ParQSubmitDeclarationAcceptedEnumSerializer();

class _$ParQSubmitDeclarationAcceptedEnumSerializer
    implements PrimitiveSerializer<ParQSubmitDeclarationAcceptedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[ParQSubmitDeclarationAcceptedEnum];
  @override
  final String wireName = 'ParQSubmitDeclarationAcceptedEnum';

  @override
  Object serialize(
          Serializers serializers, ParQSubmitDeclarationAcceptedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ParQSubmitDeclarationAcceptedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ParQSubmitDeclarationAcceptedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ParQSubmit extends ParQSubmit {
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
  final ParQSubmitDeclarationAcceptedEnum declarationAccepted;
  @override
  final String clientSignature;

  factory _$ParQSubmit([void Function(ParQSubmitBuilder)? updates]) =>
      (ParQSubmitBuilder()..update(updates))._build();

  _$ParQSubmit._(
      {required this.q1HeartCondition,
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
      required this.declarationAccepted,
      required this.clientSignature})
      : super._();
  @override
  ParQSubmit rebuild(void Function(ParQSubmitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParQSubmitBuilder toBuilder() => ParQSubmitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParQSubmit &&
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
        declarationAccepted == other.declarationAccepted &&
        clientSignature == other.clientSignature;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    _$hash = $jc(_$hash, declarationAccepted.hashCode);
    _$hash = $jc(_$hash, clientSignature.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParQSubmit')
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
          ..add('declarationAccepted', declarationAccepted)
          ..add('clientSignature', clientSignature))
        .toString();
  }
}

class ParQSubmitBuilder implements Builder<ParQSubmit, ParQSubmitBuilder> {
  _$ParQSubmit? _$v;

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

  ParQSubmitDeclarationAcceptedEnum? _declarationAccepted;
  ParQSubmitDeclarationAcceptedEnum? get declarationAccepted =>
      _$this._declarationAccepted;
  set declarationAccepted(
          ParQSubmitDeclarationAcceptedEnum? declarationAccepted) =>
      _$this._declarationAccepted = declarationAccepted;

  String? _clientSignature;
  String? get clientSignature => _$this._clientSignature;
  set clientSignature(String? clientSignature) =>
      _$this._clientSignature = clientSignature;

  ParQSubmitBuilder() {
    ParQSubmit._defaults(this);
  }

  ParQSubmitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
      _declarationAccepted = $v.declarationAccepted;
      _clientSignature = $v.clientSignature;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParQSubmit other) {
    _$v = other as _$ParQSubmit;
  }

  @override
  void update(void Function(ParQSubmitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParQSubmit build() => _build();

  _$ParQSubmit _build() {
    final _$result = _$v ??
        _$ParQSubmit._(
          q1HeartCondition: BuiltValueNullFieldError.checkNotNull(
              q1HeartCondition, r'ParQSubmit', 'q1HeartCondition'),
          q1Details: q1Details,
          q2ChestPainActivity: BuiltValueNullFieldError.checkNotNull(
              q2ChestPainActivity, r'ParQSubmit', 'q2ChestPainActivity'),
          q2Details: q2Details,
          q3ChestPainRest: BuiltValueNullFieldError.checkNotNull(
              q3ChestPainRest, r'ParQSubmit', 'q3ChestPainRest'),
          q3Details: q3Details,
          q4DizzinessConsciousness: BuiltValueNullFieldError.checkNotNull(
              q4DizzinessConsciousness,
              r'ParQSubmit',
              'q4DizzinessConsciousness'),
          q4Details: q4Details,
          q5BoneJointProblem: BuiltValueNullFieldError.checkNotNull(
              q5BoneJointProblem, r'ParQSubmit', 'q5BoneJointProblem'),
          q5Details: q5Details,
          q6MedicationCondition: BuiltValueNullFieldError.checkNotNull(
              q6MedicationCondition, r'ParQSubmit', 'q6MedicationCondition'),
          q6Details: q6Details,
          q7OtherReason: BuiltValueNullFieldError.checkNotNull(
              q7OtherReason, r'ParQSubmit', 'q7OtherReason'),
          q7Details: q7Details,
          declarationAccepted: BuiltValueNullFieldError.checkNotNull(
              declarationAccepted, r'ParQSubmit', 'declarationAccepted'),
          clientSignature: BuiltValueNullFieldError.checkNotNull(
              clientSignature, r'ParQSubmit', 'clientSignature'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
