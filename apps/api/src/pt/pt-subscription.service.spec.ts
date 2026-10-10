import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import {
  BadRequestError,
  ConflictError,
} from '../platform/errors/app-error';
import { PtScheduleService } from './pt-schedule.service';
import { PtSubscriptionService } from './pt-subscription.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

const admin = {
  id: 1,
  email: 'a@x.com',
  phoneNumber: null,
  userType: 'admin' as const,
  roleId: 1,
  profileId: null,
  sessionId: 1,
};

// "Now" is Thu 2026-10-01 08:00 UTC; gym timezone is UTC for readability.
const NOW = new Date('2026-10-01T08:00:00.000Z');
const MON = '2026-10-05';

const product = {
  id: 3,
  name: 'PT Monthly 3x',
  code: 'PT3',
  duration_days: 28,
  base_price: '3000.00',
  tax_percentage: '0.00',
  is_active: true,
};

const femaleMember = { id: 42, first_name: 'Asha', last_name: 'K', gender: 'Female', user_id: 10 };
const femaleTrainer = { id: 7, first_name: 'Rina', last_name: 'S', gender: 'female', is_active: true };
const maleTrainer = { id: 8, first_name: 'Arun', last_name: 'M', gender: 'Male', is_active: true };

const monWedFri5to8 = [1, 3, 5].map((d) => ({
  trainer_id: 7,
  day_of_week: d,
  start_time: '17:00',
  end_time: '20:00',
  is_recurring: true,
  override_date: null,
  is_available: true,
}));

describe('PT subscriptions', () => {
  let subsRepo: Record<string, ReturnType<typeof vi.fn>>;
  let productRepo: Record<string, ReturnType<typeof vi.fn>>;
  let memberRepo: Record<string, ReturnType<typeof vi.fn>>;
  let trainerRepo: Record<string, ReturnType<typeof vi.fn>>;
  let availabilityRepo: Record<string, ReturnType<typeof vi.fn>>;
  let scheduleRepo: Record<string, ReturnType<typeof vi.fn>>;
  let scheduleTypeRepo: Record<string, ReturnType<typeof vi.fn>>;
  let membershipRepo: Record<string, ReturnType<typeof vi.fn>>;
  let paymentService: Record<string, ReturnType<typeof vi.fn>>;
  let settings: Record<string, ReturnType<typeof vi.fn>>;
  let scheduleService: PtScheduleService;
  let service: PtSubscriptionService;
  let stored: any;
  let changes: any[];

  beforeEach(() => {
    vi.useFakeTimers({ toFake: ['Date'] });
    vi.setSystemTime(NOW);
    stored = null;
    changes = [];

    subsRepo = {
      findById: vi.fn().mockImplementation(async () => stored),
      insertSubscription: vi.fn().mockImplementation(async (v) => {
        stored = { id: 900, ...v };
        return 900;
      }),
      updateSubscription: vi.fn().mockImplementation(async (_id, v) => {
        stored = { ...stored, ...v };
      }),
      findOpenOverlappingForMember: vi.fn().mockResolvedValue([]),
      hasActiveForMember: vi.fn().mockResolvedValue(false),
      lockMember: vi.fn().mockResolvedValue(undefined),
      lockTrainer: vi.fn().mockResolvedValue(undefined),
      memberNamesForSubscriptions: vi.fn().mockResolvedValue(new Map([[500, 'Other Member']])),
      findFutureOccurrenceIds: vi.fn().mockResolvedValue([]),
      insertChange: vi.fn().mockImplementation(async (v) => {
        changes.push({ id: changes.length + 1, ...v });
      }),
      listChanges: vi.fn().mockImplementation(async () => [...changes].reverse()),
      listOpenWithEffectiveChanges: vi.fn().mockImplementation(async () => (stored ? [stored] : [])),
      completeDue: vi.fn().mockResolvedValue([]),
      activateDue: vi.fn().mockResolvedValue([]),
      listForMember: vi.fn().mockResolvedValue([]),
    };
    productRepo = { findById: vi.fn().mockResolvedValue(product) };
    memberRepo = {
      findById: vi.fn().mockResolvedValue(femaleMember),
      updateMember: vi.fn().mockResolvedValue(undefined),
    };
    trainerRepo = {
      findById: vi.fn().mockImplementation(async (id) => (id === 8 ? maleTrainer : femaleTrainer)),
      findAllActive: vi.fn().mockResolvedValue([femaleTrainer, maleTrainer]),
    };
    availabilityRepo = { findByTrainerId: vi.fn().mockResolvedValue(monWedFri5to8) };
    let nextScheduleId = 1000;
    scheduleRepo = {
      findBusyForTrainer: vi.fn().mockResolvedValue([]),
      findOverlappingBookedForMember: vi.fn().mockResolvedValue([]),
      insertSchedule: vi.fn().mockImplementation(async () => nextScheduleId++),
      insertParticipant: vi.fn().mockResolvedValue(1),
      insertHistory: vi.fn().mockResolvedValue(undefined),
      updateSchedule: vi.fn().mockResolvedValue(undefined),
      cancelParticipants: vi.fn().mockResolvedValue(undefined),
    };
    scheduleTypeRepo = { findByName: vi.fn().mockResolvedValue({ id: 11, name: 'Personal Training' }) };
    membershipRepo = {
      findActiveOrFrozenForMember: vi
        .fn()
        .mockResolvedValue({ id: 77, status: 'active', end_date: '2026-12-31' }),
    };
    paymentService = {
      computeTotals: vi.fn().mockResolvedValue({ subtotal: '3000.00', discount: '0.00', tax: '0.00', total: '3000.00' }),
      resolveStatus: vi.fn().mockImplementation((total: string, paid: string) =>
        Number(paid) >= Number(total) ? 'paid' : Number(paid) > 0 ? 'partial' : 'pending',
      ),
      create: vi.fn().mockResolvedValue({ id: 555, status: 'paid', pt_subscription_id: 900 }),
    };
    settings = {
      getTimezone: vi.fn().mockResolvedValue('UTC'),
      getPaymentsActivateMembershipOnPartial: vi.fn().mockResolvedValue(false),
    };

    scheduleService = new PtScheduleService(
      memberRepo as any,
      trainerRepo as any,
      availabilityRepo as any,
      scheduleRepo as any,
      productRepo as any,
      subsRepo as any,
      settings as any,
    );
    service = new PtSubscriptionService(
      subsRepo as any,
      productRepo as any,
      scheduleService,
      { trainerAccess: vi.fn().mockResolvedValue('full') } as any,
      memberRepo as any,
      trainerRepo as any,
      membershipRepo as any,
      scheduleRepo as any,
      scheduleTypeRepo as any,
      paymentService as any,
      settings as any,
      { recordAudit: vi.fn().mockResolvedValue(undefined) } as any,
      {} as any,
    );
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  const purchase = (overrides: Record<string, unknown> = {}) =>
    service.purchase(
      {
        member_id: 42,
        pt_product_id: 3,
        trainer_id: 7,
        start_date: MON,
        weekdays: [1, 3, 5],
        slot_start: '17:00',
        payment_method_id: 1,
        ...overrides,
      } as any,
      admin,
    );

  describe('purchase', () => {
    it('assigns the trainer, takes payment, and occupies the slot for every PT day', async () => {
      const { subscription, payment } = await purchase();

      // 28 days from Mon 5 Oct (inclusive end 2 Nov) → 4 weeks × 3 + Mon 2 Nov = 13 sessions.
      expect(scheduleRepo.insertSchedule).toHaveBeenCalledTimes(13);
      expect(scheduleRepo.insertSchedule).toHaveBeenCalledWith(
        expect.objectContaining({
          pt_subscription_id: 900,
          trainer_id: 7,
          schedule_type_id: 11,
          max_capacity: 1,
          start_time: new Date('2026-10-05T17:00:00.000Z'),
          end_time: new Date('2026-10-05T18:00:00.000Z'),
        }),
      );
      expect(scheduleRepo.insertParticipant).toHaveBeenCalledTimes(13);
      expect(subsRepo.lockTrainer).toHaveBeenCalledWith(7);
      expect(memberRepo.updateMember).toHaveBeenCalledWith(42, expect.objectContaining({ assigned_trainer_id: 7 }));
      expect(paymentService.create).toHaveBeenCalledWith(
        expect.objectContaining({ member_id: 42, subtotal: '3000.00' }),
        admin,
        { ptSubscriptionId: 900 },
      );
      expect(subscription).toMatchObject({
        status: 'scheduled',
        start_date: MON,
        end_date: '2026-11-02',
        slot_start: '17:00:00',
        slot_label: '17:00-18:00',
        trainer_name: 'Rina S',
      });
      expect(payment.id).toBe(555);
    });

    it('allows a trainer of any gender', async () => {
      await expect(purchase({ trainer_id: 8 })).resolves.toBeDefined();
    });

    it('allows a member with no gender on file', async () => {
      memberRepo.findById.mockResolvedValue({ ...femaleMember, gender: null });
      await expect(purchase()).resolves.toBeDefined();
    });

    it('requires an active, unexpired membership', async () => {
      membershipRepo.findActiveOrFrozenForMember.mockResolvedValue({ id: 77, status: 'active', end_date: '2026-09-30' });
      await expect(purchase()).rejects.toThrow(/active, unexpired membership/);
    });

    it('allows PT to run past the membership end date', async () => {
      membershipRepo.findActiveOrFrozenForMember.mockResolvedValue({ id: 77, status: 'active', end_date: '2026-10-10' });
      await expect(purchase()).resolves.toBeDefined();
    });

    it('allows only one PT at a time', async () => {
      subsRepo.findOpenOverlappingForMember.mockResolvedValue([{ id: 1, end_date: '2026-10-20' }]);
      await expect(purchase()).rejects.toBeInstanceOf(ConflictError);
    });

    it('re-checks for another PT under the member lock', async () => {
      // A concurrent sale commits between the pre-check and the transaction.
      subsRepo.findOpenOverlappingForMember
        .mockResolvedValueOnce([])
        .mockResolvedValueOnce([{ id: 1, end_date: '2026-11-02' }]);
      await expect(purchase()).rejects.toBeInstanceOf(ConflictError);
      expect(subsRepo.lockMember).toHaveBeenCalledWith(42);
      expect(subsRepo.insertSubscription).not.toHaveBeenCalled();
    });

    it('keeps the current trainer assigned until a future PT starts', async () => {
      subsRepo.hasActiveForMember.mockResolvedValue(true);
      await purchase();
      expect(memberRepo.updateMember).not.toHaveBeenCalled();
    });

    it('assigns the trainer straight away when the PT starts today', async () => {
      subsRepo.hasActiveForMember.mockResolvedValue(true);
      await purchase({ start_date: '2026-10-01' });
      expect(memberRepo.updateMember).toHaveBeenCalledWith(42, expect.objectContaining({ assigned_trainer_id: 7 }));
    });

    it('accepts a weekday count chosen independently of any fixed package rate', async () => {
      await expect(purchase({ weekdays: [1, 3] })).resolves.toBeDefined();
    });

    it('rejects when the slot is taken on any date in the period, naming who holds it', async () => {
      scheduleRepo.findBusyForTrainer.mockResolvedValue([
        {
          id: 1,
          pt_subscription_id: 500,
          title: 'PT · Other Member',
          start_time: new Date('2026-10-21T17:00:00.000Z'), // a Wednesday inside the range
          end_time: new Date('2026-10-21T18:00:00.000Z'),
          status: 'scheduled',
        },
      ]);
      const err = await purchase().catch((e) => e);
      expect(err).toBeInstanceOf(ConflictError);
      expect(err.message).toMatch(/occupied by Other Member on 2026-10-21/);
      expect(subsRepo.insertSubscription).not.toHaveBeenCalled();
    });

    it('rejects an hour outside the trainer availability', async () => {
      await expect(purchase({ slot_start: '20:00' })).rejects.toThrow(/not available/);
    });

    it('rejects when payment would not activate', async () => {
      await expect(purchase({ payment_method_id: undefined })).rejects.toThrow(/paid in full/);
      expect(subsRepo.insertSubscription).not.toHaveBeenCalled();
    });

    it('rejects a past start date', async () => {
      await expect(purchase({ start_date: '2026-09-28' })).rejects.toBeInstanceOf(BadRequestError);
    });
  });

  describe('schedule grid', () => {
    it('lists all active trainers and marks hours free/occupied/unavailable', async () => {
      scheduleRepo.findBusyForTrainer.mockResolvedValue([
        {
          id: 1,
          pt_subscription_id: 500,
          title: 'PT · Other Member',
          start_time: new Date('2026-10-12T18:00:00.000Z'),
          end_time: new Date('2026-10-12T19:00:00.000Z'),
          status: 'scheduled',
        },
      ]);
      const grid = await scheduleService.buildGrid({
        member_id: 42,
        pt_product_id: 3,
        start_date: MON,
        weekdays: [1, 3, 5],
      });

      expect(grid).not.toHaveProperty('gender');
      expect(grid.trainers).toEqual([
        { id: 7, name: 'Rina S' },
        { id: 8, name: 'Arun M' },
      ]);
      expect(grid.hours).toEqual(['17:00:00', '18:00:00', '19:00:00']);
      const cell = (slot: string) => grid.cells.find((c) => c.slot_start === slot)!;
      expect(cell('17:00:00')).toMatchObject({ status: 'free', occupied_by: null });
      expect(cell('18:00:00')).toMatchObject({
        status: 'occupied',
        occupied_by: 'Other Member',
        conflict_dates: ['2026-10-12'],
      });
    });
  });

  it('limits a re-plan grid to the subscription end date and weekday count', async () => {
    stored = {
      id: 900,
      member_id: 42,
      pt_product_id: 3,
      trainer_id: 7,
      start_date: '2026-09-28',
      end_date: '2026-10-09',
      weekdays: [1, 3, 5],
      slot_start: '17:00:00',
      status: 'active',
      row_version: 1,
    };
    productRepo.findById.mockResolvedValue(product);
    // Busy after the PT ends: must not mark the slot occupied.
    scheduleRepo.findBusyForTrainer.mockImplementation(async (_id: number, _from: Date, to: Date) =>
      to < new Date('2026-10-20T00:00:00.000Z')
        ? []
        : [
            {
              id: 1,
              pt_subscription_id: 500,
              title: 'PT · Other Member',
              start_time: new Date('2026-10-21T17:00:00.000Z'),
              end_time: new Date('2026-10-21T18:00:00.000Z'),
              status: 'scheduled',
            },
          ],
    );
    const grid = await scheduleService.buildGrid({
      member_id: 42,
      pt_product_id: 3,
      start_date: '2026-10-01',
      weekdays: [1, 3, 5],
      exclude_subscription_id: 900,
    });
    expect(grid.end_date).toBe('2026-10-09');
    expect(grid.cells.find((c) => c.slot_start === '17:00:00')).toMatchObject({ status: 'free' });
  });

  describe('renew', () => {
    beforeEach(() => {
      stored = {
        id: 900,
        member_id: 42,
        pt_product_id: 3,
        trainer_id: 7,
        start_date: MON,
        end_date: '2026-11-02',
        weekdays: [1, 3, 5],
        slot_start: '17:00:00',
        status: 'active',
        row_version: 1,
      };
    });

    it('continues the day after the current end date with the same trainer and slot', async () => {
      await service.renew(900, { payment_method_id: 1 } as any, admin);
      expect(subsRepo.insertSubscription).toHaveBeenCalledWith(
        expect.objectContaining({
          renewed_from_id: 900,
          trainer_id: 7,
          start_date: '2026-11-03',
          end_date: '2026-12-01',
          slot_start: '17:00:00',
          weekdays: [1, 3, 5],
          status: 'scheduled',
        }),
      );
    });

    it('fails with the clashing dates when the slot is no longer free', async () => {
      scheduleRepo.findBusyForTrainer.mockResolvedValue([
        {
          id: 2,
          pt_subscription_id: null,
          title: 'Staff meeting',
          start_time: new Date('2026-11-04T17:00:00.000Z'),
          end_time: new Date('2026-11-04T18:00:00.000Z'),
          status: 'scheduled',
        },
      ]);
      const err = await service.renew(900, { payment_method_id: 1 } as any, admin).catch((e) => e);
      expect(err).toBeInstanceOf(ConflictError);
      expect(err.details[0]).toMatchObject({ date: '2026-11-04', reason: 'trainer_busy' });
    });
  });

  describe('reassign trainer', () => {
    beforeEach(() => {
      stored = {
        id: 900,
        member_id: 42,
        pt_product_id: 3,
        trainer_id: 7,
        start_date: '2026-09-28',
        end_date: '2026-10-26',
        weekdays: [1, 3, 5],
        slot_start: '17:00:00',
        status: 'active',
        row_version: 1,
      };
      trainerRepo.findById.mockImplementation(async (id: number) =>
        id === 9
          ? { id: 9, first_name: 'Neha', last_name: 'P', gender: 'female', is_active: true }
          : id === 8
            ? maleTrainer
            : femaleTrainer,
      );
      subsRepo.findFutureOccurrenceIds.mockResolvedValue([3001, 3002]);
    });

    it('replaces only future sessions from the effective date and hands over on that date', async () => {
      await service.reassignTrainer(900, { trainer_id: 9, effective_date: '2026-10-12' }, admin);

      const cutoff: Date = subsRepo.findFutureOccurrenceIds.mock.calls[0][1];
      expect(cutoff.toISOString()).toBe('2026-10-12T00:00:00.000Z');
      expect(scheduleRepo.updateSchedule).toHaveBeenCalledWith(3001, expect.objectContaining({ status: 'cancelled' }));
      // Mon 12 → Mon 26 Oct: 12,14,16,19,21,23,26 = 7 new sessions for trainer 9.
      expect(scheduleRepo.insertSchedule).toHaveBeenCalledTimes(7);
      expect(scheduleRepo.insertSchedule).toHaveBeenCalledWith(expect.objectContaining({ trainer_id: 9 }));
      expect(subsRepo.insertChange).toHaveBeenCalledWith(
        expect.objectContaining({ change_type: 'trainer', old_trainer_id: 7, new_trainer_id: 9 }),
      );
      // Trainer 7 keeps the member (and write access) until the effective date.
      expect(stored.trainer_id).toBe(7);
      expect(memberRepo.updateMember).not.toHaveBeenCalled();

      await service.runStatusTransitions();
      expect(stored.trainer_id).toBe(7);

      vi.setSystemTime(new Date('2026-10-12T00:30:00.000Z'));
      await service.runStatusTransitions();
      expect(stored.trainer_id).toBe(9);
      expect(memberRepo.updateMember).toHaveBeenCalledWith(42, expect.objectContaining({ assigned_trainer_id: 9 }));
    });

    it('hands over immediately when effective today', async () => {
      await service.reassignTrainer(900, { trainer_id: 9, effective_date: '2026-10-01' }, admin);
      expect(stored.trainer_id).toBe(9);
      expect(memberRepo.updateMember).toHaveBeenCalledWith(42, expect.objectContaining({ assigned_trainer_id: 9 }));
    });

    it('keeps a pending handover when the slot changes later without a trainer', async () => {
      await service.reassignTrainer(900, { trainer_id: 9, effective_date: '2026-10-12' }, admin);
      scheduleRepo.insertSchedule.mockClear();
      await service.changeSlot(
        900,
        { weekdays: [1, 3, 5], slot_start: '18:00', effective_date: '2026-10-19' },
        admin,
      );
      expect(scheduleRepo.insertSchedule).toHaveBeenCalledWith(expect.objectContaining({ trainer_id: 9 }));
      expect(subsRepo.insertChange).toHaveBeenLastCalledWith(
        expect.objectContaining({ change_type: 'slot', old_trainer_id: 9, new_trainer_id: 9 }),
      );
    });

    it('allows the weekday count to change freely on a re-plan', async () => {
      await expect(
        service.changeSlot(
          900,
          { weekdays: [1, 3, 5], slot_start: '18:00', effective_date: '2026-10-12' },
          admin,
        ),
      ).resolves.toBeDefined();
      await expect(
        service.changeSlot(900, { weekdays: [1, 3], slot_start: '18:00', effective_date: '2026-10-12' }, admin),
      ).resolves.toBeDefined();
    });

    it('accepts a trainer of the opposite gender', async () => {
      await expect(
        service.reassignTrainer(900, { trainer_id: 8, effective_date: '2026-10-12' }, admin),
      ).resolves.toBeDefined();
    });

    it('moves trainer and slot together in one re-plan', async () => {
      availabilityRepo.findByTrainerId.mockResolvedValue(
        [1, 2, 4].map((d) => ({ ...monWedFri5to8[0], day_of_week: d, start_time: '06:00', end_time: '09:00' })),
      );
      await service.changeSlot(
        900,
        { weekdays: [1, 2, 4], slot_start: '07:00', trainer_id: 9, effective_date: '2026-10-12' },
        admin,
      );
      expect(scheduleRepo.insertSchedule).toHaveBeenCalledWith(
        expect.objectContaining({
          trainer_id: 9,
          start_time: new Date('2026-10-12T07:00:00.000Z'),
        }),
      );
      expect(stored.trainer_id).toBe(7);
      expect(subsRepo.insertChange).toHaveBeenCalledWith(
        expect.objectContaining({ change_type: 'trainer_slot', new_slot_start: '07:00:00', new_weekdays: [1, 2, 4] }),
      );
    });

    it('refuses an effective date in the past', async () => {
      await expect(
        service.reassignTrainer(900, { trainer_id: 9, effective_date: '2026-09-30' }, admin),
      ).rejects.toBeInstanceOf(BadRequestError);
    });
  });
});
