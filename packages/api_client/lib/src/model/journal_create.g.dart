// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const JournalCreateSourceTypeEnum _$journalCreateSourceTypeEnum_manual =
    const JournalCreateSourceTypeEnum._('manual');
const JournalCreateSourceTypeEnum _$journalCreateSourceTypeEnum_openingBalance =
    const JournalCreateSourceTypeEnum._('openingBalance');

JournalCreateSourceTypeEnum _$journalCreateSourceTypeEnumValueOf(String name) {
  switch (name) {
    case 'manual':
      return _$journalCreateSourceTypeEnum_manual;
    case 'openingBalance':
      return _$journalCreateSourceTypeEnum_openingBalance;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<JournalCreateSourceTypeEnum>
    _$journalCreateSourceTypeEnumValues =
    BuiltSet<JournalCreateSourceTypeEnum>(const <JournalCreateSourceTypeEnum>[
  _$journalCreateSourceTypeEnum_manual,
  _$journalCreateSourceTypeEnum_openingBalance,
]);

Serializer<JournalCreateSourceTypeEnum>
    _$journalCreateSourceTypeEnumSerializer =
    _$JournalCreateSourceTypeEnumSerializer();

class _$JournalCreateSourceTypeEnumSerializer
    implements PrimitiveSerializer<JournalCreateSourceTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'manual': 'manual',
    'openingBalance': 'opening_balance',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'manual': 'manual',
    'opening_balance': 'openingBalance',
  };

  @override
  final Iterable<Type> types = const <Type>[JournalCreateSourceTypeEnum];
  @override
  final String wireName = 'JournalCreateSourceTypeEnum';

  @override
  Object serialize(Serializers serializers, JournalCreateSourceTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  JournalCreateSourceTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      JournalCreateSourceTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$JournalCreate extends JournalCreate {
  @override
  final Date entryDate;
  @override
  final JournalCreateSourceTypeEnum sourceType;
  @override
  final String? memo;
  @override
  final BuiltList<JournalLineWrite> lines;

  factory _$JournalCreate([void Function(JournalCreateBuilder)? updates]) =>
      (JournalCreateBuilder()..update(updates))._build();

  _$JournalCreate._(
      {required this.entryDate,
      required this.sourceType,
      this.memo,
      required this.lines})
      : super._();
  @override
  JournalCreate rebuild(void Function(JournalCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JournalCreateBuilder toBuilder() => JournalCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JournalCreate &&
        entryDate == other.entryDate &&
        sourceType == other.sourceType &&
        memo == other.memo &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entryDate.hashCode);
    _$hash = $jc(_$hash, sourceType.hashCode);
    _$hash = $jc(_$hash, memo.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JournalCreate')
          ..add('entryDate', entryDate)
          ..add('sourceType', sourceType)
          ..add('memo', memo)
          ..add('lines', lines))
        .toString();
  }
}

class JournalCreateBuilder
    implements Builder<JournalCreate, JournalCreateBuilder> {
  _$JournalCreate? _$v;

  Date? _entryDate;
  Date? get entryDate => _$this._entryDate;
  set entryDate(Date? entryDate) => _$this._entryDate = entryDate;

  JournalCreateSourceTypeEnum? _sourceType;
  JournalCreateSourceTypeEnum? get sourceType => _$this._sourceType;
  set sourceType(JournalCreateSourceTypeEnum? sourceType) =>
      _$this._sourceType = sourceType;

  String? _memo;
  String? get memo => _$this._memo;
  set memo(String? memo) => _$this._memo = memo;

  ListBuilder<JournalLineWrite>? _lines;
  ListBuilder<JournalLineWrite> get lines =>
      _$this._lines ??= ListBuilder<JournalLineWrite>();
  set lines(ListBuilder<JournalLineWrite>? lines) => _$this._lines = lines;

  JournalCreateBuilder() {
    JournalCreate._defaults(this);
  }

  JournalCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entryDate = $v.entryDate;
      _sourceType = $v.sourceType;
      _memo = $v.memo;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JournalCreate other) {
    _$v = other as _$JournalCreate;
  }

  @override
  void update(void Function(JournalCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JournalCreate build() => _build();

  _$JournalCreate _build() {
    _$JournalCreate _$result;
    try {
      _$result = _$v ??
          _$JournalCreate._(
            entryDate: BuiltValueNullFieldError.checkNotNull(
                entryDate, r'JournalCreate', 'entryDate'),
            sourceType: BuiltValueNullFieldError.checkNotNull(
                sourceType, r'JournalCreate', 'sourceType'),
            memo: memo,
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'JournalCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
