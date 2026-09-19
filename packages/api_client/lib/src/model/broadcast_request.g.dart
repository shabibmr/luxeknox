// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BroadcastRequestAudienceEnum _$broadcastRequestAudienceEnum_allMembers =
    const BroadcastRequestAudienceEnum._('allMembers');
const BroadcastRequestAudienceEnum
    _$broadcastRequestAudienceEnum_assignedClients =
    const BroadcastRequestAudienceEnum._('assignedClients');
const BroadcastRequestAudienceEnum _$broadcastRequestAudienceEnum_role =
    const BroadcastRequestAudienceEnum._('role');

BroadcastRequestAudienceEnum _$broadcastRequestAudienceEnumValueOf(
    String name) {
  switch (name) {
    case 'allMembers':
      return _$broadcastRequestAudienceEnum_allMembers;
    case 'assignedClients':
      return _$broadcastRequestAudienceEnum_assignedClients;
    case 'role':
      return _$broadcastRequestAudienceEnum_role;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BroadcastRequestAudienceEnum>
    _$broadcastRequestAudienceEnumValues =
    BuiltSet<BroadcastRequestAudienceEnum>(const <BroadcastRequestAudienceEnum>[
  _$broadcastRequestAudienceEnum_allMembers,
  _$broadcastRequestAudienceEnum_assignedClients,
  _$broadcastRequestAudienceEnum_role,
]);

Serializer<BroadcastRequestAudienceEnum>
    _$broadcastRequestAudienceEnumSerializer =
    _$BroadcastRequestAudienceEnumSerializer();

class _$BroadcastRequestAudienceEnumSerializer
    implements PrimitiveSerializer<BroadcastRequestAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'allMembers': 'all_members',
    'assignedClients': 'assigned_clients',
    'role': 'role',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'all_members': 'allMembers',
    'assigned_clients': 'assignedClients',
    'role': 'role',
  };

  @override
  final Iterable<Type> types = const <Type>[BroadcastRequestAudienceEnum];
  @override
  final String wireName = 'BroadcastRequestAudienceEnum';

  @override
  Object serialize(Serializers serializers, BroadcastRequestAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BroadcastRequestAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BroadcastRequestAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BroadcastRequest extends BroadcastRequest {
  @override
  final int? notificationTypeId;
  @override
  final String title;
  @override
  final String message;
  @override
  final BuiltMap<String, JsonObject?>? dataPayload;
  @override
  final BroadcastRequestAudienceEnum? audience;
  @override
  final int? roleId;

  factory _$BroadcastRequest(
          [void Function(BroadcastRequestBuilder)? updates]) =>
      (BroadcastRequestBuilder()..update(updates))._build();

  _$BroadcastRequest._(
      {this.notificationTypeId,
      required this.title,
      required this.message,
      this.dataPayload,
      this.audience,
      this.roleId})
      : super._();
  @override
  BroadcastRequest rebuild(void Function(BroadcastRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BroadcastRequestBuilder toBuilder() =>
      BroadcastRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BroadcastRequest &&
        notificationTypeId == other.notificationTypeId &&
        title == other.title &&
        message == other.message &&
        dataPayload == other.dataPayload &&
        audience == other.audience &&
        roleId == other.roleId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, notificationTypeId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, dataPayload.hashCode);
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, roleId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BroadcastRequest')
          ..add('notificationTypeId', notificationTypeId)
          ..add('title', title)
          ..add('message', message)
          ..add('dataPayload', dataPayload)
          ..add('audience', audience)
          ..add('roleId', roleId))
        .toString();
  }
}

class BroadcastRequestBuilder
    implements Builder<BroadcastRequest, BroadcastRequestBuilder> {
  _$BroadcastRequest? _$v;

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

  BroadcastRequestAudienceEnum? _audience;
  BroadcastRequestAudienceEnum? get audience => _$this._audience;
  set audience(BroadcastRequestAudienceEnum? audience) =>
      _$this._audience = audience;

  int? _roleId;
  int? get roleId => _$this._roleId;
  set roleId(int? roleId) => _$this._roleId = roleId;

  BroadcastRequestBuilder() {
    BroadcastRequest._defaults(this);
  }

  BroadcastRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _notificationTypeId = $v.notificationTypeId;
      _title = $v.title;
      _message = $v.message;
      _dataPayload = $v.dataPayload?.toBuilder();
      _audience = $v.audience;
      _roleId = $v.roleId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BroadcastRequest other) {
    _$v = other as _$BroadcastRequest;
  }

  @override
  void update(void Function(BroadcastRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BroadcastRequest build() => _build();

  _$BroadcastRequest _build() {
    _$BroadcastRequest _$result;
    try {
      _$result = _$v ??
          _$BroadcastRequest._(
            notificationTypeId: notificationTypeId,
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'BroadcastRequest', 'title'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'BroadcastRequest', 'message'),
            dataPayload: _dataPayload?.build(),
            audience: audience,
            roleId: roleId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'dataPayload';
        _dataPayload?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BroadcastRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
