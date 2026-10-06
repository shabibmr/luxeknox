import { describe, expect, it } from 'vitest';
import { buildPushData } from './notification-payload';

describe('buildPushData', () => {
  it('maps booking_confirmed schedule_id to entity_type/entity_id strings', () => {
    expect(
      buildPushData({
        typeCode: 'booking_confirmed',
        dataPayload: { schedule_id: 12 },
        notificationId: 9,
      }),
    ).toEqual({
      notification_id: '9',
      type_code: 'booking_confirmed',
      entity_type: 'schedule',
      entity_id: '12',
      schedule_id: '12',
    });
  });

  it('maps announcement with schedule_id to schedule entity', () => {
    expect(
      buildPushData({
        typeCode: 'announcement',
        dataPayload: { schedule_id: 44, participant_id: 3 },
        notificationId: 2,
      }),
    ).toMatchObject({
      notification_id: '2',
      type_code: 'announcement',
      entity_type: 'schedule',
      entity_id: '44',
      schedule_id: '44',
      participant_id: '3',
    });
  });

  it('maps membership_expiry and freeze_pending to membership', () => {
    expect(
      buildPushData({
        typeCode: 'membership_expiry',
        dataPayload: { membership_id: 7 },
        notificationId: 1,
      }),
    ).toMatchObject({
      entity_type: 'membership',
      entity_id: '7',
      type_code: 'membership_expiry',
    });

    expect(
      buildPushData({
        typeCode: 'freeze_pending',
        dataPayload: { membership_id: 8 },
        notificationId: 1,
      }),
    ).toMatchObject({
      entity_type: 'membership',
      entity_id: '8',
    });
  });

  it('maps payment_due to payment', () => {
    expect(
      buildPushData({
        typeCode: 'payment_due',
        dataPayload: { payment_id: 55 },
        notificationId: 3,
      }),
    ).toMatchObject({
      entity_type: 'payment',
      entity_id: '55',
      payment_id: '55',
    });
  });

  it('maps broadcast to notification entity using notification id', () => {
    expect(
      buildPushData({
        typeCode: 'broadcast',
        dataPayload: { hello: 'world' },
        notificationId: 99,
      }),
    ).toMatchObject({
      notification_id: '99',
      type_code: 'broadcast',
      entity_type: 'notification',
      entity_id: '99',
      hello: 'world',
    });
  });

  it('attaches entity keys for trainer_assigned', () => {
    const data = buildPushData({
      typeCode: 'trainer_assigned',
      dataPayload: { member_id: 1, trainer_id: 2 },
      notificationId: 5,
    });
    expect(data).toEqual({
      notification_id: '5',
      type_code: 'trainer_assigned',
      member_id: '1',
      trainer_id: '2',
      entity_type: 'trainer',
      entity_id: '2',
    });
  });

  it('keeps an explicit entity_type from the payload', () => {
    expect(
      buildPushData({
        typeCode: 'announcement',
        dataPayload: { entity_type: 'custom', entity_id: 'x', schedule_id: 1 },
        notificationId: 1,
      }),
    ).toMatchObject({
      entity_type: 'custom',
      entity_id: 'x',
    });
  });
});
