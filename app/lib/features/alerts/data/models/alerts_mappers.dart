import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/system_alert.dart';

SystemAlert systemAlertFromApi(api.AuditLog log) {
  return SystemAlert(
    id: log.id,
    actorUserId: log.actorUserId,
    action: log.action,
    entityName: log.entityName,
    entityId: log.entityId,
    ipAddress: log.ipAddress,
    timestamp: log.timestamp,
  );
}
