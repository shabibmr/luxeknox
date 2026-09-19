// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_health.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberHealth extends MemberHealth {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final String? bloodGroup;
  @override
  final num? heightCm;
  @override
  final num? baselineWeightKg;
  @override
  final String? allergies;
  @override
  final String? dietaryPreferences;
  @override
  final String? physicianName;
  @override
  final String? physicianPhone;
  @override
  final DateTime? updatedAt;

  factory _$MemberHealth([void Function(MemberHealthBuilder)? updates]) =>
      (MemberHealthBuilder()..update(updates))._build();

  _$MemberHealth._(
      {required this.id,
      required this.memberId,
      this.bloodGroup,
      this.heightCm,
      this.baselineWeightKg,
      this.allergies,
      this.dietaryPreferences,
      this.physicianName,
      this.physicianPhone,
      this.updatedAt})
      : super._();
  @override
  MemberHealth rebuild(void Function(MemberHealthBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberHealthBuilder toBuilder() => MemberHealthBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberHealth &&
        id == other.id &&
        memberId == other.memberId &&
        bloodGroup == other.bloodGroup &&
        heightCm == other.heightCm &&
        baselineWeightKg == other.baselineWeightKg &&
        allergies == other.allergies &&
        dietaryPreferences == other.dietaryPreferences &&
        physicianName == other.physicianName &&
        physicianPhone == other.physicianPhone &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, bloodGroup.hashCode);
    _$hash = $jc(_$hash, heightCm.hashCode);
    _$hash = $jc(_$hash, baselineWeightKg.hashCode);
    _$hash = $jc(_$hash, allergies.hashCode);
    _$hash = $jc(_$hash, dietaryPreferences.hashCode);
    _$hash = $jc(_$hash, physicianName.hashCode);
    _$hash = $jc(_$hash, physicianPhone.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberHealth')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('bloodGroup', bloodGroup)
          ..add('heightCm', heightCm)
          ..add('baselineWeightKg', baselineWeightKg)
          ..add('allergies', allergies)
          ..add('dietaryPreferences', dietaryPreferences)
          ..add('physicianName', physicianName)
          ..add('physicianPhone', physicianPhone)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class MemberHealthBuilder
    implements Builder<MemberHealth, MemberHealthBuilder> {
  _$MemberHealth? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  String? _bloodGroup;
  String? get bloodGroup => _$this._bloodGroup;
  set bloodGroup(String? bloodGroup) => _$this._bloodGroup = bloodGroup;

  num? _heightCm;
  num? get heightCm => _$this._heightCm;
  set heightCm(num? heightCm) => _$this._heightCm = heightCm;

  num? _baselineWeightKg;
  num? get baselineWeightKg => _$this._baselineWeightKg;
  set baselineWeightKg(num? baselineWeightKg) =>
      _$this._baselineWeightKg = baselineWeightKg;

  String? _allergies;
  String? get allergies => _$this._allergies;
  set allergies(String? allergies) => _$this._allergies = allergies;

  String? _dietaryPreferences;
  String? get dietaryPreferences => _$this._dietaryPreferences;
  set dietaryPreferences(String? dietaryPreferences) =>
      _$this._dietaryPreferences = dietaryPreferences;

  String? _physicianName;
  String? get physicianName => _$this._physicianName;
  set physicianName(String? physicianName) =>
      _$this._physicianName = physicianName;

  String? _physicianPhone;
  String? get physicianPhone => _$this._physicianPhone;
  set physicianPhone(String? physicianPhone) =>
      _$this._physicianPhone = physicianPhone;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  MemberHealthBuilder() {
    MemberHealth._defaults(this);
  }

  MemberHealthBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _bloodGroup = $v.bloodGroup;
      _heightCm = $v.heightCm;
      _baselineWeightKg = $v.baselineWeightKg;
      _allergies = $v.allergies;
      _dietaryPreferences = $v.dietaryPreferences;
      _physicianName = $v.physicianName;
      _physicianPhone = $v.physicianPhone;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberHealth other) {
    _$v = other as _$MemberHealth;
  }

  @override
  void update(void Function(MemberHealthBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberHealth build() => _build();

  _$MemberHealth _build() {
    final _$result = _$v ??
        _$MemberHealth._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'MemberHealth', 'id'),
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'MemberHealth', 'memberId'),
          bloodGroup: bloodGroup,
          heightCm: heightCm,
          baselineWeightKg: baselineWeightKg,
          allergies: allergies,
          dietaryPreferences: dietaryPreferences,
          physicianName: physicianName,
          physicianPhone: physicianPhone,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
