// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debit_note_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DebitNoteCreate extends DebitNoteCreate {
  @override
  final int purchaseBillId;
  @override
  final Date debitNoteDate;
  @override
  final String? reason;
  @override
  final String subtotal;
  @override
  final String? taxAmount;

  factory _$DebitNoteCreate([void Function(DebitNoteCreateBuilder)? updates]) =>
      (DebitNoteCreateBuilder()..update(updates))._build();

  _$DebitNoteCreate._(
      {required this.purchaseBillId,
      required this.debitNoteDate,
      this.reason,
      required this.subtotal,
      this.taxAmount})
      : super._();
  @override
  DebitNoteCreate rebuild(void Function(DebitNoteCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DebitNoteCreateBuilder toBuilder() => DebitNoteCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DebitNoteCreate &&
        purchaseBillId == other.purchaseBillId &&
        debitNoteDate == other.debitNoteDate &&
        reason == other.reason &&
        subtotal == other.subtotal &&
        taxAmount == other.taxAmount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, purchaseBillId.hashCode);
    _$hash = $jc(_$hash, debitNoteDate.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, subtotal.hashCode);
    _$hash = $jc(_$hash, taxAmount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DebitNoteCreate')
          ..add('purchaseBillId', purchaseBillId)
          ..add('debitNoteDate', debitNoteDate)
          ..add('reason', reason)
          ..add('subtotal', subtotal)
          ..add('taxAmount', taxAmount))
        .toString();
  }
}

class DebitNoteCreateBuilder
    implements Builder<DebitNoteCreate, DebitNoteCreateBuilder> {
  _$DebitNoteCreate? _$v;

  int? _purchaseBillId;
  int? get purchaseBillId => _$this._purchaseBillId;
  set purchaseBillId(int? purchaseBillId) =>
      _$this._purchaseBillId = purchaseBillId;

  Date? _debitNoteDate;
  Date? get debitNoteDate => _$this._debitNoteDate;
  set debitNoteDate(Date? debitNoteDate) =>
      _$this._debitNoteDate = debitNoteDate;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _subtotal;
  String? get subtotal => _$this._subtotal;
  set subtotal(String? subtotal) => _$this._subtotal = subtotal;

  String? _taxAmount;
  String? get taxAmount => _$this._taxAmount;
  set taxAmount(String? taxAmount) => _$this._taxAmount = taxAmount;

  DebitNoteCreateBuilder() {
    DebitNoteCreate._defaults(this);
  }

  DebitNoteCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _purchaseBillId = $v.purchaseBillId;
      _debitNoteDate = $v.debitNoteDate;
      _reason = $v.reason;
      _subtotal = $v.subtotal;
      _taxAmount = $v.taxAmount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DebitNoteCreate other) {
    _$v = other as _$DebitNoteCreate;
  }

  @override
  void update(void Function(DebitNoteCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DebitNoteCreate build() => _build();

  _$DebitNoteCreate _build() {
    final _$result = _$v ??
        _$DebitNoteCreate._(
          purchaseBillId: BuiltValueNullFieldError.checkNotNull(
              purchaseBillId, r'DebitNoteCreate', 'purchaseBillId'),
          debitNoteDate: BuiltValueNullFieldError.checkNotNull(
              debitNoteDate, r'DebitNoteCreate', 'debitNoteDate'),
          reason: reason,
          subtotal: BuiltValueNullFieldError.checkNotNull(
              subtotal, r'DebitNoteCreate', 'subtotal'),
          taxAmount: taxAmount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
