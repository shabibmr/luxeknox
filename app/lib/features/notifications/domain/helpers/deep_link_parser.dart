import '../entities/deep_link_target.dart';

/// Parses a notification `data_payload` for deep-link entity type/id.
///
/// Accepts flexible key names: `entity_type` / `entityType` / `type` and
/// `entity_id` / `entityId` / `id`.
DeepLinkTarget? parseNotificationDeepLink(Map<String, String?>? payload) {
  if (payload == null || payload.isEmpty) return null;

  final type = _firstNonEmpty(payload, const [
    'entity_type',
    'entityType',
    'type',
  ]);
  final id = _firstNonEmpty(payload, const [
    'entity_id',
    'entityId',
    'id',
  ]);

  if (type == null || id == null) return null;
  return DeepLinkTarget(entityType: type.toLowerCase(), entityId: id);
}

String? _firstNonEmpty(Map<String, String?> payload, List<String> keys) {
  for (final key in keys) {
    final value = payload[key]?.trim();
    if (value != null && value.isNotEmpty) return value;
  }
  // Case-insensitive fallback.
  final lower = {
    for (final e in payload.entries) e.key.toLowerCase(): e.value,
  };
  for (final key in keys) {
    final value = lower[key.toLowerCase()]?.trim();
    if (value != null && value.isNotEmpty) return value;
  }
  return null;
}
