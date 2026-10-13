// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_document_counts.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DraftDocumentCounts extends DraftDocumentCounts {
  @override
  final int purchaseBills;
  @override
  final int expenseVouchers;
  @override
  final int paymentVouchers;
  @override
  final int creditNotes;
  @override
  final int debitNotes;
  @override
  final int total;

  factory _$DraftDocumentCounts(
          [void Function(DraftDocumentCountsBuilder)? updates]) =>
      (DraftDocumentCountsBuilder()..update(updates))._build();

  _$DraftDocumentCounts._(
      {required this.purchaseBills,
      required this.expenseVouchers,
      required this.paymentVouchers,
      required this.creditNotes,
      required this.debitNotes,
      required this.total})
      : super._();
  @override
  DraftDocumentCounts rebuild(
          void Function(DraftDocumentCountsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DraftDocumentCountsBuilder toBuilder() =>
      DraftDocumentCountsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DraftDocumentCounts &&
        purchaseBills == other.purchaseBills &&
        expenseVouchers == other.expenseVouchers &&
        paymentVouchers == other.paymentVouchers &&
        creditNotes == other.creditNotes &&
        debitNotes == other.debitNotes &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, purchaseBills.hashCode);
    _$hash = $jc(_$hash, expenseVouchers.hashCode);
    _$hash = $jc(_$hash, paymentVouchers.hashCode);
    _$hash = $jc(_$hash, creditNotes.hashCode);
    _$hash = $jc(_$hash, debitNotes.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DraftDocumentCounts')
          ..add('purchaseBills', purchaseBills)
          ..add('expenseVouchers', expenseVouchers)
          ..add('paymentVouchers', paymentVouchers)
          ..add('creditNotes', creditNotes)
          ..add('debitNotes', debitNotes)
          ..add('total', total))
        .toString();
  }
}

class DraftDocumentCountsBuilder
    implements Builder<DraftDocumentCounts, DraftDocumentCountsBuilder> {
  _$DraftDocumentCounts? _$v;

  int? _purchaseBills;
  int? get purchaseBills => _$this._purchaseBills;
  set purchaseBills(int? purchaseBills) =>
      _$this._purchaseBills = purchaseBills;

  int? _expenseVouchers;
  int? get expenseVouchers => _$this._expenseVouchers;
  set expenseVouchers(int? expenseVouchers) =>
      _$this._expenseVouchers = expenseVouchers;

  int? _paymentVouchers;
  int? get paymentVouchers => _$this._paymentVouchers;
  set paymentVouchers(int? paymentVouchers) =>
      _$this._paymentVouchers = paymentVouchers;

  int? _creditNotes;
  int? get creditNotes => _$this._creditNotes;
  set creditNotes(int? creditNotes) => _$this._creditNotes = creditNotes;

  int? _debitNotes;
  int? get debitNotes => _$this._debitNotes;
  set debitNotes(int? debitNotes) => _$this._debitNotes = debitNotes;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  DraftDocumentCountsBuilder() {
    DraftDocumentCounts._defaults(this);
  }

  DraftDocumentCountsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _purchaseBills = $v.purchaseBills;
      _expenseVouchers = $v.expenseVouchers;
      _paymentVouchers = $v.paymentVouchers;
      _creditNotes = $v.creditNotes;
      _debitNotes = $v.debitNotes;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DraftDocumentCounts other) {
    _$v = other as _$DraftDocumentCounts;
  }

  @override
  void update(void Function(DraftDocumentCountsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DraftDocumentCounts build() => _build();

  _$DraftDocumentCounts _build() {
    final _$result = _$v ??
        _$DraftDocumentCounts._(
          purchaseBills: BuiltValueNullFieldError.checkNotNull(
              purchaseBills, r'DraftDocumentCounts', 'purchaseBills'),
          expenseVouchers: BuiltValueNullFieldError.checkNotNull(
              expenseVouchers, r'DraftDocumentCounts', 'expenseVouchers'),
          paymentVouchers: BuiltValueNullFieldError.checkNotNull(
              paymentVouchers, r'DraftDocumentCounts', 'paymentVouchers'),
          creditNotes: BuiltValueNullFieldError.checkNotNull(
              creditNotes, r'DraftDocumentCounts', 'creditNotes'),
          debitNotes: BuiltValueNullFieldError.checkNotNull(
              debitNotes, r'DraftDocumentCounts', 'debitNotes'),
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'DraftDocumentCounts', 'total'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
