import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BadRequestError, ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import { PaginationHelper } from '../platform/http/pagination';
import { NotificationService } from './notification.service';
import { LoggingPushDispatcherAdapter } from './push-dispatcher.adapter';
import type { NotificationRepository } from './notification.repository';

describe('NotificationService (V13: NOT-003 to NOT-015)', () => {
  let service: NotificationService;
  let repo: any;
  let pushDispatcher: LoggingPushDispatcherAdapter;
  let paginationHelper: any;
  let auditService: any;
  let eventBus: any;

  const mockAdmin: AuthenticatedUser = {
    id: 1,
    roleId: 1,
    userType: 'admin',
    email: 'admin@luxeknox.com',
    phoneNumber: null,
    profileId: null,
    sessionId: 1,
  };

  const mockTrainer: AuthenticatedUser = {
    id: 10,
    roleId: 2,
    userType: 'trainer',
    profileId: 5,
    email: 'trainer@luxeknox.com',
    phoneNumber: null,
    sessionId: 2,
  };

  const mockMember: AuthenticatedUser = {
    id: 100,
    roleId: 4,
    userType: 'member',
    profileId: 50,
    email: 'member@luxeknox.com',
    phoneNumber: null,
    sessionId: 3,
  };

  beforeEach(() => {
    repo = {
      findNotificationById: vi.fn(),
      insertNotification: vi.fn().mockResolvedValue(1),
      findUserInbox: vi.fn().mockResolvedValue([]),
      findUserInboxItem: vi.fn(),
      markDeliveryRead: vi.fn().mockResolvedValue(true),
      markAllDeliveriesRead: vi.fn().mockResolvedValue(3),
      insertDeliveries: vi.fn().mockResolvedValue(undefined),
      findDelivery: vi.fn().mockResolvedValue({ id: 1, retry_count: 0 }),
      updateDeliveryStatus: vi.fn().mockResolvedValue(undefined),
      findFailedDeliveries: vi.fn().mockResolvedValue([]),
      findDevicesByUserId: vi.fn().mockResolvedValue([]),
      upsertDevice: vi.fn(),
      deleteDevice: vi.fn().mockResolvedValue(true),
      findBroadcasts: vi.fn().mockResolvedValue({ rows: [], total: 0 }),
      findActiveUserIdsForRole: vi.fn().mockResolvedValue([100, 101]),
      findAllActiveMemberUserIds: vi.fn().mockResolvedValue([100, 101, 102]),
      findActiveAssignedClientUserIds: vi.fn().mockResolvedValue([100]),
      findTypeByCode: vi.fn().mockResolvedValue({ id: 5, type_code: 'announcement' }),
    };

    pushDispatcher = new LoggingPushDispatcherAdapter();
    paginationHelper = {
      resolveLimit: vi.fn().mockResolvedValue(20),
      normalizeParams: vi.fn().mockResolvedValue({ mode: 'offset', offset: 0, limit: 20 }),
    };
    auditService = {
      recordAudit: vi.fn().mockResolvedValue(undefined),
    };
    eventBus = {
      emit: vi.fn().mockResolvedValue([]),
    };

    service = new NotificationService(
      repo,
      pushDispatcher,
      paginationHelper,
      auditService,
      eventBus,
    );
  });

  describe('dispatch pipeline & delivery tracking (NOT-007, NOT-008, NOT-015)', () => {
    it('dispatches notification to active recipients, inserts deliveries and dispatches push', async () => {
      repo.findDevicesByUserId.mockResolvedValue([
        { id: 1, device_token: 'valid_token_ios', device_platform: 'ios' },
      ]);
      repo.findDelivery.mockResolvedValue({ id: 10, retry_count: 0 });

      const notifId = await service.dispatch({
        recipientUserIds: [100, 101],
        title: 'Gym Closure Alert',
        message: 'Gym will close at 8 PM for maintenance.',
        typeCode: 'announcement',
      });

      expect(notifId).toBe(1);
      expect(repo.insertNotification).toHaveBeenCalled();
      expect(repo.insertDeliveries).toHaveBeenCalledWith(
        expect.arrayContaining([
          expect.objectContaining({ notification_id: 1, user_id: 100 }),
          expect.objectContaining({ notification_id: 1, user_id: 101 }),
        ]),
      );
    });

    it('records failed delivery state when device token triggers push gateway error', async () => {
      repo.findDevicesByUserId.mockResolvedValue([
        { id: 1, device_token: 'invalid_token_fail', device_platform: 'android' },
      ]);
      repo.findDelivery.mockResolvedValue({ id: 10, retry_count: 0 });

      await service.sendPushToUser(100, 1, 'Test Title', 'Test Body');

      expect(repo.updateDeliveryStatus).toHaveBeenCalledWith(
        10,
        'failed',
        expect.objectContaining({
          failureReason: expect.stringContaining('Invalid device registration token'),
          retryCount: 1,
        }),
      );
    });

    it('records sent status when user has no registered push devices (inbox delivery)', async () => {
      repo.findDevicesByUserId.mockResolvedValue([]);
      repo.findDelivery.mockResolvedValue({ id: 10, retry_count: 0 });

      await service.sendPushToUser(100, 1, 'Test Title', 'Test Body');

      expect(repo.updateDeliveryStatus).toHaveBeenCalledWith(
        10,
        'sent',
        expect.objectContaining({ deliveredAt: expect.any(Date) }),
      );
    });
  });

  describe('inbox & read state (NOT-003, NOT-004, NOT-005)', () => {
    it('returns paginated inbox for user', async () => {
      repo.findUserInbox.mockResolvedValue([
        {
          id: 1,
          notification_type_id: 1,
          title: 'Welcome',
          message: 'Welcome to LuxeKnox',
          data_payload: null,
          sender_user_id: null,
          created_at: new Date(),
          is_read: false,
          read_at: null,
        },
      ]);

      const result = await service.getInbox(mockMember, { limit: 20 });
      expect(result.data).toHaveLength(1);
      expect(result.meta.limit).toBe(20);
    });

    it('fetches single notification detail if belonging to user', async () => {
      repo.findUserInboxItem.mockResolvedValue({
        id: 1,
        title: 'Detail',
        message: 'Detail message',
        created_at: new Date(),
        is_read: false,
        read_at: null,
      });

      const item = await service.getNotificationDetail(mockMember, 1);
      expect(item.id).toBe(1);
    });

    it('throws NotFoundError when notification is not in user inbox', async () => {
      repo.findUserInboxItem.mockResolvedValue(null);

      await expect(service.getNotificationDetail(mockMember, 999)).rejects.toThrow(
        NotFoundError,
      );
    });

    it('marks a single notification read', async () => {
      repo.markDeliveryRead.mockResolvedValue(true);
      repo.findUserInboxItem.mockResolvedValue({
        id: 1,
        title: 'Read notification',
        message: 'Content',
        is_read: true,
        read_at: new Date(),
        created_at: new Date(),
      });

      const updated = await service.markAsRead(mockMember, 1);
      expect(updated.is_read).toBe(true);
      expect(repo.markDeliveryRead).toHaveBeenCalledWith(mockMember.id, 1, expect.any(Date));
    });

    it('marks all notifications read for caller', async () => {
      await service.markAllAsRead(mockMember);
      expect(repo.markAllDeliveriesRead).toHaveBeenCalledWith(mockMember.id, expect.any(Date));
    });
  });

  describe('device registration & deletion (NOT-006)', () => {
    it('registers user push token', async () => {
      repo.upsertDevice.mockResolvedValue({
        id: 1,
        user_id: mockMember.id,
        device_token: 'fcm_token_123',
        device_platform: 'ios',
        last_active_at: new Date(),
        created_at: new Date(),
      });

      const device = await service.registerDevice(mockMember, {
        device_token: 'fcm_token_123',
        device_platform: 'ios',
      });

      expect(device.device_token).toBe('fcm_token_123');
      expect(repo.upsertDevice).toHaveBeenCalled();
    });

    it('deletes device and throws NotFoundError if not owned by user', async () => {
      repo.deleteDevice.mockResolvedValue(false);

      await expect(service.deleteDevice(mockMember, 99)).rejects.toThrow(NotFoundError);
    });
  });

  describe('broadcast audience resolution & restrictions (NOT-010, NOT-011, NOT-012)', () => {
    it('admin can broadcast to all_members', async () => {
      repo.findNotificationById.mockResolvedValue({
        id: 1,
        title: 'Gym Announcement',
        message: 'Maintenance tomorrow',
        created_at: new Date(),
      });

      const result = await service.broadcast(mockAdmin, {
        title: 'Gym Announcement',
        message: 'Maintenance tomorrow',
        audience: 'all_members',
      });

      expect(result.title).toBe('Gym Announcement');
      expect(repo.findAllActiveMemberUserIds).toHaveBeenCalled();
      expect(auditService.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'notification.broadcast' }),
      );
    });

    it('member cannot send broadcasts', async () => {
      await expect(
        service.broadcast(mockMember, {
          title: 'Unauthorized Broadcast',
          message: 'Spam',
          audience: 'all_members',
        }),
      ).rejects.toThrow(ForbiddenError);
    });

    it('trainer cannot broadcast to all_members', async () => {
      await expect(
        service.broadcast(mockTrainer, {
          title: 'Trainer Broadcast to all',
          message: 'Hey everyone',
          audience: 'all_members',
        }),
      ).rejects.toThrow(ForbiddenError);
    });

    it('trainer can broadcast to assigned_clients', async () => {
      repo.findNotificationById.mockResolvedValue({
        id: 2,
        title: 'Group Session Announcement',
        message: 'Class moving to studio B',
        created_at: new Date(),
      });

      const result = await service.broadcast(mockTrainer, {
        title: 'Group Session Announcement',
        message: 'Class moving to studio B',
        audience: 'assigned_clients',
      });

      expect(result.id).toBe(2);
      expect(repo.findActiveAssignedClientUserIds).toHaveBeenCalledWith(mockTrainer.profileId);
    });

    it('lists broadcasts scoped to trainer vs admin', async () => {
      repo.findBroadcasts.mockResolvedValue({ rows: [], total: 0 });

      // Trainer query passes their user ID
      await service.listBroadcasts(mockTrainer, { limit: 20, offset: 0 });
      expect(repo.findBroadcasts).toHaveBeenCalledWith(20, 0, mockTrainer.id);

      // Admin query does not filter by sender
      await service.listBroadcasts(mockAdmin, { limit: 20, offset: 0 });
      expect(repo.findBroadcasts).toHaveBeenCalledWith(20, 0, undefined);
    });
  });

  describe('failed-delivery retry policy (NOT-014)', () => {
    it('retries deliveries with retry count under threshold', async () => {
      repo.findFailedDeliveries.mockResolvedValue([
        { id: 10, notification_id: 1, user_id: 100, retry_count: 1 },
      ]);
      repo.findNotificationById.mockResolvedValue({
        id: 1,
        title: 'Retry Title',
        message: 'Retry Message',
      });
      repo.findDevicesByUserId.mockResolvedValue([
        { id: 1, device_token: 'valid_token_web', device_platform: 'web' },
      ]);

      const count = await service.retryFailedDeliveries(3);
      expect(count).toBe(1);
      expect(repo.findFailedDeliveries).toHaveBeenCalledWith(3, 50);
    });
  });
});
