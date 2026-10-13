// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JournalLine extends JournalLine {
  @override
  final int id;
  @override
  final int journalEntryId;
  @override
  final int accountId;
  @override
  final String debit;
  @override
  final String credit;
  @override
  final String? memo;
  @override
  final int? memberId;
  @override
  final int? vendorId;

  factory _$JournalLine([void Function(JournalLineBuilder)? updates]) =>
      (JournalLineBuilder()..update(updates))._build();

  _$JournalLine._(
      {required this.id,
      required this.journalEntryId,
      required this.accountId,
      required this.debit,
      required this.credit,
      this.memo,
      this.memberId,
      this.vendorId})
      : super._();
  @override
  JournalLine rebuild(void Function(JournalLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JournalLineBuilder toBuilder() => JournalLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JournalLine &&
        id == other.id &&
        journalEntryId == other.journalEntryId &&
        accountId == other.accountId &&
        debit == other.debit &&
        credit == other.credit &&
        memo == other.memo &&
        memberId == other.memberId &&
        vendorId == other.vendorId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, journalEntryId.hashCode);
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, debit.hashCode);
    _$hash = $jc(_$hash, credit.hashCode);
    _$hash = $jc(_$hash, memo.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JournalLine')
          ..add('id', id)
          ..add('journalEntryId', journalEntryId)
          ..add('accountId', accountId)
          ..add('debit', debit)
          ..add('credit', credit)
          ..add('memo', memo)
          ..add('memberId', memberId)
          ..add('vendorId', vendorId))
        .toString();
  }
}

class JournalLineBuilder implements Builder<JournalLine, JournalLineBuilder> {
  _$JournalLine? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _journalEntryId;
  int? get journalEntryId => _$this._journalEntryId;
  set journalEntryId(int? journalEntryId) =>
      _$this._journalEntryId = journalEntryId;

  int? _accountId;
  int? get accountId => _$this._accountId;
  set accountId(int? accountId) => _$this._accountId = accountId;

  String? _debit;
  String? get debit => _$this._debit;
  set debit(String? debit) => _$this._debit = debit;

  String? _credit;
  String? get credit => _$this._credit;
  set credit(String? credit) => _$this._credit = credit;

  String? _memo;
  String? get memo => _$this._memo;
  set memo(String? memo) => _$this._memo = memo;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _vendorId;
  int? get vendorId => _$this._vendorId;
  set vendorId(int? vendorId) => _$this._vendorId = vendorId;

  JournalLineBuilder() {
    JournalLine._defaults(this);
  }

  JournalLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _journalEntryId = $v.journalEntryId;
      _accountId = $v.accountId;
      _debit = $v.debit;
      _credit = $v.credit;
      _memo = $v.memo;
      _memberId = $v.memberId;
      _vendorId = $v.vendorId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JournalLine other) {
    _$v = other as _$JournalLine;
  }

  @override
  void update(void Function(JournalLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JournalLine build() => _build();

  _$JournalLine _build() {
    final _$result = _$v ??
        _$JournalLine._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'JournalLine', 'id'),
          journalEntryId: BuiltValueNullFieldError.checkNotNull(
              journalEntryId, r'JournalLine', 'journalEntryId'),
          accountId: BuiltValueNullFieldError.checkNotNull(
              accountId, r'JournalLine', 'accountId'),
          debit: BuiltValueNullFieldError.checkNotNull(
              debit, r'JournalLine', 'debit'),
          credit: BuiltValueNullFieldError.checkNotNull(
              credit, r'JournalLine', 'credit'),
          memo: memo,
          memberId: memberId,
          vendorId: vendorId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
