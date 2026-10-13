// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_transfer_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FundTransferCreate extends FundTransferCreate {
  @override
  final Date transferDate;
  @override
  final int fromAccountId;
  @override
  final int toAccountId;
  @override
  final String amount;
  @override
  final String? feeAmount;
  @override
  final int? feeAccountId;
  @override
  final String? memo;

  factory _$FundTransferCreate(
          [void Function(FundTransferCreateBuilder)? updates]) =>
      (FundTransferCreateBuilder()..update(updates))._build();

  _$FundTransferCreate._(
      {required this.transferDate,
      required this.fromAccountId,
      required this.toAccountId,
      required this.amount,
      this.feeAmount,
      this.feeAccountId,
      this.memo})
      : super._();
  @override
  FundTransferCreate rebuild(
          void Function(FundTransferCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FundTransferCreateBuilder toBuilder() =>
      FundTransferCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FundTransferCreate &&
        transferDate == other.transferDate &&
        fromAccountId == other.fromAccountId &&
        toAccountId == other.toAccountId &&
        amount == other.amount &&
        feeAmount == other.feeAmount &&
        feeAccountId == other.feeAccountId &&
        memo == other.memo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, transferDate.hashCode);
    _$hash = $jc(_$hash, fromAccountId.hashCode);
    _$hash = $jc(_$hash, toAccountId.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, feeAmount.hashCode);
    _$hash = $jc(_$hash, feeAccountId.hashCode);
    _$hash = $jc(_$hash, memo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FundTransferCreate')
          ..add('transferDate', transferDate)
          ..add('fromAccountId', fromAccountId)
          ..add('toAccountId', toAccountId)
          ..add('amount', amount)
          ..add('feeAmount', feeAmount)
          ..add('feeAccountId', feeAccountId)
          ..add('memo', memo))
        .toString();
  }
}

class FundTransferCreateBuilder
    implements Builder<FundTransferCreate, FundTransferCreateBuilder> {
  _$FundTransferCreate? _$v;

  Date? _transferDate;
  Date? get transferDate => _$this._transferDate;
  set transferDate(Date? transferDate) => _$this._transferDate = transferDate;

  int? _fromAccountId;
  int? get fromAccountId => _$this._fromAccountId;
  set fromAccountId(int? fromAccountId) =>
      _$this._fromAccountId = fromAccountId;

  int? _toAccountId;
  int? get toAccountId => _$this._toAccountId;
  set toAccountId(int? toAccountId) => _$this._toAccountId = toAccountId;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _feeAmount;
  String? get feeAmount => _$this._feeAmount;
  set feeAmount(String? feeAmount) => _$this._feeAmount = feeAmount;

  int? _feeAccountId;
  int? get feeAccountId => _$this._feeAccountId;
  set feeAccountId(int? feeAccountId) => _$this._feeAccountId = feeAccountId;

  String? _memo;
  String? get memo => _$this._memo;
  set memo(String? memo) => _$this._memo = memo;

  FundTransferCreateBuilder() {
    FundTransferCreate._defaults(this);
  }

  FundTransferCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _transferDate = $v.transferDate;
      _fromAccountId = $v.fromAccountId;
      _toAccountId = $v.toAccountId;
      _amount = $v.amount;
      _feeAmount = $v.feeAmount;
      _feeAccountId = $v.feeAccountId;
      _memo = $v.memo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FundTransferCreate other) {
    _$v = other as _$FundTransferCreate;
  }

  @override
  void update(void Function(FundTransferCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FundTransferCreate build() => _build();

  _$FundTransferCreate _build() {
    final _$result = _$v ??
        _$FundTransferCreate._(
          transferDate: BuiltValueNullFieldError.checkNotNull(
              transferDate, r'FundTransferCreate', 'transferDate'),
          fromAccountId: BuiltValueNullFieldError.checkNotNull(
              fromAccountId, r'FundTransferCreate', 'fromAccountId'),
          toAccountId: BuiltValueNullFieldError.checkNotNull(
              toAccountId, r'FundTransferCreate', 'toAccountId'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'FundTransferCreate', 'amount'),
          feeAmount: feeAmount,
          feeAccountId: feeAccountId,
          memo: memo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
