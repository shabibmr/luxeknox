// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FoodWrite extends FoodWrite {
  @override
  final String name;
  @override
  final String servingUnit;
  @override
  final num? servingSize;
  @override
  final num? calories;
  @override
  final num? proteinGrams;
  @override
  final num? carbsGrams;
  @override
  final num? fatGrams;
  @override
  final num? fiberGrams;
  @override
  final bool? isVerified;

  factory _$FoodWrite([void Function(FoodWriteBuilder)? updates]) =>
      (FoodWriteBuilder()..update(updates))._build();

  _$FoodWrite._(
      {required this.name,
      required this.servingUnit,
      this.servingSize,
      this.calories,
      this.proteinGrams,
      this.carbsGrams,
      this.fatGrams,
      this.fiberGrams,
      this.isVerified})
      : super._();
  @override
  FoodWrite rebuild(void Function(FoodWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FoodWriteBuilder toBuilder() => FoodWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FoodWrite &&
        name == other.name &&
        servingUnit == other.servingUnit &&
        servingSize == other.servingSize &&
        calories == other.calories &&
        proteinGrams == other.proteinGrams &&
        carbsGrams == other.carbsGrams &&
        fatGrams == other.fatGrams &&
        fiberGrams == other.fiberGrams &&
        isVerified == other.isVerified;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, servingUnit.hashCode);
    _$hash = $jc(_$hash, servingSize.hashCode);
    _$hash = $jc(_$hash, calories.hashCode);
    _$hash = $jc(_$hash, proteinGrams.hashCode);
    _$hash = $jc(_$hash, carbsGrams.hashCode);
    _$hash = $jc(_$hash, fatGrams.hashCode);
    _$hash = $jc(_$hash, fiberGrams.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FoodWrite')
          ..add('name', name)
          ..add('servingUnit', servingUnit)
          ..add('servingSize', servingSize)
          ..add('calories', calories)
          ..add('proteinGrams', proteinGrams)
          ..add('carbsGrams', carbsGrams)
          ..add('fatGrams', fatGrams)
          ..add('fiberGrams', fiberGrams)
          ..add('isVerified', isVerified))
        .toString();
  }
}

class FoodWriteBuilder implements Builder<FoodWrite, FoodWriteBuilder> {
  _$FoodWrite? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _servingUnit;
  String? get servingUnit => _$this._servingUnit;
  set servingUnit(String? servingUnit) => _$this._servingUnit = servingUnit;

  num? _servingSize;
  num? get servingSize => _$this._servingSize;
  set servingSize(num? servingSize) => _$this._servingSize = servingSize;

  num? _calories;
  num? get calories => _$this._calories;
  set calories(num? calories) => _$this._calories = calories;

  num? _proteinGrams;
  num? get proteinGrams => _$this._proteinGrams;
  set proteinGrams(num? proteinGrams) => _$this._proteinGrams = proteinGrams;

  num? _carbsGrams;
  num? get carbsGrams => _$this._carbsGrams;
  set carbsGrams(num? carbsGrams) => _$this._carbsGrams = carbsGrams;

  num? _fatGrams;
  num? get fatGrams => _$this._fatGrams;
  set fatGrams(num? fatGrams) => _$this._fatGrams = fatGrams;

  num? _fiberGrams;
  num? get fiberGrams => _$this._fiberGrams;
  set fiberGrams(num? fiberGrams) => _$this._fiberGrams = fiberGrams;

  bool? _isVerified;
  bool? get isVerified => _$this._isVerified;
  set isVerified(bool? isVerified) => _$this._isVerified = isVerified;

  FoodWriteBuilder() {
    FoodWrite._defaults(this);
  }

  FoodWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _servingUnit = $v.servingUnit;
      _servingSize = $v.servingSize;
      _calories = $v.calories;
      _proteinGrams = $v.proteinGrams;
      _carbsGrams = $v.carbsGrams;
      _fatGrams = $v.fatGrams;
      _fiberGrams = $v.fiberGrams;
      _isVerified = $v.isVerified;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FoodWrite other) {
    _$v = other as _$FoodWrite;
  }

  @override
  void update(void Function(FoodWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FoodWrite build() => _build();

  _$FoodWrite _build() {
    final _$result = _$v ??
        _$FoodWrite._(
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'FoodWrite', 'name'),
          servingUnit: BuiltValueNullFieldError.checkNotNull(
              servingUnit, r'FoodWrite', 'servingUnit'),
          servingSize: servingSize,
          calories: calories,
          proteinGrams: proteinGrams,
          carbsGrams: carbsGrams,
          fatGrams: fatGrams,
          fiberGrams: fiberGrams,
          isVerified: isVerified,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
