// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditLog extends AuditLog {
  @override
  final int id;
  @override
  final int actorUserId;
  @override
  final String action;
  @override
  final String entityName;
  @override
  final int? entityId;
  @override
  final BuiltMap<String, JsonObject?>? beforeState;
  @override
  final BuiltMap<String, JsonObject?>? afterState;
  @override
  final String? ipAddress;
  @override
  final DateTime timestamp;

  factory _$AuditLog([void Function(AuditLogBuilder)? updates]) =>
      (AuditLogBuilder()..update(updates))._build();

  _$AuditLog._(
      {required this.id,
      required this.actorUserId,
      required this.action,
      required this.entityName,
      this.entityId,
      this.beforeState,
      this.afterState,
      this.ipAddress,
      required this.timestamp})
      : super._();
  @override
  AuditLog rebuild(void Function(AuditLogBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditLogBuilder toBuilder() => AuditLogBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditLog &&
        id == other.id &&
        actorUserId == other.actorUserId &&
        action == other.action &&
        entityName == other.entityName &&
        entityId == other.entityId &&
        beforeState == other.beforeState &&
        afterState == other.afterState &&
        ipAddress == other.ipAddress &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, actorUserId.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, entityName.hashCode);
    _$hash = $jc(_$hash, entityId.hashCode);
    _$hash = $jc(_$hash, beforeState.hashCode);
    _$hash = $jc(_$hash, afterState.hashCode);
    _$hash = $jc(_$hash, ipAddress.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuditLog')
          ..add('id', id)
          ..add('actorUserId', actorUserId)
          ..add('action', action)
          ..add('entityName', entityName)
          ..add('entityId', entityId)
          ..add('beforeState', beforeState)
          ..add('afterState', afterState)
          ..add('ipAddress', ipAddress)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class AuditLogBuilder implements Builder<AuditLog, AuditLogBuilder> {
  _$AuditLog? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _actorUserId;
  int? get actorUserId => _$this._actorUserId;
  set actorUserId(int? actorUserId) => _$this._actorUserId = actorUserId;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _entityName;
  String? get entityName => _$this._entityName;
  set entityName(String? entityName) => _$this._entityName = entityName;

  int? _entityId;
  int? get entityId => _$this._entityId;
  set entityId(int? entityId) => _$this._entityId = entityId;

  MapBuilder<String, JsonObject?>? _beforeState;
  MapBuilder<String, JsonObject?> get beforeState =>
      _$this._beforeState ??= MapBuilder<String, JsonObject?>();
  set beforeState(MapBuilder<String, JsonObject?>? beforeState) =>
      _$this._beforeState = beforeState;

  MapBuilder<String, JsonObject?>? _afterState;
  MapBuilder<String, JsonObject?> get afterState =>
      _$this._afterState ??= MapBuilder<String, JsonObject?>();
  set afterState(MapBuilder<String, JsonObject?>? afterState) =>
      _$this._afterState = afterState;

  String? _ipAddress;
  String? get ipAddress => _$this._ipAddress;
  set ipAddress(String? ipAddress) => _$this._ipAddress = ipAddress;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  AuditLogBuilder() {
    AuditLog._defaults(this);
  }

  AuditLogBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _actorUserId = $v.actorUserId;
      _action = $v.action;
      _entityName = $v.entityName;
      _entityId = $v.entityId;
      _beforeState = $v.beforeState?.toBuilder();
      _afterState = $v.afterState?.toBuilder();
      _ipAddress = $v.ipAddress;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuditLog other) {
    _$v = other as _$AuditLog;
  }

  @override
  void update(void Function(AuditLogBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditLog build() => _build();

  _$AuditLog _build() {
    _$AuditLog _$result;
    try {
      _$result = _$v ??
          _$AuditLog._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'AuditLog', 'id'),
            actorUserId: BuiltValueNullFieldError.checkNotNull(
                actorUserId, r'AuditLog', 'actorUserId'),
            action: BuiltValueNullFieldError.checkNotNull(
                action, r'AuditLog', 'action'),
            entityName: BuiltValueNullFieldError.checkNotNull(
                entityName, r'AuditLog', 'entityName'),
            entityId: entityId,
            beforeState: _beforeState?.build(),
            afterState: _afterState?.build(),
            ipAddress: ipAddress,
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'AuditLog', 'timestamp'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'beforeState';
        _beforeState?.build();
        _$failedField = 'afterState';
        _afterState?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AuditLog', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
