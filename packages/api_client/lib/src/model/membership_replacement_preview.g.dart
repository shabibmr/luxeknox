// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_replacement_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipReplacementPreview extends MembershipReplacementPreview {
  @override
  final int membershipId;
  @override
  final String productName;
  @override
  final MembershipStatus status;
  @override
  final Date endDate;
  @override
  final int remainingDays;
  @override
  final bool isCouple;
  @override
  final String suggestedCredit;

  factory _$MembershipReplacementPreview(
          [void Function(MembershipReplacementPreviewBuilder)? updates]) =>
      (MembershipReplacementPreviewBuilder()..update(updates))._build();

  _$MembershipReplacementPreview._(
      {required this.membershipId,
      required this.productName,
      required this.status,
      required this.endDate,
      required this.remainingDays,
      required this.isCouple,
      required this.suggestedCredit})
      : super._();
  @override
  MembershipReplacementPreview rebuild(
          void Function(MembershipReplacementPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipReplacementPreviewBuilder toBuilder() =>
      MembershipReplacementPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipReplacementPreview &&
        membershipId == other.membershipId &&
        productName == other.productName &&
        status == other.status &&
        endDate == other.endDate &&
        remainingDays == other.remainingDays &&
        isCouple == other.isCouple &&
        suggestedCredit == other.suggestedCredit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, membershipId.hashCode);
    _$hash = $jc(_$hash, productName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, remainingDays.hashCode);
    _$hash = $jc(_$hash, isCouple.hashCode);
    _$hash = $jc(_$hash, suggestedCredit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipReplacementPreview')
          ..add('membershipId', membershipId)
          ..add('productName', productName)
          ..add('status', status)
          ..add('endDate', endDate)
          ..add('remainingDays', remainingDays)
          ..add('isCouple', isCouple)
          ..add('suggestedCredit', suggestedCredit))
        .toString();
  }
}

class MembershipReplacementPreviewBuilder
    implements
        Builder<MembershipReplacementPreview,
            MembershipReplacementPreviewBuilder> {
  _$MembershipReplacementPreview? _$v;

  int? _membershipId;
  int? get membershipId => _$this._membershipId;
  set membershipId(int? membershipId) => _$this._membershipId = membershipId;

  String? _productName;
  String? get productName => _$this._productName;
  set productName(String? productName) => _$this._productName = productName;

  MembershipStatus? _status;
  MembershipStatus? get status => _$this._status;
  set status(MembershipStatus? status) => _$this._status = status;

  Date? _endDate;
  Date? get endDate => _$this._endDate;
  set endDate(Date? endDate) => _$this._endDate = endDate;

  int? _remainingDays;
  int? get remainingDays => _$this._remainingDays;
  set remainingDays(int? remainingDays) =>
      _$this._remainingDays = remainingDays;

  bool? _isCouple;
  bool? get isCouple => _$this._isCouple;
  set isCouple(bool? isCouple) => _$this._isCouple = isCouple;

  String? _suggestedCredit;
  String? get suggestedCredit => _$this._suggestedCredit;
  set suggestedCredit(String? suggestedCredit) =>
      _$this._suggestedCredit = suggestedCredit;

  MembershipReplacementPreviewBuilder() {
    MembershipReplacementPreview._defaults(this);
  }

  MembershipReplacementPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _membershipId = $v.membershipId;
      _productName = $v.productName;
      _status = $v.status;
      _endDate = $v.endDate;
      _remainingDays = $v.remainingDays;
      _isCouple = $v.isCouple;
      _suggestedCredit = $v.suggestedCredit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipReplacementPreview other) {
    _$v = other as _$MembershipReplacementPreview;
  }

  @override
  void update(void Function(MembershipReplacementPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipReplacementPreview build() => _build();

  _$MembershipReplacementPreview _build() {
    final _$result = _$v ??
        _$MembershipReplacementPreview._(
          membershipId: BuiltValueNullFieldError.checkNotNull(
              membershipId, r'MembershipReplacementPreview', 'membershipId'),
          productName: BuiltValueNullFieldError.checkNotNull(
              productName, r'MembershipReplacementPreview', 'productName'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'MembershipReplacementPreview', 'status'),
          endDate: BuiltValueNullFieldError.checkNotNull(
              endDate, r'MembershipReplacementPreview', 'endDate'),
          remainingDays: BuiltValueNullFieldError.checkNotNull(
              remainingDays, r'MembershipReplacementPreview', 'remainingDays'),
          isCouple: BuiltValueNullFieldError.checkNotNull(
              isCouple, r'MembershipReplacementPreview', 'isCouple'),
          suggestedCredit: BuiltValueNullFieldError.checkNotNull(
              suggestedCredit,
              r'MembershipReplacementPreview',
              'suggestedCredit'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
