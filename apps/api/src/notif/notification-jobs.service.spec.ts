import { beforeEach, describe, expect, it, vi } from 'vitest';
import { NotificationJobsService } from './notification-jobs.service';

describe('NotificationJobsService (NOT-013, NOT-014)', () => {
  let jobsService: NotificationJobsService;
  let jobRunner: any;
  let notificationService: any;
  let membershipRepo: any;
  let scheduleRepo: any;
  let memberRepo: any;
  let fakeDb: any;

  beforeEach(() => {
    jobRunner = {
      register: vi.fn(),
      run: vi.fn().mockImplementation((name, fn) => fn()),
    };
    notificationService = {
      dispatch: vi.fn().mockResolvedValue(1),
      retryFailedDeliveries: vi.fn().mockResolvedValue(2),
    };
    fakeDb = {
      select: vi.fn().mockReturnThis(),
      from: vi.fn().mockReturnThis(),
      innerJoin: vi.fn().mockReturnThis(),
      where: vi.fn().mockResolvedValue([]),
    };
    membershipRepo = {
      getDb: vi.fn().mockReturnValue(fakeDb),
    };
    scheduleRepo = {
      getDb: vi.fn().mockReturnValue(fakeDb),
    };
    memberRepo = {
      findById: vi.fn(),
    };

    jobsService = new NotificationJobsService(
      jobRunner,
      notificationService,
      membershipRepo as any,
      scheduleRepo as any,
      memberRepo as any,
    );
  });

  it('registers jobs with JobRunner on module init', () => {
    jobsService.onModuleInit();
    expect(jobRunner.register).toHaveBeenCalledWith(
      'notifications.membership_reminders',
      expect.any(Function),
    );
    expect(jobRunner.register).toHaveBeenCalledWith(
      'notifications.session_reminders',
      expect.any(Function),
    );
    expect(jobRunner.register).toHaveBeenCalledWith(
      'notifications.payment_reminders',
      expect.any(Function),
    );
    expect(jobRunner.register).toHaveBeenCalledWith(
      'notifications.retry_failed_deliveries',
      expect.any(Function),
    );
  });

  it('runs membership expiry reminder query and dispatches notifications for active users', async () => {
    fakeDb.where.mockResolvedValue([
      {
        membershipId: 1,
        memberId: 10,
        endDate: '2026-09-25',
        userId: 100,
      },
    ]);

    const sent = await jobsService.runMembershipReminders();
    expect(sent).toBe(1);
    expect(notificationService.dispatch).toHaveBeenCalledWith(
      expect.objectContaining({
        recipientUserIds: [100],
        typeCode: 'membership_expiry',
        title: 'Membership Expiring Soon',
      }),
    );
  });

  it('runs session reminder query and dispatches notifications for upcoming booked sessions', async () => {
    fakeDb.where.mockResolvedValue([
      {
        scheduleId: 12,
        title: 'Pilates Class',
        startTime: new Date(Date.now() + 3600000),
        userId: 200,
      },
    ]);

    const sent = await jobsService.runSessionReminders();
    expect(sent).toBe(1);
    expect(notificationService.dispatch).toHaveBeenCalledWith(
      expect.objectContaining({
        recipientUserIds: [200],
        typeCode: 'session_reminder',
        title: 'Upcoming Session Reminder',
      }),
    );
  });

  it('runs retry failed deliveries job', async () => {
    const retried = await jobsService.runRetryFailedDeliveries();
    expect(retried).toBe(2);
    expect(notificationService.retryFailedDeliveries).toHaveBeenCalledWith(3);
  });
});
