import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  type CreditNote,
  type TaxCodeComponent,
} from '../platform/db/schema/accounting';
import { memberships, membershipProducts } from '../platform/db/schema/memberships';
import { payments, paymentMethods, type Payment, type PaymentHistory } from '../platform/db/schema/payments';
import { ptSubscriptions, ptProducts } from '../platform/db/schema/personal-training';
import { runInTransaction } from '../platform/db/transaction-context';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import {
  addMoney,
  cmpMoney,
  fromCents,
  mulMoneyPercent,
  roundMoney,
  subMoney,
  toCents,
} from '../platform/money/money';
import { SettingsService } from '../sys/settings.service';
import { AccountingPostingService, type PostJournalLineInput } from './accounting-posting.service';
import { AccountingRepository, type JournalEntryWithLines } from './accounting.repository';
import { AccountsRepository } from './accounts.repository';
import { CreditNotesRepository } from './credit-notes.repository';
import { RevenueRecognitionRepository } from './revenue-recognition.repository';
import { TaxCodesRepository } from './tax-codes.repository';

function toDateString(d: Date | string): string {
  if (typeof d === 'string') {
    return d.slice(0, 10);
  }
  return d.toISOString().slice(0, 10);
}

function subtractOneDay(dateStr: string): string {
  const parts = dateStr.slice(0, 10).split('-');
  const year = parseInt(parts[0], 10);
  const month = parseInt(parts[1], 10) - 1;
  const day = parseInt(parts[2], 10);
  const d = new Date(Date.UTC(year, month, day));
  d.setUTCDate(d.getUTCDate() - 1);
  return d.toISOString().slice(0, 10);
}

@Injectable()
export class SalesBridgeService {
  constructor(
    private readonly postingService: AccountingPostingService,
    private readonly accountingRepository: AccountingRepository,
    private readonly accountsRepository: AccountsRepository,
    private readonly taxCodesRepository: TaxCodesRepository,
    private readonly creditNotesRepository: CreditNotesRepository,
    private readonly revenueRecognitionRepository: RevenueRecognitionRepository,
    private readonly settingsService: SettingsService,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  /**
   * ACC-051 & ACC-055: On invoice insert (`payments` creation).
   * - Debit total: Accounts receivable (1100)
   * - Debit discount: Sales discounts (4900) when discount > 0
   * - Credit tax: Output tax accounts (2100, 2110, 2120) from active components of accounting.default_tax_code
   * - If component tax sum differs from payment.tax_amount, post gap to 5950 Rounding off (ACC-056)
   * - Credit net of tax (subtotal):
   *     - Unearned membership (2200) when membership_id is set
   *     - Unearned PT (2210) when pt_subscription_id is set and membership_id is null
   *     - Otherwise (product.income_account_id if set, else 4200 Other sales)
   * - source_type = 'sales_invoice', source_id = payment.id
   * - When unearned is credited (2200 or 2210), insert revenue_recognition_schedules (ACC-055)
   */
  async onInvoiceCreated(
    payment: Payment,
    options?: { productId?: number; startDate?: string },
  ): Promise<JournalEntryWithLines | null> {
    const isPostingEnabled =
      (await this.settingsService.getSetting('accounting.posting_enabled')) === 'true';
    if (!isPostingEnabled) {
      return null;
    }

    return runInTransaction(this.db, async () => {
      const arAccount = await this.accountsRepository.findByCode('1100');
      if (!arAccount) {
        throw new NotFoundError('Accounts receivable account (1100) was not found');
      }

      let creditedAccountId: number;
      let targetIncomeAccountId: number | null = null;
      let isUnearned = false;
      let termStart: string = options?.startDate ?? toDateString(payment.payment_date);
      let termEnd: string = termStart;

      if (payment.membership_id != null) {
        isUnearned = true;
        const unearnedAccount = await this.accountsRepository.findByCode('2200');
        if (!unearnedAccount) {
          throw new NotFoundError('Unearned membership revenue account (2200) was not found');
        }
        creditedAccountId = unearnedAccount.id;

        // Resolve term dates and target income account from membership
        const membershipRows = await (this.db as any)
          .select({
            startDate: memberships.start_date,
            endDate: memberships.end_date,
            productId: memberships.product_id,
          })
          .from(memberships)
          .where(eq(memberships.id, payment.membership_id))
          .limit(1);

        const membership = membershipRows[0];
        if (membership) {
          termStart = membership.startDate;
          termEnd = membership.endDate;

          const prodRows = await (this.db as any)
            .select({ incomeAccountId: membershipProducts.income_account_id })
            .from(membershipProducts)
            .where(eq(membershipProducts.id, membership.productId))
            .limit(1);
          if (prodRows[0]?.incomeAccountId != null) {
            targetIncomeAccountId = prodRows[0].incomeAccountId;
          }
        }

        if (targetIncomeAccountId == null) {
          const membershipIncomeAccount = await this.accountsRepository.findByCode('4000');
          if (!membershipIncomeAccount) {
            throw new NotFoundError('Membership revenue account (4000) was not found');
          }
          targetIncomeAccountId = membershipIncomeAccount.id;
        }
      } else if (payment.pt_subscription_id != null) {
        isUnearned = true;
        const unearnedPtAccount = await this.accountsRepository.findByCode('2210');
        if (!unearnedPtAccount) {
          throw new NotFoundError('Unearned personal training revenue account (2210) was not found');
        }
        creditedAccountId = unearnedPtAccount.id;

        // Resolve term dates and target income account from PT subscription
        const subRows = await (this.db as any)
          .select({
            startDate: ptSubscriptions.start_date,
            endDate: ptSubscriptions.end_date,
            ptProductId: ptSubscriptions.pt_product_id,
          })
          .from(ptSubscriptions)
          .where(eq(ptSubscriptions.id, payment.pt_subscription_id))
          .limit(1);

        const sub = subRows[0];
        if (sub) {
          termStart = sub.startDate;
          termEnd = sub.endDate;

          const prodRows = await (this.db as any)
            .select({ incomeAccountId: ptProducts.income_account_id })
            .from(ptProducts)
            .where(eq(ptProducts.id, sub.ptProductId))
            .limit(1);
          if (prodRows[0]?.incomeAccountId != null) {
            targetIncomeAccountId = prodRows[0].incomeAccountId;
          }
        }

        if (targetIncomeAccountId == null) {
          const ptIncomeAccount = await this.accountsRepository.findByCode('4100');
          if (!ptIncomeAccount) {
            throw new NotFoundError('Personal training revenue account (4100) was not found');
          }
          targetIncomeAccountId = ptIncomeAccount.id;
        }
      } else {
        // Direct sale / other
        isUnearned = false;
        let foundIncomeAccountId: number | null = null;
        if (options?.productId != null) {
          const prodRows = await (this.db as any)
            .select({ incomeAccountId: membershipProducts.income_account_id })
            .from(membershipProducts)
            .where(eq(membershipProducts.id, options.productId))
            .limit(1);
          if (prodRows[0]?.incomeAccountId != null) {
            foundIncomeAccountId = prodRows[0].incomeAccountId;
          }
        }
        if (foundIncomeAccountId != null) {
          creditedAccountId = foundIncomeAccountId;
        } else {
          const otherSalesAccount = await this.accountsRepository.findByCode('4200');
          if (!otherSalesAccount) {
            throw new NotFoundError('Other sales account (4200) was not found');
          }
          creditedAccountId = otherSalesAccount.id;
        }
      }

      // Build journal lines
      const lines: PostJournalLineInput[] = [];

      // 1. Debit Accounts Receivable (1100)
      lines.push({
        accountId: arAccount.id,
        debit: roundMoney(String(payment.total_amount)),
        memberId: payment.member_id,
        memo: `Invoice ${payment.invoice_number}`,
      });

      // 2. Debit Sales Discounts (4900) when discount > 0
      const discount = roundMoney(String(payment.discount_amount));
      if (cmpMoney(discount, '0') > 0) {
        const discountAccount = await this.accountsRepository.findByCode('4900');
        if (discountAccount) {
          lines.push({
            accountId: discountAccount.id,
            debit: discount,
            memberId: payment.member_id,
            memo: `Sales discount on ${payment.invoice_number}`,
          });
        }
      }

      // 3. Credit net of tax (subtotal)
      lines.push({
        accountId: creditedAccountId,
        credit: roundMoney(String(payment.subtotal)),
        memberId: payment.member_id,
        memo: `Sales revenue for ${payment.invoice_number}`,
      });

      // 4. Tax components & rounding gap (ACC-051 & ACC-056)
      const paymentTax = roundMoney(String(payment.tax_amount));
      const taxable = subMoney(roundMoney(String(payment.subtotal)), discount);

      const defaultTaxCodeKey =
        (await this.settingsService.getSetting('accounting.default_tax_code')) ?? 'gst_18';
      const taxCode = await this.taxCodesRepository.findByCode(defaultTaxCodeKey);
      const components = taxCode ? await this.taxCodesRepository.listComponents(taxCode.id) : [];

      let compTaxSum = '0.00';
      if (cmpMoney(paymentTax, '0') > 0 && components.length > 0) {
        for (const comp of components) {
          const compTax = mulMoneyPercent(taxable, comp.rate_percent);
          compTaxSum = addMoney(compTaxSum, compTax);
          if (cmpMoney(compTax, '0') > 0) {
            lines.push({
              accountId: comp.output_account_id,
              credit: compTax,
              memberId: payment.member_id,
              memo: `${comp.name} on ${payment.invoice_number}`,
            });
          }
        }
      }

      const taxGap = subMoney(paymentTax, compTaxSum);
      if (cmpMoney(taxGap, '0') !== 0) {
        const roundingAccount = await this.accountsRepository.findByCode('5950');
        if (roundingAccount) {
          if (cmpMoney(taxGap, '0') > 0) {
            lines.push({
              accountId: roundingAccount.id,
              credit: taxGap,
              memo: `Rounding off on ${payment.invoice_number}`,
            });
          } else {
            lines.push({
              accountId: roundingAccount.id,
              debit: subMoney('0.00', taxGap),
              memo: `Rounding off on ${payment.invoice_number}`,
            });
          }
        }
      }

      // Post journal
      const entryDate = toDateString(payment.payment_date);
      const journal = await this.postingService.postJournal({
        entryDate,
        sourceType: 'sales_invoice',
        sourceId: payment.id,
        memo: `Sales invoice ${payment.invoice_number}`,
        postedByUserId: payment.cashier_user_id,
        lines,
      });

      // ACC-055: Create revenue recognition schedule when unearned is credited
      if (isUnearned && targetIncomeAccountId != null) {
        const recognizedThrough = subtractOneDay(termStart);
        await this.revenueRecognitionRepository.insertSchedule({
          payment_id: payment.id,
          unearned_account_id: creditedAccountId,
          income_account_id: targetIncomeAccountId,
          total_amount: roundMoney(String(payment.subtotal)),
          recognized_amount: '0.00',
          starts_on: termStart,
          ends_on: termEnd,
          recognized_through: recognizedThrough,
          status: 'open',
          paused_from: null,
        });
      }

      return journal;
    });
  }

  /**
   * ACC-052: On collection (`payment_histories.action = 'payment_received'`).
   * - Look up payment_methods: if method.account_id == null, throw BusinessRuleError
   * - Debit method's bank or cash account (method.account_id)
   * - Credit accounts receivable (1100)
   * - source_type = 'sales_receipt', source_id = history.id
   */
  async onPaymentReceived(
    history: PaymentHistory,
    payment: Payment,
  ): Promise<JournalEntryWithLines | null> {
    const isPostingEnabled =
      (await this.settingsService.getSetting('accounting.posting_enabled')) === 'true';
    if (!isPostingEnabled) {
      return null;
    }

    return runInTransaction(this.db, async () => {
      if (history.payment_method_id == null) {
        throw new BusinessRuleError('Payment method has no linked account_id');
      }

      const methodRows = await (this.db as any)
        .select({
          id: paymentMethods.id,
          accountId: paymentMethods.account_id,
          methodName: paymentMethods.method_name,
        })
        .from(paymentMethods)
        .where(eq(paymentMethods.id, history.payment_method_id))
        .limit(1);

      const method = methodRows[0];
      if (!method || method.accountId == null) {
        throw new BusinessRuleError('Payment method has no linked account_id');
      }

      const arAccount = await this.accountsRepository.findByCode('1100');
      if (!arAccount) {
        throw new NotFoundError('Accounts receivable account (1100) was not found');
      }

      const entryDate = toDateString(history.timestamp);
      const amount = roundMoney(String(history.amount));

      return this.postingService.postJournal({
        entryDate,
        sourceType: 'sales_receipt',
        sourceId: history.id,
        memo: `Collection for invoice ${payment.invoice_number}`,
        lines: [
          {
            accountId: method.accountId,
            debit: amount,
            memberId: payment.member_id,
            memo: `Receipt tender via ${method.methodName} for ${payment.invoice_number}`,
          },
          {
            accountId: arAccount.id,
            credit: amount,
            memberId: payment.member_id,
            memo: `Collection for ${payment.invoice_number}`,
          },
        ],
      });
    });
  }

  /**
   * ACC-053: On refund (`payment_histories.action = 'refunded'`).
   * - Allocate credit note number from credit_note_number_counters
   * - Debit same unearned/income account credited by invoice, in proportion to refund / invoice net
   * - Debit output tax in proportion to refund / invoice tax
   * - Credit accounts receivable when invoice not fully collected, or bank/cash account when money is paid back
   * - source_type = 'credit_note', source_id = creditNote.id
   * - Proportionally shrink revenue_recognition_schedules.total_amount if schedule exists
   */
  async onRefund(
    payment: Payment,
    history: PaymentHistory,
    options?: { paymentMethodId?: number | null; notes?: string | null },
  ): Promise<{ creditNote: CreditNote; journal: JournalEntryWithLines } | null> {
    const isPostingEnabled =
      (await this.settingsService.getSetting('accounting.posting_enabled')) === 'true';
    if (!isPostingEnabled) {
      return null;
    }

    return runInTransaction(this.db, async () => {
      const creditNoteNumber = await this.creditNotesRepository.allocateCreditNoteNumber();

      const refundAmount = roundMoney(String(history.amount));
      const invoiceTotal = roundMoney(String(payment.total_amount));
      const invoiceTax = roundMoney(String(payment.tax_amount));

      // Calculate net and tax portions of refund using integer cents
      const refundAmountCents = toCents(refundAmount);
      const invoiceTotalCents = toCents(invoiceTotal);
      const invoiceTaxCents = toCents(invoiceTax);

      const refundTaxCents =
        invoiceTotalCents > 0n
          ? (refundAmountCents * invoiceTaxCents + invoiceTotalCents / 2n) / invoiceTotalCents
          : 0n;
      const refundNetCents = refundAmountCents - refundTaxCents;
      const refundTax = fromCents(refundTaxCents);
      const refundNet = fromCents(refundNetCents);

      // Determine unearned/income account originally credited
      const creditedAccount = await this.resolveCreditedAccount(payment);

      // If schedule exists, check unrecognized balance and shrink schedule
      const schedule = await this.revenueRecognitionRepository.findByPaymentId(payment.id);
      if (schedule) {
        const unrecognized = subMoney(
          roundMoney(String(schedule.total_amount)),
          roundMoney(String(schedule.recognized_amount)),
        );
        if (cmpMoney(refundNet, unrecognized) > 0) {
          throw new BusinessRuleError('Refund exceeds unrecognized balance on schedule');
        }
        const newScheduleTotal = subMoney(
          roundMoney(String(schedule.total_amount)),
          refundNet,
        );
        const newStatus =
          cmpMoney(newScheduleTotal, roundMoney(String(schedule.recognized_amount))) === 0
            ? 'closed'
            : schedule.status;
        await this.revenueRecognitionRepository.updateSchedule(schedule.id, {
          total_amount: newScheduleTotal,
          status: newStatus,
        });
      }

      // Resolve credit side account (refund payment method bank/cash or accounts receivable)
      let creditAccountId: number;
      if (options?.paymentMethodId != null) {
        const methodRows = await (this.db as any)
          .select({
            id: paymentMethods.id,
            accountId: paymentMethods.account_id,
          })
          .from(paymentMethods)
          .where(eq(paymentMethods.id, options.paymentMethodId))
          .limit(1);

        const method = methodRows[0];
        if (!method || method.accountId == null) {
          throw new BusinessRuleError('Payment method has no linked account_id');
        }
        creditAccountId = method.accountId;
      } else {
        const arAccount = await this.accountsRepository.findByCode('1100');
        if (!arAccount) {
          throw new NotFoundError('Accounts receivable account (1100) was not found');
        }
        creditAccountId = arAccount.id;
      }

      // Split refundTax across active components of default_tax_code
      const taxLines = await this.buildTaxComponentLines(
        refundTax,
        payment,
        'debit',
        `Refund tax on ${payment.invoice_number}`,
      );

      const entryDate = toDateString(history.timestamp);
      const creditNote = await this.creditNotesRepository.insertCreditNote({
        credit_note_number: creditNoteNumber,
        payment_id: payment.id,
        credit_note_date: entryDate,
        reason: options?.notes ?? `Refund for invoice ${payment.invoice_number}`,
        subtotal: refundNet,
        tax_amount: refundTax,
        total_amount: refundAmount,
        status: 'posted',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: new Date(),
      });

      const journal = await this.postingService.postJournal({
        entryDate,
        sourceType: 'credit_note',
        sourceId: creditNote.id,
        memo: `Credit note ${creditNote.credit_note_number} for invoice ${payment.invoice_number}`,
        lines: [
          {
            accountId: creditedAccount.id,
            debit: refundNet,
            memberId: payment.member_id,
            memo: `Reverse revenue for ${payment.invoice_number}`,
          },
          ...taxLines,
          {
            accountId: creditAccountId,
            credit: refundAmount,
            memberId: payment.member_id,
            memo: `Refund against ${payment.invoice_number}`,
          },
        ],
      });

      await this.creditNotesRepository.updateCreditNote(creditNote.id, {
        journal_entry_id: journal.id,
      });

      return { creditNote, journal };
    });
  }

  /**
   * ACC-057: On adjustment (`payment_histories.action = 'adjusted'`).
   * - If decrease:
   *     - Write and post credit note. Split net and tax in proportion. Credit receivable, debit unearned/income and tax.
   *     - Shrink schedule's total_amount by net share.
   *     - If decrease > unrecognized balance on schedule (total_amount - recognized_amount), reject with BusinessRuleError.
   * - If increase:
   *     - Post journal sourceType = 'sales_adjustment', sourceId = history.id:
   *       Debit receivable, Credit tax and unearned/income in proportion.
   *     - Grow schedule's total_amount by net share.
   * - Ensures receivable on ledger equals total_amount - amount_paid after adjustment.
   */
  async onAdjustment(
    payment: Payment,
    history: PaymentHistory,
    options: { adjustmentAmount: string; newTotal: string; notes?: string | null },
  ): Promise<{ creditNote?: CreditNote; journal: JournalEntryWithLines } | null> {
    const isPostingEnabled =
      (await this.settingsService.getSetting('accounting.posting_enabled')) === 'true';
    if (!isPostingEnabled) {
      return null;
    }

    return runInTransaction(this.db, async () => {
      const adj = roundMoney(options.adjustmentAmount);
      const isDecrease = cmpMoney(adj, '0') < 0;
      const arAccount = await this.accountsRepository.findByCode('1100');
      if (!arAccount) {
        throw new NotFoundError('Accounts receivable account (1100) was not found');
      }
      const creditedAccount = await this.resolveCreditedAccount(payment);
      const entryDate = toDateString(history.timestamp);

      if (isDecrease) {
        const mag = subMoney('0.00', adj);
        const magCents = toCents(mag);
        const invoiceTotalCents = toCents(roundMoney(String(payment.total_amount)));
        const invoiceTaxCents = toCents(roundMoney(String(payment.tax_amount)));

        const taxCents =
          invoiceTotalCents > 0n
            ? (magCents * invoiceTaxCents + invoiceTotalCents / 2n) / invoiceTotalCents
            : 0n;
        const netCents = magCents - taxCents;
        const decTax = fromCents(taxCents);
        const decNet = fromCents(netCents);

        // Check schedule and shrink
        const schedule = await this.revenueRecognitionRepository.findByPaymentId(payment.id);
        if (schedule) {
          const unrecognized = subMoney(
            roundMoney(String(schedule.total_amount)),
            roundMoney(String(schedule.recognized_amount)),
          );
          if (cmpMoney(decNet, unrecognized) > 0) {
            throw new BusinessRuleError(
              'Adjustment decrease exceeds unrecognized balance on schedule',
            );
          }
          const newScheduleTotal = subMoney(
            roundMoney(String(schedule.total_amount)),
            decNet,
          );
          const newStatus =
            cmpMoney(newScheduleTotal, roundMoney(String(schedule.recognized_amount))) === 0
              ? 'closed'
              : schedule.status;
          await this.revenueRecognitionRepository.updateSchedule(schedule.id, {
            total_amount: newScheduleTotal,
            status: newStatus,
          });
        }

        const creditNoteNumber = await this.creditNotesRepository.allocateCreditNoteNumber();
        const taxLines = await this.buildTaxComponentLines(
          decTax,
          payment,
          'debit',
          `Adjustment decrease tax on ${payment.invoice_number}`,
        );

        const creditNote = await this.creditNotesRepository.insertCreditNote({
          credit_note_number: creditNoteNumber,
          payment_id: payment.id,
          credit_note_date: entryDate,
          reason: options.notes ?? `Adjustment decrease for invoice ${payment.invoice_number}`,
          subtotal: decNet,
          tax_amount: decTax,
          total_amount: mag,
          status: 'posted',
          journal_entry_id: null,
          row_version: 1,
          created_at: new Date(),
          updated_at: new Date(),
        });

        const journal = await this.postingService.postJournal({
          entryDate,
          sourceType: 'credit_note',
          sourceId: creditNote.id,
          memo: `Credit note ${creditNote.credit_note_number} for adjustment of ${payment.invoice_number}`,
          lines: [
            {
              accountId: creditedAccount.id,
              debit: decNet,
              memberId: payment.member_id,
              memo: `Adjustment decrease revenue for ${payment.invoice_number}`,
            },
            ...taxLines,
            {
              accountId: arAccount.id,
              credit: mag,
              memberId: payment.member_id,
              memo: `Adjustment decrease receivable for ${payment.invoice_number}`,
            },
          ],
        });

        await this.creditNotesRepository.updateCreditNote(creditNote.id, {
          journal_entry_id: journal.id,
        });

        return { creditNote, journal };
      } else {
        // Increase
        const mag = adj;
        const magCents = toCents(mag);
        const invoiceTotalCents = toCents(roundMoney(String(payment.total_amount)));
        const invoiceTaxCents = toCents(roundMoney(String(payment.tax_amount)));

        const taxCents =
          invoiceTotalCents > 0n
            ? (magCents * invoiceTaxCents + invoiceTotalCents / 2n) / invoiceTotalCents
            : 0n;
        const netCents = magCents - taxCents;
        const incTax = fromCents(taxCents);
        const incNet = fromCents(netCents);

        // Grow schedule
        const schedule = await this.revenueRecognitionRepository.findByPaymentId(payment.id);
        if (schedule) {
          const newScheduleTotal = addMoney(
            roundMoney(String(schedule.total_amount)),
            incNet,
          );
          await this.revenueRecognitionRepository.updateSchedule(schedule.id, {
            total_amount: newScheduleTotal,
            status: 'open',
          });
        }

        const taxLines = await this.buildTaxComponentLines(
          incTax,
          payment,
          'credit',
          `Adjustment increase tax on ${payment.invoice_number}`,
        );

        const journal = await this.postingService.postJournal({
          entryDate,
          sourceType: 'sales_adjustment',
          sourceId: history.id,
          memo: options.notes ?? `Adjustment increase for invoice ${payment.invoice_number}`,
          lines: [
            {
              accountId: arAccount.id,
              debit: mag,
              memberId: payment.member_id,
              memo: `Adjustment increase receivable for ${payment.invoice_number}`,
            },
            {
              accountId: creditedAccount.id,
              credit: incNet,
              memberId: payment.member_id,
              memo: `Adjustment increase revenue for ${payment.invoice_number}`,
            },
            ...taxLines,
          ],
        });

        return { journal };
      }
    });
  }

  private async resolveCreditedAccount(payment: Payment) {
    if (payment.membership_id != null) {
      const acc = await this.accountsRepository.findByCode('2200');
      if (!acc) throw new NotFoundError('Account 2200 was not found');
      return acc;
    }
    if (payment.pt_subscription_id != null) {
      const acc = await this.accountsRepository.findByCode('2210');
      if (!acc) throw new NotFoundError('Account 2210 was not found');
      return acc;
    }
    const acc = await this.accountsRepository.findByCode('4200');
    if (!acc) throw new NotFoundError('Account 4200 was not found');
    return acc;
  }

  private async buildTaxComponentLines(
    taxAmount: string,
    payment: Payment,
    side: 'debit' | 'credit',
    memoPrefix: string,
  ): Promise<PostJournalLineInput[]> {
    const lines: PostJournalLineInput[] = [];
    if (cmpMoney(taxAmount, '0') <= 0) {
      return lines;
    }

    const defaultTaxCodeKey =
      (await this.settingsService.getSetting('accounting.default_tax_code')) ?? 'gst_18';
    const taxCode = await this.taxCodesRepository.findByCode(defaultTaxCodeKey);
    const components = taxCode ? await this.taxCodesRepository.listComponents(taxCode.id) : [];

    if (components.length === 0) {
      return lines;
    }

    const taxAmountCents = toCents(taxAmount);
    const sumRates = components.reduce((sum, c) => addMoney(sum, c.rate_percent), '0.00');
    const sumRatesCents = toCents(sumRates);

    let compTaxSumCents = 0n;
    for (const comp of components) {
      const cTaxCents =
        sumRatesCents > 0n
          ? (taxAmountCents * toCents(comp.rate_percent) + sumRatesCents / 2n) / sumRatesCents
          : 0n;
      compTaxSumCents += cTaxCents;
      const compTax = fromCents(cTaxCents);
      if (cmpMoney(compTax, '0') > 0) {
        lines.push({
          accountId: comp.output_account_id,
          ...(side === 'debit' ? { debit: compTax } : { credit: compTax }),
          memberId: payment.member_id,
          memo: `${memoPrefix} (${comp.name})`,
        });
      }
    }

    const taxGapCents = taxAmountCents - compTaxSumCents;
    if (taxGapCents !== 0n) {
      const roundingAccount = await this.accountsRepository.findByCode('5950');
      if (roundingAccount) {
        if (taxGapCents > 0n) {
          const gap = fromCents(taxGapCents);
          lines.push({
            accountId: roundingAccount.id,
            ...(side === 'debit' ? { debit: gap } : { credit: gap }),
            memo: `${memoPrefix} (Rounding off)`,
          });
        } else {
          const gap = fromCents(-taxGapCents);
          lines.push({
            accountId: roundingAccount.id,
            ...(side === 'debit' ? { credit: gap } : { debit: gap }),
            memo: `${memoPrefix} (Rounding off)`,
          });
        }
      }
    }

    return lines;
  }
}
