// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_meals_write_meals_inner_foods_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietPlanMealsWriteMealsInnerFoodsInner
    extends DietPlanMealsWriteMealsInnerFoodsInner {
  @override
  final int foodId;
  @override
  final num quantity;
  @override
  final String? servingUnit;

  factory _$DietPlanMealsWriteMealsInnerFoodsInner(
          [void Function(DietPlanMealsWriteMealsInnerFoodsInnerBuilder)?
              updates]) =>
      (DietPlanMealsWriteMealsInnerFoodsInnerBuilder()..update(updates))
          ._build();

  _$DietPlanMealsWriteMealsInnerFoodsInner._(
      {required this.foodId, required this.quantity, this.servingUnit})
      : super._();
  @override
  DietPlanMealsWriteMealsInnerFoodsInner rebuild(
          void Function(DietPlanMealsWriteMealsInnerFoodsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietPlanMealsWriteMealsInnerFoodsInnerBuilder toBuilder() =>
      DietPlanMealsWriteMealsInnerFoodsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietPlanMealsWriteMealsInnerFoodsInner &&
        foodId == other.foodId &&
        quantity == other.quantity &&
        servingUnit == other.servingUnit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, foodId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, servingUnit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'DietPlanMealsWriteMealsInnerFoodsInner')
          ..add('foodId', foodId)
          ..add('quantity', quantity)
          ..add('servingUnit', servingUnit))
        .toString();
  }
}

class DietPlanMealsWriteMealsInnerFoodsInnerBuilder
    implements
        Builder<DietPlanMealsWriteMealsInnerFoodsInner,
            DietPlanMealsWriteMealsInnerFoodsInnerBuilder> {
  _$DietPlanMealsWriteMealsInnerFoodsInner? _$v;

  int? _foodId;
  int? get foodId => _$this._foodId;
  set foodId(int? foodId) => _$this._foodId = foodId;

  num? _quantity;
  num? get quantity => _$this._quantity;
  set quantity(num? quantity) => _$this._quantity = quantity;

  String? _servingUnit;
  String? get servingUnit => _$this._servingUnit;
  set servingUnit(String? servingUnit) => _$this._servingUnit = servingUnit;

  DietPlanMealsWriteMealsInnerFoodsInnerBuilder() {
    DietPlanMealsWriteMealsInnerFoodsInner._defaults(this);
  }

  DietPlanMealsWriteMealsInnerFoodsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _foodId = $v.foodId;
      _quantity = $v.quantity;
      _servingUnit = $v.servingUnit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietPlanMealsWriteMealsInnerFoodsInner other) {
    _$v = other as _$DietPlanMealsWriteMealsInnerFoodsInner;
  }

  @override
  void update(
      void Function(DietPlanMealsWriteMealsInnerFoodsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietPlanMealsWriteMealsInnerFoodsInner build() => _build();

  _$DietPlanMealsWriteMealsInnerFoodsInner _build() {
    final _$result = _$v ??
        _$DietPlanMealsWriteMealsInnerFoodsInner._(
          foodId: BuiltValueNullFieldError.checkNotNull(
              foodId, r'DietPlanMealsWriteMealsInnerFoodsInner', 'foodId'),
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'DietPlanMealsWriteMealsInnerFoodsInner', 'quantity'),
          servingUnit: servingUnit,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
