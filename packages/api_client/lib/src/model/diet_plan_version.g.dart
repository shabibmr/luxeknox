// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DietPlanVersion extends DietPlanVersion {
  @override
  final int id;
  @override
  final int dietPlanId;
  @override
  final int versionNumber;
  @override
  final String? changelog;
  @override
  final DateTime? createdAt;
  @override
  final BuiltList<DietPlanMeal>? meals;

  factory _$DietPlanVersion([void Function(DietPlanVersionBuilder)? updates]) =>
      (DietPlanVersionBuilder()..update(updates))._build();

  _$DietPlanVersion._(
      {required this.id,
      required this.dietPlanId,
      required this.versionNumber,
      this.changelog,
      this.createdAt,
      this.meals})
      : super._();
  @override
  DietPlanVersion rebuild(void Function(DietPlanVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DietPlanVersionBuilder toBuilder() => DietPlanVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DietPlanVersion &&
        id == other.id &&
        dietPlanId == other.dietPlanId &&
        versionNumber == other.versionNumber &&
        changelog == other.changelog &&
        createdAt == other.createdAt &&
        meals == other.meals;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, dietPlanId.hashCode);
    _$hash = $jc(_$hash, versionNumber.hashCode);
    _$hash = $jc(_$hash, changelog.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, meals.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DietPlanVersion')
          ..add('id', id)
          ..add('dietPlanId', dietPlanId)
          ..add('versionNumber', versionNumber)
          ..add('changelog', changelog)
          ..add('createdAt', createdAt)
          ..add('meals', meals))
        .toString();
  }
}

class DietPlanVersionBuilder
    implements Builder<DietPlanVersion, DietPlanVersionBuilder> {
  _$DietPlanVersion? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _dietPlanId;
  int? get dietPlanId => _$this._dietPlanId;
  set dietPlanId(int? dietPlanId) => _$this._dietPlanId = dietPlanId;

  int? _versionNumber;
  int? get versionNumber => _$this._versionNumber;
  set versionNumber(int? versionNumber) =>
      _$this._versionNumber = versionNumber;

  String? _changelog;
  String? get changelog => _$this._changelog;
  set changelog(String? changelog) => _$this._changelog = changelog;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<DietPlanMeal>? _meals;
  ListBuilder<DietPlanMeal> get meals =>
      _$this._meals ??= ListBuilder<DietPlanMeal>();
  set meals(ListBuilder<DietPlanMeal>? meals) => _$this._meals = meals;

  DietPlanVersionBuilder() {
    DietPlanVersion._defaults(this);
  }

  DietPlanVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _dietPlanId = $v.dietPlanId;
      _versionNumber = $v.versionNumber;
      _changelog = $v.changelog;
      _createdAt = $v.createdAt;
      _meals = $v.meals?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DietPlanVersion other) {
    _$v = other as _$DietPlanVersion;
  }

  @override
  void update(void Function(DietPlanVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DietPlanVersion build() => _build();

  _$DietPlanVersion _build() {
    _$DietPlanVersion _$result;
    try {
      _$result = _$v ??
          _$DietPlanVersion._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DietPlanVersion', 'id'),
            dietPlanId: BuiltValueNullFieldError.checkNotNull(
                dietPlanId, r'DietPlanVersion', 'dietPlanId'),
            versionNumber: BuiltValueNullFieldError.checkNotNull(
                versionNumber, r'DietPlanVersion', 'versionNumber'),
            changelog: changelog,
            createdAt: createdAt,
            meals: _meals?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meals';
        _meals?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DietPlanVersion', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
