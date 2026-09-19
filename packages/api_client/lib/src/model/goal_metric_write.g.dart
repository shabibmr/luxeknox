// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_metric_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GoalMetricWriteCategoryEnum
    _$goalMetricWriteCategoryEnum_bodyComposition =
    const GoalMetricWriteCategoryEnum._('bodyComposition');
const GoalMetricWriteCategoryEnum _$goalMetricWriteCategoryEnum_circumference =
    const GoalMetricWriteCategoryEnum._('circumference');
const GoalMetricWriteCategoryEnum _$goalMetricWriteCategoryEnum_strength =
    const GoalMetricWriteCategoryEnum._('strength');

GoalMetricWriteCategoryEnum _$goalMetricWriteCategoryEnumValueOf(String name) {
  switch (name) {
    case 'bodyComposition':
      return _$goalMetricWriteCategoryEnum_bodyComposition;
    case 'circumference':
      return _$goalMetricWriteCategoryEnum_circumference;
    case 'strength':
      return _$goalMetricWriteCategoryEnum_strength;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GoalMetricWriteCategoryEnum>
    _$goalMetricWriteCategoryEnumValues =
    BuiltSet<GoalMetricWriteCategoryEnum>(const <GoalMetricWriteCategoryEnum>[
  _$goalMetricWriteCategoryEnum_bodyComposition,
  _$goalMetricWriteCategoryEnum_circumference,
  _$goalMetricWriteCategoryEnum_strength,
]);

Serializer<GoalMetricWriteCategoryEnum>
    _$goalMetricWriteCategoryEnumSerializer =
    _$GoalMetricWriteCategoryEnumSerializer();

class _$GoalMetricWriteCategoryEnumSerializer
    implements PrimitiveSerializer<GoalMetricWriteCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[GoalMetricWriteCategoryEnum];
  @override
  final String wireName = 'GoalMetricWriteCategoryEnum';

  @override
  Object serialize(Serializers serializers, GoalMetricWriteCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GoalMetricWriteCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GoalMetricWriteCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GoalMetricWrite extends GoalMetricWrite {
  @override
  final String name;
  @override
  final String unitOfMeasure;
  @override
  final GoalMetricWriteCategoryEnum category;
  @override
  final bool? isActive;

  factory _$GoalMetricWrite([void Function(GoalMetricWriteBuilder)? updates]) =>
      (GoalMetricWriteBuilder()..update(updates))._build();

  _$GoalMetricWrite._(
      {required this.name,
      required this.unitOfMeasure,
      required this.category,
      this.isActive})
      : super._();
  @override
  GoalMetricWrite rebuild(void Function(GoalMetricWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoalMetricWriteBuilder toBuilder() => GoalMetricWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoalMetricWrite &&
        name == other.name &&
        unitOfMeasure == other.unitOfMeasure &&
        category == other.category &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, unitOfMeasure.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoalMetricWrite')
          ..add('name', name)
          ..add('unitOfMeasure', unitOfMeasure)
          ..add('category', category)
          ..add('isActive', isActive))
        .toString();
  }
}

class GoalMetricWriteBuilder
    implements Builder<GoalMetricWrite, GoalMetricWriteBuilder> {
  _$GoalMetricWrite? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _unitOfMeasure;
  String? get unitOfMeasure => _$this._unitOfMeasure;
  set unitOfMeasure(String? unitOfMeasure) =>
      _$this._unitOfMeasure = unitOfMeasure;

  GoalMetricWriteCategoryEnum? _category;
  GoalMetricWriteCategoryEnum? get category => _$this._category;
  set category(GoalMetricWriteCategoryEnum? category) =>
      _$this._category = category;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  GoalMetricWriteBuilder() {
    GoalMetricWrite._defaults(this);
  }

  GoalMetricWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _unitOfMeasure = $v.unitOfMeasure;
      _category = $v.category;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoalMetricWrite other) {
    _$v = other as _$GoalMetricWrite;
  }

  @override
  void update(void Function(GoalMetricWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoalMetricWrite build() => _build();

  _$GoalMetricWrite _build() {
    final _$result = _$v ??
        _$GoalMetricWrite._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'GoalMetricWrite', 'name'),
          unitOfMeasure: BuiltValueNullFieldError.checkNotNull(
              unitOfMeasure, r'GoalMetricWrite', 'unitOfMeasure'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'GoalMetricWrite', 'category'),
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
