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
  final String? lockerNumber;
  @override
  final bool? autoRenew;

  factory _$MembershipCreate(
          [void Function(MembershipCreateBuilder)? updates]) =>
      (MembershipCreateBuilder()..update(updates))._build();

  _$MembershipCreate._(
      {required this.memberId,
      required this.productId,
      required this.startDate,
      this.lockerNumber,
      this.autoRenew})
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
        lockerNumber == other.lockerNumber &&
        autoRenew == other.autoRenew;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, lockerNumber.hashCode);
    _$hash = $jc(_$hash, autoRenew.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipCreate')
          ..add('memberId', memberId)
          ..add('productId', productId)
          ..add('startDate', startDate)
          ..add('lockerNumber', lockerNumber)
          ..add('autoRenew', autoRenew))
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

  String? _lockerNumber;
  String? get lockerNumber => _$this._lockerNumber;
  set lockerNumber(String? lockerNumber) => _$this._lockerNumber = lockerNumber;

  bool? _autoRenew;
  bool? get autoRenew => _$this._autoRenew;
  set autoRenew(bool? autoRenew) => _$this._autoRenew = autoRenew;

  MembershipCreateBuilder() {
    MembershipCreate._defaults(this);
  }

  MembershipCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _productId = $v.productId;
      _startDate = $v.startDate;
      _lockerNumber = $v.lockerNumber;
      _autoRenew = $v.autoRenew;
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
          lockerNumber: lockerNumber,
          autoRenew: autoRenew,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
