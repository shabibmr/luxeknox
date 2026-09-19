// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_meals_write_meals_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietPlanMealsWriteMealsInner extends DietPlanMealsWriteMealsInner {
  @override
  final String mealName;
  @override
  final String? scheduledTime;
  @override
  final int? targetCalories;
  @override
  final String? notes;
  @override
  final BuiltList<DietPlanMealsWriteMealsInnerFoodsInner>? foods;

  factory _$DietPlanMealsWriteMealsInner(
          [void Function(DietPlanMealsWriteMealsInnerBuilder)? updates]) =>
      (DietPlanMealsWriteMealsInnerBuilder()..update(updates))._build();

  _$DietPlanMealsWriteMealsInner._(
      {required this.mealName,
      this.scheduledTime,
      this.targetCalories,
      this.notes,
      this.foods})
      : super._();
  @override
  DietPlanMealsWriteMealsInner rebuild(
          void Function(DietPlanMealsWriteMealsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietPlanMealsWriteMealsInnerBuilder toBuilder() =>
      DietPlanMealsWriteMealsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietPlanMealsWriteMealsInner &&
        mealName == other.mealName &&
        scheduledTime == other.scheduledTime &&
        targetCalories == other.targetCalories &&
        notes == other.notes &&
        foods == other.foods;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mealName.hashCode);
    _$hash = $jc(_$hash, scheduledTime.hashCode);
    _$hash = $jc(_$hash, targetCalories.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, foods.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DietPlanMealsWriteMealsInner')
          ..add('mealName', mealName)
          ..add('scheduledTime', scheduledTime)
          ..add('targetCalories', targetCalories)
          ..add('notes', notes)
          ..add('foods', foods))
        .toString();
  }
}

class DietPlanMealsWriteMealsInnerBuilder
    implements
        Builder<DietPlanMealsWriteMealsInner,
            DietPlanMealsWriteMealsInnerBuilder> {
  _$DietPlanMealsWriteMealsInner? _$v;

  String? _mealName;
  String? get mealName => _$this._mealName;
  set mealName(String? mealName) => _$this._mealName = mealName;

  String? _scheduledTime;
  String? get scheduledTime => _$this._scheduledTime;
  set scheduledTime(String? scheduledTime) =>
      _$this._scheduledTime = scheduledTime;

  int? _targetCalories;
  int? get targetCalories => _$this._targetCalories;
  set targetCalories(int? targetCalories) =>
      _$this._targetCalories = targetCalories;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  ListBuilder<DietPlanMealsWriteMealsInnerFoodsInner>? _foods;
  ListBuilder<DietPlanMealsWriteMealsInnerFoodsInner> get foods =>
      _$this._foods ??= ListBuilder<DietPlanMealsWriteMealsInnerFoodsInner>();
  set foods(ListBuilder<DietPlanMealsWriteMealsInnerFoodsInner>? foods) =>
      _$this._foods = foods;

  DietPlanMealsWriteMealsInnerBuilder() {
    DietPlanMealsWriteMealsInner._defaults(this);
  }

  DietPlanMealsWriteMealsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mealName = $v.mealName;
      _scheduledTime = $v.scheduledTime;
      _targetCalories = $v.targetCalories;
      _notes = $v.notes;
      _foods = $v.foods?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietPlanMealsWriteMealsInner other) {
    _$v = other as _$DietPlanMealsWriteMealsInner;
  }

  @override
  void update(void Function(DietPlanMealsWriteMealsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietPlanMealsWriteMealsInner build() => _build();

  _$DietPlanMealsWriteMealsInner _build() {
    _$DietPlanMealsWriteMealsInner _$result;
    try {
      _$result = _$v ??
          _$DietPlanMealsWriteMealsInner._(
            mealName: BuiltValueNullFieldError.checkNotNull(
                mealName, r'DietPlanMealsWriteMealsInner', 'mealName'),
            scheduledTime: scheduledTime,
            targetCalories: targetCalories,
            notes: notes,
            foods: _foods?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'foods';
        _foods?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DietPlanMealsWriteMealsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
