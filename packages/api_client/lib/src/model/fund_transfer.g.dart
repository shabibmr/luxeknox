// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_transfer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FundTransferStatusEnum _$fundTransferStatusEnum_draft =
    const FundTransferStatusEnum._('draft');
const FundTransferStatusEnum _$fundTransferStatusEnum_posted =
    const FundTransferStatusEnum._('posted');

FundTransferStatusEnum _$fundTransferStatusEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$fundTransferStatusEnum_draft;
    case 'posted':
      return _$fundTransferStatusEnum_posted;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FundTransferStatusEnum> _$fundTransferStatusEnumValues =
    BuiltSet<FundTransferStatusEnum>(const <FundTransferStatusEnum>[
  _$fundTransferStatusEnum_draft,
  _$fundTransferStatusEnum_posted,
]);

Serializer<FundTransferStatusEnum> _$fundTransferStatusEnumSerializer =
    _$FundTransferStatusEnumSerializer();

class _$FundTransferStatusEnumSerializer
    implements PrimitiveSerializer<FundTransferStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'posted': 'posted',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'posted': 'posted',
  };

  @override
  final Iterable<Type> types = const <Type>[FundTransferStatusEnum];
  @override
  final String wireName = 'FundTransferStatusEnum';

  @override
  Object serialize(Serializers serializers, FundTransferStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FundTransferStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FundTransferStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FundTransfer extends FundTransfer {
  @override
  final int id;
  @override
  final String transferNumber;
  @override
  final Date transferDate;
  @override
  final int fromAccountId;
  @override
  final int toAccountId;
  @override
  final String amount;
  @override
  final String feeAmount;
  @override
  final int? feeAccountId;
  @override
  final String? memo;
  @override
  final FundTransferStatusEnum status;
  @override
  final int? journalEntryId;
  @override
  final int rowVersion;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  factory _$FundTransfer([void Function(FundTransferBuilder)? updates]) =>
      (FundTransferBuilder()..update(updates))._build();

  _$FundTransfer._(
      {required this.id,
      required this.transferNumber,
      required this.transferDate,
      required this.fromAccountId,
      required this.toAccountId,
      required this.amount,
      required this.feeAmount,
      this.feeAccountId,
      this.memo,
      required this.status,
      this.journalEntryId,
      required this.rowVersion,
      required this.createdAt,
      this.updatedAt})
      : super._();
  @override
  FundTransfer rebuild(void Function(FundTransferBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FundTransferBuilder toBuilder() => FundTransferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FundTransfer &&
        id == other.id &&
        transferNumber == other.transferNumber &&
        transferDate == other.transferDate &&
        fromAccountId == other.fromAccountId &&
        toAccountId == other.toAccountId &&
        amount == other.amount &&
        feeAmount == other.feeAmount &&
        feeAccountId == other.feeAccountId &&
        memo == other.memo &&
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
    _$hash = $jc(_$hash, transferNumber.hashCode);
    _$hash = $jc(_$hash, transferDate.hashCode);
    _$hash = $jc(_$hash, fromAccountId.hashCode);
    _$hash = $jc(_$hash, toAccountId.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, feeAmount.hashCode);
    _$hash = $jc(_$hash, feeAccountId.hashCode);
    _$hash = $jc(_$hash, memo.hashCode);
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
    return (newBuiltValueToStringHelper(r'FundTransfer')
          ..add('id', id)
          ..add('transferNumber', transferNumber)
          ..add('transferDate', transferDate)
          ..add('fromAccountId', fromAccountId)
          ..add('toAccountId', toAccountId)
          ..add('amount', amount)
          ..add('feeAmount', feeAmount)
          ..add('feeAccountId', feeAccountId)
          ..add('memo', memo)
          ..add('status', status)
          ..add('journalEntryId', journalEntryId)
          ..add('rowVersion', rowVersion)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class FundTransferBuilder
    implements Builder<FundTransfer, FundTransferBuilder> {
  _$FundTransfer? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _transferNumber;
  String? get transferNumber => _$this._transferNumber;
  set transferNumber(String? transferNumber) =>
      _$this._transferNumber = transferNumber;

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

  FundTransferStatusEnum? _status;
  FundTransferStatusEnum? get status => _$this._status;
  set status(FundTransferStatusEnum? status) => _$this._status = status;

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

  FundTransferBuilder() {
    FundTransfer._defaults(this);
  }

  FundTransferBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _transferNumber = $v.transferNumber;
      _transferDate = $v.transferDate;
      _fromAccountId = $v.fromAccountId;
      _toAccountId = $v.toAccountId;
      _amount = $v.amount;
      _feeAmount = $v.feeAmount;
      _feeAccountId = $v.feeAccountId;
      _memo = $v.memo;
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
  void replace(FundTransfer other) {
    _$v = other as _$FundTransfer;
  }

  @override
  void update(void Function(FundTransferBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FundTransfer build() => _build();

  _$FundTransfer _build() {
    final _$result = _$v ??
        _$FundTransfer._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'FundTransfer', 'id'),
          transferNumber: BuiltValueNullFieldError.checkNotNull(
              transferNumber, r'FundTransfer', 'transferNumber'),
          transferDate: BuiltValueNullFieldError.checkNotNull(
              transferDate, r'FundTransfer', 'transferDate'),
          fromAccountId: BuiltValueNullFieldError.checkNotNull(
              fromAccountId, r'FundTransfer', 'fromAccountId'),
          toAccountId: BuiltValueNullFieldError.checkNotNull(
              toAccountId, r'FundTransfer', 'toAccountId'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'FundTransfer', 'amount'),
          feeAmount: BuiltValueNullFieldError.checkNotNull(
              feeAmount, r'FundTransfer', 'feeAmount'),
          feeAccountId: feeAccountId,
          memo: memo,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'FundTransfer', 'status'),
          journalEntryId: journalEntryId,
          rowVersion: BuiltValueNullFieldError.checkNotNull(
              rowVersion, r'FundTransfer', 'rowVersion'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'FundTransfer', 'createdAt'),
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
