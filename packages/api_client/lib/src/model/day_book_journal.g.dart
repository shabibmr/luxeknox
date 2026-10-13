// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_book_journal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DayBookJournal extends DayBookJournal {
  @override
  final int id;
  @override
  final String journalNumber;
  @override
  final Date entryDate;
  @override
  final String sourceType;
  @override
  final int sourceId;
  @override
  final String? memo;
  @override
  final int? reversesJournalId;
  @override
  final BuiltList<DayBookLine> lines;

  factory _$DayBookJournal([void Function(DayBookJournalBuilder)? updates]) =>
      (DayBookJournalBuilder()..update(updates))._build();

  _$DayBookJournal._(
      {required this.id,
      required this.journalNumber,
      required this.entryDate,
      required this.sourceType,
      required this.sourceId,
      this.memo,
      this.reversesJournalId,
      required this.lines})
      : super._();
  @override
  DayBookJournal rebuild(void Function(DayBookJournalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DayBookJournalBuilder toBuilder() => DayBookJournalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DayBookJournal &&
        id == other.id &&
        journalNumber == other.journalNumber &&
        entryDate == other.entryDate &&
        sourceType == other.sourceType &&
        sourceId == other.sourceId &&
        memo == other.memo &&
        reversesJournalId == other.reversesJournalId &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, journalNumber.hashCode);
    _$hash = $jc(_$hash, entryDate.hashCode);
    _$hash = $jc(_$hash, sourceType.hashCode);
    _$hash = $jc(_$hash, sourceId.hashCode);
    _$hash = $jc(_$hash, memo.hashCode);
    _$hash = $jc(_$hash, reversesJournalId.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DayBookJournal')
          ..add('id', id)
          ..add('journalNumber', journalNumber)
          ..add('entryDate', entryDate)
          ..add('sourceType', sourceType)
          ..add('sourceId', sourceId)
          ..add('memo', memo)
          ..add('reversesJournalId', reversesJournalId)
          ..add('lines', lines))
        .toString();
  }
}

class DayBookJournalBuilder
    implements Builder<DayBookJournal, DayBookJournalBuilder> {
  _$DayBookJournal? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _journalNumber;
  String? get journalNumber => _$this._journalNumber;
  set journalNumber(String? journalNumber) =>
      _$this._journalNumber = journalNumber;

  Date? _entryDate;
  Date? get entryDate => _$this._entryDate;
  set entryDate(Date? entryDate) => _$this._entryDate = entryDate;

  String? _sourceType;
  String? get sourceType => _$this._sourceType;
  set sourceType(String? sourceType) => _$this._sourceType = sourceType;

  int? _sourceId;
  int? get sourceId => _$this._sourceId;
  set sourceId(int? sourceId) => _$this._sourceId = sourceId;

  String? _memo;
  String? get memo => _$this._memo;
  set memo(String? memo) => _$this._memo = memo;

  int? _reversesJournalId;
  int? get reversesJournalId => _$this._reversesJournalId;
  set reversesJournalId(int? reversesJournalId) =>
      _$this._reversesJournalId = reversesJournalId;

  ListBuilder<DayBookLine>? _lines;
  ListBuilder<DayBookLine> get lines =>
      _$this._lines ??= ListBuilder<DayBookLine>();
  set lines(ListBuilder<DayBookLine>? lines) => _$this._lines = lines;

  DayBookJournalBuilder() {
    DayBookJournal._defaults(this);
  }

  DayBookJournalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _journalNumber = $v.journalNumber;
      _entryDate = $v.entryDate;
      _sourceType = $v.sourceType;
      _sourceId = $v.sourceId;
      _memo = $v.memo;
      _reversesJournalId = $v.reversesJournalId;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DayBookJournal other) {
    _$v = other as _$DayBookJournal;
  }

  @override
  void update(void Function(DayBookJournalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DayBookJournal build() => _build();

  _$DayBookJournal _build() {
    _$DayBookJournal _$result;
    try {
      _$result = _$v ??
          _$DayBookJournal._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DayBookJournal', 'id'),
            journalNumber: BuiltValueNullFieldError.checkNotNull(
                journalNumber, r'DayBookJournal', 'journalNumber'),
            entryDate: BuiltValueNullFieldError.checkNotNull(
                entryDate, r'DayBookJournal', 'entryDate'),
            sourceType: BuiltValueNullFieldError.checkNotNull(
                sourceType, r'DayBookJournal', 'sourceType'),
            sourceId: BuiltValueNullFieldError.checkNotNull(
                sourceId, r'DayBookJournal', 'sourceId'),
            memo: memo,
            reversesJournalId: reversesJournalId,
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DayBookJournal', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
