// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_food.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietPlanFood extends DietPlanFood {
  @override
  final int id;
  @override
  final int dietPlanMealId;
  @override
  final int foodId;
  @override
  final num quantity;
  @override
  final String? servingUnit;
  @override
  final Food? food;

  factory _$DietPlanFood([void Function(DietPlanFoodBuilder)? updates]) =>
      (DietPlanFoodBuilder()..update(updates))._build();

  _$DietPlanFood._(
      {required this.id,
      required this.dietPlanMealId,
      required this.foodId,
      required this.quantity,
      this.servingUnit,
      this.food})
      : super._();
  @override
  DietPlanFood rebuild(void Function(DietPlanFoodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietPlanFoodBuilder toBuilder() => DietPlanFoodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietPlanFood &&
        id == other.id &&
        dietPlanMealId == other.dietPlanMealId &&
        foodId == other.foodId &&
        quantity == other.quantity &&
        servingUnit == other.servingUnit &&
        food == other.food;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, dietPlanMealId.hashCode);
    _$hash = $jc(_$hash, foodId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, servingUnit.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DietPlanFood')
          ..add('id', id)
          ..add('dietPlanMealId', dietPlanMealId)
          ..add('foodId', foodId)
          ..add('quantity', quantity)
          ..add('servingUnit', servingUnit)
          ..add('food', food))
        .toString();
  }
}

class DietPlanFoodBuilder
    implements Builder<DietPlanFood, DietPlanFoodBuilder> {
  _$DietPlanFood? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _dietPlanMealId;
  int? get dietPlanMealId => _$this._dietPlanMealId;
  set dietPlanMealId(int? dietPlanMealId) =>
      _$this._dietPlanMealId = dietPlanMealId;

  int? _foodId;
  int? get foodId => _$this._foodId;
  set foodId(int? foodId) => _$this._foodId = foodId;

  num? _quantity;
  num? get quantity => _$this._quantity;
  set quantity(num? quantity) => _$this._quantity = quantity;

  String? _servingUnit;
  String? get servingUnit => _$this._servingUnit;
  set servingUnit(String? servingUnit) => _$this._servingUnit = servingUnit;

  FoodBuilder? _food;
  FoodBuilder get food => _$this._food ??= FoodBuilder();
  set food(FoodBuilder? food) => _$this._food = food;

  DietPlanFoodBuilder() {
    DietPlanFood._defaults(this);
  }

  DietPlanFoodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _dietPlanMealId = $v.dietPlanMealId;
      _foodId = $v.foodId;
      _quantity = $v.quantity;
      _servingUnit = $v.servingUnit;
      _food = $v.food?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietPlanFood other) {
    _$v = other as _$DietPlanFood;
  }

  @override
  void update(void Function(DietPlanFoodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietPlanFood build() => _build();

  _$DietPlanFood _build() {
    _$DietPlanFood _$result;
    try {
      _$result = _$v ??
          _$DietPlanFood._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DietPlanFood', 'id'),
            dietPlanMealId: BuiltValueNullFieldError.checkNotNull(
                dietPlanMealId, r'DietPlanFood', 'dietPlanMealId'),
            foodId: BuiltValueNullFieldError.checkNotNull(
                foodId, r'DietPlanFood', 'foodId'),
            quantity: BuiltValueNullFieldError.checkNotNull(
                quantity, r'DietPlanFood', 'quantity'),
            servingUnit: servingUnit,
            food: _food?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'food';
        _food?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DietPlanFood', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
