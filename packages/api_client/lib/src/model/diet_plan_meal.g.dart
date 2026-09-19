// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_meal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietPlanMeal extends DietPlanMeal {
  @override
  final int id;
  @override
  final int dietPlanVersionId;
  @override
  final String mealName;
  @override
  final String? scheduledTime;
  @override
  final int? targetCalories;
  @override
  final String? notes;
  @override
  final BuiltList<DietPlanFood>? foods;

  factory _$DietPlanMeal([void Function(DietPlanMealBuilder)? updates]) =>
      (DietPlanMealBuilder()..update(updates))._build();

  _$DietPlanMeal._(
      {required this.id,
      required this.dietPlanVersionId,
      required this.mealName,
      this.scheduledTime,
      this.targetCalories,
      this.notes,
      this.foods})
      : super._();
  @override
  DietPlanMeal rebuild(void Function(DietPlanMealBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietPlanMealBuilder toBuilder() => DietPlanMealBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietPlanMeal &&
        id == other.id &&
        dietPlanVersionId == other.dietPlanVersionId &&
        mealName == other.mealName &&
        scheduledTime == other.scheduledTime &&
        targetCalories == other.targetCalories &&
        notes == other.notes &&
        foods == other.foods;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, dietPlanVersionId.hashCode);
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
    return (newBuiltValueToStringHelper(r'DietPlanMeal')
          ..add('id', id)
          ..add('dietPlanVersionId', dietPlanVersionId)
          ..add('mealName', mealName)
          ..add('scheduledTime', scheduledTime)
          ..add('targetCalories', targetCalories)
          ..add('notes', notes)
          ..add('foods', foods))
        .toString();
  }
}

class DietPlanMealBuilder
    implements Builder<DietPlanMeal, DietPlanMealBuilder> {
  _$DietPlanMeal? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _dietPlanVersionId;
  int? get dietPlanVersionId => _$this._dietPlanVersionId;
  set dietPlanVersionId(int? dietPlanVersionId) =>
      _$this._dietPlanVersionId = dietPlanVersionId;

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

  ListBuilder<DietPlanFood>? _foods;
  ListBuilder<DietPlanFood> get foods =>
      _$this._foods ??= ListBuilder<DietPlanFood>();
  set foods(ListBuilder<DietPlanFood>? foods) => _$this._foods = foods;

  DietPlanMealBuilder() {
    DietPlanMeal._defaults(this);
  }

  DietPlanMealBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _dietPlanVersionId = $v.dietPlanVersionId;
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
  void replace(DietPlanMeal other) {
    _$v = other as _$DietPlanMeal;
  }

  @override
  void update(void Function(DietPlanMealBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietPlanMeal build() => _build();

  _$DietPlanMeal _build() {
    _$DietPlanMeal _$result;
    try {
      _$result = _$v ??
          _$DietPlanMeal._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DietPlanMeal', 'id'),
            dietPlanVersionId: BuiltValueNullFieldError.checkNotNull(
                dietPlanVersionId, r'DietPlanMeal', 'dietPlanVersionId'),
            mealName: BuiltValueNullFieldError.checkNotNull(
                mealName, r'DietPlanMeal', 'mealName'),
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
            r'DietPlanMeal', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
