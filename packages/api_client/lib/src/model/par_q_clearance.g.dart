// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'par_q_clearance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ParQClearanceDecisionEnum _$parQClearanceDecisionEnum_cleared =
    const ParQClearanceDecisionEnum._('cleared');
const ParQClearanceDecisionEnum _$parQClearanceDecisionEnum_rejected =
    const ParQClearanceDecisionEnum._('rejected');

ParQClearanceDecisionEnum _$parQClearanceDecisionEnumValueOf(String name) {
  switch (name) {
    case 'cleared':
      return _$parQClearanceDecisionEnum_cleared;
    case 'rejected':
      return _$parQClearanceDecisionEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ParQClearanceDecisionEnum> _$parQClearanceDecisionEnumValues =
    BuiltSet<ParQClearanceDecisionEnum>(const <ParQClearanceDecisionEnum>[
  _$parQClearanceDecisionEnum_cleared,
  _$parQClearanceDecisionEnum_rejected,
]);

Serializer<ParQClearanceDecisionEnum> _$parQClearanceDecisionEnumSerializer =
    _$ParQClearanceDecisionEnumSerializer();

class _$ParQClearanceDecisionEnumSerializer
    implements PrimitiveSerializer<ParQClearanceDecisionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'cleared': 'cleared',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'cleared': 'cleared',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[ParQClearanceDecisionEnum];
  @override
  final String wireName = 'ParQClearanceDecisionEnum';

  @override
  Object serialize(Serializers serializers, ParQClearanceDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ParQClearanceDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ParQClearanceDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ParQClearance extends ParQClearance {
  @override
  final ParQClearanceDecisionEnum decision;

  factory _$ParQClearance([void Function(ParQClearanceBuilder)? updates]) =>
      (ParQClearanceBuilder()..update(updates))._build();

  _$ParQClearance._({required this.decision}) : super._();
  @override
  ParQClearance rebuild(void Function(ParQClearanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParQClearanceBuilder toBuilder() => ParQClearanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParQClearance && decision == other.decision;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParQClearance')
          ..add('decision', decision))
        .toString();
  }
}

class ParQClearanceBuilder
    implements Builder<ParQClearance, ParQClearanceBuilder> {
  _$ParQClearance? _$v;

  ParQClearanceDecisionEnum? _decision;
  ParQClearanceDecisionEnum? get decision => _$this._decision;
  set decision(ParQClearanceDecisionEnum? decision) =>
      _$this._decision = decision;

  ParQClearanceBuilder() {
    ParQClearance._defaults(this);
  }

  ParQClearanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _decision = $v.decision;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParQClearance other) {
    _$v = other as _$ParQClearance;
  }

  @override
  void update(void Function(ParQClearanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParQClearance build() => _build();

  _$ParQClearance _build() {
    final _$result = _$v ??
        _$ParQClearance._(
          decision: BuiltValueNullFieldError.checkNotNull(
              decision, r'ParQClearance', 'decision'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
