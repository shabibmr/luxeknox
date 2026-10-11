// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipCreate extends MembershipCreate {
  @override
  final int memberId;
  @override
  final int productId;
  @override
  final Date startDate;
  @override
  final int paymentMethodId;
  @override
  final String? lockerNumber;
  @override
  final bool? autoRenew;
  @override
  final int? partnerMemberId;
  @override
  final bool? replacePartnerMembership;
  @override
  final String? discountAmount;

  factory _$MembershipCreate(
          [void Function(MembershipCreateBuilder)? updates]) =>
      (MembershipCreateBuilder()..update(updates))._build();

  _$MembershipCreate._(
      {required this.memberId,
      required this.productId,
      required this.startDate,
      required this.paymentMethodId,
      this.lockerNumber,
      this.autoRenew,
      this.partnerMemberId,
      this.replacePartnerMembership,
      this.discountAmount})
      : super._();
  @override
  MembershipCreate rebuild(void Function(MembershipCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipCreateBuilder toBuilder() =>
      MembershipCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipCreate &&
        memberId == other.memberId &&
        productId == other.productId &&
        startDate == other.startDate &&
        paymentMethodId == other.paymentMethodId &&
        lockerNumber == other.lockerNumber &&
        autoRenew == other.autoRenew &&
        partnerMemberId == other.partnerMemberId &&
        replacePartnerMembership == other.replacePartnerMembership &&
        discountAmount == other.discountAmount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, paymentMethodId.hashCode);
    _$hash = $jc(_$hash, lockerNumber.hashCode);
    _$hash = $jc(_$hash, autoRenew.hashCode);
    _$hash = $jc(_$hash, partnerMemberId.hashCode);
    _$hash = $jc(_$hash, replacePartnerMembership.hashCode);
    _$hash = $jc(_$hash, discountAmount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipCreate')
          ..add('memberId', memberId)
          ..add('productId', productId)
          ..add('startDate', startDate)
          ..add('paymentMethodId', paymentMethodId)
          ..add('lockerNumber', lockerNumber)
          ..add('autoRenew', autoRenew)
          ..add('partnerMemberId', partnerMemberId)
          ..add('replacePartnerMembership', replacePartnerMembership)
          ..add('discountAmount', discountAmount))
        .toString();
  }
}

class MembershipCreateBuilder
    implements Builder<MembershipCreate, MembershipCreateBuilder> {
  _$MembershipCreate? _$v;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _productId;
  int? get productId => _$this._productId;
  set productId(int? productId) => _$this._productId = productId;

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(Date? startDate) => _$this._startDate = startDate;

  int? _paymentMethodId;
  int? get paymentMethodId => _$this._paymentMethodId;
  set paymentMethodId(int? paymentMethodId) =>
      _$this._paymentMethodId = paymentMethodId;

  String? _lockerNumber;
  String? get lockerNumber => _$this._lockerNumber;
  set lockerNumber(String? lockerNumber) => _$this._lockerNumber = lockerNumber;

  bool? _autoRenew;
  bool? get autoRenew => _$this._autoRenew;
  set autoRenew(bool? autoRenew) => _$this._autoRenew = autoRenew;

  int? _partnerMemberId;
  int? get partnerMemberId => _$this._partnerMemberId;
  set partnerMemberId(int? partnerMemberId) =>
      _$this._partnerMemberId = partnerMemberId;

  bool? _replacePartnerMembership;
  bool? get replacePartnerMembership => _$this._replacePartnerMembership;
  set replacePartnerMembership(bool? replacePartnerMembership) =>
      _$this._replacePartnerMembership = replacePartnerMembership;

  String? _discountAmount;
  String? get discountAmount => _$this._discountAmount;
  set discountAmount(String? discountAmount) =>
      _$this._discountAmount = discountAmount;

  MembershipCreateBuilder() {
    MembershipCreate._defaults(this);
  }

  MembershipCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _productId = $v.productId;
      _startDate = $v.startDate;
      _paymentMethodId = $v.paymentMethodId;
      _lockerNumber = $v.lockerNumber;
      _autoRenew = $v.autoRenew;
      _partnerMemberId = $v.partnerMemberId;
      _replacePartnerMembership = $v.replacePartnerMembership;
      _discountAmount = $v.discountAmount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipCreate other) {
    _$v = other as _$MembershipCreate;
  }

  @override
  void update(void Function(MembershipCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipCreate build() => _build();

  _$MembershipCreate _build() {
    final _$result = _$v ??
        _$MembershipCreate._(
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'MembershipCreate', 'memberId'),
          productId: BuiltValueNullFieldError.checkNotNull(
              productId, r'MembershipCreate', 'productId'),
          startDate: BuiltValueNullFieldError.checkNotNull(
              startDate, r'MembershipCreate', 'startDate'),
          paymentMethodId: BuiltValueNullFieldError.checkNotNull(
              paymentMethodId, r'MembershipCreate', 'paymentMethodId'),
          lockerNumber: lockerNumber,
          autoRenew: autoRenew,
          partnerMemberId: partnerMemberId,
          replacePartnerMembership: replacePartnerMembership,
          discountAmount: discountAmount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
