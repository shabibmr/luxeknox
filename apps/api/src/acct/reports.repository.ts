import { Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, gte, inArray, lte, ne, sql, type SQL } from 'drizzle-orm';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  accounts,
  debitNotes,
  fiscalYears,
  journalEntries,
  journalLines,
  paymentAllocations,
  paymentVouchers,
  purchaseBills,
  taxCodeComponents,
  taxCodes,
  type Account,
  type FiscalYear,
  type JournalEntry,
  type JournalLine,
  type PurchaseBill,
  type TaxCode,
  type TaxCodeComponent,
} from '../platform/db/schema/accounting';
import { payments, type Payment } from '../platform/db/schema/payments';
import { fromCents, toCents } from '../platform/money/money';
import { PeriodsRepository } from './periods.repository';
import type {
  BalanceSheetAccountDto,
  DayBookJournalDto,
  DayBookLineDto,
  GstTaxCodeSummaryDto,
  OpenApItemDto,
  OpenArItemDto,
  ProfitAndLossAccountDto,
  TrialBalanceAccountDto,
} from './reports.dto';

@Injectable()
export class ReportsRepository {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>,
    private readonly periodsRepository: PeriodsRepository,
  ) {}

  /**
   * ACC-070: Calculate trial balance account rows and totals.
   * Debit total equals credit total. Reuses PeriodsRepository.calculateTrialBalanceTotals.
   */
  async getTrialBalance(
    from: string | undefined,
    to: string,
  ): Promise<{
    accounts: TrialBalanceAccountDto[];
    totalDebit: string;
    totalCredit: string;
  }> {
    const db = this.db as any;

    // 1. Get totals via the single canonical trial-balance totals query
    const { totalDebit, totalCredit } =
      await this.periodsRepository.calculateTrialBalanceTotals(to, from);

    // 2. Query account movements in the range
    const conditions: SQL[] = [lte(journalEntries.entry_date, to)];
    if (from) {
      conditions.push(gte(journalEntries.entry_date, from));
    }

    const rows = await db
      .select({
        accountId: accounts.id,
        accountCode: accounts.code,
        accountName: accounts.name,
        accountType: accounts.account_type,
        debit: sql<string>`COALESCE(SUM(${journalLines.debit}), '0.00')`,
        credit: sql<string>`COALESCE(SUM(${journalLines.credit}), '0.00')`,
      })
      .from(journalLines)
      .innerJoin(journalEntries, eq(journalLines.journal_entry_id, journalEntries.id))
      .innerJoin(accounts, eq(journalLines.account_id, accounts.id))
      .where(and(...conditions))
      .groupBy(accounts.id, accounts.code, accounts.name, accounts.account_type)
      .orderBy(asc(accounts.code));

    const resultAccounts: TrialBalanceAccountDto[] = [];
    for (const row of rows) {
      const debitCents = toCents(row.debit);
      const creditCents = toCents(row.credit);
      if (debitCents > 0n || creditCents > 0n) {
        resultAccounts.push({
          account_id: Number(row.accountId),
          account_code: String(row.accountCode),
          account_name: String(row.accountName),
          account_type: String(row.accountType),
          debit: fromCents(debitCents),
          credit: fromCents(creditCents),
        });
      }
    }

    return {
      accounts: resultAccounts,
      totalDebit,
      totalCredit,
    };
  }

  /**
   * ACC-071: Profit and loss for a date range.
   * Only income and expense accounts.
   */
  async getProfitAndLoss(
    from: string,
    to: string,
  ): Promise<{
    incomeAccounts: ProfitAndLossAccountDto[];
    totalIncome: string;
    expenseAccounts: ProfitAndLossAccountDto[];
    totalExpense: string;
    netProfit: string;
  }> {
    const db = this.db as any;
    const conditions: SQL[] = [
      gte(journalEntries.entry_date, from),
      lte(journalEntries.entry_date, to),
      inArray(accounts.account_type, ['income', 'expense']),
    ];

    const rows = await db
      .select({
        accountId: accounts.id,
        accountCode: accounts.code,
        accountName: accounts.name,
        accountType: accounts.account_type,
        debit: sql<string>`COALESCE(SUM(${journalLines.debit}), '0.00')`,
        credit: sql<string>`COALESCE(SUM(${journalLines.credit}), '0.00')`,
      })
      .from(journalLines)
      .innerJoin(journalEntries, eq(journalLines.journal_entry_id, journalEntries.id))
      .innerJoin(accounts, eq(journalLines.account_id, accounts.id))
      .where(and(...conditions))
      .groupBy(accounts.id, accounts.code, accounts.name, accounts.account_type)
      .orderBy(asc(accounts.code));

    const incomeAccounts: ProfitAndLossAccountDto[] = [];
    const expenseAccounts: ProfitAndLossAccountDto[] = [];
    let totalIncomeCents = 0n;
    let totalExpenseCents = 0n;

    for (const r of rows) {
      const debitCents = toCents(r.debit);
      const creditCents = toCents(r.credit);
      if (debitCents === 0n && creditCents === 0n) continue;

      if (r.accountType === 'income') {
        // Income is normally credit balance: credits - debits
        const netCents = creditCents - debitCents;
        totalIncomeCents += netCents;
        incomeAccounts.push({
          account_id: Number(r.accountId),
          account_code: String(r.accountCode),
          account_name: String(r.accountName),
          amount: fromCents(netCents),
        });
      } else if (r.accountType === 'expense') {
        // Expense is normally debit balance: debits - credits
        const netCents = debitCents - creditCents;
        totalExpenseCents += netCents;
        expenseAccounts.push({
          account_id: Number(r.accountId),
          account_code: String(r.accountCode),
          account_name: String(r.accountName),
          amount: fromCents(netCents),
        });
      }
    }

    const netProfitCents = totalIncomeCents - totalExpenseCents;

    return {
      incomeAccounts,
      totalIncome: fromCents(totalIncomeCents),
      expenseAccounts,
      totalExpense: fromCents(totalExpenseCents),
      netProfit: fromCents(netProfitCents),
    };
  }

  /**
   * ACC-072: Balance sheet as of a date, with current-year earnings under equity.
   * Assets equal liabilities plus equity.
   */
  async getBalanceSheet(asOf: string): Promise<{
    asOf: string;
    fiscalYearStart: string;
    assetAccounts: BalanceSheetAccountDto[];
    totalAssets: string;
    liabilityAccounts: BalanceSheetAccountDto[];
    totalLiabilities: string;
    equityAccounts: BalanceSheetAccountDto[];
    retainedEarnings: string;
    currentYearEarnings: string;
    totalEquity: string;
    totalLiabilitiesAndEquity: string;
  }> {
    const db = this.db as any;

    // 1. Identify fiscal year for asOf date
    const fyRows = await db
      .select()
      .from(fiscalYears)
      .where(and(lte(fiscalYears.starts_on, asOf), gte(fiscalYears.ends_on, asOf)))
      .limit(1);

    const fiscalYear: FiscalYear | null = fyRows[0] ?? null;
    let fiscalYearStart: string;
    if (fiscalYear) {
      fiscalYearStart = fiscalYear.starts_on;
    } else {
      // Fallback: earliest start or Jan 1 of that year
      fiscalYearStart = `${asOf.substring(0, 4)}-01-01`;
    }

    // 2. Query cumulative balance up to asOf for all accounts
    const rows = await db
      .select({
        accountId: accounts.id,
        accountCode: accounts.code,
        accountName: accounts.name,
        accountType: accounts.account_type,
        debit: sql<string>`COALESCE(SUM(${journalLines.debit}), '0.00')`,
        credit: sql<string>`COALESCE(SUM(${journalLines.credit}), '0.00')`,
      })
      .from(journalLines)
      .innerJoin(journalEntries, eq(journalLines.journal_entry_id, journalEntries.id))
      .innerJoin(accounts, eq(journalLines.account_id, accounts.id))
      .where(lte(journalEntries.entry_date, asOf))
      .groupBy(accounts.id, accounts.code, accounts.name, accounts.account_type)
      .orderBy(asc(accounts.code));

    const assetAccounts: BalanceSheetAccountDto[] = [];
    const liabilityAccounts: BalanceSheetAccountDto[] = [];
    const equityAccounts: BalanceSheetAccountDto[] = [];

    let totalAssetCents = 0n;
    let totalLiabilityCents = 0n;
    let equityAccountsCents = 0n;

    for (const r of rows) {
      const debitCents = toCents(r.debit);
      const creditCents = toCents(r.credit);
      if (debitCents === 0n && creditCents === 0n) continue;

      if (r.accountType === 'asset') {
        const net = debitCents - creditCents;
        totalAssetCents += net;
        assetAccounts.push({
          account_id: Number(r.accountId),
          account_code: String(r.accountCode),
          account_name: String(r.accountName),
          amount: fromCents(net),
        });
      } else if (r.accountType === 'liability') {
        const net = creditCents - debitCents;
        totalLiabilityCents += net;
        liabilityAccounts.push({
          account_id: Number(r.accountId),
          account_code: String(r.accountCode),
          account_name: String(r.accountName),
          amount: fromCents(net),
        });
      } else if (r.accountType === 'equity') {
        const net = creditCents - debitCents;
        equityAccountsCents += net;
        equityAccounts.push({
          account_id: Number(r.accountId),
          account_code: String(r.accountCode),
          account_name: String(r.accountName),
          amount: fromCents(net),
        });
      }
    }

    // 3. Calculate current-year earnings (income minus expense from fiscalYearStart to asOf)
    const currentYearPnl = await this.getProfitAndLoss(fiscalYearStart, asOf);
    const currentYearEarningsCents = toCents(currentYearPnl.netProfit);

    // 4. Retained earnings: P&L from the earliest entry up to the day before the fiscal year start.
    // Without this, income and expense from earlier years drop out and the sheet stops balancing.
    const dayBeforeStart = new Date(`${fiscalYearStart}T00:00:00Z`);
    dayBeforeStart.setUTCDate(dayBeforeStart.getUTCDate() - 1);
    const priorPnl = await this.getProfitAndLoss('0001-01-01', dayBeforeStart.toISOString().substring(0, 10));
    const retainedEarningsCents = toCents(priorPnl.netProfit);

    const totalEquityCents = equityAccountsCents + retainedEarningsCents + currentYearEarningsCents;
    const totalLiabilitiesAndEquityCents = totalLiabilityCents + totalEquityCents;

    return {
      asOf,
      fiscalYearStart,
      assetAccounts,
      totalAssets: fromCents(totalAssetCents),
      liabilityAccounts,
      totalLiabilities: fromCents(totalLiabilityCents),
      equityAccounts,
      retainedEarnings: fromCents(retainedEarningsCents),
      currentYearEarnings: fromCents(currentYearEarningsCents),
      totalEquity: fromCents(totalEquityCents),
      totalLiabilitiesAndEquity: fromCents(totalLiabilitiesAndEquityCents),
    };
  }

  /**
   * ACC-073: Day book for one date.
   * Every journal on that date is listed with its lines.
   */
  async getDayBook(date: string): Promise<{
    date: string;
    journals: DayBookJournalDto[];
    totalDebit: string;
    totalCredit: string;
  }> {
    const db = this.db as any;

    const entries = await db
      .select()
      .from(journalEntries)
      .where(eq(journalEntries.entry_date, date))
      .orderBy(asc(journalEntries.journal_number), asc(journalEntries.id));

    if (entries.length === 0) {
      return {
        date,
        journals: [],
        totalDebit: '0.00',
        totalCredit: '0.00',
      };
    }

    const entryIds = entries.map((e: JournalEntry) => e.id);

    const lines = await db
      .select({
        id: journalLines.id,
        journalEntryId: journalLines.journal_entry_id,
        accountId: journalLines.account_id,
        accountCode: accounts.code,
        accountName: accounts.name,
        debit: journalLines.debit,
        credit: journalLines.credit,
        memo: journalLines.memo,
        memberId: journalLines.member_id,
        vendorId: journalLines.vendor_id,
      })
      .from(journalLines)
      .innerJoin(accounts, eq(journalLines.account_id, accounts.id))
      .where(inArray(journalLines.journal_entry_id, entryIds))
      .orderBy(asc(journalLines.id));

    const lineMap = new Map<number, DayBookLineDto[]>();
    let totalDebitCents = 0n;
    let totalCreditCents = 0n;

    for (const l of lines) {
      const lineDto: DayBookLineDto = {
        id: Number(l.id),
        account_id: Number(l.accountId),
        account_code: String(l.accountCode),
        account_name: String(l.accountName),
        debit: fromCents(toCents(l.debit)),
        credit: fromCents(toCents(l.credit)),
        memo: l.memo ?? null,
        member_id: l.memberId != null ? Number(l.memberId) : null,
        vendor_id: l.vendorId != null ? Number(l.vendorId) : null,
      };
      totalDebitCents += toCents(l.debit);
      totalCreditCents += toCents(l.credit);

      const list = lineMap.get(Number(l.journalEntryId)) ?? [];
      list.push(lineDto);
      lineMap.set(Number(l.journalEntryId), list);
    }

    const journals: DayBookJournalDto[] = entries.map((e: JournalEntry) => ({
      id: Number(e.id),
      journal_number: e.journal_number,
      entry_date: e.entry_date,
      source_type: e.source_type,
      source_id: Number(e.source_id),
      memo: e.memo ?? null,
      reverses_journal_id: e.reverses_journal_id != null ? Number(e.reverses_journal_id) : null,
      lines: lineMap.get(Number(e.id)) ?? [],
    }));

    return {
      date,
      journals,
      totalDebit: fromCents(totalDebitCents),
      totalCredit: fromCents(totalCreditCents),
    };
  }

  /**
   * ACC-074: Open items (AR from unpaid payments, AP from posted bills whose allocations are short).
   * A paid invoice and a fully allocated bill are absent.
   */
  async getOpenArItems(): Promise<{ items: OpenArItemDto[]; totalOpenAmount: string }> {
    const db = this.db as any;

    const rows: Payment[] = await db
      .select()
      .from(payments)
      .where(inArray(payments.status, ['pending', 'partial']))
      .orderBy(asc(payments.payment_date), asc(payments.id));

    const items: OpenArItemDto[] = [];
    let totalOpenCents = 0n;

    for (const p of rows) {
      const totalCents = toCents(p.total_amount);
      const paidCents = toCents(p.amount_paid);
      const openCents = totalCents - paidCents;

      if (openCents > 0n) {
        totalOpenCents += openCents;
        items.push({
          payment_id: Number(p.id),
          invoice_number: p.invoice_number,
          invoice_date:
            typeof p.payment_date === 'string'
              ? (p.payment_date as string).slice(0, 10)
              : p.payment_date.toISOString().slice(0, 10),
          member_id: Number(p.member_id),
          total_amount: fromCents(totalCents),
          amount_paid: fromCents(paidCents),
          open_amount: fromCents(openCents),
          status: p.status,
        });
      }
    }

    return {
      items,
      totalOpenAmount: fromCents(totalOpenCents),
    };
  }

  async getOpenApItems(): Promise<{ items: OpenApItemDto[]; totalOpenAmount: string }> {
    const db = this.db as any;

    const bills: PurchaseBill[] = await db
      .select()
      .from(purchaseBills)
      .where(eq(purchaseBills.status, 'posted'))
      .orderBy(asc(purchaseBills.bill_date), asc(purchaseBills.id));

    const items: OpenApItemDto[] = [];
    let totalOpenCents = 0n;

    for (const b of bills) {
      // Sum posted allocations for this bill
      const allocRows = await db
        .select({ amount: paymentAllocations.amount })
        .from(paymentAllocations)
        .innerJoin(paymentVouchers, eq(paymentAllocations.payment_voucher_id, paymentVouchers.id))
        .where(
          and(
            eq(paymentAllocations.purchase_bill_id, b.id),
            eq(paymentVouchers.status, 'posted'),
          ),
        );

      let allocatedCents = 0n;
      for (const a of allocRows) {
        allocatedCents += toCents(a.amount);
      }

      // Sum posted debit notes for this bill
      const dnRows = await db
        .select({ totalAmount: debitNotes.total_amount })
        .from(debitNotes)
        .where(and(eq(debitNotes.purchase_bill_id, b.id), eq(debitNotes.status, 'posted')));

      let debitNoteCents = 0n;
      for (const d of dnRows) {
        debitNoteCents += toCents(d.totalAmount);
      }

      const totalBillCents = toCents(b.total_amount);
      const openCents = totalBillCents - allocatedCents - debitNoteCents;

      if (openCents > 0n) {
        totalOpenCents += openCents;
        items.push({
          purchase_bill_id: Number(b.id),
          bill_number: b.bill_number,
          bill_date: b.bill_date,
          due_date: b.due_date,
          vendor_id: Number(b.vendor_id),
          total_amount: fromCents(totalBillCents),
          allocated_amount: fromCents(allocatedCents),
          debit_note_amount: fromCents(debitNoteCents),
          open_amount: fromCents(openCents),
          status: b.status,
        });
      }
    }

    return {
      items,
      totalOpenAmount: fromCents(totalOpenCents),
    };
  }

  /**
   * ACC-075: GST summary for a date range.
   * Taxable value and output CGST, SGST, IGST by tax code, input tax credit, net payable.
   * Output tax per component equals that tax account's movement for the range.
   * Net payable equals output minus input.
   */
  async getGstSummary(
    from: string,
    to: string,
  ): Promise<{
    taxCodes: GstTaxCodeSummaryDto[];
    totalTaxableValue: string;
    outputCgst: string;
    outputSgst: string;
    outputIgst: string;
    totalOutputTax: string;
    inputTaxCredit: string;
    netPayable: string;
  }> {
    const db = this.db as any;

    // 1. Output tax movements on control accounts:
    // Output CGST (2100): credits - debits
    // Output SGST (2110): credits - debits
    // Output IGST (2120): credits - debits
    // Input tax (1300): debits - credits
    // Inner joins with the date filter in WHERE: a tax account with no movement in the range
    // yields no row, and the totals below start at zero.
    const taxAccounts = await db
      .select({
        id: accounts.id,
        code: accounts.code,
        controlRole: accounts.control_role,
        debit: sql<string>`COALESCE(SUM(${journalLines.debit}), '0.00')`,
        credit: sql<string>`COALESCE(SUM(${journalLines.credit}), '0.00')`,
      })
      .from(journalLines)
      .innerJoin(journalEntries, eq(journalLines.journal_entry_id, journalEntries.id))
      .innerJoin(accounts, eq(journalLines.account_id, accounts.id))
      .where(
        and(
          inArray(accounts.control_role, [
            'output_cgst',
            'output_sgst',
            'output_igst',
            'input_tax',
          ]),
          gte(journalEntries.entry_date, from),
          lte(journalEntries.entry_date, to),
        ),
      )
      .groupBy(accounts.id, accounts.code, accounts.control_role);

    let outputCgstCents = 0n;
    let outputSgstCents = 0n;
    let outputIgstCents = 0n;
    let inputTaxCents = 0n;

    for (const ta of taxAccounts) {
      const debitCents = toCents(ta.debit);
      const creditCents = toCents(ta.credit);

      if (ta.controlRole === 'output_cgst') {
        outputCgstCents = creditCents - debitCents;
      } else if (ta.controlRole === 'output_sgst') {
        outputSgstCents = creditCents - debitCents;
      } else if (ta.controlRole === 'output_igst') {
        outputIgstCents = creditCents - debitCents;
      } else if (ta.controlRole === 'input_tax') {
        inputTaxCents = debitCents - creditCents;
      }
    }

    const totalOutputTaxCents = outputCgstCents + outputSgstCents + outputIgstCents;
    const netPayableCents = totalOutputTaxCents - inputTaxCents;

    // 2. Breakdown by tax code
    const allTaxCodes: TaxCode[] = await db
      .select()
      .from(taxCodes)
      .orderBy(asc(taxCodes.id));

    const components: TaxCodeComponent[] = await db
      .select()
      .from(taxCodeComponents)
      .orderBy(asc(taxCodeComponents.id));

    const codeCompMap = new Map<number, TaxCodeComponent[]>();
    for (const c of components) {
      const list = codeCompMap.get(c.tax_code_id) ?? [];
      list.push(c);
      codeCompMap.set(c.tax_code_id, list);
    }

    // Read taxable value from posted sales invoices within the date range
    // Each payment posted has subtotal minus discount_amount
    const invoiceRows = await db
      .select({
        subtotal: payments.subtotal,
        discount: payments.discount_amount,
        total: payments.total_amount,
      })
      .from(payments)
      .innerJoin(
        journalEntries,
        and(
          eq(journalEntries.source_type, 'sales_invoice'),
          eq(journalEntries.source_id, payments.id),
          gte(journalEntries.entry_date, from),
          lte(journalEntries.entry_date, to),
        ),
      );

    let salesTaxableCents = 0n;
    for (const inv of invoiceRows) {
      const sub = toCents(inv.subtotal);
      const disc = toCents(inv.discount);
      salesTaxableCents += sub - disc;
    }

    const taxCodeSummaries: GstTaxCodeSummaryDto[] = [];
    let totalTaxableValueCents = 0n;

    for (const tc of allTaxCodes) {
      const comps = codeCompMap.get(tc.id) ?? [];
      const rate = Number(tc.rate_percent);

      if (rate > 0 && comps.length > 0) {
        // If this code represents the active standard tax code
        const hasCgst = comps.some((c) => c.name.toLowerCase().includes('cgst'));
        const hasSgst = comps.some((c) => c.name.toLowerCase().includes('sgst'));
        const hasIgst = comps.some((c) => c.name.toLowerCase().includes('igst'));

        let cgstCents = 0n;
        let sgstCents = 0n;
        let igstCents = 0n;

        if (hasCgst && hasSgst) {
          cgstCents = outputCgstCents;
          sgstCents = outputSgstCents;
        } else if (hasIgst) {
          igstCents = outputIgstCents;
        }

        const codeTotalTax = cgstCents + sgstCents + igstCents;
        const taxable = salesTaxableCents; // Taxable value from source documents
        totalTaxableValueCents += taxable;

        taxCodeSummaries.push({
          tax_code_id: tc.id,
          tax_code_name: tc.name,
          rate_percent: tc.rate_percent,
          taxable_value: fromCents(taxable),
          cgst_amount: fromCents(cgstCents),
          sgst_amount: fromCents(sgstCents),
          igst_amount: fromCents(igstCents),
          total_tax: fromCents(codeTotalTax),
        });
      } else {
        taxCodeSummaries.push({
          tax_code_id: tc.id,
          tax_code_name: tc.name,
          rate_percent: tc.rate_percent,
          taxable_value: '0.00',
          cgst_amount: '0.00',
          sgst_amount: '0.00',
          igst_amount: '0.00',
          total_tax: '0.00',
        });
      }
    }

    return {
      taxCodes: taxCodeSummaries,
      totalTaxableValue: fromCents(totalTaxableValueCents),
      outputCgst: fromCents(outputCgstCents),
      outputSgst: fromCents(outputSgstCents),
      outputIgst: fromCents(outputIgstCents),
      totalOutputTax: fromCents(totalOutputTaxCents),
      inputTaxCredit: fromCents(inputTaxCents),
      netPayable: fromCents(netPayableCents),
    };
  }
}
