// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_health_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberHealthWrite extends MemberHealthWrite {
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

  factory _$MemberHealthWrite(
          [void Function(MemberHealthWriteBuilder)? updates]) =>
      (MemberHealthWriteBuilder()..update(updates))._build();

  _$MemberHealthWrite._(
      {this.bloodGroup,
      this.heightCm,
      this.baselineWeightKg,
      this.allergies,
      this.dietaryPreferences,
      this.physicianName,
      this.physicianPhone})
      : super._();
  @override
  MemberHealthWrite rebuild(void Function(MemberHealthWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberHealthWriteBuilder toBuilder() =>
      MemberHealthWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberHealthWrite &&
        bloodGroup == other.bloodGroup &&
        heightCm == other.heightCm &&
        baselineWeightKg == other.baselineWeightKg &&
        allergies == other.allergies &&
        dietaryPreferences == other.dietaryPreferences &&
        physicianName == other.physicianName &&
        physicianPhone == other.physicianPhone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bloodGroup.hashCode);
    _$hash = $jc(_$hash, heightCm.hashCode);
    _$hash = $jc(_$hash, baselineWeightKg.hashCode);
    _$hash = $jc(_$hash, allergies.hashCode);
    _$hash = $jc(_$hash, dietaryPreferences.hashCode);
    _$hash = $jc(_$hash, physicianName.hashCode);
    _$hash = $jc(_$hash, physicianPhone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberHealthWrite')
          ..add('bloodGroup', bloodGroup)
          ..add('heightCm', heightCm)
          ..add('baselineWeightKg', baselineWeightKg)
          ..add('allergies', allergies)
          ..add('dietaryPreferences', dietaryPreferences)
          ..add('physicianName', physicianName)
          ..add('physicianPhone', physicianPhone))
        .toString();
  }
}

class MemberHealthWriteBuilder
    implements Builder<MemberHealthWrite, MemberHealthWriteBuilder> {
  _$MemberHealthWrite? _$v;

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

  MemberHealthWriteBuilder() {
    MemberHealthWrite._defaults(this);
  }

  MemberHealthWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bloodGroup = $v.bloodGroup;
      _heightCm = $v.heightCm;
      _baselineWeightKg = $v.baselineWeightKg;
      _allergies = $v.allergies;
      _dietaryPreferences = $v.dietaryPreferences;
      _physicianName = $v.physicianName;
      _physicianPhone = $v.physicianPhone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberHealthWrite other) {
    _$v = other as _$MemberHealthWrite;
  }

  @override
  void update(void Function(MemberHealthWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberHealthWrite build() => _build();

  _$MemberHealthWrite _build() {
    final _$result = _$v ??
        _$MemberHealthWrite._(
          bloodGroup: bloodGroup,
          heightCm: heightCm,
          baselineWeightKg: baselineWeightKg,
          allergies: allergies,
          dietaryPreferences: dietaryPreferences,
          physicianName: physicianName,
          physicianPhone: physicianPhone,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
