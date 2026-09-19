// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_meals_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietPlanMealsWrite extends DietPlanMealsWrite {
  @override
  final String? changelog;
  @override
  final int? rowVersion;
  @override
  final BuiltList<DietPlanMealsWriteMealsInner> meals;

  factory _$DietPlanMealsWrite(
          [void Function(DietPlanMealsWriteBuilder)? updates]) =>
      (DietPlanMealsWriteBuilder()..update(updates))._build();

  _$DietPlanMealsWrite._({this.changelog, this.rowVersion, required this.meals})
      : super._();
  @override
  DietPlanMealsWrite rebuild(
          void Function(DietPlanMealsWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietPlanMealsWriteBuilder toBuilder() =>
      DietPlanMealsWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietPlanMealsWrite &&
        changelog == other.changelog &&
        rowVersion == other.rowVersion &&
        meals == other.meals;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changelog.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, meals.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DietPlanMealsWrite')
          ..add('changelog', changelog)
          ..add('rowVersion', rowVersion)
          ..add('meals', meals))
        .toString();
  }
}

class DietPlanMealsWriteBuilder
    implements Builder<DietPlanMealsWrite, DietPlanMealsWriteBuilder> {
  _$DietPlanMealsWrite? _$v;

  String? _changelog;
  String? get changelog => _$this._changelog;
  set changelog(String? changelog) => _$this._changelog = changelog;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  ListBuilder<DietPlanMealsWriteMealsInner>? _meals;
  ListBuilder<DietPlanMealsWriteMealsInner> get meals =>
      _$this._meals ??= ListBuilder<DietPlanMealsWriteMealsInner>();
  set meals(ListBuilder<DietPlanMealsWriteMealsInner>? meals) =>
      _$this._meals = meals;

  DietPlanMealsWriteBuilder() {
    DietPlanMealsWrite._defaults(this);
  }

  DietPlanMealsWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changelog = $v.changelog;
      _rowVersion = $v.rowVersion;
      _meals = $v.meals.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietPlanMealsWrite other) {
    _$v = other as _$DietPlanMealsWrite;
  }

  @override
  void update(void Function(DietPlanMealsWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietPlanMealsWrite build() => _build();

  _$DietPlanMealsWrite _build() {
    _$DietPlanMealsWrite _$result;
    try {
      _$result = _$v ??
          _$DietPlanMealsWrite._(
            changelog: changelog,
            rowVersion: rowVersion,
            meals: meals.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meals';
        meals.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DietPlanMealsWrite', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
