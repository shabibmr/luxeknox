import 'package:equatable/equatable.dart';

/// A system-generated admin alert, backed by the append-only audit log.
class SystemAlert extends Equatable {
  const SystemAlert({
    required this.id,
    required this.actorUserId,
    required this.action,
    required this.entityName,
    this.entityId,
    this.ipAddress,
    required this.timestamp,
  });

  final int id;
  final int actorUserId;
  final String action;
  final String entityName;
  final int? entityId;
  final String? ipAddress;
  final DateTime timestamp;

  /// Short human-readable summary, e.g. "update on member #42".
  String get summary =>
      '$action on $entityName${entityId != null ? ' #$entityId' : ''}';

  @override
  List<Object?> get props => [
    id,
    actorUserId,
    action,
    entityName,
    entityId,
    ipAddress,
    timestamp,
  ];
}
