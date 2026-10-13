// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_transfer_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FundTransferUpdate extends FundTransferUpdate {
  @override
  final Date? transferDate;
  @override
  final int? fromAccountId;
  @override
  final int? toAccountId;
  @override
  final String? amount;
  @override
  final String? feeAmount;
  @override
  final int? feeAccountId;
  @override
  final String? memo;

  factory _$FundTransferUpdate(
          [void Function(FundTransferUpdateBuilder)? updates]) =>
      (FundTransferUpdateBuilder()..update(updates))._build();

  _$FundTransferUpdate._(
      {this.transferDate,
      this.fromAccountId,
      this.toAccountId,
      this.amount,
      this.feeAmount,
      this.feeAccountId,
      this.memo})
      : super._();
  @override
  FundTransferUpdate rebuild(
          void Function(FundTransferUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FundTransferUpdateBuilder toBuilder() =>
      FundTransferUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FundTransferUpdate &&
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
    return (newBuiltValueToStringHelper(r'FundTransferUpdate')
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

class FundTransferUpdateBuilder
    implements Builder<FundTransferUpdate, FundTransferUpdateBuilder> {
  _$FundTransferUpdate? _$v;

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

  FundTransferUpdateBuilder() {
    FundTransferUpdate._defaults(this);
  }

  FundTransferUpdateBuilder get _$this {
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
  void replace(FundTransferUpdate other) {
    _$v = other as _$FundTransferUpdate;
  }

  @override
  void update(void Function(FundTransferUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FundTransferUpdate build() => _build();

  _$FundTransferUpdate _build() {
    final _$result = _$v ??
        _$FundTransferUpdate._(
          transferDate: transferDate,
          fromAccountId: fromAccountId,
          toAccountId: toAccountId,
          amount: amount,
          feeAmount: feeAmount,
          feeAccountId: feeAccountId,
          memo: memo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
