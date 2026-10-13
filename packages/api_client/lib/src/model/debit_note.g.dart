// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debit_note.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DebitNote extends DebitNote {
  @override
  final int id;
  @override
  final String debitNoteNumber;
  @override
  final int purchaseBillId;
  @override
  final Date debitNoteDate;
  @override
  final String? reason;
  @override
  final String subtotal;
  @override
  final String taxAmount;
  @override
  final String totalAmount;
  @override
  final DebitNoteStatus status;
  @override
  final int? journalEntryId;
  @override
  final int rowVersion;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  factory _$DebitNote([void Function(DebitNoteBuilder)? updates]) =>
      (DebitNoteBuilder()..update(updates))._build();

  _$DebitNote._(
      {required this.id,
      required this.debitNoteNumber,
      required this.purchaseBillId,
      required this.debitNoteDate,
      this.reason,
      required this.subtotal,
      required this.taxAmount,
      required this.totalAmount,
      required this.status,
      this.journalEntryId,
      required this.rowVersion,
      required this.createdAt,
      this.updatedAt})
      : super._();
  @override
  DebitNote rebuild(void Function(DebitNoteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DebitNoteBuilder toBuilder() => DebitNoteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DebitNote &&
        id == other.id &&
        debitNoteNumber == other.debitNoteNumber &&
        purchaseBillId == other.purchaseBillId &&
        debitNoteDate == other.debitNoteDate &&
        reason == other.reason &&
        subtotal == other.subtotal &&
        taxAmount == other.taxAmount &&
        totalAmount == other.totalAmount &&
        status == other.status &&
        journalEntryId == other.journalEntryId &&
        rowVersion == other.rowVersion &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, debitNoteNumber.hashCode);
    _$hash = $jc(_$hash, purchaseBillId.hashCode);
    _$hash = $jc(_$hash, debitNoteDate.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, subtotal.hashCode);
    _$hash = $jc(_$hash, taxAmount.hashCode);
    _$hash = $jc(_$hash, totalAmount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, journalEntryId.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DebitNote')
          ..add('id', id)
          ..add('debitNoteNumber', debitNoteNumber)
          ..add('purchaseBillId', purchaseBillId)
          ..add('debitNoteDate', debitNoteDate)
          ..add('reason', reason)
          ..add('subtotal', subtotal)
          ..add('taxAmount', taxAmount)
          ..add('totalAmount', totalAmount)
          ..add('status', status)
          ..add('journalEntryId', journalEntryId)
          ..add('rowVersion', rowVersion)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class DebitNoteBuilder implements Builder<DebitNote, DebitNoteBuilder> {
  _$DebitNote? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _debitNoteNumber;
  String? get debitNoteNumber => _$this._debitNoteNumber;
  set debitNoteNumber(String? debitNoteNumber) =>
      _$this._debitNoteNumber = debitNoteNumber;

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

  String? _totalAmount;
  String? get totalAmount => _$this._totalAmount;
  set totalAmount(String? totalAmount) => _$this._totalAmount = totalAmount;

  DebitNoteStatus? _status;
  DebitNoteStatus? get status => _$this._status;
  set status(DebitNoteStatus? status) => _$this._status = status;

  int? _journalEntryId;
  int? get journalEntryId => _$this._journalEntryId;
  set journalEntryId(int? journalEntryId) =>
      _$this._journalEntryId = journalEntryId;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  DebitNoteBuilder() {
    DebitNote._defaults(this);
  }

  DebitNoteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _debitNoteNumber = $v.debitNoteNumber;
      _purchaseBillId = $v.purchaseBillId;
      _debitNoteDate = $v.debitNoteDate;
      _reason = $v.reason;
      _subtotal = $v.subtotal;
      _taxAmount = $v.taxAmount;
      _totalAmount = $v.totalAmount;
      _status = $v.status;
      _journalEntryId = $v.journalEntryId;
      _rowVersion = $v.rowVersion;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DebitNote other) {
    _$v = other as _$DebitNote;
  }

  @override
  void update(void Function(DebitNoteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DebitNote build() => _build();

  _$DebitNote _build() {
    final _$result = _$v ??
        _$DebitNote._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'DebitNote', 'id'),
          debitNoteNumber: BuiltValueNullFieldError.checkNotNull(
              debitNoteNumber, r'DebitNote', 'debitNoteNumber'),
          purchaseBillId: BuiltValueNullFieldError.checkNotNull(
              purchaseBillId, r'DebitNote', 'purchaseBillId'),
          debitNoteDate: BuiltValueNullFieldError.checkNotNull(
              debitNoteDate, r'DebitNote', 'debitNoteDate'),
          reason: reason,
          subtotal: BuiltValueNullFieldError.checkNotNull(
              subtotal, r'DebitNote', 'subtotal'),
          taxAmount: BuiltValueNullFieldError.checkNotNull(
              taxAmount, r'DebitNote', 'taxAmount'),
          totalAmount: BuiltValueNullFieldError.checkNotNull(
              totalAmount, r'DebitNote', 'totalAmount'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'DebitNote', 'status'),
          journalEntryId: journalEntryId,
          rowVersion: BuiltValueNullFieldError.checkNotNull(
              rowVersion, r'DebitNote', 'rowVersion'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'DebitNote', 'createdAt'),
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
