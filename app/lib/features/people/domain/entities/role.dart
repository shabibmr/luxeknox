import 'package:equatable/equatable.dart';

/// An assignable staff role (RBAC), with its granted permission slugs.
class Role extends Equatable {
  const Role({
    required this.id,
    required this.name,
    this.description,
    required this.isSystemRole,
    this.permissionSlugs = const [],
  });

  final int id;
  final String name;
  final String? description;
  final bool isSystemRole;
  final List<String> permissionSlugs;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    isSystemRole,
    permissionSlugs,
  ];
}
