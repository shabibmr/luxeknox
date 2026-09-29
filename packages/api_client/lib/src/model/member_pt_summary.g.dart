// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_pt_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MemberPtSummaryTrainerAccessEnum _$memberPtSummaryTrainerAccessEnum_full =
    const MemberPtSummaryTrainerAccessEnum._('full');
const MemberPtSummaryTrainerAccessEnum
    _$memberPtSummaryTrainerAccessEnum_readOnly =
    const MemberPtSummaryTrainerAccessEnum._('readOnly');

MemberPtSummaryTrainerAccessEnum _$memberPtSummaryTrainerAccessEnumValueOf(
    String name) {
  switch (name) {
    case 'full':
      return _$memberPtSummaryTrainerAccessEnum_full;
    case 'readOnly':
      return _$memberPtSummaryTrainerAccessEnum_readOnly;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MemberPtSummaryTrainerAccessEnum>
    _$memberPtSummaryTrainerAccessEnumValues = BuiltSet<
        MemberPtSummaryTrainerAccessEnum>(const <MemberPtSummaryTrainerAccessEnum>[
  _$memberPtSummaryTrainerAccessEnum_full,
  _$memberPtSummaryTrainerAccessEnum_readOnly,
]);

Serializer<MemberPtSummaryTrainerAccessEnum>
    _$memberPtSummaryTrainerAccessEnumSerializer =
    _$MemberPtSummaryTrainerAccessEnumSerializer();

class _$MemberPtSummaryTrainerAccessEnumSerializer
    implements PrimitiveSerializer<MemberPtSummaryTrainerAccessEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'full': 'full',
    'readOnly': 'read_only',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'full': 'full',
    'read_only': 'readOnly',
  };

  @override
  final Iterable<Type> types = const <Type>[MemberPtSummaryTrainerAccessEnum];
  @override
  final String wireName = 'MemberPtSummaryTrainerAccessEnum';

  @override
  Object serialize(
          Serializers serializers, MemberPtSummaryTrainerAccessEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MemberPtSummaryTrainerAccessEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MemberPtSummaryTrainerAccessEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MemberPtSummary extends MemberPtSummary {
  @override
  final PtSubscription? current;
  @override
  final BuiltList<PtSubscription> history;
  @override
  final MemberPtSummaryTrainerAccessEnum? trainerAccess;

  factory _$MemberPtSummary([void Function(MemberPtSummaryBuilder)? updates]) =>
      (MemberPtSummaryBuilder()..update(updates))._build();

  _$MemberPtSummary._({this.current, required this.history, this.trainerAccess})
      : super._();
  @override
  MemberPtSummary rebuild(void Function(MemberPtSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberPtSummaryBuilder toBuilder() => MemberPtSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberPtSummary &&
        current == other.current &&
        history == other.history &&
        trainerAccess == other.trainerAccess;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jc(_$hash, trainerAccess.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberPtSummary')
          ..add('current', current)
          ..add('history', history)
          ..add('trainerAccess', trainerAccess))
        .toString();
  }
}

class MemberPtSummaryBuilder
    implements Builder<MemberPtSummary, MemberPtSummaryBuilder> {
  _$MemberPtSummary? _$v;

  PtSubscriptionBuilder? _current;
  PtSubscriptionBuilder get current =>
      _$this._current ??= PtSubscriptionBuilder();
  set current(PtSubscriptionBuilder? current) => _$this._current = current;

  ListBuilder<PtSubscription>? _history;
  ListBuilder<PtSubscription> get history =>
      _$this._history ??= ListBuilder<PtSubscription>();
  set history(ListBuilder<PtSubscription>? history) =>
      _$this._history = history;

  MemberPtSummaryTrainerAccessEnum? _trainerAccess;
  MemberPtSummaryTrainerAccessEnum? get trainerAccess => _$this._trainerAccess;
  set trainerAccess(MemberPtSummaryTrainerAccessEnum? trainerAccess) =>
      _$this._trainerAccess = trainerAccess;

  MemberPtSummaryBuilder() {
    MemberPtSummary._defaults(this);
  }

  MemberPtSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _current = $v.current?.toBuilder();
      _history = $v.history.toBuilder();
      _trainerAccess = $v.trainerAccess;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberPtSummary other) {
    _$v = other as _$MemberPtSummary;
  }

  @override
  void update(void Function(MemberPtSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberPtSummary build() => _build();

  _$MemberPtSummary _build() {
    _$MemberPtSummary _$result;
    try {
      _$result = _$v ??
          _$MemberPtSummary._(
            current: _current?.build(),
            history: history.build(),
            trainerAccess: trainerAccess,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'current';
        _current?.build();
        _$failedField = 'history';
        history.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MemberPtSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
