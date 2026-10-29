// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifestyle_priority.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LifestylePriorityPriorityEnum _$lifestylePriorityPriorityEnum_sleep =
    const LifestylePriorityPriorityEnum._('sleep');
const LifestylePriorityPriorityEnum _$lifestylePriorityPriorityEnum_nutrition =
    const LifestylePriorityPriorityEnum._('nutrition');
const LifestylePriorityPriorityEnum _$lifestylePriorityPriorityEnum_activity =
    const LifestylePriorityPriorityEnum._('activity');
const LifestylePriorityPriorityEnum _$lifestylePriorityPriorityEnum_recovery =
    const LifestylePriorityPriorityEnum._('recovery');

LifestylePriorityPriorityEnum _$lifestylePriorityPriorityEnumValueOf(
    String name) {
  switch (name) {
    case 'sleep':
      return _$lifestylePriorityPriorityEnum_sleep;
    case 'nutrition':
      return _$lifestylePriorityPriorityEnum_nutrition;
    case 'activity':
      return _$lifestylePriorityPriorityEnum_activity;
    case 'recovery':
      return _$lifestylePriorityPriorityEnum_recovery;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LifestylePriorityPriorityEnum>
    _$lifestylePriorityPriorityEnumValues = BuiltSet<
        LifestylePriorityPriorityEnum>(const <LifestylePriorityPriorityEnum>[
  _$lifestylePriorityPriorityEnum_sleep,
  _$lifestylePriorityPriorityEnum_nutrition,
  _$lifestylePriorityPriorityEnum_activity,
  _$lifestylePriorityPriorityEnum_recovery,
]);

Serializer<LifestylePriorityPriorityEnum>
    _$lifestylePriorityPriorityEnumSerializer =
    _$LifestylePriorityPriorityEnumSerializer();

class _$LifestylePriorityPriorityEnumSerializer
    implements PrimitiveSerializer<LifestylePriorityPriorityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'sleep': 'sleep',
    'nutrition': 'nutrition',
    'activity': 'activity',
    'recovery': 'recovery',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'sleep': 'sleep',
    'nutrition': 'nutrition',
    'activity': 'activity',
    'recovery': 'recovery',
  };

  @override
  final Iterable<Type> types = const <Type>[LifestylePriorityPriorityEnum];
  @override
  final String wireName = 'LifestylePriorityPriorityEnum';

  @override
  Object serialize(
          Serializers serializers, LifestylePriorityPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LifestylePriorityPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LifestylePriorityPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LifestylePriority extends LifestylePriority {
  @override
  final LifestylePriorityPriorityEnum priority;
  @override
  final String currentStatus;
  @override
  final String firstAction;

  factory _$LifestylePriority(
          [void Function(LifestylePriorityBuilder)? updates]) =>
      (LifestylePriorityBuilder()..update(updates))._build();

  _$LifestylePriority._(
      {required this.priority,
      required this.currentStatus,
      required this.firstAction})
      : super._();
  @override
  LifestylePriority rebuild(void Function(LifestylePriorityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LifestylePriorityBuilder toBuilder() =>
      LifestylePriorityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LifestylePriority &&
        priority == other.priority &&
        currentStatus == other.currentStatus &&
        firstAction == other.firstAction;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, currentStatus.hashCode);
    _$hash = $jc(_$hash, firstAction.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LifestylePriority')
          ..add('priority', priority)
          ..add('currentStatus', currentStatus)
          ..add('firstAction', firstAction))
        .toString();
  }
}

class LifestylePriorityBuilder
    implements Builder<LifestylePriority, LifestylePriorityBuilder> {
  _$LifestylePriority? _$v;

  LifestylePriorityPriorityEnum? _priority;
  LifestylePriorityPriorityEnum? get priority => _$this._priority;
  set priority(LifestylePriorityPriorityEnum? priority) =>
      _$this._priority = priority;

  String? _currentStatus;
  String? get currentStatus => _$this._currentStatus;
  set currentStatus(String? currentStatus) =>
      _$this._currentStatus = currentStatus;

  String? _firstAction;
  String? get firstAction => _$this._firstAction;
  set firstAction(String? firstAction) => _$this._firstAction = firstAction;

  LifestylePriorityBuilder() {
    LifestylePriority._defaults(this);
  }

  LifestylePriorityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _priority = $v.priority;
      _currentStatus = $v.currentStatus;
      _firstAction = $v.firstAction;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LifestylePriority other) {
    _$v = other as _$LifestylePriority;
  }

  @override
  void update(void Function(LifestylePriorityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LifestylePriority build() => _build();

  _$LifestylePriority _build() {
    final _$result = _$v ??
        _$LifestylePriority._(
          priority: BuiltValueNullFieldError.checkNotNull(
              priority, r'LifestylePriority', 'priority'),
          currentStatus: BuiltValueNullFieldError.checkNotNull(
              currentStatus, r'LifestylePriority', 'currentStatus'),
          firstAction: BuiltValueNullFieldError.checkNotNull(
              firstAction, r'LifestylePriority', 'firstAction'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
