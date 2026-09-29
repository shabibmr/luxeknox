// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_purchase_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtPurchaseRequest extends PtPurchaseRequest {
  @override
  final int ptProductId;
  @override
  final BuiltList<int> weekdays;
  @override
  final Date startDate;
  @override
  final String slotStart;
  @override
  final int memberId;
  @override
  final int trainerId;
  @override
  final String? discountAmount;
  @override
  final int? paymentMethodId;
  @override
  final BuiltList<TenderLine>? tenders;
  @override
  final String? transactionReference;

  factory _$PtPurchaseRequest(
          [void Function(PtPurchaseRequestBuilder)? updates]) =>
      (PtPurchaseRequestBuilder()..update(updates))._build();

  _$PtPurchaseRequest._(
      {required this.ptProductId,
      required this.weekdays,
      required this.startDate,
      required this.slotStart,
      required this.memberId,
      required this.trainerId,
      this.discountAmount,
      this.paymentMethodId,
      this.tenders,
      this.transactionReference})
      : super._();
  @override
  PtPurchaseRequest rebuild(void Function(PtPurchaseRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtPurchaseRequestBuilder toBuilder() =>
      PtPurchaseRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtPurchaseRequest &&
        ptProductId == other.ptProductId &&
        weekdays == other.weekdays &&
        startDate == other.startDate &&
        slotStart == other.slotStart &&
        memberId == other.memberId &&
        trainerId == other.trainerId &&
        discountAmount == other.discountAmount &&
        paymentMethodId == other.paymentMethodId &&
        tenders == other.tenders &&
        transactionReference == other.transactionReference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ptProductId.hashCode);
    _$hash = $jc(_$hash, weekdays.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, slotStart.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, discountAmount.hashCode);
    _$hash = $jc(_$hash, paymentMethodId.hashCode);
    _$hash = $jc(_$hash, tenders.hashCode);
    _$hash = $jc(_$hash, transactionReference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtPurchaseRequest')
          ..add('ptProductId', ptProductId)
          ..add('weekdays', weekdays)
          ..add('startDate', startDate)
          ..add('slotStart', slotStart)
          ..add('memberId', memberId)
          ..add('trainerId', trainerId)
          ..add('discountAmount', discountAmount)
          ..add('paymentMethodId', paymentMethodId)
          ..add('tenders', tenders)
          ..add('transactionReference', transactionReference))
        .toString();
  }
}

class PtPurchaseRequestBuilder
    implements
        Builder<PtPurchaseRequest, PtPurchaseRequestBuilder>,
        PtPaymentFieldsBuilder {
  _$PtPurchaseRequest? _$v;

  int? _ptProductId;
  int? get ptProductId => _$this._ptProductId;
  set ptProductId(covariant int? ptProductId) =>
      _$this._ptProductId = ptProductId;

  ListBuilder<int>? _weekdays;
  ListBuilder<int> get weekdays => _$this._weekdays ??= ListBuilder<int>();
  set weekdays(covariant ListBuilder<int>? weekdays) =>
      _$this._weekdays = weekdays;

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(covariant Date? startDate) => _$this._startDate = startDate;

  String? _slotStart;
  String? get slotStart => _$this._slotStart;
  set slotStart(covariant String? slotStart) => _$this._slotStart = slotStart;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(covariant int? memberId) => _$this._memberId = memberId;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(covariant int? trainerId) => _$this._trainerId = trainerId;

  String? _discountAmount;
  String? get discountAmount => _$this._discountAmount;
  set discountAmount(covariant String? discountAmount) =>
      _$this._discountAmount = discountAmount;

  int? _paymentMethodId;
  int? get paymentMethodId => _$this._paymentMethodId;
  set paymentMethodId(covariant int? paymentMethodId) =>
      _$this._paymentMethodId = paymentMethodId;

  ListBuilder<TenderLine>? _tenders;
  ListBuilder<TenderLine> get tenders =>
      _$this._tenders ??= ListBuilder<TenderLine>();
  set tenders(covariant ListBuilder<TenderLine>? tenders) =>
      _$this._tenders = tenders;

  String? _transactionReference;
  String? get transactionReference => _$this._transactionReference;
  set transactionReference(covariant String? transactionReference) =>
      _$this._transactionReference = transactionReference;

  PtPurchaseRequestBuilder() {
    PtPurchaseRequest._defaults(this);
  }

  PtPurchaseRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ptProductId = $v.ptProductId;
      _weekdays = $v.weekdays.toBuilder();
      _startDate = $v.startDate;
      _slotStart = $v.slotStart;
      _memberId = $v.memberId;
      _trainerId = $v.trainerId;
      _discountAmount = $v.discountAmount;
      _paymentMethodId = $v.paymentMethodId;
      _tenders = $v.tenders?.toBuilder();
      _transactionReference = $v.transactionReference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant PtPurchaseRequest other) {
    _$v = other as _$PtPurchaseRequest;
  }

  @override
  void update(void Function(PtPurchaseRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtPurchaseRequest build() => _build();

  _$PtPurchaseRequest _build() {
    _$PtPurchaseRequest _$result;
    try {
      _$result = _$v ??
          _$PtPurchaseRequest._(
            ptProductId: BuiltValueNullFieldError.checkNotNull(
                ptProductId, r'PtPurchaseRequest', 'ptProductId'),
            weekdays: weekdays.build(),
            startDate: BuiltValueNullFieldError.checkNotNull(
                startDate, r'PtPurchaseRequest', 'startDate'),
            slotStart: BuiltValueNullFieldError.checkNotNull(
                slotStart, r'PtPurchaseRequest', 'slotStart'),
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'PtPurchaseRequest', 'memberId'),
            trainerId: BuiltValueNullFieldError.checkNotNull(
                trainerId, r'PtPurchaseRequest', 'trainerId'),
            discountAmount: discountAmount,
            paymentMethodId: paymentMethodId,
            tenders: _tenders?.build(),
            transactionReference: transactionReference,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'weekdays';
        weekdays.build();

        _$failedField = 'tenders';
        _tenders?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PtPurchaseRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
