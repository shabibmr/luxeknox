// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_action.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PermissionAction _$create = const PermissionAction._('create');
const PermissionAction _$read = const PermissionAction._('read');
const PermissionAction _$update = const PermissionAction._('update');
const PermissionAction _$delete = const PermissionAction._('delete');
const PermissionAction _$approve = const PermissionAction._('approve');
const PermissionAction _$export_ = const PermissionAction._('export_');
const PermissionAction _$broadcast = const PermissionAction._('broadcast');

PermissionAction _$valueOf(String name) {
  switch (name) {
    case 'create':
      return _$create;
    case 'read':
      return _$read;
    case 'update':
      return _$update;
    case 'delete':
      return _$delete;
    case 'approve':
      return _$approve;
    case 'export_':
      return _$export_;
    case 'broadcast':
      return _$broadcast;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PermissionAction> _$values =
    BuiltSet<PermissionAction>(const <PermissionAction>[
  _$create,
  _$read,
  _$update,
  _$delete,
  _$approve,
  _$export_,
  _$broadcast,
]);

class _$PermissionActionMeta {
  const _$PermissionActionMeta();
  PermissionAction get create => _$create;
  PermissionAction get read => _$read;
  PermissionAction get update => _$update;
  PermissionAction get delete => _$delete;
  PermissionAction get approve => _$approve;
  PermissionAction get export_ => _$export_;
  PermissionAction get broadcast => _$broadcast;
  PermissionAction valueOf(String name) => _$valueOf(name);
  BuiltSet<PermissionAction> get values => _$values;
}

abstract class _$PermissionActionMixin {
  // ignore: non_constant_identifier_names
  _$PermissionActionMeta get PermissionAction => const _$PermissionActionMeta();
}

Serializer<PermissionAction> _$permissionActionSerializer =
    _$PermissionActionSerializer();

class _$PermissionActionSerializer
    implements PrimitiveSerializer<PermissionAction> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'create': 'create',
    'read': 'read',
    'update': 'update',
    'delete': 'delete',
    'approve': 'approve',
    'export_': 'export',
    'broadcast': 'broadcast',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'create': 'create',
    'read': 'read',
    'update': 'update',
    'delete': 'delete',
    'approve': 'approve',
    'export': 'export_',
    'broadcast': 'broadcast',
  };

  @override
  final Iterable<Type> types = const <Type>[PermissionAction];
  @override
  final String wireName = 'PermissionAction';

  @override
  Object serialize(Serializers serializers, PermissionAction object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PermissionAction deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PermissionAction.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
