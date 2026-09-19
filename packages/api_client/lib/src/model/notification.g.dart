// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

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
