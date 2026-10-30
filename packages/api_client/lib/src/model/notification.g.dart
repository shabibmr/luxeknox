// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NotificationPriorityEnum _$notificationPriorityEnum_normal =
    const NotificationPriorityEnum._('normal');
const NotificationPriorityEnum _$notificationPriorityEnum_high =
    const NotificationPriorityEnum._('high');

NotificationPriorityEnum _$notificationPriorityEnumValueOf(String name) {
  switch (name) {
    case 'normal':
      return _$notificationPriorityEnum_normal;
    case 'high':
      return _$notificationPriorityEnum_high;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NotificationPriorityEnum> _$notificationPriorityEnumValues =
    BuiltSet<NotificationPriorityEnum>(const <NotificationPriorityEnum>[
  _$notificationPriorityEnum_normal,
  _$notificationPriorityEnum_high,
]);

const NotificationTypeCodeEnum _$notificationTypeCodeEnum_membershipExpiry =
    const NotificationTypeCodeEnum._('membershipExpiry');
const NotificationTypeCodeEnum _$notificationTypeCodeEnum_sessionReminder =
    const NotificationTypeCodeEnum._('sessionReminder');
const NotificationTypeCodeEnum _$notificationTypeCodeEnum_paymentDue =
    const NotificationTypeCodeEnum._('paymentDue');
const NotificationTypeCodeEnum _$notificationTypeCodeEnum_announcement =
    const NotificationTypeCodeEnum._('announcement');
const NotificationTypeCodeEnum _$notificationTypeCodeEnum_freezePending =
    const NotificationTypeCodeEnum._('freezePending');
const NotificationTypeCodeEnum _$notificationTypeCodeEnum_bookingConfirmed =
    const NotificationTypeCodeEnum._('bookingConfirmed');
const NotificationTypeCodeEnum _$notificationTypeCodeEnum_bookingCancelled =
    const NotificationTypeCodeEnum._('bookingCancelled');
const NotificationTypeCodeEnum
    _$notificationTypeCodeEnum_sessionWaitlistPromoted =
    const NotificationTypeCodeEnum._('sessionWaitlistPromoted');
const NotificationTypeCodeEnum _$notificationTypeCodeEnum_trainerAssigned =
    const NotificationTypeCodeEnum._('trainerAssigned');
const NotificationTypeCodeEnum _$notificationTypeCodeEnum_broadcast =
    const NotificationTypeCodeEnum._('broadcast');
const NotificationTypeCodeEnum _$notificationTypeCodeEnum_workoutSafetyAlert =
    const NotificationTypeCodeEnum._('workoutSafetyAlert');

NotificationTypeCodeEnum _$notificationTypeCodeEnumValueOf(String name) {
  switch (name) {
    case 'membershipExpiry':
      return _$notificationTypeCodeEnum_membershipExpiry;
    case 'sessionReminder':
      return _$notificationTypeCodeEnum_sessionReminder;
    case 'paymentDue':
      return _$notificationTypeCodeEnum_paymentDue;
    case 'announcement':
      return _$notificationTypeCodeEnum_announcement;
    case 'freezePending':
      return _$notificationTypeCodeEnum_freezePending;
    case 'bookingConfirmed':
      return _$notificationTypeCodeEnum_bookingConfirmed;
    case 'bookingCancelled':
      return _$notificationTypeCodeEnum_bookingCancelled;
    case 'sessionWaitlistPromoted':
      return _$notificationTypeCodeEnum_sessionWaitlistPromoted;
    case 'trainerAssigned':
      return _$notificationTypeCodeEnum_trainerAssigned;
    case 'broadcast':
      return _$notificationTypeCodeEnum_broadcast;
    case 'workoutSafetyAlert':
      return _$notificationTypeCodeEnum_workoutSafetyAlert;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NotificationTypeCodeEnum> _$notificationTypeCodeEnumValues =
    BuiltSet<NotificationTypeCodeEnum>(const <NotificationTypeCodeEnum>[
  _$notificationTypeCodeEnum_membershipExpiry,
  _$notificationTypeCodeEnum_sessionReminder,
  _$notificationTypeCodeEnum_paymentDue,
  _$notificationTypeCodeEnum_announcement,
  _$notificationTypeCodeEnum_freezePending,
  _$notificationTypeCodeEnum_bookingConfirmed,
  _$notificationTypeCodeEnum_bookingCancelled,
  _$notificationTypeCodeEnum_sessionWaitlistPromoted,
  _$notificationTypeCodeEnum_trainerAssigned,
  _$notificationTypeCodeEnum_broadcast,
  _$notificationTypeCodeEnum_workoutSafetyAlert,
]);

Serializer<NotificationPriorityEnum> _$notificationPriorityEnumSerializer =
    _$NotificationPriorityEnumSerializer();
Serializer<NotificationTypeCodeEnum> _$notificationTypeCodeEnumSerializer =
    _$NotificationTypeCodeEnumSerializer();

class _$NotificationPriorityEnumSerializer
    implements PrimitiveSerializer<NotificationPriorityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'normal': 'normal',
    'high': 'high',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'normal': 'normal',
    'high': 'high',
  };

  @override
  final Iterable<Type> types = const <Type>[NotificationPriorityEnum];
  @override
  final String wireName = 'NotificationPriorityEnum';

  @override
  Object serialize(Serializers serializers, NotificationPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NotificationPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NotificationPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$NotificationTypeCodeEnumSerializer
    implements PrimitiveSerializer<NotificationTypeCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'membershipExpiry': 'membership_expiry',
    'sessionReminder': 'session_reminder',
    'paymentDue': 'payment_due',
    'announcement': 'announcement',
    'freezePending': 'freeze_pending',
    'bookingConfirmed': 'booking_confirmed',
    'bookingCancelled': 'booking_cancelled',
    'sessionWaitlistPromoted': 'session_waitlist_promoted',
    'trainerAssigned': 'trainer_assigned',
    'broadcast': 'broadcast',
    'workoutSafetyAlert': 'workout_safety_alert',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'membership_expiry': 'membershipExpiry',
    'session_reminder': 'sessionReminder',
    'payment_due': 'paymentDue',
    'announcement': 'announcement',
    'freeze_pending': 'freezePending',
    'booking_confirmed': 'bookingConfirmed',
    'booking_cancelled': 'bookingCancelled',
    'session_waitlist_promoted': 'sessionWaitlistPromoted',
    'trainer_assigned': 'trainerAssigned',
    'broadcast': 'broadcast',
    'workout_safety_alert': 'workoutSafetyAlert',
  };

  @override
  final Iterable<Type> types = const <Type>[NotificationTypeCodeEnum];
  @override
  final String wireName = 'NotificationTypeCodeEnum';

  @override
  Object serialize(Serializers serializers, NotificationTypeCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NotificationTypeCodeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NotificationTypeCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$Notification extends Notification {
  @override
  final int id;
  @override
  final int? notificationTypeId;
  @override
  final String title;
  @override
  final String message;
  @override
  final BuiltMap<String, JsonObject?>? dataPayload;
  @override
  final int? senderUserId;
  @override
  final DateTime createdAt;
  @override
  final NotificationPriorityEnum? priority;
  @override
  final NotificationTypeCodeEnum? typeCode;
  @override
  final bool? isRead;
  @override
  final DateTime? readAt;

  factory _$Notification([void Function(NotificationBuilder)? updates]) =>
      (NotificationBuilder()..update(updates))._build();

  _$Notification._(
      {required this.id,
      this.notificationTypeId,
      required this.title,
      required this.message,
      this.dataPayload,
      this.senderUserId,
      required this.createdAt,
      this.priority,
      this.typeCode,
      this.isRead,
      this.readAt})
      : super._();
  @override
  Notification rebuild(void Function(NotificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationBuilder toBuilder() => NotificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Notification &&
        id == other.id &&
        notificationTypeId == other.notificationTypeId &&
        title == other.title &&
        message == other.message &&
        dataPayload == other.dataPayload &&
        senderUserId == other.senderUserId &&
        createdAt == other.createdAt &&
        priority == other.priority &&
        typeCode == other.typeCode &&
        isRead == other.isRead &&
        readAt == other.readAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, notificationTypeId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, dataPayload.hashCode);
    _$hash = $jc(_$hash, senderUserId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, typeCode.hashCode);
    _$hash = $jc(_$hash, isRead.hashCode);
    _$hash = $jc(_$hash, readAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Notification')
          ..add('id', id)
          ..add('notificationTypeId', notificationTypeId)
          ..add('title', title)
          ..add('message', message)
          ..add('dataPayload', dataPayload)
          ..add('senderUserId', senderUserId)
          ..add('createdAt', createdAt)
          ..add('priority', priority)
          ..add('typeCode', typeCode)
          ..add('isRead', isRead)
          ..add('readAt', readAt))
        .toString();
  }
}

class NotificationBuilder
    implements Builder<Notification, NotificationBuilder> {
  _$Notification? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _notificationTypeId;
  int? get notificationTypeId => _$this._notificationTypeId;
  set notificationTypeId(int? notificationTypeId) =>
      _$this._notificationTypeId = notificationTypeId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  MapBuilder<String, JsonObject?>? _dataPayload;
  MapBuilder<String, JsonObject?> get dataPayload =>
      _$this._dataPayload ??= MapBuilder<String, JsonObject?>();
  set dataPayload(MapBuilder<String, JsonObject?>? dataPayload) =>
      _$this._dataPayload = dataPayload;

  int? _senderUserId;
  int? get senderUserId => _$this._senderUserId;
  set senderUserId(int? senderUserId) => _$this._senderUserId = senderUserId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  NotificationPriorityEnum? _priority;
  NotificationPriorityEnum? get priority => _$this._priority;
  set priority(NotificationPriorityEnum? priority) =>
      _$this._priority = priority;

  NotificationTypeCodeEnum? _typeCode;
  NotificationTypeCodeEnum? get typeCode => _$this._typeCode;
  set typeCode(NotificationTypeCodeEnum? typeCode) =>
      _$this._typeCode = typeCode;

  bool? _isRead;
  bool? get isRead => _$this._isRead;
  set isRead(bool? isRead) => _$this._isRead = isRead;

  DateTime? _readAt;
  DateTime? get readAt => _$this._readAt;
  set readAt(DateTime? readAt) => _$this._readAt = readAt;

  NotificationBuilder() {
    Notification._defaults(this);
  }

  NotificationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _notificationTypeId = $v.notificationTypeId;
      _title = $v.title;
      _message = $v.message;
      _dataPayload = $v.dataPayload?.toBuilder();
      _senderUserId = $v.senderUserId;
      _createdAt = $v.createdAt;
      _priority = $v.priority;
      _typeCode = $v.typeCode;
      _isRead = $v.isRead;
      _readAt = $v.readAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Notification other) {
    _$v = other as _$Notification;
  }

  @override
  void update(void Function(NotificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Notification build() => _build();

  _$Notification _build() {
    _$Notification _$result;
    try {
      _$result = _$v ??
          _$Notification._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'Notification', 'id'),
            notificationTypeId: notificationTypeId,
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'Notification', 'title'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'Notification', 'message'),
            dataPayload: _dataPayload?.build(),
            senderUserId: senderUserId,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'Notification', 'createdAt'),
            priority: priority,
            typeCode: typeCode,
            isRead: isRead,
            readAt: readAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'dataPayload';
        _dataPayload?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Notification', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
