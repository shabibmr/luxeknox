// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Membership extends Membership {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final int productId;
  @override
  final Date startDate;
  @override
  final Date endDate;
  @override
  final int? remainingPtSessions;
  @override
  final MembershipStatus status;
  @override
  final String? lockerNumber;
  @override
  final bool? autoRenew;
  @override
  final int rowVersion;
  @override
  final MembershipProduct? product;

  factory _$Membership([void Function(MembershipBuilder)? updates]) =>
      (MembershipBuilder()..update(updates))._build();

  _$Membership._(
      {required this.id,
      required this.memberId,
      required this.productId,
      required this.startDate,
      required this.endDate,
      this.remainingPtSessions,
      required this.status,
      this.lockerNumber,
      this.autoRenew,
      required this.rowVersion,
      this.product})
      : super._();
  @override
  Membership rebuild(void Function(MembershipBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipBuilder toBuilder() => MembershipBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Membership &&
        id == other.id &&
        memberId == other.memberId &&
        productId == other.productId &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        remainingPtSessions == other.remainingPtSessions &&
        status == other.status &&
        lockerNumber == other.lockerNumber &&
        autoRenew == other.autoRenew &&
        rowVersion == other.rowVersion &&
        product == other.product;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, remainingPtSessions.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, lockerNumber.hashCode);
    _$hash = $jc(_$hash, autoRenew.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, product.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Membership')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('productId', productId)
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('remainingPtSessions', remainingPtSessions)
          ..add('status', status)
          ..add('lockerNumber', lockerNumber)
          ..add('autoRenew', autoRenew)
          ..add('rowVersion', rowVersion)
          ..add('product', product))
        .toString();
  }
}

class MembershipBuilder implements Builder<Membership, MembershipBuilder> {
  _$Membership? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _productId;
  int? get productId => _$this._productId;
  set productId(int? productId) => _$this._productId = productId;

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(Date? startDate) => _$this._startDate = startDate;

  Date? _endDate;
  Date? get endDate => _$this._endDate;
  set endDate(Date? endDate) => _$this._endDate = endDate;

  int? _remainingPtSessions;
  int? get remainingPtSessions => _$this._remainingPtSessions;
  set remainingPtSessions(int? remainingPtSessions) =>
      _$this._remainingPtSessions = remainingPtSessions;

  MembershipStatus? _status;
  MembershipStatus? get status => _$this._status;
  set status(MembershipStatus? status) => _$this._status = status;

  String? _lockerNumber;
  String? get lockerNumber => _$this._lockerNumber;
  set lockerNumber(String? lockerNumber) => _$this._lockerNumber = lockerNumber;

  bool? _autoRenew;
  bool? get autoRenew => _$this._autoRenew;
  set autoRenew(bool? autoRenew) => _$this._autoRenew = autoRenew;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  MembershipProductBuilder? _product;
  MembershipProductBuilder get product =>
      _$this._product ??= MembershipProductBuilder();
  set product(MembershipProductBuilder? product) => _$this._product = product;

  MembershipBuilder() {
    Membership._defaults(this);
  }

  MembershipBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _productId = $v.productId;
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _remainingPtSessions = $v.remainingPtSessions;
      _status = $v.status;
      _lockerNumber = $v.lockerNumber;
      _autoRenew = $v.autoRenew;
      _rowVersion = $v.rowVersion;
      _product = $v.product?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Membership other) {
    _$v = other as _$Membership;
  }

  @override
  void update(void Function(MembershipBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Membership build() => _build();

  _$Membership _build() {
    _$Membership _$result;
    try {
      _$result = _$v ??
          _$Membership._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Membership', 'id'),
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'Membership', 'memberId'),
            productId: BuiltValueNullFieldError.checkNotNull(
                productId, r'Membership', 'productId'),
            startDate: BuiltValueNullFieldError.checkNotNull(
                startDate, r'Membership', 'startDate'),
            endDate: BuiltValueNullFieldError.checkNotNull(
                endDate, r'Membership', 'endDate'),
            remainingPtSessions: remainingPtSessions,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'Membership', 'status'),
            lockerNumber: lockerNumber,
            autoRenew: autoRenew,
            rowVersion: BuiltValueNullFieldError.checkNotNull(
                rowVersion, r'Membership', 'rowVersion'),
            product: _product?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'product';
        _product?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Membership', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
