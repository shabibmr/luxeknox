// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_voucher.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentVoucherStatusEnum _$paymentVoucherStatusEnum_draft =
    const PaymentVoucherStatusEnum._('draft');
const PaymentVoucherStatusEnum _$paymentVoucherStatusEnum_posted =
    const PaymentVoucherStatusEnum._('posted');

PaymentVoucherStatusEnum _$paymentVoucherStatusEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$paymentVoucherStatusEnum_draft;
    case 'posted':
      return _$paymentVoucherStatusEnum_posted;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentVoucherStatusEnum> _$paymentVoucherStatusEnumValues =
    BuiltSet<PaymentVoucherStatusEnum>(const <PaymentVoucherStatusEnum>[
  _$paymentVoucherStatusEnum_draft,
  _$paymentVoucherStatusEnum_posted,
]);

Serializer<PaymentVoucherStatusEnum> _$paymentVoucherStatusEnumSerializer =
    _$PaymentVoucherStatusEnumSerializer();

class _$PaymentVoucherStatusEnumSerializer
    implements PrimitiveSerializer<PaymentVoucherStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'posted': 'posted',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'posted': 'posted',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentVoucherStatusEnum];
  @override
  final String wireName = 'PaymentVoucherStatusEnum';

  @override
  Object serialize(Serializers serializers, PaymentVoucherStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentVoucherStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentVoucherStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentVoucher extends PaymentVoucher {
  @override
  final int id;
  @override
  final String voucherNumber;
  @override
  final Date paymentDate;
  @override
  final int bankAccountId;
  @override
  final String totalAmount;
  @override
  final String? memo;
  @override
  final PaymentVoucherStatusEnum status;
  @override
  final int? journalEntryId;
  @override
  final int rowVersion;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final BuiltList<PaymentAllocation> allocations;

  factory _$PaymentVoucher([void Function(PaymentVoucherBuilder)? updates]) =>
      (PaymentVoucherBuilder()..update(updates))._build();

  _$PaymentVoucher._(
      {required this.id,
      required this.voucherNumber,
      required this.paymentDate,
      required this.bankAccountId,
      required this.totalAmount,
      this.memo,
      required this.status,
      this.journalEntryId,
      required this.rowVersion,
      required this.createdAt,
      this.updatedAt,
      required this.allocations})
      : super._();
  @override
  PaymentVoucher rebuild(void Function(PaymentVoucherBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentVoucherBuilder toBuilder() => PaymentVoucherBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentVoucher &&
        id == other.id &&
        voucherNumber == other.voucherNumber &&
        paymentDate == other.paymentDate &&
        bankAccountId == other.bankAccountId &&
        totalAmount == other.totalAmount &&
        memo == other.memo &&
        status == other.status &&
        journalEntryId == other.journalEntryId &&
        rowVersion == other.rowVersion &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        allocations == other.allocations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, voucherNumber.hashCode);
    _$hash = $jc(_$hash, paymentDate.hashCode);
    _$hash = $jc(_$hash, bankAccountId.hashCode);
    _$hash = $jc(_$hash, totalAmount.hashCode);
    _$hash = $jc(_$hash, memo.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, journalEntryId.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, allocations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentVoucher')
          ..add('id', id)
          ..add('voucherNumber', voucherNumber)
          ..add('paymentDate', paymentDate)
          ..add('bankAccountId', bankAccountId)
          ..add('totalAmount', totalAmount)
          ..add('memo', memo)
          ..add('status', status)
          ..add('journalEntryId', journalEntryId)
          ..add('rowVersion', rowVersion)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('allocations', allocations))
        .toString();
  }
}

class PaymentVoucherBuilder
    implements Builder<PaymentVoucher, PaymentVoucherBuilder> {
  _$PaymentVoucher? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _voucherNumber;
  String? get voucherNumber => _$this._voucherNumber;
  set voucherNumber(String? voucherNumber) =>
      _$this._voucherNumber = voucherNumber;

  Date? _paymentDate;
  Date? get paymentDate => _$this._paymentDate;
  set paymentDate(Date? paymentDate) => _$this._paymentDate = paymentDate;

  int? _bankAccountId;
  int? get bankAccountId => _$this._bankAccountId;
  set bankAccountId(int? bankAccountId) =>
      _$this._bankAccountId = bankAccountId;

  String? _totalAmount;
  String? get totalAmount => _$this._totalAmount;
  set totalAmount(String? totalAmount) => _$this._totalAmount = totalAmount;

  String? _memo;
  String? get memo => _$this._memo;
  set memo(String? memo) => _$this._memo = memo;

  PaymentVoucherStatusEnum? _status;
  PaymentVoucherStatusEnum? get status => _$this._status;
  set status(PaymentVoucherStatusEnum? status) => _$this._status = status;

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

  ListBuilder<PaymentAllocation>? _allocations;
  ListBuilder<PaymentAllocation> get allocations =>
      _$this._allocations ??= ListBuilder<PaymentAllocation>();
  set allocations(ListBuilder<PaymentAllocation>? allocations) =>
      _$this._allocations = allocations;

  PaymentVoucherBuilder() {
    PaymentVoucher._defaults(this);
  }

  PaymentVoucherBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _voucherNumber = $v.voucherNumber;
      _paymentDate = $v.paymentDate;
      _bankAccountId = $v.bankAccountId;
      _totalAmount = $v.totalAmount;
      _memo = $v.memo;
      _status = $v.status;
      _journalEntryId = $v.journalEntryId;
      _rowVersion = $v.rowVersion;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _allocations = $v.allocations.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentVoucher other) {
    _$v = other as _$PaymentVoucher;
  }

  @override
  void update(void Function(PaymentVoucherBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentVoucher build() => _build();

  _$PaymentVoucher _build() {
    _$PaymentVoucher _$result;
    try {
      _$result = _$v ??
          _$PaymentVoucher._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PaymentVoucher', 'id'),
            voucherNumber: BuiltValueNullFieldError.checkNotNull(
                voucherNumber, r'PaymentVoucher', 'voucherNumber'),
            paymentDate: BuiltValueNullFieldError.checkNotNull(
                paymentDate, r'PaymentVoucher', 'paymentDate'),
            bankAccountId: BuiltValueNullFieldError.checkNotNull(
                bankAccountId, r'PaymentVoucher', 'bankAccountId'),
            totalAmount: BuiltValueNullFieldError.checkNotNull(
                totalAmount, r'PaymentVoucher', 'totalAmount'),
            memo: memo,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PaymentVoucher', 'status'),
            journalEntryId: journalEntryId,
            rowVersion: BuiltValueNullFieldError.checkNotNull(
                rowVersion, r'PaymentVoucher', 'rowVersion'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PaymentVoucher', 'createdAt'),
            updatedAt: updatedAt,
            allocations: allocations.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'allocations';
        allocations.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaymentVoucher', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
