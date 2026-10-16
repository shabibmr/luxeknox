// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_book_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DayBookLine extends DayBookLine {
  @override
  final int id;
  @override
  final int accountId;
  @override
  final String accountName;
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

  factory _$DayBookLine([void Function(DayBookLineBuilder)? updates]) =>
      (DayBookLineBuilder()..update(updates))._build();

  _$DayBookLine._(
      {required this.id,
      required this.accountId,
      required this.accountName,
      required this.debit,
      required this.credit,
      this.memo,
      this.memberId,
      this.vendorId})
      : super._();
  @override
  DayBookLine rebuild(void Function(DayBookLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DayBookLineBuilder toBuilder() => DayBookLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DayBookLine &&
        id == other.id &&
        accountId == other.accountId &&
        accountName == other.accountName &&
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
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, accountName.hashCode);
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
    return (newBuiltValueToStringHelper(r'DayBookLine')
          ..add('id', id)
          ..add('accountId', accountId)
          ..add('accountName', accountName)
          ..add('debit', debit)
          ..add('credit', credit)
          ..add('memo', memo)
          ..add('memberId', memberId)
          ..add('vendorId', vendorId))
        .toString();
  }
}

class DayBookLineBuilder implements Builder<DayBookLine, DayBookLineBuilder> {
  _$DayBookLine? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _accountId;
  int? get accountId => _$this._accountId;
  set accountId(int? accountId) => _$this._accountId = accountId;

  String? _accountName;
  String? get accountName => _$this._accountName;
  set accountName(String? accountName) => _$this._accountName = accountName;

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

  DayBookLineBuilder() {
    DayBookLine._defaults(this);
  }

  DayBookLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _accountId = $v.accountId;
      _accountName = $v.accountName;
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
  void replace(DayBookLine other) {
    _$v = other as _$DayBookLine;
  }

  @override
  void update(void Function(DayBookLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DayBookLine build() => _build();

  _$DayBookLine _build() {
    final _$result = _$v ??
        _$DayBookLine._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'DayBookLine', 'id'),
          accountId: BuiltValueNullFieldError.checkNotNull(
              accountId, r'DayBookLine', 'accountId'),
          accountName: BuiltValueNullFieldError.checkNotNull(
              accountName, r'DayBookLine', 'accountName'),
          debit: BuiltValueNullFieldError.checkNotNull(
              debit, r'DayBookLine', 'debit'),
          credit: BuiltValueNullFieldError.checkNotNull(
              credit, r'DayBookLine', 'credit'),
          memo: memo,
          memberId: memberId,
          vendorId: vendorId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
