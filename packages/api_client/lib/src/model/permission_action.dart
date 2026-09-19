//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'permission_action.g.dart';

class PermissionAction extends EnumClass {

  @BuiltValueEnumConst(wireName: r'create')
  static const PermissionAction create = _$create;
  @BuiltValueEnumConst(wireName: r'read')
  static const PermissionAction read = _$read;
  @BuiltValueEnumConst(wireName: r'update')
  static const PermissionAction update = _$update;
  @BuiltValueEnumConst(wireName: r'delete')
  static const PermissionAction delete = _$delete;
  @BuiltValueEnumConst(wireName: r'approve')
  static const PermissionAction approve = _$approve;
  @BuiltValueEnumConst(wireName: r'export')
  static const PermissionAction export_ = _$export_;
  @BuiltValueEnumConst(wireName: r'broadcast')
  static const PermissionAction broadcast = _$broadcast;

  static Serializer<PermissionAction> get serializer => _$permissionActionSerializer;

  const PermissionAction._(String name): super(name);

  static BuiltSet<PermissionAction> get values => _$values;
  static PermissionAction valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PermissionActionMixin = Object with _$PermissionActionMixin;

