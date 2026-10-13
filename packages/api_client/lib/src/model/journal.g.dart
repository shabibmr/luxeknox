// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Journal extends Journal {
  @override
  final int id;
  @override
  final String journalNumber;
  @override
  final Date entryDate;
  @override
  final int accountingPeriodId;
  @override
  final String sourceType;
  @override
  final int sourceId;
  @override
  final String? memo;
  @override
  final DateTime postedAt;
  @override
  final int? postedByUserId;
  @override
  final int? reversesJournalId;
  @override
  final int rowVersion;
  @override
  final BuiltList<JournalLine> lines;

  factory _$Journal([void Function(JournalBuilder)? updates]) =>
      (JournalBuilder()..update(updates))._build();

  _$Journal._(
      {required this.id,
      required this.journalNumber,
      required this.entryDate,
      required this.accountingPeriodId,
      required this.sourceType,
      required this.sourceId,
      this.memo,
      required this.postedAt,
      this.postedByUserId,
      this.reversesJournalId,
      required this.rowVersion,
      required this.lines})
      : super._();
  @override
  Journal rebuild(void Function(JournalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JournalBuilder toBuilder() => JournalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Journal &&
        id == other.id &&
        journalNumber == other.journalNumber &&
        entryDate == other.entryDate &&
        accountingPeriodId == other.accountingPeriodId &&
        sourceType == other.sourceType &&
        sourceId == other.sourceId &&
        memo == other.memo &&
        postedAt == other.postedAt &&
        postedByUserId == other.postedByUserId &&
        reversesJournalId == other.reversesJournalId &&
        rowVersion == other.rowVersion &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, journalNumber.hashCode);
    _$hash = $jc(_$hash, entryDate.hashCode);
    _$hash = $jc(_$hash, accountingPeriodId.hashCode);
    _$hash = $jc(_$hash, sourceType.hashCode);
    _$hash = $jc(_$hash, sourceId.hashCode);
    _$hash = $jc(_$hash, memo.hashCode);
    _$hash = $jc(_$hash, postedAt.hashCode);
    _$hash = $jc(_$hash, postedByUserId.hashCode);
    _$hash = $jc(_$hash, reversesJournalId.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Journal')
          ..add('id', id)
          ..add('journalNumber', journalNumber)
          ..add('entryDate', entryDate)
          ..add('accountingPeriodId', accountingPeriodId)
          ..add('sourceType', sourceType)
          ..add('sourceId', sourceId)
          ..add('memo', memo)
          ..add('postedAt', postedAt)
          ..add('postedByUserId', postedByUserId)
          ..add('reversesJournalId', reversesJournalId)
          ..add('rowVersion', rowVersion)
          ..add('lines', lines))
        .toString();
  }
}

class JournalBuilder implements Builder<Journal, JournalBuilder> {
  _$Journal? _$v;

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

  int? _accountingPeriodId;
  int? get accountingPeriodId => _$this._accountingPeriodId;
  set accountingPeriodId(int? accountingPeriodId) =>
      _$this._accountingPeriodId = accountingPeriodId;

  String? _sourceType;
  String? get sourceType => _$this._sourceType;
  set sourceType(String? sourceType) => _$this._sourceType = sourceType;

  int? _sourceId;
  int? get sourceId => _$this._sourceId;
  set sourceId(int? sourceId) => _$this._sourceId = sourceId;

  String? _memo;
  String? get memo => _$this._memo;
  set memo(String? memo) => _$this._memo = memo;

  DateTime? _postedAt;
  DateTime? get postedAt => _$this._postedAt;
  set postedAt(DateTime? postedAt) => _$this._postedAt = postedAt;

  int? _postedByUserId;
  int? get postedByUserId => _$this._postedByUserId;
  set postedByUserId(int? postedByUserId) =>
      _$this._postedByUserId = postedByUserId;

  int? _reversesJournalId;
  int? get reversesJournalId => _$this._reversesJournalId;
  set reversesJournalId(int? reversesJournalId) =>
      _$this._reversesJournalId = reversesJournalId;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  ListBuilder<JournalLine>? _lines;
  ListBuilder<JournalLine> get lines =>
      _$this._lines ??= ListBuilder<JournalLine>();
  set lines(ListBuilder<JournalLine>? lines) => _$this._lines = lines;

  JournalBuilder() {
    Journal._defaults(this);
  }

  JournalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _journalNumber = $v.journalNumber;
      _entryDate = $v.entryDate;
      _accountingPeriodId = $v.accountingPeriodId;
      _sourceType = $v.sourceType;
      _sourceId = $v.sourceId;
      _memo = $v.memo;
      _postedAt = $v.postedAt;
      _postedByUserId = $v.postedByUserId;
      _reversesJournalId = $v.reversesJournalId;
      _rowVersion = $v.rowVersion;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Journal other) {
    _$v = other as _$Journal;
  }

  @override
  void update(void Function(JournalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Journal build() => _build();

  _$Journal _build() {
    _$Journal _$result;
    try {
      _$result = _$v ??
          _$Journal._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Journal', 'id'),
            journalNumber: BuiltValueNullFieldError.checkNotNull(
                journalNumber, r'Journal', 'journalNumber'),
            entryDate: BuiltValueNullFieldError.checkNotNull(
                entryDate, r'Journal', 'entryDate'),
            accountingPeriodId: BuiltValueNullFieldError.checkNotNull(
                accountingPeriodId, r'Journal', 'accountingPeriodId'),
            sourceType: BuiltValueNullFieldError.checkNotNull(
                sourceType, r'Journal', 'sourceType'),
            sourceId: BuiltValueNullFieldError.checkNotNull(
                sourceId, r'Journal', 'sourceId'),
            memo: memo,
            postedAt: BuiltValueNullFieldError.checkNotNull(
                postedAt, r'Journal', 'postedAt'),
            postedByUserId: postedByUserId,
            reversesJournalId: reversesJournalId,
            rowVersion: BuiltValueNullFieldError.checkNotNull(
                rowVersion, r'Journal', 'rowVersion'),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Journal', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
