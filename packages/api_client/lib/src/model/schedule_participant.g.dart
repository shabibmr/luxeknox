// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_participant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ScheduleParticipantBookingStatusEnum
    _$scheduleParticipantBookingStatusEnum_booked =
    const ScheduleParticipantBookingStatusEnum._('booked');
const ScheduleParticipantBookingStatusEnum
    _$scheduleParticipantBookingStatusEnum_waitlisted =
    const ScheduleParticipantBookingStatusEnum._('waitlisted');
const ScheduleParticipantBookingStatusEnum
    _$scheduleParticipantBookingStatusEnum_cancelled =
    const ScheduleParticipantBookingStatusEnum._('cancelled');

ScheduleParticipantBookingStatusEnum
    _$scheduleParticipantBookingStatusEnumValueOf(String name) {
  switch (name) {
    case 'booked':
      return _$scheduleParticipantBookingStatusEnum_booked;
    case 'waitlisted':
      return _$scheduleParticipantBookingStatusEnum_waitlisted;
    case 'cancelled':
      return _$scheduleParticipantBookingStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ScheduleParticipantBookingStatusEnum>
    _$scheduleParticipantBookingStatusEnumValues = BuiltSet<
        ScheduleParticipantBookingStatusEnum>(const <ScheduleParticipantBookingStatusEnum>[
  _$scheduleParticipantBookingStatusEnum_booked,
  _$scheduleParticipantBookingStatusEnum_waitlisted,
  _$scheduleParticipantBookingStatusEnum_cancelled,
]);

Serializer<ScheduleParticipantBookingStatusEnum>
    _$scheduleParticipantBookingStatusEnumSerializer =
    _$ScheduleParticipantBookingStatusEnumSerializer();

class _$ScheduleParticipantBookingStatusEnumSerializer
    implements PrimitiveSerializer<ScheduleParticipantBookingStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'booked': 'booked',
    'waitlisted': 'waitlisted',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'booked': 'booked',
    'waitlisted': 'waitlisted',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ScheduleParticipantBookingStatusEnum
  ];
  @override
  final String wireName = 'ScheduleParticipantBookingStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ScheduleParticipantBookingStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ScheduleParticipantBookingStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ScheduleParticipantBookingStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ScheduleParticipant extends ScheduleParticipant {
  @override
  final int id;
  @override
  final int scheduleId;
  @override
  final int memberId;
  @override
  final ScheduleParticipantBookingStatusEnum bookingStatus;
  @override
  final bool? attended;
  @override
  final DateTime? bookedAt;
  @override
  final DateTime? markedAt;

  factory _$ScheduleParticipant(
          [void Function(ScheduleParticipantBuilder)? updates]) =>
      (ScheduleParticipantBuilder()..update(updates))._build();

  _$ScheduleParticipant._(
      {required this.id,
      required this.scheduleId,
      required this.memberId,
      required this.bookingStatus,
      this.attended,
      this.bookedAt,
      this.markedAt})
      : super._();
  @override
  ScheduleParticipant rebuild(
          void Function(ScheduleParticipantBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduleParticipantBuilder toBuilder() =>
      ScheduleParticipantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScheduleParticipant &&
        id == other.id &&
        scheduleId == other.scheduleId &&
        memberId == other.memberId &&
        bookingStatus == other.bookingStatus &&
        attended == other.attended &&
        bookedAt == other.bookedAt &&
        markedAt == other.markedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, scheduleId.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, bookingStatus.hashCode);
    _$hash = $jc(_$hash, attended.hashCode);
    _$hash = $jc(_$hash, bookedAt.hashCode);
    _$hash = $jc(_$hash, markedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScheduleParticipant')
          ..add('id', id)
          ..add('scheduleId', scheduleId)
          ..add('memberId', memberId)
          ..add('bookingStatus', bookingStatus)
          ..add('attended', attended)
          ..add('bookedAt', bookedAt)
          ..add('markedAt', markedAt))
        .toString();
  }
}

class ScheduleParticipantBuilder
    implements Builder<ScheduleParticipant, ScheduleParticipantBuilder> {
  _$ScheduleParticipant? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _scheduleId;
  int? get scheduleId => _$this._scheduleId;
  set scheduleId(int? scheduleId) => _$this._scheduleId = scheduleId;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  ScheduleParticipantBookingStatusEnum? _bookingStatus;
  ScheduleParticipantBookingStatusEnum? get bookingStatus =>
      _$this._bookingStatus;
  set bookingStatus(ScheduleParticipantBookingStatusEnum? bookingStatus) =>
      _$this._bookingStatus = bookingStatus;

  bool? _attended;
  bool? get attended => _$this._attended;
  set attended(bool? attended) => _$this._attended = attended;

  DateTime? _bookedAt;
  DateTime? get bookedAt => _$this._bookedAt;
  set bookedAt(DateTime? bookedAt) => _$this._bookedAt = bookedAt;

  DateTime? _markedAt;
  DateTime? get markedAt => _$this._markedAt;
  set markedAt(DateTime? markedAt) => _$this._markedAt = markedAt;

  ScheduleParticipantBuilder() {
    ScheduleParticipant._defaults(this);
  }

  ScheduleParticipantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _scheduleId = $v.scheduleId;
      _memberId = $v.memberId;
      _bookingStatus = $v.bookingStatus;
      _attended = $v.attended;
      _bookedAt = $v.bookedAt;
      _markedAt = $v.markedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScheduleParticipant other) {
    _$v = other as _$ScheduleParticipant;
  }

  @override
  void update(void Function(ScheduleParticipantBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScheduleParticipant build() => _build();

  _$ScheduleParticipant _build() {
    final _$result = _$v ??
        _$ScheduleParticipant._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ScheduleParticipant', 'id'),
          scheduleId: BuiltValueNullFieldError.checkNotNull(
              scheduleId, r'ScheduleParticipant', 'scheduleId'),
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'ScheduleParticipant', 'memberId'),
          bookingStatus: BuiltValueNullFieldError.checkNotNull(
              bookingStatus, r'ScheduleParticipant', 'bookingStatus'),
          attended: attended,
          bookedAt: bookedAt,
          markedAt: markedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
