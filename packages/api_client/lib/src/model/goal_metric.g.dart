// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_metric.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GoalMetricCategoryEnum _$goalMetricCategoryEnum_bodyComposition =
    const GoalMetricCategoryEnum._('bodyComposition');
const GoalMetricCategoryEnum _$goalMetricCategoryEnum_circumference =
    const GoalMetricCategoryEnum._('circumference');
const GoalMetricCategoryEnum _$goalMetricCategoryEnum_strength =
    const GoalMetricCategoryEnum._('strength');

GoalMetricCategoryEnum _$goalMetricCategoryEnumValueOf(String name) {
  switch (name) {
    case 'bodyComposition':
      return _$goalMetricCategoryEnum_bodyComposition;
    case 'circumference':
      return _$goalMetricCategoryEnum_circumference;
    case 'strength':
      return _$goalMetricCategoryEnum_strength;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GoalMetricCategoryEnum> _$goalMetricCategoryEnumValues =
    BuiltSet<GoalMetricCategoryEnum>(const <GoalMetricCategoryEnum>[
  _$goalMetricCategoryEnum_bodyComposition,
  _$goalMetricCategoryEnum_circumference,
  _$goalMetricCategoryEnum_strength,
]);

Serializer<GoalMetricCategoryEnum> _$goalMetricCategoryEnumSerializer =
    _$GoalMetricCategoryEnumSerializer();

class _$GoalMetricCategoryEnumSerializer
    implements PrimitiveSerializer<GoalMetricCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'bodyComposition': 'body_composition',
    'circumference': 'circumference',
    'strength': 'strength',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'body_composition': 'bodyComposition',
    'circumference': 'circumference',
    'strength': 'strength',
  };

  @override
  final Iterable<Type> types = const <Type>[GoalMetricCategoryEnum];
  @override
  final String wireName = 'GoalMetricCategoryEnum';

  @override
  Object serialize(Serializers serializers, GoalMetricCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GoalMetricCategoryEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GoalMetricCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GoalMetric extends GoalMetric {
  @override
  final int id;
  @override
  final String name;
  @override
  final String unitOfMeasure;
  @override
  final GoalMetricCategoryEnum category;
  @override
  final bool isActive;

  factory _$GoalMetric([void Function(GoalMetricBuilder)? updates]) =>
      (GoalMetricBuilder()..update(updates))._build();

  _$GoalMetric._(
      {required this.id,
      required this.name,
      required this.unitOfMeasure,
      required this.category,
      required this.isActive})
      : super._();
  @override
  GoalMetric rebuild(void Function(GoalMetricBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoalMetricBuilder toBuilder() => GoalMetricBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoalMetric &&
        id == other.id &&
        name == other.name &&
        unitOfMeasure == other.unitOfMeasure &&
        category == other.category &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, unitOfMeasure.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoalMetric')
          ..add('id', id)
          ..add('name', name)
          ..add('unitOfMeasure', unitOfMeasure)
          ..add('category', category)
          ..add('isActive', isActive))
        .toString();
  }
}

class GoalMetricBuilder implements Builder<GoalMetric, GoalMetricBuilder> {
  _$GoalMetric? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _unitOfMeasure;
  String? get unitOfMeasure => _$this._unitOfMeasure;
  set unitOfMeasure(String? unitOfMeasure) =>
      _$this._unitOfMeasure = unitOfMeasure;

  GoalMetricCategoryEnum? _category;
  GoalMetricCategoryEnum? get category => _$this._category;
  set category(GoalMetricCategoryEnum? category) => _$this._category = category;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  GoalMetricBuilder() {
    GoalMetric._defaults(this);
  }

  GoalMetricBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _unitOfMeasure = $v.unitOfMeasure;
      _category = $v.category;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoalMetric other) {
    _$v = other as _$GoalMetric;
  }

  @override
  void update(void Function(GoalMetricBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoalMetric build() => _build();

  _$GoalMetric _build() {
    final _$result = _$v ??
        _$GoalMetric._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'GoalMetric', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'GoalMetric', 'name'),
          unitOfMeasure: BuiltValueNullFieldError.checkNotNull(
              unitOfMeasure, r'GoalMetric', 'unitOfMeasure'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'GoalMetric', 'category'),
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'GoalMetric', 'isActive'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
