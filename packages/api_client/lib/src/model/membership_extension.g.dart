// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_extension.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipExtension extends MembershipExtension {
  @override
  final int id;
  @override
  final int membershipId;
  @override
  final int daysExtended;
  @override
  final String? reason;
  @override
  final int? grantedByUserId;
  @override
  final DateTime? createdAt;

  factory _$MembershipExtension(
          [void Function(MembershipExtensionBuilder)? updates]) =>
      (MembershipExtensionBuilder()..update(updates))._build();

  _$MembershipExtension._(
      {required this.id,
      required this.membershipId,
      required this.daysExtended,
      this.reason,
      this.grantedByUserId,
      this.createdAt})
      : super._();
  @override
  MembershipExtension rebuild(
          void Function(MembershipExtensionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipExtensionBuilder toBuilder() =>
      MembershipExtensionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipExtension &&
        id == other.id &&
        membershipId == other.membershipId &&
        daysExtended == other.daysExtended &&
        reason == other.reason &&
        grantedByUserId == other.grantedByUserId &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, membershipId.hashCode);
    _$hash = $jc(_$hash, daysExtended.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, grantedByUserId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipExtension')
          ..add('id', id)
          ..add('membershipId', membershipId)
          ..add('daysExtended', daysExtended)
          ..add('reason', reason)
          ..add('grantedByUserId', grantedByUserId)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class MembershipExtensionBuilder
    implements Builder<MembershipExtension, MembershipExtensionBuilder> {
  _$MembershipExtension? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _membershipId;
  int? get membershipId => _$this._membershipId;
  set membershipId(int? membershipId) => _$this._membershipId = membershipId;

  int? _daysExtended;
  int? get daysExtended => _$this._daysExtended;
  set daysExtended(int? daysExtended) => _$this._daysExtended = daysExtended;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  int? _grantedByUserId;
  int? get grantedByUserId => _$this._grantedByUserId;
  set grantedByUserId(int? grantedByUserId) =>
      _$this._grantedByUserId = grantedByUserId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MembershipExtensionBuilder() {
    MembershipExtension._defaults(this);
  }

  MembershipExtensionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _membershipId = $v.membershipId;
      _daysExtended = $v.daysExtended;
      _reason = $v.reason;
      _grantedByUserId = $v.grantedByUserId;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipExtension other) {
    _$v = other as _$MembershipExtension;
  }

  @override
  void update(void Function(MembershipExtensionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipExtension build() => _build();

  _$MembershipExtension _build() {
    final _$result = _$v ??
        _$MembershipExtension._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'MembershipExtension', 'id'),
          membershipId: BuiltValueNullFieldError.checkNotNull(
              membershipId, r'MembershipExtension', 'membershipId'),
          daysExtended: BuiltValueNullFieldError.checkNotNull(
              daysExtended, r'MembershipExtension', 'daysExtended'),
          reason: reason,
          grantedByUserId: grantedByUserId,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
