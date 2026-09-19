// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_history.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MembershipHistoryActionEnum _$membershipHistoryActionEnum_created =
    const MembershipHistoryActionEnum._('created');
const MembershipHistoryActionEnum _$membershipHistoryActionEnum_renewed =
    const MembershipHistoryActionEnum._('renewed');
const MembershipHistoryActionEnum _$membershipHistoryActionEnum_upgraded =
    const MembershipHistoryActionEnum._('upgraded');
const MembershipHistoryActionEnum _$membershipHistoryActionEnum_frozen =
    const MembershipHistoryActionEnum._('frozen');
const MembershipHistoryActionEnum _$membershipHistoryActionEnum_expired =
    const MembershipHistoryActionEnum._('expired');
const MembershipHistoryActionEnum _$membershipHistoryActionEnum_cancelled =
    const MembershipHistoryActionEnum._('cancelled');
const MembershipHistoryActionEnum _$membershipHistoryActionEnum_extended =
    const MembershipHistoryActionEnum._('extended');

MembershipHistoryActionEnum _$membershipHistoryActionEnumValueOf(String name) {
  switch (name) {
    case 'created':
      return _$membershipHistoryActionEnum_created;
    case 'renewed':
      return _$membershipHistoryActionEnum_renewed;
    case 'upgraded':
      return _$membershipHistoryActionEnum_upgraded;
    case 'frozen':
      return _$membershipHistoryActionEnum_frozen;
    case 'expired':
      return _$membershipHistoryActionEnum_expired;
    case 'cancelled':
      return _$membershipHistoryActionEnum_cancelled;
    case 'extended':
      return _$membershipHistoryActionEnum_extended;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MembershipHistoryActionEnum>
    _$membershipHistoryActionEnumValues =
    BuiltSet<MembershipHistoryActionEnum>(const <MembershipHistoryActionEnum>[
  _$membershipHistoryActionEnum_created,
  _$membershipHistoryActionEnum_renewed,
  _$membershipHistoryActionEnum_upgraded,
  _$membershipHistoryActionEnum_frozen,
  _$membershipHistoryActionEnum_expired,
  _$membershipHistoryActionEnum_cancelled,
  _$membershipHistoryActionEnum_extended,
]);

Serializer<MembershipHistoryActionEnum>
    _$membershipHistoryActionEnumSerializer =
    _$MembershipHistoryActionEnumSerializer();

class _$MembershipHistoryActionEnumSerializer
    implements PrimitiveSerializer<MembershipHistoryActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'created': 'created',
    'renewed': 'renewed',
    'upgraded': 'upgraded',
    'frozen': 'frozen',
    'expired': 'expired',
    'cancelled': 'cancelled',
    'extended': 'extended',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'created': 'created',
    'renewed': 'renewed',
    'upgraded': 'upgraded',
    'frozen': 'frozen',
    'expired': 'expired',
    'cancelled': 'cancelled',
    'extended': 'extended',
  };

  @override
  final Iterable<Type> types = const <Type>[MembershipHistoryActionEnum];
  @override
  final String wireName = 'MembershipHistoryActionEnum';

  @override
  Object serialize(Serializers serializers, MembershipHistoryActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MembershipHistoryActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MembershipHistoryActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MembershipHistory extends MembershipHistory {
  @override
  final int id;
  @override
  final int membershipId;
  @override
  final MembershipHistoryActionEnum action;
  @override
  final Date? oldEndDate;
  @override
  final Date? newEndDate;
  @override
  final int? performedByUserId;
  @override
  final DateTime timestamp;

  factory _$MembershipHistory(
          [void Function(MembershipHistoryBuilder)? updates]) =>
      (MembershipHistoryBuilder()..update(updates))._build();

  _$MembershipHistory._(
      {required this.id,
      required this.membershipId,
      required this.action,
      this.oldEndDate,
      this.newEndDate,
      this.performedByUserId,
      required this.timestamp})
      : super._();
  @override
  MembershipHistory rebuild(void Function(MembershipHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipHistoryBuilder toBuilder() =>
      MembershipHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipHistory &&
        id == other.id &&
        membershipId == other.membershipId &&
        action == other.action &&
        oldEndDate == other.oldEndDate &&
        newEndDate == other.newEndDate &&
        performedByUserId == other.performedByUserId &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, membershipId.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, oldEndDate.hashCode);
    _$hash = $jc(_$hash, newEndDate.hashCode);
    _$hash = $jc(_$hash, performedByUserId.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipHistory')
          ..add('id', id)
          ..add('membershipId', membershipId)
          ..add('action', action)
          ..add('oldEndDate', oldEndDate)
          ..add('newEndDate', newEndDate)
          ..add('performedByUserId', performedByUserId)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class MembershipHistoryBuilder
    implements Builder<MembershipHistory, MembershipHistoryBuilder> {
  _$MembershipHistory? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _membershipId;
  int? get membershipId => _$this._membershipId;
  set membershipId(int? membershipId) => _$this._membershipId = membershipId;

  MembershipHistoryActionEnum? _action;
  MembershipHistoryActionEnum? get action => _$this._action;
  set action(MembershipHistoryActionEnum? action) => _$this._action = action;

  Date? _oldEndDate;
  Date? get oldEndDate => _$this._oldEndDate;
  set oldEndDate(Date? oldEndDate) => _$this._oldEndDate = oldEndDate;

  Date? _newEndDate;
  Date? get newEndDate => _$this._newEndDate;
  set newEndDate(Date? newEndDate) => _$this._newEndDate = newEndDate;

  int? _performedByUserId;
  int? get performedByUserId => _$this._performedByUserId;
  set performedByUserId(int? performedByUserId) =>
      _$this._performedByUserId = performedByUserId;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  MembershipHistoryBuilder() {
    MembershipHistory._defaults(this);
  }

  MembershipHistoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _membershipId = $v.membershipId;
      _action = $v.action;
      _oldEndDate = $v.oldEndDate;
      _newEndDate = $v.newEndDate;
      _performedByUserId = $v.performedByUserId;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipHistory other) {
    _$v = other as _$MembershipHistory;
  }

  @override
  void update(void Function(MembershipHistoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipHistory build() => _build();

  _$MembershipHistory _build() {
    final _$result = _$v ??
        _$MembershipHistory._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'MembershipHistory', 'id'),
          membershipId: BuiltValueNullFieldError.checkNotNull(
              membershipId, r'MembershipHistory', 'membershipId'),
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'MembershipHistory', 'action'),
          oldEndDate: oldEndDate,
          newEndDate: newEndDate,
          performedByUserId: performedByUserId,
          timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp, r'MembershipHistory', 'timestamp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
