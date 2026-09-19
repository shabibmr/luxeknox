// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_freeze.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MembershipFreezeStatusEnum _$membershipFreezeStatusEnum_pending =
    const MembershipFreezeStatusEnum._('pending');
const MembershipFreezeStatusEnum _$membershipFreezeStatusEnum_approved =
    const MembershipFreezeStatusEnum._('approved');
const MembershipFreezeStatusEnum _$membershipFreezeStatusEnum_rejected =
    const MembershipFreezeStatusEnum._('rejected');

MembershipFreezeStatusEnum _$membershipFreezeStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$membershipFreezeStatusEnum_pending;
    case 'approved':
      return _$membershipFreezeStatusEnum_approved;
    case 'rejected':
      return _$membershipFreezeStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MembershipFreezeStatusEnum> _$membershipFreezeStatusEnumValues =
    BuiltSet<MembershipFreezeStatusEnum>(const <MembershipFreezeStatusEnum>[
  _$membershipFreezeStatusEnum_pending,
  _$membershipFreezeStatusEnum_approved,
  _$membershipFreezeStatusEnum_rejected,
]);

Serializer<MembershipFreezeStatusEnum> _$membershipFreezeStatusEnumSerializer =
    _$MembershipFreezeStatusEnumSerializer();

class _$MembershipFreezeStatusEnumSerializer
    implements PrimitiveSerializer<MembershipFreezeStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'approved': 'approved',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'approved': 'approved',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[MembershipFreezeStatusEnum];
  @override
  final String wireName = 'MembershipFreezeStatusEnum';

  @override
  Object serialize(Serializers serializers, MembershipFreezeStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MembershipFreezeStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MembershipFreezeStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MembershipFreeze extends MembershipFreeze {
  @override
  final int id;
  @override
  final int membershipId;
  @override
  final Date startDate;
  @override
  final Date endDate;
  @override
  final int? totalFreezeDays;
  @override
  final String? reason;
  @override
  final MembershipFreezeStatusEnum status;
  @override
  final int? reviewedByUserId;
  @override
  final DateTime? reviewedAt;

  factory _$MembershipFreeze(
          [void Function(MembershipFreezeBuilder)? updates]) =>
      (MembershipFreezeBuilder()..update(updates))._build();

  _$MembershipFreeze._(
      {required this.id,
      required this.membershipId,
      required this.startDate,
      required this.endDate,
      this.totalFreezeDays,
      this.reason,
      required this.status,
      this.reviewedByUserId,
      this.reviewedAt})
      : super._();
  @override
  MembershipFreeze rebuild(void Function(MembershipFreezeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipFreezeBuilder toBuilder() =>
      MembershipFreezeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipFreeze &&
        id == other.id &&
        membershipId == other.membershipId &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        totalFreezeDays == other.totalFreezeDays &&
        reason == other.reason &&
        status == other.status &&
        reviewedByUserId == other.reviewedByUserId &&
        reviewedAt == other.reviewedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, membershipId.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, totalFreezeDays.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reviewedByUserId.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipFreeze')
          ..add('id', id)
          ..add('membershipId', membershipId)
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('totalFreezeDays', totalFreezeDays)
          ..add('reason', reason)
          ..add('status', status)
          ..add('reviewedByUserId', reviewedByUserId)
          ..add('reviewedAt', reviewedAt))
        .toString();
  }
}

class MembershipFreezeBuilder
    implements Builder<MembershipFreeze, MembershipFreezeBuilder> {
  _$MembershipFreeze? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _membershipId;
  int? get membershipId => _$this._membershipId;
  set membershipId(int? membershipId) => _$this._membershipId = membershipId;

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(Date? startDate) => _$this._startDate = startDate;

  Date? _endDate;
  Date? get endDate => _$this._endDate;
  set endDate(Date? endDate) => _$this._endDate = endDate;

  int? _totalFreezeDays;
  int? get totalFreezeDays => _$this._totalFreezeDays;
  set totalFreezeDays(int? totalFreezeDays) =>
      _$this._totalFreezeDays = totalFreezeDays;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  MembershipFreezeStatusEnum? _status;
  MembershipFreezeStatusEnum? get status => _$this._status;
  set status(MembershipFreezeStatusEnum? status) => _$this._status = status;

  int? _reviewedByUserId;
  int? get reviewedByUserId => _$this._reviewedByUserId;
  set reviewedByUserId(int? reviewedByUserId) =>
      _$this._reviewedByUserId = reviewedByUserId;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  MembershipFreezeBuilder() {
    MembershipFreeze._defaults(this);
  }

  MembershipFreezeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _membershipId = $v.membershipId;
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _totalFreezeDays = $v.totalFreezeDays;
      _reason = $v.reason;
      _status = $v.status;
      _reviewedByUserId = $v.reviewedByUserId;
      _reviewedAt = $v.reviewedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipFreeze other) {
    _$v = other as _$MembershipFreeze;
  }

  @override
  void update(void Function(MembershipFreezeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipFreeze build() => _build();

  _$MembershipFreeze _build() {
    final _$result = _$v ??
        _$MembershipFreeze._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'MembershipFreeze', 'id'),
          membershipId: BuiltValueNullFieldError.checkNotNull(
              membershipId, r'MembershipFreeze', 'membershipId'),
          startDate: BuiltValueNullFieldError.checkNotNull(
              startDate, r'MembershipFreeze', 'startDate'),
          endDate: BuiltValueNullFieldError.checkNotNull(
              endDate, r'MembershipFreeze', 'endDate'),
          totalFreezeDays: totalFreezeDays,
          reason: reason,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'MembershipFreeze', 'status'),
          reviewedByUserId: reviewedByUserId,
          reviewedAt: reviewedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
