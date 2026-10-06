import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { and, eq, gte, lte } from 'drizzle-orm';
import { JobRunnerService } from '../job/job-runner.service';
import { NotificationService } from './notification.service';
import { NotificationRepository } from './notification.repository';
import { MembershipRepository } from '../memb/membership.repository';
import { ScheduleRepository } from '../sched/schedule.repository';
import { MemberRepository } from '../people/member.repository';
import { PaymentRepository } from '../pay/payment.repository';
import { IdempotencyRepository } from '../platform/idempotency/idempotency.repository';
import { memberships } from '../platform/db/schema/memberships';
import { schedules, scheduleParticipants } from '../platform/db/schema/scheduling';
import { members } from '../platform/db/schema/members';
import { users } from '../platform/db/schema/users';

export const NOTIFICATION_MEMBERSHIP_REMINDERS_JOB = 'notifications.membership_reminders';
export const NOTIFICATION_SESSION_REMINDERS_JOB = 'notifications.session_reminders';
export const NOTIFICATION_PAYMENT_REMINDERS_JOB = 'notifications.payment_reminders';
export const NOTIFICATION_RETRY_FAILED_JOB = 'notifications.retry_failed_deliveries';

@Injectable()
export class NotificationJobsService implements OnModuleInit {
  private readonly logger = new Logger(NotificationJobsService.name);

  constructor(
    private readonly jobRunner: JobRunnerService,
    private readonly notificationService: NotificationService,
    private readonly membershipRepository: MembershipRepository,
    private readonly scheduleRepository: ScheduleRepository,
    private readonly memberRepository: MemberRepository,
    private readonly notificationRepository: NotificationRepository,
    private readonly paymentRepository: PaymentRepository,
    private readonly idempotencyRepository: IdempotencyRepository,
  ) {}

  private utcDay(date = new Date()): string {
    return date.toISOString().slice(0, 10);
  }

  onModuleInit(): void {
    this.jobRunner.register(NOTIFICATION_MEMBERSHIP_REMINDERS_JOB, () =>
      this.runMembershipReminders(),
    );
    this.jobRunner.register(NOTIFICATION_SESSION_REMINDERS_JOB, () =>
      this.runSessionReminders(),
    );
    this.jobRunner.register(NOTIFICATION_PAYMENT_REMINDERS_JOB, () =>
      this.runPaymentReminders(),
    );
    this.jobRunner.register(NOTIFICATION_RETRY_FAILED_JOB, () =>
      this.runRetryFailedDeliveries(),
    );
  }

  /**
   * Daily at 08:00 UTC: Notify members whose memberships expire within 7 days.
   */
  @Cron('0 8 * * *')
  async cronMembershipReminders(): Promise<void> {
    await this.jobRunner.run(NOTIFICATION_MEMBERSHIP_REMINDERS_JOB, () =>
      this.runMembershipReminders(),
    );
  }

  /**
   * Hourly: Notify participants of sessions starting in the next 2 hours.
   */
  @Cron('0 * * * *')
  async cronSessionReminders(): Promise<void> {
    await this.jobRunner.run(NOTIFICATION_SESSION_REMINDERS_JOB, () =>
      this.runSessionReminders(),
    );
  }

  /**
   * Daily at 09:00 UTC: Remind members about pending dues or payments.
   */
  @Cron('0 9 * * *')
  async cronPaymentReminders(): Promise<void> {
    await this.jobRunner.run(NOTIFICATION_PAYMENT_REMINDERS_JOB, () =>
      this.runPaymentReminders(),
    );
  }

  /**
   * Every 30 minutes: Retry failed push notification deliveries up to 3 times.
   */
  @Cron('*/30 * * * *')
  async cronRetryFailedDeliveries(): Promise<void> {
    await this.jobRunner.run(NOTIFICATION_RETRY_FAILED_JOB, () =>
      this.runRetryFailedDeliveries(),
    );
  }

  // ==================== Job Logic Implementations ====================

  async runMembershipReminders(): Promise<number> {
    const today = new Date().toISOString().slice(0, 10);
    const in7Days = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().slice(0, 10);

    const db = this.membershipRepository.getDb() as any;
    const rows = await db
      .select({
        membershipId: memberships.id,
        memberId: memberships.member_id,
        endDate: memberships.end_date,
        userId: members.user_id,
      })
      .from(memberships)
      .innerJoin(members, eq(members.id, memberships.member_id))
      .innerJoin(users, eq(users.id, members.user_id))
      .where(
        and(
          eq(memberships.status, 'active'),
          gte(memberships.end_date, today),
          lte(memberships.end_date, in7Days),
          eq(users.status, 'active'),
        ),
      );

    const day = this.utcDay();
    const candidateKeys = rows.map(
      (r: { membershipId: number }) => `remind:membership_expiry:${r.membershipId}:${day}`,
    );
    const activeKeys = await this.idempotencyRepository.findActiveKeys(candidateKeys, new Date());

    const processedEntries: Array<{ key: string; path: string; expiresAt: Date }> = [];
    const expiresAt = new Date(Date.now() + 2 * 24 * 60 * 60 * 1000);
    let sent = 0;

    for (let i = 0; i < rows.length; i++) {
      const row = rows[i];
      const key = candidateKeys[i];
      if (activeKeys.has(key)) continue;

      await this.notificationService.dispatch({
        recipientUserIds: [row.userId],
        title: 'Membership Expiring Soon',
        message: `Your membership expires on ${row.endDate}. Renew today to continue enjoying full access!`,
        typeCode: 'membership_expiry',
        dataPayload: { membership_id: row.membershipId, end_date: row.endDate },
      });
      processedEntries.push({ key, path: NOTIFICATION_MEMBERSHIP_REMINDERS_JOB, expiresAt });
      sent++;
    }

    if (processedEntries.length > 0) {
      await this.idempotencyRepository.recordJobKeys(processedEntries);
    }

    this.logger.log(`Dispatched ${sent} membership expiry reminder(s)`);
    return sent;
  }

  async runSessionReminders(): Promise<number> {
    const now = new Date();
    const in2Hours = new Date(now.getTime() + 2 * 60 * 60 * 1000);

    const db = this.scheduleRepository.getDb() as any;
    const rows = await db
      .select({
        scheduleId: schedules.id,
        title: schedules.title,
        startTime: schedules.start_time,
        userId: members.user_id,
      })
      .from(scheduleParticipants)
      .innerJoin(schedules, eq(schedules.id, scheduleParticipants.schedule_id))
      .innerJoin(members, eq(members.id, scheduleParticipants.member_id))
      .innerJoin(users, eq(users.id, members.user_id))
      .where(
        and(
          eq(scheduleParticipants.booking_status, 'booked'),
          eq(schedules.status, 'scheduled'),
          gte(schedules.start_time, now),
          lte(schedules.start_time, in2Hours),
          eq(users.status, 'active'),
        ),
      );

    const day = this.utcDay();
    const candidateKeys = rows.map(
      (r: { scheduleId: number; userId: number }) =>
        `remind:session_reminder:${r.scheduleId}:${r.userId}:${day}`,
    );
    const activeKeys = await this.idempotencyRepository.findActiveKeys(candidateKeys, new Date());

    const processedEntries: Array<{ key: string; path: string; expiresAt: Date }> = [];
    const expiresAt = new Date(Date.now() + 2 * 24 * 60 * 60 * 1000);
    let sent = 0;

    for (let i = 0; i < rows.length; i++) {
      const row = rows[i];
      const key = candidateKeys[i];
      if (activeKeys.has(key)) continue;

      await this.notificationService.dispatch({
        recipientUserIds: [row.userId],
        title: 'Upcoming Session Reminder',
        message: `Reminder: Your session "${row.title}" starts at ${new Date(row.startTime).toLocaleTimeString()}.`,
        typeCode: 'session_reminder',
        dataPayload: { schedule_id: row.scheduleId },
      });
      processedEntries.push({ key, path: NOTIFICATION_SESSION_REMINDERS_JOB, expiresAt });
      sent++;
    }

    if (processedEntries.length > 0) {
      await this.idempotencyRepository.recordJobKeys(processedEntries);
    }

    this.logger.log(`Dispatched ${sent} upcoming session reminder(s)`);
    return sent;
  }

  async runPaymentReminders(): Promise<number> {
    const rows = await this.paymentRepository.findPendingPaymentReminderCandidates();

    const day = this.utcDay();
    const candidateKeys = rows.map(
      (r) => `remind:payment_due:${r.paymentId}:${day}`,
    );
    const activeKeys = await this.idempotencyRepository.findActiveKeys(candidateKeys, new Date());

    const processedEntries: Array<{ key: string; path: string; expiresAt: Date }> = [];
    const expiresAt = new Date(Date.now() + 2 * 24 * 60 * 60 * 1000);
    let sent = 0;

    for (let i = 0; i < rows.length; i++) {
      const row = rows[i];
      const key = candidateKeys[i];
      if (activeKeys.has(key)) continue;

      const outstanding = Math.max(
        0,
        Number(row.totalAmount) - Number(row.amountPaid ?? 0),
      );
      const amount = outstanding.toFixed(2);

      await this.notificationService.dispatch({
        recipientUserIds: [row.userId],
        title: 'Payment Due',
        message: `You have an outstanding payment of ${amount}.`,
        typeCode: 'payment_due',
        dataPayload: {
          payment_id: row.paymentId,
          amount,
        },
      });
      processedEntries.push({ key, path: NOTIFICATION_PAYMENT_REMINDERS_JOB, expiresAt });
      sent++;
    }

    if (processedEntries.length > 0) {
      await this.idempotencyRepository.recordJobKeys(processedEntries);
    }

    this.logger.log(`Dispatched ${sent} payment due reminder(s)`);
    return sent;
  }

  async runRetryFailedDeliveries(): Promise<number> {
    const count = await this.notificationService.retryFailedDeliveries(3);
    this.logger.log(`Retried ${count} failed push notification delivery(ies)`);
    return count;
  }
}
