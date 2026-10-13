import { describe, it, expect, beforeAll, afterAll, vi } from 'vitest';
import { eq, sql } from 'drizzle-orm';
import {
  createTestApp,
  seedTestUsers,
  ADMIN_CREDENTIALS,
  type TestAppInstance,
} from './helpers/mysql';
import { seedAccounting } from '../src/platform/db/seed/accounting';
import {
  accounts,
  journalEntries,
  journalLines,
  revenueRecognitionSchedules,
  revenueRecognitionLines,
  type Account,
} from '../src/platform/db/schema/accounting';
import { memberships, membershipProducts, membershipFreezes } from '../src/platform/db/schema/memberships';
import { payments, paymentMethods, paymentHistories } from '../src/platform/db/schema/payments';
import { addMoney, cmpMoney, subMoney } from '../src/platform/money/money';
import { AccountsRepository } from '../src/acct/accounts.repository';
import { PaymentRepository } from '../src/pay/payment.repository';
import { PaymentService } from '../src/pay/payment.service';
import { SalesBridgeService } from '../src/acct/sales-bridge.service';
import { RevenueRecognitionService } from '../src/acct/revenue-recognition.service';
import { RevenueRecognitionRepository } from '../src/acct/revenue-recognition.repository';
import { MembershipRepository } from '../src/memb/membership.repository';

describe('Accounting Lifecycle E2E (ACC-081)', () => {
  let testApp: TestAppInstance;
  let adminToken: string;
  let bankAccount: Account;
  let equityAccount: Account;
  let arAccount: Account;
  let unearnedAccount: Account;
  let incomeAccount: Account;
  let forfeitAccount: Account;
  let paymentMethodId: number;
  let memberId: number;
  let productId: number;
  let membershipId: number;
  let invoiceId: number;
  let collectionHistoryId: number;
  let scheduleId: number;

  async function loginAdmin(): Promise<string> {
    const res = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: ADMIN_CREDENTIALS.email,
        password: ADMIN_CREDENTIALS.password,
      }),
    });
    expect(res.status).toBe(200);
    const data = (await res.json()) as any;
    return data.accessToken;
  }

  beforeAll(async () => {
    vi.useFakeTimers({ toFake: ['Date'] });
    vi.setSystemTime(new Date('2026-04-01T10:00:00.000Z'));

    testApp = await createTestApp();
    await seedTestUsers(testApp.db);
    await seedAccounting(testApp.db);

    // Clean prior test accounting transactions if any
    await testApp.db.delete(revenueRecognitionLines);
    await testApp.db.delete(revenueRecognitionSchedules);
    await testApp.db.delete(journalLines);
    await testApp.db.delete(journalEntries);
    await testApp.db.delete(membershipProducts).where(sql`code LIKE 'MEMB-30D-%'`);

    adminToken = await loginAdmin();

    const accountsRepo = testApp.app.get(AccountsRepository);
    bankAccount = (await accountsRepo.findByCode('1010'))!;
    equityAccount = (await accountsRepo.findByCode('3000'))!;
    arAccount = (await accountsRepo.findByCode('1100'))!;
    unearnedAccount = (await accountsRepo.findByCode('2200'))!;
    incomeAccount = (await accountsRepo.findByCode('4000'))!;
    forfeitAccount = (await accountsRepo.findByCode('4300'))!;

    expect(bankAccount).toBeDefined();
    expect(equityAccount).toBeDefined();
    expect(arAccount).toBeDefined();
    expect(unearnedAccount).toBeDefined();
    expect(incomeAccount).toBeDefined();
    expect(forfeitAccount).toBeDefined();
  });

  afterAll(async () => {
    vi.useRealTimers();
    if (testApp?.app) {
      await testApp.app.close();
    }
  });

  it('Step 1: Post opening journal and configure payment method', async () => {
    // 1. Check unearned preview (GET /v1/accounting/go-live/unearned-preview)
    const previewRes = await fetch(`${testApp.baseUrl}/accounting/go-live/unearned-preview`, {
      headers: { Authorization: `Bearer ${adminToken}` },
    });
    expect(previewRes.status).toBe(200);
    const preview = (await previewRes.json()) as any;
    expect(preview.totals).toBeDefined();
    expect(preview.totals.unearned_membership_total).toBeDefined();

    const unearnedMemb = preview.totals.unearned_membership_total ?? '0.00';
    const unearnedPt = preview.totals.unearned_pt_total ?? '0.00';
    const accountsRepo = testApp.app.get(AccountsRepository);

    const lines: Array<{ account_id: number; debit?: string; credit?: string; memo: string }> = [
      {
        account_id: equityAccount.id,
        credit: '50000.00',
        memo: "Owner's equity",
      },
    ];

    let totalDebit = '50000.00';
    if (cmpMoney(unearnedMemb, '0.00') > 0) {
      lines.push({
        account_id: unearnedAccount.id,
        credit: unearnedMemb,
        memo: 'Opening unearned membership',
      });
      totalDebit = addMoney(totalDebit, unearnedMemb);
    }
    if (cmpMoney(unearnedPt, '0.00') > 0) {
      const ptAccount = (await accountsRepo.findByCode('2210'))!;
      lines.push({
        account_id: ptAccount.id,
        credit: unearnedPt,
        memo: 'Opening unearned PT',
      });
      totalDebit = addMoney(totalDebit, unearnedPt);
    }

    lines.unshift({
      account_id: bankAccount.id,
      debit: totalDebit,
      memo: 'Opening bank balance',
    });

    const openRes = await fetch(`${testApp.baseUrl}/accounting/journals`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        entry_date: '2026-04-01',
        source_type: 'opening_balance',
        memo: 'Go-live opening balance journal',
        lines,
      }),
    });
    if (openRes.status !== 201) {
      console.error('POST /accounting/journals failed:', await openRes.text());
    }
    expect(openRes.status).toBe(201);
    const openJournal = (await openRes.json()) as any;
    expect(openJournal.id).toBeGreaterThan(0);
    expect(openJournal.source_type).toBe('opening_balance');

    // 3. Ensure payment method has account_id set to active bank account (1010)
    const existingMethods = await testApp.db.select().from(paymentMethods);
    if (existingMethods.length === 0) {
      const [insertRes] = await testApp.db.insert(paymentMethods).values({
        method_name: 'Bank Transfer',
        is_digital: true,
        is_active: true,
        account_id: bankAccount.id,
        created_at: new Date(),
        updated_at: new Date(),
      });
      paymentMethodId = Number((insertRes as any).insertId);
    } else {
      await testApp.db
        .update(paymentMethods)
        .set({ account_id: bankAccount.id })
        .where(eq(paymentMethods.is_active, true));
      paymentMethodId = existingMethods[0].id;
    }

    const [pm] = await testApp.db
      .select()
      .from(paymentMethods)
      .where(eq(paymentMethods.id, paymentMethodId));
    expect(pm.account_id).toBe(bankAccount.id);
  });

  it('Step 2: Enable posting in settings', async () => {
    // Update settings via PUT /v1/settings
    const putRes = await fetch(`${testApp.baseUrl}/settings`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        items: [
          { setting_key: 'tax_rate_percent', setting_value: '0.00' },
          { setting_key: 'accounting.default_tax_code', setting_value: 'exempt' },
          { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
        ],
      }),
    });
    if (putRes.status !== 200) {
      console.error('PUT /settings failed:', await putRes.text());
    }
    expect(putRes.status).toBe(200);

    // Verify posting is now enabled
    const getRes = await fetch(`${testApp.baseUrl}/settings`, {
      headers: { Authorization: `Bearer ${adminToken}` },
    });
    expect(getRes.status).toBe(200);
    const settingsData = (await getRes.json()) as any;
    const postingSetting = settingsData.data.find(
      (s: any) => s.setting_key === 'accounting.posting_enabled',
    );
    expect(postingSetting?.setting_value).toBe('true');
  });

  it('Step 3: Issue membership invoice mid-month (2026-04-15 to 2026-05-14)', async () => {
    // Advance time to mid-month
    vi.setSystemTime(new Date('2026-04-15T10:00:00.000Z'));
    adminToken = await loginAdmin();

    const runTag = Math.floor(Math.random() * 10000000);

    // 1. Create a member
    const memberRes = await fetch(`${testApp.baseUrl}/members`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        email: `e2e_midmonth_${runTag}@luxeknox.test`,
        password: 'Password123!',
        first_name: 'MidMonth',
        last_name: 'Member',
        gender: 'male',
      }),
    });
    if (memberRes.status !== 201) {
      console.error('POST /members failed:', await memberRes.text());
    }
    expect(memberRes.status).toBe(201);
    const memberData = (await memberRes.json()) as any;
    memberId = memberData.id;

    // 2. Create a membership product (30 days, 3000.00, allows up to 15 freeze days)
    const [prodRes] = await testApp.db.insert(membershipProducts).values({
      name: '30-Day Monthly Package',
      code: `MEMB-30D-${runTag}`,
      duration_days: 30,
      base_price: '3000.00',
      tax_percentage: '0.00',
      max_freeze_days: 15,
      income_account_id: incomeAccount.id,
      is_active: true,
      created_at: new Date(),
    });
    productId = Number((prodRes as any).insertId);

    // 3. Create membership (2026-04-15 to 2026-05-14: exactly 30 days)
    const [membRes] = await testApp.db.insert(memberships).values({
      member_id: memberId,
      product_id: productId,
      start_date: '2026-04-15',
      end_date: '2026-05-14',
      status: 'active',
      row_version: 1,
      created_at: new Date(),
    });
    membershipId = Number((membRes as any).insertId);

    // 4. Issue invoice via PaymentService (unpaid / pending)
    const paymentService = testApp.app.get(PaymentService);
    const invoice = await paymentService.create(
      {
        member_id: memberId,
        membership_id: membershipId,
        product_id: productId,
        start_date: '2026-04-15',
        subtotal: '3000.00',
      },
      {
        id: 1,
        email: ADMIN_CREDENTIALS.email,
        userType: 'admin',
        roleId: 1,
        profileId: null,
        sessionId: 1,
      },
    );
    expect(invoice.id).toBeGreaterThan(0);
    expect(invoice.status).toBe('pending');
    invoiceId = invoice.id;

    // 5. Verify sales bridge triggered: AR (1100) debited, Unearned (2200) credited
    const invoiceJournals = await testApp.db
      .select()
      .from(journalEntries)
      .where(
        sql`${journalEntries.source_type} = 'sales_invoice' AND ${journalEntries.source_id} = ${invoiceId}`,
      );
    expect(invoiceJournals.length).toBe(1);

    const invoiceLines = await testApp.db
      .select()
      .from(journalLines)
      .where(eq(journalLines.journal_entry_id, invoiceJournals[0].id));

    const arLine = invoiceLines.find((l) => l.account_id === arAccount.id);
    const unearnedLine = invoiceLines.find((l) => l.account_id === unearnedAccount.id);
    expect(arLine).toBeDefined();
    expect(arLine?.debit).toBe('3000.00');
    expect(unearnedLine).toBeDefined();
    expect(unearnedLine?.credit).toBe('3000.00');

    // 6. Verify revenue recognition schedule was created with status 'open'
    const schedules = await testApp.db
      .select()
      .from(revenueRecognitionSchedules)
      .where(eq(revenueRecognitionSchedules.payment_id, invoiceId));
    expect(schedules.length).toBe(1);
    expect(schedules[0].status).toBe('open');
    expect(schedules[0].total_amount).toBe('3000.00');
    expect(schedules[0].recognized_amount).toBe('0.00');
    expect(schedules[0].starts_on).toBe('2026-04-15');
    expect(schedules[0].ends_on).toBe('2026-05-14');
    scheduleId = schedules[0].id;
  });

  it('Step 4: Collect payment', async () => {
    const paymentRepository = testApp.app.get(PaymentRepository);
    const salesBridgeService = testApp.app.get(SalesBridgeService);

    // Record payment collection history
    const history = await paymentRepository.insertHistory({
      payment_id: invoiceId,
      payment_method_id: paymentMethodId,
      action: 'payment_received',
      amount: '3000.00',
      notes: 'Full collection via bank transfer',
      timestamp: new Date('2026-04-15T12:00:00.000Z'),
    });
    collectionHistoryId = history.id;

    // Update payment header to paid
    await paymentRepository.updatePayment(invoiceId, {
      amount_paid: '3000.00',
      status: 'paid',
      row_version: 2,
      updated_at: new Date('2026-04-15T12:00:00.000Z'),
    });

    const paymentRow = await paymentRepository.findById(invoiceId);
    expect(paymentRow).toBeDefined();

    // Trigger collection journal via sales bridge
    const receiptJournal = await salesBridgeService.onPaymentReceived(history, paymentRow!);
    expect(receiptJournal).toBeDefined();

    // Verify collection journal: bank debited, AR credited
    const receiptLines = await testApp.db
      .select()
      .from(journalLines)
      .where(eq(journalLines.journal_entry_id, receiptJournal!.id));

    const bankLine = receiptLines.find((l) => l.account_id === bankAccount.id);
    const arLine = receiptLines.find((l) => l.account_id === arAccount.id);
    expect(bankLine).toBeDefined();
    expect(bankLine?.debit).toBe('3000.00');
    expect(arLine).toBeDefined();
    expect(arLine?.credit).toBe('3000.00');
  });

  it('Step 5: Run revenue recognition through 2026-04-30 (16 of 30 days)', async () => {
    const revenueRecognitionService = testApp.app.get(RevenueRecognitionService);

    // Run recognition job for the April period
    const result = await revenueRecognitionService.runMonthlyRecognition('2026-04-30');
    expect(result).toBeDefined();
    expect(result?.recognizedCount).toBe(1);
    expect(result?.totalRecognized).toBe('1600.00');

    // Verify recognition journal: debit 2200, credit 4000
    const recJournals = await testApp.db
      .select()
      .from(journalEntries)
      .where(eq(journalEntries.source_type, 'revenue_recognition'));
    expect(recJournals.length).toBe(1);

    const recLines = await testApp.db
      .select()
      .from(journalLines)
      .where(eq(journalLines.journal_entry_id, recJournals[0].id));

    const unearnedDebitLine = recLines.find((l) => l.account_id === unearnedAccount.id);
    const incomeCreditLine = recLines.find((l) => l.account_id === incomeAccount.id);
    expect(unearnedDebitLine?.debit).toBe('1600.00');
    expect(incomeCreditLine?.credit).toBe('1600.00');

    // Verify schedule updated recognized_amount
    const [schedule] = await testApp.db
      .select()
      .from(revenueRecognitionSchedules)
      .where(eq(revenueRecognitionSchedules.id, scheduleId));
    expect(schedule.recognized_amount).toBe('1600.00');
    expect(schedule.recognized_through).toBe('2026-04-30');
    expect(schedule.status).toBe('open');
  });

  it('Step 6: Freeze membership from 2026-05-01', async () => {
    vi.setSystemTime(new Date('2026-05-01T10:00:00.000Z'));
    adminToken = await loginAdmin();

    // Freeze membership for 7 days via API
    const freezeRes = await fetch(`${testApp.baseUrl}/memberships/${membershipId}/freezes`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        start_date: '2026-05-01',
        end_date: '2026-05-07',
        reason: 'Mid-term vacation',
      }),
    });
    expect(freezeRes.status).toBe(201);

    // Verify recognition schedule is paused
    const [schedule] = await testApp.db
      .select()
      .from(revenueRecognitionSchedules)
      .where(eq(revenueRecognitionSchedules.id, scheduleId));
    expect(schedule.status).toBe('paused');
    expect(schedule.paused_from).toBe('2026-05-01');
  });

  it('Step 7: Cancel membership, forfeit unearned revenue to 4300', async () => {
    vi.setSystemTime(new Date('2026-05-02T10:00:00.000Z'));
    adminToken = await loginAdmin();

    const membershipRepo = testApp.app.get(MembershipRepository);
    const membBefore = await membershipRepo.findById(membershipId);
    expect(membBefore).toBeDefined();

    // Cancel membership via API
    const cancelRes = await fetch(`${testApp.baseUrl}/memberships/${membershipId}/cancel`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        row_version: membBefore!.row_version,
        reason: 'Member cancelled contract',
      }),
    });
    expect(cancelRes.status).toBe(200);

    // Verify forfeit journal posted: Debit 2200 for remaining 1400.00, Credit 4300 for 1400.00
    const forfeitJournals = await testApp.db
      .select()
      .from(journalEntries)
      .where(
        sql`${journalEntries.source_type} = 'recognition_forfeit' AND ${journalEntries.source_id} = ${scheduleId}`,
      );
    expect(forfeitJournals.length).toBe(1);

    const forfeitLines = await testApp.db
      .select()
      .from(journalLines)
      .where(eq(journalLines.journal_entry_id, forfeitJournals[0].id));

    const unearnedDebit = forfeitLines.find((l) => l.account_id === unearnedAccount.id);
    const forfeitCredit = forfeitLines.find((l) => l.account_id === forfeitAccount.id);
    expect(unearnedDebit?.debit).toBe('1400.00');
    expect(forfeitCredit?.credit).toBe('1400.00');

    // Verify recognition schedule is closed and unearned is 0
    const [schedule] = await testApp.db
      .select()
      .from(revenueRecognitionSchedules)
      .where(eq(revenueRecognitionSchedules.id, scheduleId));
    expect(schedule.status).toBe('closed');
    const remainingUnearned = subMoney(schedule.total_amount, schedule.recognized_amount);
    expect(remainingUnearned).toBe('0.00');
  });

  it('Step 8: Read trial balance report and verify balances', async () => {
    // Fetch trial balance report
    const tbRes = await fetch(
      `${testApp.baseUrl}/accounting/reports/trial-balance?from=2026-04-01&to=2026-05-31`,
      {
        headers: { Authorization: `Bearer ${adminToken}` },
      },
    );
    expect(tbRes.status).toBe(200);
    const tb = (await tbRes.json()) as any;

    // 1. Total debits === Total credits (trial balance balances!)
    expect(tb.total_debit).toBe(tb.total_credit);
    expect(tb.total_debit).toBe('59000.00');

    // 2. Account 4000 has the prorated recognized amount (1600.00)
    const acc4000 = tb.accounts.find((a: any) => a.account_code === '4000');
    expect(acc4000).toBeDefined();
    expect(acc4000?.credit).toBe('1600.00');
    expect(acc4000?.debit).toBe('0.00');

    // 3. Account 4300 has the remaining forfeited amount (1400.00)
    const acc4300 = tb.accounts.find((a: any) => a.account_code === '4300');
    expect(acc4300).toBeDefined();
    expect(acc4300?.credit).toBe('1400.00');
    expect(acc4300?.debit).toBe('0.00');

    // 4. Account 2200 net balance is zero (fully recognized 1600 + forfeited 1400 = 3000 credited)
    const acc2200 = tb.accounts.find((a: any) => a.account_code === '2200');
    expect(acc2200).toBeDefined();
    expect(acc2200?.debit).toBe('3000.00');
    expect(acc2200?.credit).toBe('3000.00');
    const net2200 = subMoney(acc2200.debit, acc2200.credit);
    expect(net2200).toBe('0.00');

    // 5. Account 1010 Bank holds 50000 opening + 3000 collected = 53000.00 debit
    const acc1010 = tb.accounts.find((a: any) => a.account_code === '1010');
    expect(acc1010?.debit).toBe('53000.00');

    // 6. Account 3000 Owner's capital holds 50000.00 credit
    const acc3000 = tb.accounts.find((a: any) => a.account_code === '3000');
    expect(acc3000?.credit).toBe('50000.00');

    // 7. Schedule unearned is zero and 4300 holds the rest
    const recRepo = testApp.app.get(RevenueRecognitionRepository);
    const schedule = (await recRepo.findById(scheduleId))!;
    expect(schedule.status).toBe('closed');
    const scheduleUnearned = subMoney(schedule.total_amount, schedule.recognized_amount);
    expect(scheduleUnearned).toBe('0.00');
    expect(acc4300?.credit).toBe('1400.00');
  });
});
