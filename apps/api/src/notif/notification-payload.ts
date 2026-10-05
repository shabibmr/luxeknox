export type BuildPushDataInput = {
  typeCode?: string | null;
  dataPayload?: Record<string, unknown> | null;
  notificationId: number;
};

const SCHEDULE_TYPE_CODES = new Set([
  'booking_confirmed',
  'booking_cancelled',
  'session_reminder',
  'session_waitlist_promoted',
]);

const MEMBERSHIP_TYPE_CODES = new Set(['membership_expiry', 'freeze_pending']);

function stringifyPayload(
  dataPayload?: Record<string, unknown> | null,
): Record<string, string> {
  const out: Record<string, string> = {};
  if (!dataPayload) return out;
  for (const [key, value] of Object.entries(dataPayload)) {
    if (value == null) continue;
    out[key] = typeof value === 'string' ? value : String(value);
  }
  return out;
}

/**
 * Builds FCM data keys Flutter can deep-link from.
 * Always includes notification_id and type_code as strings when known.
 */
export function buildPushData(input: BuildPushDataInput): Record<string, string> {
  const data = stringifyPayload(input.dataPayload);
  data.notification_id = String(input.notificationId);

  const typeCode = input.typeCode ?? data.type_code ?? null;
  if (typeCode) {
    data.type_code = typeCode;
  }

  if (data.entity_type) {
    return data;
  }

  if (!typeCode) {
    return data;
  }

  if (SCHEDULE_TYPE_CODES.has(typeCode) || (typeCode === 'announcement' && data.schedule_id)) {
    if (data.schedule_id) {
      data.entity_type = 'schedule';
      data.entity_id = data.schedule_id;
    }
    return data;
  }

  if (MEMBERSHIP_TYPE_CODES.has(typeCode) && data.membership_id) {
    data.entity_type = 'membership';
    data.entity_id = data.membership_id;
    return data;
  }

  if (typeCode === 'payment_due' && data.payment_id) {
    data.entity_type = 'payment';
    data.entity_id = data.payment_id;
    return data;
  }

  if (typeCode === 'broadcast') {
    data.entity_type = 'notification';
    data.entity_id = String(input.notificationId);
    return data;
  }

  // trainer_assigned and unknown codes: leave entity_* unset
  return data;
}
