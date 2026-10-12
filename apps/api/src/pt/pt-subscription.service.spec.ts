import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  NotFoundError,
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
  package_type: 'single' as const,
  is_active: true,
};

const femaleMember = { id: 42, first_name: 'Asha', last_name: 'K', gender: 'Female', user_id: 10 };
const partnerMember = { id: 55, first_name: 'Priya', last_name: 'Shah', gender: 'Female', user_id: 11 };
const coupleProduct = {
  ...product,
  id: 4,
  name: 'Couple PT 1 Month',
  code: 'CPT-1M',
  package_type: 'couple' as const,
};
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
  // `_byId` / `_setNextId` are test helpers alongside vi.fn mocks.
  let subsRepo: Record<string, any>;
  let productRepo: Record<string, ReturnType<typeof vi.fn>>;
  let memberRepo: Record<string, ReturnType<typeof vi.fn>>;
  let trainerRepo: Record<string, ReturnType<typeof vi.fn>>;
  let availabilityRepo: Record<string, ReturnType<typeof vi.fn>>;
  let scheduleRepo: Record<string, ReturnType<typeof vi.fn>>;
  let scheduleTypeRepo: Record<string, ReturnType<typeof vi.fn>>;
  let membershipService: Record<string, ReturnType<typeof vi.fn>>;
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
    let nextSubId = 900;
    const byId = new Map<number, any>();

    subsRepo = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        if (byId.has(id)) return byId.get(id);
        return stored?.id === id ? stored : null;
      }),
      insertSubscription: vi.fn().mockImplementation(async (v) => {
        const id = nextSubId++;
        const row = { id, ...v };
        byId.set(id, row);
        stored = row;
        return id;
      }),
      updateSubscription: vi.fn().mockImplementation(async (id, v) => {
        const prev = byId.get(id) ?? stored;
        const next = { ...prev, ...v };
        byId.set(id, next);
        if (stored?.id === id) stored = next;
      }),
      findOpenOverlappingForMember: vi.fn().mockResolvedValue([]),
      hasActiveForMember: vi.fn().mockResolvedValue(false),
      lockMember: vi.fn().mockResolvedValue(undefined),
      lockMembers: vi.fn().mockResolvedValue(undefined),
      lockTrainer: vi.fn().mockResolvedValue(undefined),
      setPartner: vi.fn().mockImplementation(async (id: number, partnerId: number) => {
        const row = byId.get(id);
        if (row) {
          row.partner_subscription_id = partnerId;
          byId.set(id, row);
        }
      }),
      findPartner: vi.fn().mockImplementation(async (sub: { partner_subscription_id: number | null }) =>
        sub.partner_subscription_id != null ? (byId.get(sub.partner_subscription_id) ?? null) : null,
      ),
      occurrenceOwnerId: vi.fn().mockImplementation((sub: { id: number; is_primary?: boolean; partner_subscription_id?: number | null }) =>
        sub.is_primary === false ? (sub.partner_subscription_id ?? sub.id) : sub.id,
      ),
      memberNamesForSubscriptions: vi.fn().mockResolvedValue(new Map([[500, 'Other Member']])),
      findFutureOccurrenceIds: vi.fn().mockResolvedValue([]),
      insertChange: vi.fn().mockImplementation(async (v) => {
        changes.push({ id: changes.length + 1, ...v });
      }),
      listChanges: vi.fn().mockImplementation(async (subscriptionId?: number) =>
        [...changes]
          .filter((c) => subscriptionId == null || c.pt_subscription_id === subscriptionId)
          .reverse(),
      ),
      listOpenWithEffectiveChanges: vi.fn().mockImplementation(async () =>
        [...byId.values()].filter((s) => s.status === 'scheduled' || s.status === 'active'),
      ),
      completeDue: vi.fn().mockResolvedValue([]),
      activateDue: vi.fn().mockResolvedValue([]),
      listForMember: vi.fn().mockResolvedValue([]),
      _byId: byId,
      _setNextId: (n: number) => {
        nextSubId = n;
      },
    };
    productRepo = {
      findById: vi.fn().mockImplementation(async (id: number) =>
        id === coupleProduct.id ? coupleProduct : product,
      ),
    };
    memberRepo = {
      findById: vi.fn().mockImplementation(async (id: number) => {
        if (id === partnerMember.id) return partnerMember;
        if (id === femaleMember.id) return femaleMember;
        return null;
      }),
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
    membershipService = {
      // ADR-0012: bundling creates/extends a membership per member (primary 42 -> 77, partner 55 -> 88).
      bundleForPt: vi.fn().mockImplementation(async ({ memberIds }: { memberIds: number[] }) => ({
        membershipIds: new Map(memberIds.map((id) => [id, id === 55 ? 88 : 77])),
        events: [{ eventName: 'membership.created', occurredAt: NOW, payload: {} }],
      })),
      emitEvents: vi.fn().mockResolvedValue(undefined),
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
      membershipService as any,
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

    it('bundles a membership for the PT period and links it to the subscription', async () => {
      const { subscription } = await purchase();
      expect(membershipService.bundleForPt).toHaveBeenCalledWith(
        expect.objectContaining({
          memberIds: [42],
          startDate: '2026-10-05',
          endDate: '2026-11-02',
          durationDays: product.duration_days,
          today: '2026-10-01',
        }),
      );
      expect(subsRepo.insertSubscription).toHaveBeenCalledWith(
        expect.objectContaining({ member_id: 42, membership_id: 77 }),
      );
      expect(subscription).toBeDefined();
      expect(membershipService.emitEvents).toHaveBeenCalledTimes(1);
    });

    it('rejects, writing nothing, when the membership cannot be bundled', async () => {
      membershipService.bundleForPt.mockRejectedValue(new BusinessRuleError('membership is frozen'));
      await expect(purchase()).rejects.toThrow(/frozen/);
      expect(subsRepo.insertSubscription).not.toHaveBeenCalled();
      expect(paymentService.create).not.toHaveBeenCalled();
      expect(membershipService.emitEvents).not.toHaveBeenCalled();
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
      expect(subsRepo.lockMembers).toHaveBeenCalledWith([42]);
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

    describe('couple packages (CP-07)', () => {
      const purchaseCouple = (overrides: Record<string, unknown> = {}) =>
        purchase({
          pt_product_id: 4,
          partner_member_id: 55,
          ...overrides,
        });

      beforeEach(() => {
        productRepo.findById.mockResolvedValue(coupleProduct);
      });

      it('rejects a couple product without a partner', async () => {
        await expect(purchase({ pt_product_id: 4 })).rejects.toBeInstanceOf(BadRequestError);
        expect(subsRepo.insertSubscription).not.toHaveBeenCalled();
      });

      it('rejects a single product with a partner', async () => {
        productRepo.findById.mockResolvedValue(product);
        await expect(purchase({ partner_member_id: 55 })).rejects.toBeInstanceOf(BadRequestError);
      });

      it('rejects a member picked as their own partner', async () => {
        await expect(purchaseCouple({ partner_member_id: 42 })).rejects.toBeInstanceOf(BadRequestError);
      });

      it('rejects when the partner member is missing', async () => {
        memberRepo.findById.mockImplementation(async (id: number) =>
          id === 42 ? femaleMember : null,
        );
        await expect(purchaseCouple()).rejects.toBeInstanceOf(NotFoundError);
      });

      it('bundles a membership for both members and links each row to its own', async () => {
        await purchaseCouple();
        expect(membershipService.bundleForPt).toHaveBeenCalledWith(
          expect.objectContaining({ memberIds: [42, 55] }),
        );
        expect(subsRepo.insertSubscription).toHaveBeenNthCalledWith(
          1,
          expect.objectContaining({ member_id: 42, membership_id: 77 }),
        );
        expect(subsRepo.insertSubscription).toHaveBeenNthCalledWith(
          2,
          expect.objectContaining({ member_id: 55, membership_id: 88 }),
        );
      });

      it('rejects when the partner already has overlapping PT, naming who failed', async () => {
        subsRepo.findOpenOverlappingForMember.mockImplementation(async (memberId: number) =>
          memberId === 55 ? [{ id: 1, end_date: '2026-10-20' }] : [],
        );
        const err = await purchaseCouple().catch((e) => e);
        expect(err).toBeInstanceOf(ConflictError);
        expect(err.message).toMatch(/Priya Shah already has Personal Training/);
      });

      it('creates two cross-linked rows, one payment on primary, and shared capacity-2 sessions', async () => {
        const { subscription, payment } = await purchaseCouple({ discount_amount: '200.00' });

        expect(subsRepo.lockMembers).toHaveBeenCalledWith([42, 55]);
        expect(subsRepo.insertSubscription).toHaveBeenNthCalledWith(
          1,
          expect.objectContaining({
            member_id: 42,
            is_primary: true,
            partner_subscription_id: null,
            trainer_id: 7,
            weekdays: [1, 3, 5],
            slot_start: '17:00:00',
          }),
        );
        expect(subsRepo.insertSubscription).toHaveBeenNthCalledWith(
          2,
          expect.objectContaining({
            member_id: 55,
            is_primary: false,
            partner_subscription_id: 900,
            trainer_id: 7,
            weekdays: [1, 3, 5],
            slot_start: '17:00:00',
          }),
        );
        expect(subsRepo.setPartner).toHaveBeenCalledWith(900, 901);
        expect(paymentService.create).toHaveBeenCalledWith(
          expect.objectContaining({
            member_id: 42,
            subtotal: '3000.00',
            discount_amount: '200.00',
          }),
          admin,
          { ptSubscriptionId: 900 },
        );
        expect(scheduleRepo.insertSchedule).toHaveBeenCalledWith(
          expect.objectContaining({
            pt_subscription_id: 900,
            max_capacity: 2,
            title: 'PT · Asha K & Priya Shah',
          }),
        );
        expect(scheduleRepo.insertParticipant).toHaveBeenCalledTimes(13 * 2);
        expect(memberRepo.updateMember).toHaveBeenCalledWith(
          42,
          expect.objectContaining({ assigned_trainer_id: 7 }),
        );
        expect(memberRepo.updateMember).toHaveBeenCalledWith(
          55,
          expect.objectContaining({ assigned_trainer_id: 7 }),
        );
        expect(subscription).toMatchObject({
          id: 900,
          is_primary: true,
          partner_subscription_id: 901,
          package_type: 'couple',
          partner_member_id: 55,
          partner_member_name: 'Priya Shah',
        });
        expect(payment.id).toBe(555);
      });

      it('locks both members for either purchase role (deadlock-safe call site)', async () => {
        await purchaseCouple({ member_id: 55, partner_member_id: 42 });
        expect(subsRepo.lockMembers).toHaveBeenCalledWith([55, 42]);
      });
    });
  });

  describe('present (CP-06 partner fields)', () => {
    it('includes partner fields for a linked row and null for a single row', async () => {
      const byId = (subsRepo as any)._byId as Map<number, any>;
      byId.set(900, {
        id: 900,
        member_id: 42,
        pt_product_id: 4,
        trainer_id: 7,
        start_date: MON,
        end_date: '2026-11-02',
        weekdays: [1, 3, 5],
        slot_start: '17:00:00',
        status: 'active',
        row_version: 1,
        is_primary: true,
        partner_subscription_id: 901,
      });
      byId.set(901, {
        id: 901,
        member_id: 55,
        pt_product_id: 4,
        trainer_id: 7,
        start_date: MON,
        end_date: '2026-11-02',
        weekdays: [1, 3, 5],
        slot_start: '17:00:00',
        status: 'active',
        row_version: 1,
        is_primary: false,
        partner_subscription_id: 900,
      });
      productRepo.findById.mockResolvedValue(coupleProduct);

      const linked = await service.getById(900, admin);
      expect(linked.package_type).toBe('couple');
      expect(linked.is_primary).toBe(true);
      expect(linked.partner_subscription_id).toBe(901);
      expect(linked.partner_member_id).toBe(55);
      expect(linked.partner_member_name).toBe('Priya Shah');

      byId.set(902, {
        id: 902,
        member_id: 42,
        pt_product_id: 3,
        trainer_id: 7,
        start_date: MON,
        end_date: '2026-11-02',
        weekdays: [1, 3, 5],
        slot_start: '17:00:00',
        status: 'active',
        row_version: 1,
        is_primary: true,
        partner_subscription_id: null,
      });
      productRepo.findById.mockResolvedValue(product);
      const single = await service.getById(902, admin);
      expect(single.package_type).toBe('single');
      expect(single.partner_subscription_id).toBeNull();
      expect(single.partner_member_id).toBeNull();
      expect(single.partner_member_name).toBeNull();
    });

    it('hides partner ids for a member-scoped read, keeping only the name', async () => {
      const byId = (subsRepo as any)._byId as Map<number, any>;
      byId.set(900, {
        id: 900,
        member_id: 42,
        pt_product_id: 4,
        trainer_id: 7,
        start_date: MON,
        end_date: '2026-11-02',
        weekdays: [1, 3, 5],
        slot_start: '17:00:00',
        status: 'active',
        row_version: 1,
        is_primary: true,
        partner_subscription_id: 901,
      });
      byId.set(901, {
        id: 901,
        member_id: 55,
        pt_product_id: 4,
        trainer_id: 7,
        start_date: MON,
        end_date: '2026-11-02',
        weekdays: [1, 3, 5],
        slot_start: '17:00:00',
        status: 'active',
        row_version: 1,
        is_primary: false,
        partner_subscription_id: 900,
      });
      productRepo.findById.mockResolvedValue(coupleProduct);

      const memberActor = {
        ...admin,
        userType: 'member' as const,
        profileId: 42,
      };
      const result = await service.getById(900, memberActor);
      expect(result.partner_subscription_id).toBeNull();
      expect(result.partner_member_id).toBeNull();
      expect(result.partner_member_name).toBe('Priya Shah');
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

    it('marks a cell occupied when the partner member is busy (CP-05)', async () => {
      subsRepo.memberNamesForSubscriptions.mockResolvedValue(
        new Map([
          [500, 'Other Member'],
          [800, 'Priya Shah'],
        ]),
      );
      scheduleRepo.findOverlappingBookedForMember.mockImplementation(async (memberId: number) =>
        memberId === 55
          ? [
              {
                id: 99,
                pt_subscription_id: 800,
                title: 'PT · Priya Shah',
                start_time: new Date('2026-10-12T17:00:00.000Z'),
                end_time: new Date('2026-10-12T18:00:00.000Z'),
                status: 'booked',
              },
            ]
          : [],
      );
      const grid = await scheduleService.buildGrid({
        member_id: 42,
        partner_member_id: 55,
        pt_product_id: 3,
        start_date: MON,
        weekdays: [1, 3, 5],
      });
      expect(grid.cells.find((c) => c.slot_start === '17:00:00' && c.trainer_id === 7)).toMatchObject({
        status: 'occupied',
        occupied_by: 'Priya Shah',
        conflict_dates: ['2026-10-12'],
      });
    });

    it('re-plan of a couple excludes shared owner sessions and includes the partner (CP-05)', async () => {
      const byId = (subsRepo as any)._byId as Map<number, any>;
      byId.set(900, {
        id: 900,
        member_id: 42,
        pt_product_id: 4,
        trainer_id: 7,
        start_date: '2026-09-28',
        end_date: '2026-10-09',
        weekdays: [1, 3, 5],
        slot_start: '17:00:00',
        status: 'active',
        row_version: 1,
        is_primary: true,
        partner_subscription_id: 901,
      });
      byId.set(901, {
        id: 901,
        member_id: 55,
        pt_product_id: 4,
        trainer_id: 7,
        start_date: '2026-09-28',
        end_date: '2026-10-09',
        weekdays: [1, 3, 5],
        slot_start: '17:00:00',
        status: 'active',
        row_version: 1,
        is_primary: false,
        partner_subscription_id: 900,
      });
      productRepo.findById.mockResolvedValue(coupleProduct);
      scheduleRepo.findBusyForTrainer.mockResolvedValue([
        {
          id: 1,
          pt_subscription_id: 900,
          title: 'PT · Asha K & Priya Shah',
          start_time: new Date('2026-10-05T17:00:00.000Z'),
          end_time: new Date('2026-10-05T18:00:00.000Z'),
          status: 'scheduled',
        },
      ]);
      const grid = await scheduleService.buildGrid({
        member_id: 42,
        pt_product_id: 4,
        start_date: '2026-10-01',
        weekdays: [1, 3, 5],
        exclude_subscription_id: 900,
      });
      expect(grid.end_date).toBe('2026-10-09');
      expect(grid.cells.find((c) => c.slot_start === '17:00:00' && c.trainer_id === 7)).toMatchObject({
        status: 'free',
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
      is_primary: true,
      partner_subscription_id: null,
    };
    (subsRepo as any)._byId.set(900, stored);
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
        is_primary: true,
        partner_subscription_id: null,
      };
      (subsRepo as any)._byId.set(900, stored);
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

    it('extends the bundled membership by the renewed PT period', async () => {
      await service.renew(900, { payment_method_id: 1 } as any, admin);
      expect(membershipService.bundleForPt).toHaveBeenCalledWith(
        expect.objectContaining({
          memberIds: [42],
          startDate: '2026-11-03',
          endDate: '2026-12-01',
          durationDays: product.duration_days,
        }),
      );
      expect(subsRepo.insertSubscription).toHaveBeenCalledWith(
        expect.objectContaining({ member_id: 42, membership_id: 77, renewed_from_id: 900 }),
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

    describe('couple linked renew (CP-08)', () => {
      const seedCouple = () => {
        const primary = {
          id: 900,
          member_id: 42,
          pt_product_id: 4,
          trainer_id: 7,
          start_date: MON,
          end_date: '2026-11-02',
          weekdays: [1, 3, 5],
          slot_start: '17:00:00',
          status: 'active',
          row_version: 1,
          is_primary: true,
          partner_subscription_id: 901,
        };
        const partner = {
          ...primary,
          id: 901,
          member_id: 55,
          is_primary: false,
          partner_subscription_id: 900,
        };
        stored = primary;
        (subsRepo as any)._byId.set(900, primary);
        (subsRepo as any)._byId.set(901, partner);
        (subsRepo as any)._setNextId(902);
        productRepo.findById.mockImplementation(async (id: number) =>
          id === 4 || id === coupleProduct.id ? coupleProduct : product,
        );
        paymentService.computeTotals.mockResolvedValue({
          subtotal: '5000.00',
          discount: '0.00',
          tax: '0.00',
          total: '5000.00',
        });
      };

      it('creates two linked rows billed on the primary with matching dates', async () => {
        seedCouple();
        await service.renew(900, { payment_method_id: 1 } as any, admin);

        expect(subsRepo.insertSubscription).toHaveBeenCalledTimes(2);
        expect(subsRepo.insertSubscription).toHaveBeenCalledWith(
          expect.objectContaining({
            member_id: 42,
            is_primary: true,
            renewed_from_id: 900,
            start_date: '2026-11-03',
            end_date: '2026-12-01',
          }),
        );
        expect(subsRepo.insertSubscription).toHaveBeenCalledWith(
          expect.objectContaining({
            member_id: 55,
            is_primary: false,
            renewed_from_id: 901,
            partner_subscription_id: 902,
            start_date: '2026-11-03',
            end_date: '2026-12-01',
          }),
        );
        expect(subsRepo.setPartner).toHaveBeenCalledWith(902, 903);
        expect(paymentService.create).toHaveBeenCalledWith(
          expect.objectContaining({ member_id: 42 }),
          admin,
          { ptSubscriptionId: 902 },
        );
        expect(scheduleRepo.insertSchedule).toHaveBeenCalledWith(
          expect.objectContaining({ max_capacity: 2, pt_subscription_id: 902 }),
        );
      });

      it('renews the same pair when started from the partner row', async () => {
        seedCouple();
        await service.renew(901, { payment_method_id: 1 } as any, admin);
        expect(subsRepo.insertSubscription).toHaveBeenCalledWith(
          expect.objectContaining({ member_id: 42, is_primary: true, renewed_from_id: 900 }),
        );
        expect(subsRepo.insertSubscription).toHaveBeenCalledWith(
          expect.objectContaining({ member_id: 55, is_primary: false, renewed_from_id: 901 }),
        );
        expect(paymentService.create).toHaveBeenCalledWith(
          expect.anything(),
          admin,
          { ptSubscriptionId: 902 },
        );
      });

      it('rejects a package_type mismatch in both directions', async () => {
        seedCouple();
        await expect(
          service.renew(900, { pt_product_id: 3, payment_method_id: 1 } as any, admin),
        ).rejects.toBeInstanceOf(BusinessRuleError);

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
          is_primary: true,
          partner_subscription_id: null,
        };
        (subsRepo as any)._byId.clear();
        (subsRepo as any)._byId.set(900, stored);
        await expect(
          service.renew(900, { pt_product_id: 4, payment_method_id: 1 } as any, admin),
        ).rejects.toBeInstanceOf(BusinessRuleError);
      });
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
        is_primary: true,
        partner_subscription_id: null,
      };
      (subsRepo as any)._byId.set(900, stored);
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

    describe('couple linked reassign / change slot (CP-09)', () => {
      const seedCoupleOpen = () => {
        const primary = {
          id: 900,
          member_id: 42,
          pt_product_id: 4,
          trainer_id: 7,
          start_date: '2026-09-28',
          end_date: '2026-10-26',
          weekdays: [1, 3, 5],
          slot_start: '17:00:00',
          status: 'active',
          row_version: 1,
          is_primary: true,
          partner_subscription_id: 901,
        };
        const partner = {
          ...primary,
          id: 901,
          member_id: 55,
          is_primary: false,
          partner_subscription_id: 900,
        };
        stored = primary;
        (subsRepo as any)._byId.set(900, primary);
        (subsRepo as any)._byId.set(901, partner);
        productRepo.findById.mockResolvedValue(coupleProduct);
      };

      it('updates both rows and regenerates shared sessions from either side', async () => {
        seedCoupleOpen();
        await service.reassignTrainer(901, { trainer_id: 9, effective_date: '2026-10-01' }, admin);

        expect(subsRepo.findFutureOccurrenceIds).toHaveBeenCalledWith(900, expect.any(Date));
        expect(scheduleRepo.insertSchedule).toHaveBeenCalledWith(
          expect.objectContaining({ pt_subscription_id: 900, trainer_id: 9, max_capacity: 2 }),
        );
        expect(subsRepo.insertChange).toHaveBeenCalledWith(
          expect.objectContaining({ pt_subscription_id: 900, change_type: 'trainer', new_trainer_id: 9 }),
        );
        expect(subsRepo.insertChange).toHaveBeenCalledWith(
          expect.objectContaining({ pt_subscription_id: 901, change_type: 'trainer', new_trainer_id: 9 }),
        );
        expect((subsRepo as any)._byId.get(900).trainer_id).toBe(9);
        expect((subsRepo as any)._byId.get(901).trainer_id).toBe(9);
        expect(memberRepo.updateMember).toHaveBeenCalledWith(42, expect.objectContaining({ assigned_trainer_id: 9 }));
        expect(memberRepo.updateMember).toHaveBeenCalledWith(55, expect.objectContaining({ assigned_trainer_id: 9 }));
      });

      it('applies a future-dated handover to both rows via the status job', async () => {
        seedCoupleOpen();
        await service.reassignTrainer(900, { trainer_id: 9, effective_date: '2026-10-12' }, admin);
        expect((subsRepo as any)._byId.get(900).trainer_id).toBe(7);
        expect((subsRepo as any)._byId.get(901).trainer_id).toBe(7);

        vi.setSystemTime(new Date('2026-10-12T00:30:00.000Z'));
        await service.runStatusTransitions();
        expect((subsRepo as any)._byId.get(900).trainer_id).toBe(9);
        expect((subsRepo as any)._byId.get(901).trainer_id).toBe(9);
        expect(memberRepo.updateMember).toHaveBeenCalledWith(42, expect.objectContaining({ assigned_trainer_id: 9 }));
        expect(memberRepo.updateMember).toHaveBeenCalledWith(55, expect.objectContaining({ assigned_trainer_id: 9 }));
      });

      it('blocks the change when the partner is busy on a new slot', async () => {
        seedCoupleOpen();
        scheduleRepo.findOverlappingBookedForMember.mockImplementation(async (memberId: number) =>
          memberId === 55
            ? [
                {
                  id: 88,
                  pt_subscription_id: 777,
                  title: 'Other class',
                  start_time: new Date('2026-10-12T18:00:00.000Z'),
                  end_time: new Date('2026-10-12T19:00:00.000Z'),
                  status: 'scheduled',
                },
              ]
            : [],
        );
        await expect(
          service.changeSlot(
            900,
            { weekdays: [1, 3, 5], slot_start: '18:00', effective_date: '2026-10-12' },
            admin,
          ),
        ).rejects.toBeInstanceOf(ConflictError);
      });
    });
  });

  describe('status job for a linked pair (CP-10)', () => {
    it('activates and completes both rows together', async () => {
      const primary = {
        id: 900,
        member_id: 42,
        pt_product_id: 4,
        trainer_id: 7,
        start_date: MON,
        end_date: '2026-11-02',
        weekdays: [1, 3, 5],
        slot_start: '17:00:00',
        status: 'scheduled',
        row_version: 1,
        is_primary: true,
        partner_subscription_id: 901,
      };
      const partner = { ...primary, id: 901, member_id: 55, is_primary: false, partner_subscription_id: 900 };
      (subsRepo as any)._byId.set(900, primary);
      (subsRepo as any)._byId.set(901, partner);
      subsRepo.activateDue.mockResolvedValue([900, 901]);
      subsRepo.completeDue.mockResolvedValue([]);

      const result = await service.runStatusTransitions();
      expect(result.activated).toBe(2);
      expect(memberRepo.updateMember).toHaveBeenCalledWith(42, expect.objectContaining({ assigned_trainer_id: 7 }));
      expect(memberRepo.updateMember).toHaveBeenCalledWith(55, expect.objectContaining({ assigned_trainer_id: 7 }));

      subsRepo.activateDue.mockResolvedValue([]);
      subsRepo.completeDue.mockResolvedValue([900, 901]);
      const completed = await service.runStatusTransitions();
      expect(completed.completed).toBe(2);
    });
  });
});
