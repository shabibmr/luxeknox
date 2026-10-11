import { describe, it, expect, vi, beforeEach } from 'vitest';
import { MembershipService } from './membership.service';
import type { MembershipRepository } from './membership.repository';
import type { MembershipProductRepository } from './membership-product.repository';
import type { MemberRepository } from '../people/member.repository';
import { PaginationHelper } from '../platform/http/pagination';
import type { AuditService } from '../platform/audit/audit.service';
import type { DomainEventBus } from '../platform/events/domain-events';
import type { DrizzleDb } from '../platform/db/client';
import { BadRequestError, BusinessRuleError, ConflictError, NotFoundError } from '../platform/errors/app-error';
import type { Membership, MembershipProduct } from '../platform/db/schema/memberships';
import type { AuthenticatedUser } from '../auth/auth.guard';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const MEMBER_USER: AuthenticatedUser = {
  id: 10,
  email: 'member@luxeknox.test',
  phoneNumber: null,
  userType: 'member',
  roleId: 5,
  profileId: 100,
  sessionId: 2,
};

function makeMembership(overrides: Partial<Membership> = {}): Membership {
  return {
    id: 1,
    member_id: 100,
    product_id: 1,
    start_date: '2026-01-01',
    end_date: '2026-01-31',
    remaining_pt_sessions: 4,
    status: 'active',
    locker_number: null,
    auto_renew: false,
    partner_membership_id: null,
    row_version: 1,
    created_at: new Date('2026-01-01T00:00:00.000Z'),
    updated_at: null,
    ...overrides,
  };
}

function makeProduct(overrides: Partial<MembershipProduct> = {}): MembershipProduct {
  return {
    id: 1,
    name: 'Gold Plan',
    code: 'GOLD',
    description: null,
    duration_days: 30,
    base_price: '1299.00',
    tax_percentage: '5.00',
    max_freeze_days: 15,
    pt_sessions_included: 4,
    access_facilities: ['pool'],
    package_type: 'single',
    is_active: true,
    created_at: new Date('2026-01-01T00:00:00.000Z'),
    updated_at: null,
    ...overrides,
  };
}

function makeMembershipWithProduct(
  overrides: Partial<Membership> = {},
  productOverrides: Partial<MembershipProduct> | null = {},
): ReturnType<typeof makeMembership> & {
  product: MembershipProduct | null;
  partner_member_id: number | null;
  partner_member_name: string | null;
} {
  return {
    ...makeMembership(overrides),
    product: productOverrides === null ? null : makeProduct(productOverrides),
    partner_member_id: null,
    partner_member_name: null,
  };
}

describe('MembershipService', () => {
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let productRepository: Record<string, ReturnType<typeof vi.fn>>;
  let memberRepository: Record<string, ReturnType<typeof vi.fn>>;
  let auditService: { recordAudit: ReturnType<typeof vi.fn> };
  let domainEventBus: { emit: ReturnType<typeof vi.fn> };
  let paymentService: { create: ReturnType<typeof vi.fn> };
  let paginationHelper: PaginationHelper;
  let service: MembershipService;

  beforeEach(() => {
    repository = {
      findManyFiltered: vi.fn(),
      findByIdWithProduct: vi.fn(),
      findById: vi.fn(),
      findActiveOrFrozenForMember: vi.fn().mockResolvedValue(null),
      findByLockerNumberActiveOrFrozen: vi.fn().mockResolvedValue(null),
      insertMembership: vi.fn(),
      updateMembership: vi.fn().mockResolvedValue(undefined),
      insertHistory: vi.fn().mockResolvedValue(undefined),
      listHistory: vi.fn(),
      insertFreeze: vi.fn(),
      updateFreeze: vi.fn().mockResolvedValue(undefined),
      findFreezeById: vi.fn(),
      listFreezesForMembership: vi.fn(),
      sumApprovedFreezeDays: vi.fn().mockResolvedValue(0),
      findOverlappingFreeze: vi.fn().mockResolvedValue(null),
      insertExtension: vi.fn(),
      setPartner: vi.fn().mockResolvedValue(undefined),
      findPartner: vi.fn(),
      setPairedFreeze: vi.fn().mockResolvedValue(undefined),
    };
    productRepository = { findById: vi.fn() };
    memberRepository = { findById: vi.fn().mockImplementation(async (id: number) => ({ id, user_id: 10 })) };
    auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };
    domainEventBus = { emit: vi.fn().mockResolvedValue(undefined) };
    paymentService = { create: vi.fn().mockResolvedValue({ id: 50 }) };
    paginationHelper = new PaginationHelper({
      getDefaultPageSize: vi.fn().mockResolvedValue(20),
    } as any);

    service = new MembershipService(
      repository as unknown as MembershipRepository,
      productRepository as unknown as MembershipProductRepository,
      memberRepository as unknown as MemberRepository,
      paginationHelper,
      auditService as unknown as AuditService,
      domainEventBus as unknown as DomainEventBus,
      paymentService as any,
      { transaction: vi.fn((cb: any) => cb({})) } as unknown as DrizzleDb<any>,
    );
  });

  describe('create', () => {
    it('rejects a second active/frozen membership for the same member (FR-MEMB-006)', async () => {
      memberRepository.findById.mockResolvedValue({ id: 100 });
      productRepository.findById.mockResolvedValue(makeProduct());
      repository.findActiveOrFrozenForMember.mockResolvedValue(makeMembership());

      await expect(
        service.create(
          { member_id: 100, product_id: 1, start_date: '2026-02-01', payment_method_id: 1 },
          ADMIN_USER,
        ),
      ).rejects.toThrow(BusinessRuleError);
      expect(repository.insertMembership).not.toHaveBeenCalled();
    });

    it('rejects a locker already held by an active/frozen membership (BR-MEMB-004)', async () => {
      memberRepository.findById.mockResolvedValue({ id: 100 });
      productRepository.findById.mockResolvedValue(makeProduct());
      repository.findByLockerNumberActiveOrFrozen.mockResolvedValue(makeMembership({ id: 2 }));

      await expect(
        service.create(
          {
            member_id: 100,
            product_id: 1,
            start_date: '2026-02-01',
            payment_method_id: 1,
            locker_number: 'L1',
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow(ConflictError);
    });

    it('computes end_date = start_date + duration_days and writes a created history row', async () => {
      memberRepository.findById.mockResolvedValue({ id: 100 });
      productRepository.findById.mockResolvedValue(makeProduct({ duration_days: 30 }));
      repository.insertMembership.mockResolvedValue(5);
      repository.findByIdWithProduct.mockResolvedValue({ ...makeMembership({ id: 5 }), product: makeProduct() });

      await service.create(
        { member_id: 100, product_id: 1, start_date: '2026-01-01', payment_method_id: 9 },
        ADMIN_USER,
      );

      expect(repository.insertMembership).toHaveBeenCalledWith(
        expect.objectContaining({ end_date: '2026-01-31', status: 'active', row_version: 1 }),
      );
      expect(repository.insertHistory).toHaveBeenCalledWith(
        expect.objectContaining({ membership_id: 5, action: 'created' }),
      );
      expect(auditService.recordAudit).toHaveBeenCalledTimes(1);
      expect(paymentService.create).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 100,
          membership_id: 5,
          payment_method_id: 9,
          subtotal: '1299.00',
        }),
        ADMIN_USER,
      );
    });

    describe('couple packages (CM-07)', () => {
      it('rejects a couple product without a partner', async () => {
        memberRepository.findById.mockResolvedValue({ id: 100 });
        productRepository.findById.mockResolvedValue(makeProduct({ package_type: 'couple' }));

        await expect(
          service.create(
            { member_id: 100, product_id: 1, start_date: '2026-02-01', payment_method_id: 1 },
            ADMIN_USER,
          ),
        ).rejects.toThrow(BadRequestError);
        expect(repository.insertMembership).not.toHaveBeenCalled();
      });

      it('rejects a single product with a partner', async () => {
        memberRepository.findById.mockResolvedValue({ id: 100 });
        productRepository.findById.mockResolvedValue(makeProduct({ package_type: 'single' }));

        await expect(
          service.create(
            {
              member_id: 100,
              product_id: 1,
              start_date: '2026-02-01',
              payment_method_id: 1,
              partner_member_id: 200,
            },
            ADMIN_USER,
          ),
        ).rejects.toThrow(BadRequestError);
      });

      it('rejects a member picked as their own partner', async () => {
        memberRepository.findById.mockResolvedValue({ id: 100 });
        productRepository.findById.mockResolvedValue(makeProduct({ package_type: 'couple' }));

        await expect(
          service.create(
            {
              member_id: 100,
              product_id: 1,
              start_date: '2026-02-01',
              payment_method_id: 1,
              partner_member_id: 100,
            },
            ADMIN_USER,
          ),
        ).rejects.toThrow(BadRequestError);
      });

      it('rejects replacing a partner membership without the confirmation flag', async () => {
        memberRepository.findById.mockImplementation(async (id: number) => ({ id }));
        productRepository.findById.mockResolvedValue(makeProduct({ package_type: 'couple' }));
        repository.findActiveOrFrozenForMember.mockImplementation(async (memberId: number) =>
          memberId === 200 ? makeMembership({ id: 9, member_id: 200 }) : null,
        );

        await expect(
          service.create(
            {
              member_id: 100,
              product_id: 1,
              start_date: '2026-02-01',
              payment_method_id: 1,
              partner_member_id: 200,
            },
            ADMIN_USER,
          ),
        ).rejects.toThrow(BusinessRuleError);
        expect(repository.insertMembership).not.toHaveBeenCalled();
      });

      it('rejects replacing a partner who is already in a couple membership', async () => {
        memberRepository.findById.mockImplementation(async (id: number) => ({ id }));
        productRepository.findById.mockImplementation(async (id: number) =>
          id === 1 ? makeProduct({ id: 1, package_type: 'couple' }) : makeProduct({ id: 2, package_type: 'couple' }),
        );
        repository.findActiveOrFrozenForMember.mockImplementation(async (memberId: number) =>
          memberId === 200 ? makeMembership({ id: 9, member_id: 200, product_id: 2 }) : null,
        );

        await expect(
          service.create(
            {
              member_id: 100,
              product_id: 1,
              start_date: '2026-02-01',
              payment_method_id: 1,
              partner_member_id: 200,
              replace_partner_membership: true,
            },
            ADMIN_USER,
          ),
        ).rejects.toThrow(BusinessRuleError);
        expect(repository.insertMembership).not.toHaveBeenCalled();
      });

      it('rejects a discount outside 0..base_price', async () => {
        memberRepository.findById.mockResolvedValue({ id: 100 });
        productRepository.findById.mockResolvedValue(makeProduct({ base_price: '100.00' }));

        await expect(
          service.create(
            {
              member_id: 100,
              product_id: 1,
              start_date: '2026-02-01',
              payment_method_id: 1,
              discount_amount: '150.00',
            },
            ADMIN_USER,
          ),
        ).rejects.toThrow(BadRequestError);
      });

      it('creates two cross-linked rows, cancels the replaced partner row, and pays with the discount', async () => {
        memberRepository.findById.mockImplementation(async (id: number) => ({ id }));
        productRepository.findById.mockImplementation(async (id: number) => {
          if (id === 1) return makeProduct({ id: 1, package_type: 'couple', base_price: '2000.00', duration_days: 30 });
          return makeProduct({ id: 2, package_type: 'single' });
        });
        const partnerExisting = makeMembership({ id: 9, member_id: 200, product_id: 2, row_version: 1 });
        repository.findActiveOrFrozenForMember.mockImplementation(async (memberId: number) =>
          memberId === 200 ? partnerExisting : null,
        );
        repository.insertMembership.mockResolvedValueOnce(5).mockResolvedValueOnce(6);
        repository.findByIdWithProduct.mockResolvedValue(
          makeMembershipWithProduct({ id: 5, partner_membership_id: 6 }, { id: 1, package_type: 'couple' }),
        );

        await service.create(
          {
            member_id: 100,
            product_id: 1,
            start_date: '2026-02-01',
            payment_method_id: 1,
            partner_member_id: 200,
            replace_partner_membership: true,
            discount_amount: '300.00',
          },
          ADMIN_USER,
        );

        expect(repository.updateMembership).toHaveBeenCalledWith(
          9,
          expect.objectContaining({ status: 'cancelled', row_version: 2 }),
        );
        expect(repository.insertMembership).toHaveBeenNthCalledWith(
          1,
          expect.objectContaining({ member_id: 100, product_id: 1 }),
        );
        expect(repository.insertMembership).toHaveBeenNthCalledWith(
          2,
          expect.objectContaining({ member_id: 200, product_id: 1, partner_membership_id: 5 }),
        );
        expect(repository.setPartner).toHaveBeenCalledWith(5, 6);
        expect(paymentService.create).toHaveBeenCalledWith(
          expect.objectContaining({
            member_id: 100,
            membership_id: 5,
            subtotal: '2000.00',
            discount_amount: '300.00',
          }),
          ADMIN_USER,
        );
        expect(auditService.recordAudit).toHaveBeenCalledWith(
          expect.objectContaining({
            action: 'membership.cancelled',
            entityId: 9,
            afterState: expect.objectContaining({ reason: 'replaced_by_couple' }),
          }),
        );
      });
    });
  });

  describe('getReplacementPreview (CM-06)', () => {
    it('404s when the member has no active or frozen membership', async () => {
      repository.findActiveOrFrozenForMember.mockResolvedValue(null);

      await expect(service.getReplacementPreview(100)).rejects.toThrow(NotFoundError);
    });

    it('computes remaining days and a pro-rated credit for a membership mid-term', async () => {
      repository.findActiveOrFrozenForMember.mockResolvedValue(
        makeMembership({ start_date: '2026-01-01', end_date: '2026-01-31' }),
      );
      productRepository.findById.mockResolvedValue(
        makeProduct({ base_price: '300.00', duration_days: 30, package_type: 'single' }),
      );
      vi.setSystemTime(new Date('2026-01-11T00:00:00.000Z'));

      const preview = await service.getReplacementPreview(100);

      expect(preview.remaining_days).toBe(20);
      expect(preview.suggested_credit).toBe('200.00');
      expect(preview.is_couple).toBe(false);
      vi.useRealTimers();
    });

    it('caps the credit at base_price for a membership that has not started yet', async () => {
      repository.findActiveOrFrozenForMember.mockResolvedValue(
        makeMembership({ start_date: '2026-02-01', end_date: '2026-03-03' }),
      );
      productRepository.findById.mockResolvedValue(
        makeProduct({ base_price: '300.00', duration_days: 30, package_type: 'couple' }),
      );
      vi.setSystemTime(new Date('2026-01-11T00:00:00.000Z'));

      const preview = await service.getReplacementPreview(100);

      expect(preview.remaining_days).toBe(30);
      expect(preview.suggested_credit).toBe('300.00');
      expect(preview.is_couple).toBe(true);
      vi.useRealTimers();
    });

    it('computes a pro-rated credit for a frozen membership', async () => {
      repository.findActiveOrFrozenForMember.mockResolvedValue(
        makeMembership({ status: 'frozen', start_date: '2026-01-01', end_date: '2026-01-31' }),
      );
      productRepository.findById.mockResolvedValue(
        makeProduct({ base_price: '300.00', duration_days: 30, package_type: 'single' }),
      );
      vi.setSystemTime(new Date('2026-01-11T00:00:00.000Z'));

      const preview = await service.getReplacementPreview(100);

      expect(preview.status).toBe('frozen');
      expect(preview.remaining_days).toBe(20);
      expect(preview.suggested_credit).toBe('200.00');
      vi.useRealTimers();
    });

    it('returns zero remaining days and zero credit for a membership ending today', async () => {
      repository.findActiveOrFrozenForMember.mockResolvedValue(
        makeMembership({ start_date: '2026-01-01', end_date: '2026-01-11' }),
      );
      productRepository.findById.mockResolvedValue(
        makeProduct({ base_price: '300.00', duration_days: 10, package_type: 'single' }),
      );
      vi.setSystemTime(new Date('2026-01-11T00:00:00.000Z'));

      const preview = await service.getReplacementPreview(100);

      expect(preview.remaining_days).toBe(0);
      expect(preview.suggested_credit).toBe('0.00');
      vi.useRealTimers();
    });
  });

  describe('renew', () => {
    it('throws a conflict when row_version does not match', async () => {
      repository.findById.mockResolvedValue(makeMembership({ row_version: 3 }));

      await expect(service.renew(1, { row_version: 1 }, ADMIN_USER)).rejects.toThrow();
      expect(repository.updateMembership).not.toHaveBeenCalled();
    });

    it('continues from the day after the current end_date and leaves the retired PT counter alone', async () => {
      repository.findById.mockResolvedValue(
        makeMembership({ end_date: '2099-01-31', remaining_pt_sessions: 2, row_version: 1 }),
      );
      productRepository.findById.mockResolvedValue(makeProduct({ duration_days: 30, pt_sessions_included: 4 }));
      repository.findByIdWithProduct.mockResolvedValue({ ...makeMembership(), product: makeProduct() });

      await service.renew(1, { row_version: 1 }, ADMIN_USER);

      expect(repository.updateMembership).toHaveBeenCalledWith(
        1,
        expect.objectContaining({
          end_date: '2099-03-03',
          row_version: 2,
        }),
        1,
      );
      expect(repository.updateMembership.mock.calls[0][1]).not.toHaveProperty('remaining_pt_sessions');
    });
  });

  describe('cancel', () => {
    it('sets status to cancelled and bumps row_version', async () => {
      repository.findById.mockResolvedValue(makeMembership({ row_version: 1 }));
      repository.findByIdWithProduct.mockResolvedValue({ ...makeMembership({ status: 'cancelled' }), product: null });

      await service.cancel(1, { row_version: 1 }, ADMIN_USER);

      expect(repository.updateMembership).toHaveBeenCalledWith(
        1,
        expect.objectContaining({ status: 'cancelled', row_version: 2 }),
      );
    });
  });

  describe('requestFreeze', () => {
    it('rejects overlapping freeze windows (FR-MEMB-018)', async () => {
      repository.findById.mockResolvedValue(makeMembership());
      repository.findOverlappingFreeze.mockResolvedValue({ id: 9 });

      await expect(
        service.requestFreeze(1, { start_date: '2026-01-10', end_date: '2026-01-15' }, MEMBER_USER),
      ).rejects.toThrow(BusinessRuleError);
    });

    it('creates a pending freeze for a member without touching the membership', async () => {
      repository.findById.mockResolvedValue(makeMembership({ member_id: 100 }));
      repository.insertFreeze.mockResolvedValue(1);
      repository.findFreezeById.mockResolvedValue({ id: 1, status: 'pending' });

      await service.requestFreeze(
        1,
        { start_date: '2026-01-10', end_date: '2026-01-15' },
        { ...MEMBER_USER, profileId: 100 },
      );

      expect(repository.insertFreeze).toHaveBeenCalledWith(
        expect.objectContaining({ status: 'pending', total_freeze_days: 6 }),
      );
      expect(repository.updateMembership).not.toHaveBeenCalled();
    });

    it('rejects an admin-direct freeze that exceeds product.max_freeze_days (FR-MEMB-017)', async () => {
      repository.findById.mockResolvedValue(makeMembership());
      productRepository.findById.mockResolvedValue(makeProduct({ max_freeze_days: 3 }));
      repository.sumApprovedFreezeDays.mockResolvedValue(0);

      await expect(
        service.requestFreeze(1, { start_date: '2026-01-10', end_date: '2026-01-15' }, ADMIN_USER),
      ).rejects.toThrow(BusinessRuleError);
      expect(repository.insertFreeze).not.toHaveBeenCalled();
    });

    it('applies an admin-direct freeze immediately, shifting end_date and writing history', async () => {
      repository.findById.mockResolvedValue(makeMembership({ end_date: '2026-01-31', row_version: 1 }));
      productRepository.findById.mockResolvedValue(makeProduct({ max_freeze_days: 15 }));
      repository.sumApprovedFreezeDays.mockResolvedValue(0);
      repository.insertFreeze.mockResolvedValue(2);
      repository.findFreezeById.mockResolvedValue({ id: 2, status: 'approved' });

      await service.requestFreeze(1, { start_date: '2026-01-10', end_date: '2026-01-15' }, ADMIN_USER);

      expect(repository.updateMembership).toHaveBeenCalledWith(
        1,
        expect.objectContaining({ status: 'frozen', end_date: '2026-02-06', row_version: 2 }),
      );
      expect(repository.insertHistory).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'frozen' }),
      );
    });
  });

  describe('approveFreeze', () => {
    it('rejects approving a non-pending freeze', async () => {
      repository.findFreezeById.mockResolvedValue({ id: 1, status: 'approved' });

      await expect(service.approveFreeze(1, ADMIN_USER)).rejects.toThrow(BusinessRuleError);
    });

    it('enforces the freeze quota at approval time', async () => {
      repository.findFreezeById.mockResolvedValue({
        id: 1,
        membership_id: 1,
        status: 'pending',
        total_freeze_days: 10,
      });
      repository.findById.mockResolvedValue(makeMembership());
      productRepository.findById.mockResolvedValue(makeProduct({ max_freeze_days: 15 }));
      repository.sumApprovedFreezeDays.mockResolvedValue(10);

      await expect(service.approveFreeze(1, ADMIN_USER)).rejects.toThrow(BusinessRuleError);
      expect(repository.updateFreeze).not.toHaveBeenCalled();
    });
  });

  describe('extend', () => {
    it('member cannot self-extend — enforced by the memberships.approve permission at the controller', async () => {
      repository.findById.mockResolvedValue(makeMembership({ end_date: '2026-01-31' }));
      repository.insertExtension.mockResolvedValue(1);

      const result = await service.extend(1, { days_extended: 5 }, ADMIN_USER);

      expect(repository.updateMembership).toHaveBeenCalledWith(
        1,
        expect.objectContaining({ end_date: '2026-02-05' }),
      );
      expect(result.days_extended).toBe(5);
    });
  });

  describe('present (trainer pricing/locker hiding)', () => {
    it('hides the nested product and locker_number for trainer reads', async () => {
      const trainer: AuthenticatedUser = { ...ADMIN_USER, userType: 'trainer', profileId: 7 };
      repository.findByIdWithProduct.mockResolvedValue({
        ...makeMembership({ locker_number: 'L1' }),
        product: makeProduct(),
      });
      memberRepository.findById.mockResolvedValue({ id: 100, assigned_trainer_id: 7 });

      const result = await service.getById(1, trainer);

      expect(result.product).toBeNull();
      expect(result.locker_number).toBeNull();
    });

    it('404s for a trainer not assigned to the member', async () => {
      const trainer: AuthenticatedUser = { ...ADMIN_USER, userType: 'trainer', profileId: 7 };
      repository.findByIdWithProduct.mockResolvedValue({ ...makeMembership(), product: makeProduct() });
      memberRepository.findById.mockResolvedValue({ id: 100, assigned_trainer_id: 99 });

      await expect(service.getById(1, trainer)).rejects.toThrow(NotFoundError);
    });
  });

  describe('present (CM-05 partner fields)', () => {
    it('includes partner fields for a linked row and null for a single row', async () => {
      repository.findByIdWithProduct.mockResolvedValue(
        makeMembershipWithProduct(
          { id: 1, partner_membership_id: 6 },
          { package_type: 'couple' },
        ),
      );
      (repository.findByIdWithProduct as any).mockResolvedValueOnce({
        ...makeMembershipWithProduct({ id: 1, partner_membership_id: 6 }, { package_type: 'couple' }),
        partner_member_id: 200,
        partner_member_name: 'Priya Shah',
      });

      const linked = await service.getById(1, ADMIN_USER);
      expect(linked.partner_membership_id).toBe(6);
      expect(linked.partner_member_id).toBe(200);
      expect(linked.partner_member_name).toBe('Priya Shah');

      repository.findByIdWithProduct.mockResolvedValue(makeMembershipWithProduct());
      const single = await service.getById(1, ADMIN_USER);
      expect(single.partner_membership_id).toBeNull();
      expect(single.partner_member_id).toBeNull();
      expect(single.partner_member_name).toBeNull();
    });

    it('hides partner_membership_id and partner_member_id for a member-scoped read, keeping only the name', async () => {
      repository.findByIdWithProduct.mockResolvedValue({
        ...makeMembershipWithProduct({ id: 1, member_id: 100, partner_membership_id: 6 }, { package_type: 'couple' }),
        partner_member_id: 200,
        partner_member_name: 'Priya Shah',
      });

      const result = await service.getById(1, { ...MEMBER_USER, profileId: 100 });

      expect(result.partner_membership_id).toBeNull();
      expect(result.partner_member_id).toBeNull();
      expect(result.partner_member_name).toBe('Priya Shah');
    });
  });

  describe('createOrRenewForPayment', () => {
    it('creates new membership when none exists and emits membership.created', async () => {
      repository.findActiveOrFrozenForMember.mockResolvedValue(null);
      productRepository.findById.mockResolvedValue(makeProduct({ id: 2, duration_days: 60, pt_sessions_included: 8 }));
      repository.insertMembership.mockResolvedValue(10);

      const now = new Date('2026-03-01T10:00:00.000Z');
      const membershipId = await service.createOrRenewForPayment({
        memberId: 100,
        productId: 2,
        actor: ADMIN_USER,
        now,
      });

      expect(membershipId).toBe(10);
      expect(repository.insertMembership).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 100,
          product_id: 2,
          start_date: '2026-03-01',
          end_date: '2026-04-30',
          status: 'active',
        }),
      );
      expect(domainEventBus.emit).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'membership.created',
          payload: expect.objectContaining({ membershipId: 10, memberId: 100 }),
        }),
      );
    });

    it('renews existing active membership, supports product switching and emits membership.renewed', async () => {
      const existing = makeMembership({
        id: 5,
        product_id: 1,
        status: 'active',
        start_date: '2026-01-01',
        end_date: '2026-01-31',
        remaining_pt_sessions: 2,
        row_version: 3,
      });
      repository.findActiveOrFrozenForMember.mockResolvedValue(existing);
      productRepository.findById.mockResolvedValue(makeProduct({ id: 2, duration_days: 30, pt_sessions_included: 6 }));

      const now = new Date('2026-01-15T12:00:00.000Z');
      const membershipId = await service.createOrRenewForPayment({
        memberId: 100,
        productId: 2,
        expectedRowVersion: 3,
        actor: ADMIN_USER,
        now,
      });

      expect(membershipId).toBe(5);
      expect(repository.updateMembership).toHaveBeenCalledWith(
        5,
        expect.objectContaining({
          product_id: 2,
          end_date: '2026-03-03',
          status: 'active',
          row_version: 4,
        }),
        3,
      );
      expect(domainEventBus.emit).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'membership.renewed',
          payload: { membershipId: 5 },
        }),
      );
    });

    it('rejects renewal when expectedRowVersion mismatches', async () => {
      const existing = makeMembership({
        id: 5,
        row_version: 3,
      });
      repository.findActiveOrFrozenForMember.mockResolvedValue(existing);
      productRepository.findById.mockResolvedValue(makeProduct({ id: 1 }));

      const now = new Date('2026-01-15T12:00:00.000Z');
      await expect(
        service.createOrRenewForPayment({
          memberId: 100,
          productId: 1,
          expectedRowVersion: 2,
          actor: ADMIN_USER,
          now,
        }),
      ).rejects.toThrow(ConflictError);
    });

    it('throws NotFoundError if product not found', async () => {
      productRepository.findById.mockResolvedValue(null);

      await expect(
        service.createOrRenewForPayment({
          memberId: 100,
          productId: 999,
          actor: ADMIN_USER,
        }),
      ).rejects.toThrow(NotFoundError);
    });
  });
});
