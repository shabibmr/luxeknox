import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { MembershipProductRepository } from '../memb/membership-product.repository';
import { MembershipRepository } from '../memb/membership.repository';
import { MembershipService } from '../memb/membership.service';
import { MemberRepository } from '../people/member.repository';
import { assertMemberAccess } from '../people/row-scope';
import { AuditService } from '../platform/audit/audit.service';
import { verifyRowVersion } from '../platform/concurrency/row-version';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { Payment, PaymentHistory, PaymentReceipt } from '../platform/db/schema/payments';
import { runInTransaction } from '../platform/db/transaction-context';
import {
  BadRequestError,
  BusinessRuleError,
  NotFoundError,
} from '../platform/errors/app-error';
import { DomainEventBus } from '../platform/events/domain-events';
import {
  addMoney,
  cmpMoney,
  mulMoneyPercent,
  roundMoney,
  subMoney,
} from '../platform/money/money';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import { SettingsService } from '../sys/settings.service';
import type {
  PaymentAdjustDto,
  PaymentCreateDto,
  PaymentDto,
  PaymentHistoryDto,
  PaymentReceiptDto,
} from './payment.dto';
import { PaymentMethodRepository } from './payment-method.repository';
import { PaymentRepository, type PaymentListScope } from './payment.repository';

@Injectable()
export class PaymentService {
  constructor(
    private readonly repository: PaymentRepository,
    private readonly methodRepository: PaymentMethodRepository,
    private readonly memberRepository: MemberRepository,
    private readonly membershipRepository: MembershipRepository,
    private readonly productRepository: MembershipProductRepository,
    private readonly membershipService: MembershipService,
    private readonly settingsService: SettingsService,
    private readonly auditService: AuditService,
    private readonly domainEventBus: DomainEventBus,
    private readonly paginationHelper: PaginationHelper,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  private listScope(actor: AuthenticatedUser): PaymentListScope {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return { type: 'all' };
    }
    if (actor.userType === 'trainer') {
      if (actor.profileId == null) {
        return { type: 'trainer', trainerProfileId: -1 };
      }
      return { type: 'trainer', trainerProfileId: actor.profileId };
    }
    if (actor.profileId == null) {
      return { type: 'self', memberProfileId: -1 };
    }
    return { type: 'self', memberProfileId: actor.profileId };
  }

  /** PAY-007: admin/employee all; member own; trainer assigned members. */
  private async assertReadScope(actor: AuthenticatedUser, payment: Payment): Promise<void> {
    try {
      await assertMemberAccess(this.memberRepository, actor, payment.member_id);
    } catch (err) {
      // Uniform 404 with getById so callers cannot tell missing vs unauthorized payment.
      if (err instanceof NotFoundError) {
        throw new NotFoundError('Payment not found');
      }
      throw err;
    }
  }

  toHistoryDto(row: PaymentHistory): PaymentHistoryDto {
    return {
      id: row.id,
      payment_id: row.payment_id,
      payment_method_id: row.payment_method_id,
      action: row.action,
      amount: roundMoney(String(row.amount)),
      notes: row.notes,
      timestamp: row.timestamp.toISOString(),
    };
  }

  toDto(row: Payment, histories?: PaymentHistory[]): PaymentDto {
    return {
      id: row.id,
      invoice_number: row.invoice_number,
      member_id: row.member_id,
      membership_id: row.membership_id,
      payment_method_id: row.payment_method_id,
      subtotal: roundMoney(String(row.subtotal)),
      tax_amount: roundMoney(String(row.tax_amount)),
      discount_amount: roundMoney(String(row.discount_amount)),
      total_amount: roundMoney(String(row.total_amount)),
      amount_paid: roundMoney(String(row.amount_paid)),
      status: row.status,
      transaction_reference: row.transaction_reference,
      cashier_user_id: row.cashier_user_id,
      payment_date: row.payment_date.toISOString(),
      row_version: row.row_version,
      ...(histories ? { histories: histories.map((h) => this.toHistoryDto(h)) } : {}),
    };
  }

  toReceiptDto(row: PaymentReceipt, payment?: PaymentDto): PaymentReceiptDto {
    return {
      id: row.id,
      payment_id: row.payment_id,
      receipt_number: row.receipt_number,
      receipt_pdf_url: row.receipt_pdf_url,
      generated_at: row.generated_at.toISOString(),
      ...(payment ? { payment } : {}),
    };
  }

  /**
   * Server-side tax/discount (PAY-004).
   * taxable = subtotal - discount; tax = taxable * tax_rate%; total = taxable + tax.
   */
  async computeTotals(
    subtotalRaw: string,
    discountRaw?: string,
  ): Promise<{ subtotal: string; discount: string; tax: string; total: string }> {
    const subtotal = roundMoney(subtotalRaw);
    const discount = roundMoney(discountRaw ?? '0');
    if (cmpMoney(discount, subtotal) > 0) {
      throw new BadRequestError('discount_amount cannot exceed subtotal');
    }
    if (cmpMoney(subtotal, '0') < 0) {
      throw new BadRequestError('subtotal must be non-negative');
    }
    const taxable = subMoney(subtotal, discount);
    const taxRate = await this.settingsService.getTaxRatePercent();
    const tax = mulMoneyPercent(taxable, taxRate);
    const total = addMoney(taxable, tax);
    return { subtotal, discount, tax, total };
  }

  resolveStatus(total: string, amountPaid: string): 'pending' | 'partial' | 'paid' | 'refunded' {
    if (cmpMoney(amountPaid, '0') <= 0) {
      return cmpMoney(total, '0') <= 0 ? 'refunded' : 'pending';
    }
    if (cmpMoney(amountPaid, total) >= 0) return 'paid';
    return 'partial';
  }

  private netPaidFromHistories(histories: PaymentHistory[]): string {
    let net = '0.00';
    for (const h of histories) {
      const amt = roundMoney(String(h.amount));
      if (h.action === 'payment_received') net = addMoney(net, amt);
      else if (h.action === 'refunded') net = subMoney(net, amt);
    }
    return net;
  }

  private async ensureReceipt(paymentId: number, now: Date): Promise<PaymentReceipt> {
    const existing = await this.repository.findReceiptByPaymentId(paymentId);
    if (existing) return existing;
    const receiptNumber = await this.repository.allocateReceiptNumber();
    return this.repository.insertReceipt({
      payment_id: paymentId,
      receipt_number: receiptNumber,
      receipt_pdf_url: null,
      generated_at: now,
    });
  }

  async create(dto: PaymentCreateDto, actor: AuthenticatedUser): Promise<PaymentDto> {
    const member = await this.memberRepository.findById(dto.member_id);
    if (!member) {
      throw new NotFoundError('Member not found');
    }

    const totals = await this.computeTotals(dto.subtotal, dto.discount_amount);

    const tenders =
      dto.tenders?.map((t) => ({
        payment_method_id: t.payment_method_id,
        amount: roundMoney(t.amount),
        transaction_reference: t.transaction_reference,
      })) ?? [];

    if (dto.payment_method_id != null && tenders.length === 0) {
      tenders.push({
        payment_method_id: dto.payment_method_id,
        amount: totals.total,
        transaction_reference: dto.transaction_reference,
      });
    }

    for (const tender of tenders) {
      if (cmpMoney(tender.amount, '0') <= 0) {
        throw new BadRequestError('Each tender amount must be positive');
      }
      const method = await this.methodRepository.findById(tender.payment_method_id);
      if (!method || !method.is_active) {
        throw new NotFoundError(`Payment method ${tender.payment_method_id} not found or inactive`);
      }
    }

    const amountPaid = tenders.reduce((sum, t) => addMoney(sum, t.amount), '0.00');
    if (cmpMoney(amountPaid, totals.total) > 0) {
      throw new BusinessRuleError('Tender total cannot exceed invoice total');
    }

    const status = this.resolveStatus(totals.total, amountPaid);
    const headerMethodId =
      tenders.length === 1
        ? tenders[0].payment_method_id
        : tenders.length === 0
          ? (dto.payment_method_id ?? null)
          : null;

    const allowPartialActivation =
      await this.settingsService.getPaymentsActivateMembershipOnPartial();
    const shouldActivateMembership =
      dto.product_id != null &&
      (status === 'paid' || (status === 'partial' && allowPartialActivation));

    return runInTransaction(this.db, async () => {
      const now = new Date();
      const invoiceNumber = await this.repository.allocateInvoiceNumber();

      let membershipId: number | null = dto.membership_id ?? null;
      if (shouldActivateMembership && dto.product_id != null) {
        membershipId = await this.membershipService.createOrRenewForPayment({
          memberId: dto.member_id,
          productId: dto.product_id,
          membershipId: dto.membership_id ?? null,
          startDate: dto.start_date,
          expectedRowVersion: dto.expected_row_version,
          actor,
          now,
        });
      }

      const created = await this.repository.insertPayment({
        invoice_number: invoiceNumber,
        member_id: dto.member_id,
        membership_id: membershipId,
        payment_method_id: headerMethodId,
        subtotal: totals.subtotal,
        tax_amount: totals.tax,
        discount_amount: totals.discount,
        total_amount: totals.total,
        amount_paid: amountPaid,
        status,
        transaction_reference: dto.transaction_reference ?? null,
        cashier_user_id: actor.id,
        payment_date: now,
        row_version: 1,
        created_at: now,
        updated_at: now,
      });

      const histories: PaymentHistory[] = [];
      for (const tender of tenders) {
        const history = await this.repository.insertHistory({
          payment_id: created.id,
          payment_method_id: tender.payment_method_id,
          action: 'payment_received',
          amount: tender.amount,
          notes: tender.transaction_reference ?? null,
          timestamp: now,
        });
        histories.push(history);
      }

      if (status === 'paid') {
        await this.ensureReceipt(created.id, now);
      }

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'payment.created',
        entityName: 'payments',
        entityId: created.id,
        afterState: {
          invoice_number: invoiceNumber,
          total_amount: totals.total,
          amount_paid: amountPaid,
          status,
          tender_count: tenders.length,
          membership_id: membershipId,
        },
      });

      await this.domainEventBus.emit({
        eventName: status === 'paid' ? 'payment.settled' : 'payment.created',
        occurredAt: now,
        payload: {
          payment_id: created.id,
          invoice_number: invoiceNumber,
          member_id: dto.member_id,
          status,
        },
      });

      return this.toDto(created, histories);
    });
  }

  async list(
    query: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<PaymentDto>> {
    const pagination = await this.paginationHelper.normalizeParams(query);
    const offset = pagination.offset ?? 0;
    const memberId =
      query.member_id != null && query.member_id !== ''
        ? Number(query.member_id)
        : undefined;
    const status = typeof query.status === 'string' ? query.status : undefined;
    const scope = this.listScope(actor);
    const { rows, total } = await this.repository.findManyFiltered({
      memberId: Number.isFinite(memberId) ? memberId : undefined,
      status,
      scope,
      limit: pagination.limit,
      offset,
    });
    return createPaginatedResponse({
      items: rows.map((r) => this.toDto(r)),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  /** PAY-006 */
  async listOutstanding(
    query: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<PaymentDto>> {
    const pagination = await this.paginationHelper.normalizeParams(query);
    const offset = pagination.offset ?? 0;
    const scope = this.listScope(actor);
    const { rows, total } = await this.repository.findManyFiltered({
      statuses: ['pending', 'partial'],
      outstandingOnly: true,
      scope,
      limit: pagination.limit,
      offset,
    });
    return createPaginatedResponse({
      items: rows.map((r) => this.toDto(r)),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async getById(id: number, actor: AuthenticatedUser): Promise<PaymentDto> {
    const row = await this.repository.findById(id);
    if (!row) throw new NotFoundError('Payment not found');
    await this.assertReadScope(actor, row);
    // FR-PAY-008: trainers see header only — no history line items.
    if (actor.userType === 'trainer') {
      return this.toDto(row);
    }
    const histories = await this.repository.listHistories(id);
    return this.toDto(row, histories);
  }

  /** PAY-009 */
  async refund(
    id: number,
    dto: PaymentAdjustDto,
    actor: AuthenticatedUser,
  ): Promise<PaymentDto> {
    const amount = roundMoney(dto.amount);
    if (cmpMoney(amount, '0') <= 0) {
      throw new BadRequestError('Refund amount must be positive');
    }
    if (dto.payment_method_id != null) {
      const method = await this.methodRepository.findById(dto.payment_method_id);
      if (!method || !method.is_active) {
        throw new NotFoundError('Payment method not found or inactive');
      }
    }

    return runInTransaction(this.db, async () => {
      const row = await this.repository.findById(id);
      if (!row) throw new NotFoundError('Payment not found');
      if (dto.row_version != null) {
        verifyRowVersion(dto.row_version, row.row_version);
      }

      const histories = await this.repository.listHistories(id);
      const netPaid = this.netPaidFromHistories(histories);
      if (cmpMoney(amount, netPaid) > 0) {
        throw new BusinessRuleError('Refund cannot exceed net amount paid');
      }

      const now = new Date();
      const newAmountPaid = subMoney(roundMoney(String(row.amount_paid)), amount);
      const newStatus =
        cmpMoney(newAmountPaid, '0') <= 0
          ? 'refunded'
          : this.resolveStatus(roundMoney(String(row.total_amount)), newAmountPaid);

      const history = await this.repository.insertHistory({
        payment_id: id,
        payment_method_id: dto.payment_method_id ?? null,
        action: 'refunded',
        amount,
        notes: dto.notes ?? null,
        timestamp: now,
      });

      const updated = await this.repository.updatePayment(id, {
        amount_paid: newAmountPaid,
        status: newStatus,
        row_version: row.row_version + 1,
        updated_at: now,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'payment.refunded',
        entityName: 'payments',
        entityId: id,
        beforeState: { amount_paid: row.amount_paid, status: row.status },
        afterState: { amount_paid: newAmountPaid, status: newStatus, refund: amount },
      });

      await this.domainEventBus.emit({
        eventName: 'payment.refunded',
        occurredAt: now,
        payload: { payment_id: id, amount, status: newStatus },
      });

      return this.toDto(updated, [...histories, history]);
    });
  }

  /** PAY-010: adjust total_amount by signed amount; history is append-only. */
  async adjust(
    id: number,
    dto: PaymentAdjustDto,
    actor: AuthenticatedUser,
  ): Promise<PaymentDto> {
    const amount = roundMoney(dto.amount);
    if (cmpMoney(amount, '0') === 0) {
      throw new BadRequestError('Adjustment amount must be non-zero');
    }

    return runInTransaction(this.db, async () => {
      const row = await this.repository.findById(id);
      if (!row) throw new NotFoundError('Payment not found');
      if (dto.row_version != null) {
        verifyRowVersion(dto.row_version, row.row_version);
      }

      const now = new Date();
      const newTotal = addMoney(roundMoney(String(row.total_amount)), amount);
      if (cmpMoney(newTotal, '0') < 0) {
        throw new BusinessRuleError('Adjusted total_amount cannot be negative');
      }

      const amountPaid = roundMoney(String(row.amount_paid));
      const newStatus =
        row.status === 'refunded' && cmpMoney(amountPaid, '0') <= 0
          ? 'refunded'
          : this.resolveStatus(newTotal, amountPaid);

      const history = await this.repository.insertHistory({
        payment_id: id,
        payment_method_id: dto.payment_method_id ?? null,
        action: 'adjusted',
        amount,
        notes: dto.notes ?? null,
        timestamp: now,
      });

      const updated = await this.repository.updatePayment(id, {
        total_amount: newTotal,
        status: newStatus,
        row_version: row.row_version + 1,
        updated_at: now,
      });

      const histories = await this.repository.listHistories(id);

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'payment.adjusted',
        entityName: 'payments',
        entityId: id,
        beforeState: { total_amount: row.total_amount, status: row.status },
        afterState: { total_amount: newTotal, status: newStatus, adjustment: amount },
      });

      return this.toDto(updated, histories.length ? histories : [history]);
    });
  }

  /** PAY-011 */
  async getReceipt(id: number, actor: AuthenticatedUser): Promise<PaymentReceiptDto> {
    const row = await this.repository.findById(id);
    if (!row) throw new NotFoundError('Payment not found');
    await this.assertReadScope(actor, row);

    if (row.status !== 'paid' && row.status !== 'partial' && row.status !== 'refunded') {
      // Unpaid pending invoices have no receipt.
      if (cmpMoney(roundMoney(String(row.amount_paid)), '0') <= 0) {
        throw new NotFoundError('Receipt not found');
      }
    }

    let receipt = await this.repository.findReceiptByPaymentId(id);
    if (!receipt) {
      if (row.status !== 'paid') {
        throw new NotFoundError('Receipt not found');
      }
      receipt = await runInTransaction(this.db, async () => {
        return this.ensureReceipt(id, new Date());
      });
    }

    const paymentDto =
      actor.userType === 'trainer'
        ? this.toDto(row)
        : this.toDto(row, await this.repository.listHistories(id));
    return this.toReceiptDto(receipt, paymentDto);
  }

  /**
   * PAY-008: Coordinate membership purchase with payment in a single atomic transaction.
   */
  async purchaseMembership(
    dto: {
      member_id: number;
      product_id: number;
      start_date?: string;
      discount_amount?: string;
      payment_method_id?: number;
      tenders?: Array<{
        payment_method_id: number;
        amount: string;
        transaction_reference?: string;
      }>;
      transaction_reference?: string;
    },
    actor: AuthenticatedUser,
  ): Promise<{ payment: PaymentDto; membershipId: number }> {
    const product = await this.productRepository.findById(dto.product_id);
    if (!product || !product.is_active) {
      throw new NotFoundError('Membership product not found or inactive');
    }
    const payment = await this.create(
      {
        member_id: dto.member_id,
        product_id: dto.product_id,
        start_date: dto.start_date,
        subtotal: product.base_price,
        discount_amount: dto.discount_amount,
        payment_method_id: dto.payment_method_id,
        tenders: dto.tenders,
        transaction_reference: dto.transaction_reference,
      },
      actor,
    );
    return { payment, membershipId: payment.membership_id! };
  }

  /**
   * PAY-008: Coordinate membership renewal with payment in a single atomic transaction.
   */
  async renewMembership(
    dto: {
      membership_id: number;
      product_id?: number;
      expected_row_version?: number;
      discount_amount?: string;
      payment_method_id?: number;
      tenders?: Array<{
        payment_method_id: number;
        amount: string;
        transaction_reference?: string;
      }>;
      transaction_reference?: string;
    },
    actor: AuthenticatedUser,
  ): Promise<{ payment: PaymentDto; membershipId: number }> {
    const membership = await this.membershipRepository.findById(dto.membership_id);
    if (!membership) {
      throw new NotFoundError('Membership not found');
    }
    if (dto.expected_row_version != null) {
      verifyRowVersion(dto.expected_row_version, membership.row_version);
    }
    const productId = dto.product_id ?? membership.product_id;
    const product = await this.productRepository.findById(productId);
    if (!product || !product.is_active) {
      throw new NotFoundError('Membership product not found or inactive');
    }
    const payment = await this.create(
      {
        member_id: membership.member_id,
        membership_id: membership.id,
        product_id: productId,
        expected_row_version: dto.expected_row_version,
        subtotal: product.base_price,
        discount_amount: dto.discount_amount,
        payment_method_id: dto.payment_method_id,
        tenders: dto.tenders,
        transaction_reference: dto.transaction_reference,
      },
      actor,
    );
    return { payment, membershipId: payment.membership_id! };
  }

  /**
   * PAY-017 / DSH-007: Aggregated revenue today for dashboard and reporting.
   */
  async getRevenueToday(
    now = new Date(),
  ): Promise<{ total_amount: string; invoice_count: number }> {
    const dayStart = new Date(
      Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), 0, 0, 0, 0),
    );
    const dayEnd = new Date(dayStart.getTime() + 24 * 60 * 60 * 1000);
    return this.repository.getRevenueToday(dayStart, dayEnd);
  }
}
