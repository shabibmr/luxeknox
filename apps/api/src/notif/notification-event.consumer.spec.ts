import { beforeEach, describe, expect, it, vi } from 'vitest';
import { NotificationEventConsumer } from './notification-event.consumer';
import type { DomainEventBus } from '../platform/events/domain-events';

describe('NotificationEventConsumer (NOT-009)', () => {
  let consumer: NotificationEventConsumer;
  let eventBus: any;
  let notificationService: any;
  let idempotencyRepo: any;
  let memberRepo: any;
  let scheduleRepo: any;
  let membershipRepo: any;

  beforeEach(() => {
    eventBus = {
      on: vi.fn(),
    };
    notificationService = {
      dispatch: vi.fn().mockResolvedValue(1),
    };
    idempotencyRepo = {
      findActive: vi.fn().mockResolvedValue(null),
      insert: vi.fn().mockResolvedValue(undefined),
    };
    memberRepo = {
      findById: vi.fn().mockResolvedValue({ id: 10, user_id: 100 }),
    };
    scheduleRepo = {
      findById: vi.fn().mockResolvedValue({
        id: 5,
        title: 'Morning Yoga',
        start_time: new Date('2026-09-22T08:00:00Z'),
      }),
      findParticipantById: vi.fn().mockResolvedValue({ id: 20, member_id: 10 }),
    };
    membershipRepo = {
      findById: vi.fn().mockResolvedValue({ id: 7, member_id: 10 }),
      findFreezeById: vi.fn().mockResolvedValue({
        id: 3,
        membership_id: 7,
        start_date: '2026-10-10',
        end_date: '2026-10-20',
      }),
    };

    consumer = new NotificationEventConsumer(
      eventBus as any,
      notificationService as any,
      idempotencyRepo as any,
      memberRepo as any,
      scheduleRepo as any,
      membershipRepo as any,
    );
  });

  it('registers handlers on module init', () => {
    consumer.onModuleInit();
    expect(eventBus.on).toHaveBeenCalledWith('schedule.booked', expect.any(Function));
    expect(eventBus.on).toHaveBeenCalledWith('schedule.waitlisted', expect.any(Function));
    expect(eventBus.on).toHaveBeenCalledWith('schedule.booking_cancelled', expect.any(Function));
    expect(eventBus.on).toHaveBeenCalledWith('schedule.waitlist_promoted', expect.any(Function));
    expect(eventBus.on).toHaveBeenCalledWith('member.trainer_assigned', expect.any(Function));
  });

  it('handles schedule.booked idempotently and dispatches booking confirmed notification', async () => {
    const handler = vi.fn();
    const event = {
      eventName: 'schedule.booked',
      occurredAt: new Date(),
      payload: { scheduleId: 5, memberId: 10, participantId: 20 },
    };

    await consumer.handleIdempotentEvent(event, 'schedule.booked', async (payload) => {
      await (consumer as any).handleScheduleBooked(payload);
    });

    expect(idempotencyRepo.findActive).toHaveBeenCalled();
    expect(notificationService.dispatch).toHaveBeenCalledWith(
      expect.objectContaining({
        recipientUserIds: [100],
        typeCode: 'booking_confirmed',
        title: 'Booking Confirmed',
      }),
    );
    expect(idempotencyRepo.insert).toHaveBeenCalledWith(
      expect.objectContaining({
        method: 'EVENT',
        path: 'schedule.booked',
      }),
    );
  });

  it('skips processing if event is duplicate (already in idempotency store)', async () => {
    idempotencyRepo.findActive.mockResolvedValue({ id: 1 });

    const handler = vi.fn();
    const event = {
      eventName: 'schedule.booked',
      occurredAt: new Date(),
      payload: { scheduleId: 5, memberId: 10, participantId: 20 },
    };

    await consumer.handleIdempotentEvent(event, 'schedule.booked', handler);

    expect(handler).not.toHaveBeenCalled();
    expect(notificationService.dispatch).not.toHaveBeenCalled();
  });

  it('handles waitlist promotion and dispatches notification', async () => {
    const event = {
      eventName: 'schedule.waitlist_promoted',
      occurredAt: new Date(),
      payload: { scheduleId: 5, participantId: 20 },
    };

    await consumer.handleIdempotentEvent(event, 'schedule.waitlist_promoted', async (payload) => {
      await (consumer as any).handleScheduleWaitlistPromoted(payload);
    });

    expect(notificationService.dispatch).toHaveBeenCalledWith(
      expect.objectContaining({
        recipientUserIds: [100],
        typeCode: 'session_waitlist_promoted',
        title: 'Waitlist Promoted!',
      }),
    );
  });

  it('handles trainer assigned and dispatches notification', async () => {
    const event = {
      eventName: 'member.trainer_assigned',
      occurredAt: new Date(),
      payload: { memberId: 10, userId: 100, trainerId: 2 },
    };

    await consumer.handleIdempotentEvent(event, 'member.trainer_assigned', async (payload) => {
      await (consumer as any).handleTrainerAssigned(payload);
    });

    expect(notificationService.dispatch).toHaveBeenCalledWith(
      expect.objectContaining({
        recipientUserIds: [100],
        typeCode: 'trainer_assigned',
        title: 'Personal Trainer Assigned',
      }),
    );
  });

  it('handles membership.freeze_pending and dispatches freeze_pending with membership_id', async () => {
    const event = {
      eventName: 'membership.freeze_pending',
      occurredAt: new Date(),
      payload: { membershipId: 7, freezeId: 3 },
    };

    await consumer.handleIdempotentEvent(event, 'membership.freeze_pending', async (payload) => {
      await (consumer as any).handleMembershipFreezePending(payload);
    });

    expect(membershipRepo.findById).toHaveBeenCalledWith(7);
    expect(memberRepo.findById).toHaveBeenCalledWith(10);
    expect(notificationService.dispatch).toHaveBeenCalledTimes(1);
    expect(notificationService.dispatch).toHaveBeenCalledWith(
      expect.objectContaining({
        recipientUserIds: [100],
        typeCode: 'freeze_pending',
        dataPayload: expect.objectContaining({
          membership_id: 7,
          freeze_id: 3,
        }),
      }),
    );
  });

  it('skips freeze_pending dispatch when membership is missing', async () => {
    membershipRepo.findById.mockResolvedValue(null);

    await (consumer as any).handleMembershipFreezePending({
      membershipId: 99,
      freezeId: 3,
    });

    expect(notificationService.dispatch).not.toHaveBeenCalled();
  });
});
