import { beforeEach, describe, expect, it, vi } from 'vitest';
import { DeviceController, NotificationController } from './notification.controller';

describe('NotificationController & DeviceController (NOT-003, NOT-004, NOT-005, NOT-006, NOT-010)', () => {
  let notifController: NotificationController;
  let deviceController: DeviceController;
  let notifService: any;

  const mockUser: any = {
    id: 100,
    roleId: 4,
    userType: 'member',
  };

  beforeEach(() => {
    notifService = {
      getInbox: vi.fn().mockResolvedValue({ data: [], meta: { limit: 20 } }),
      getNotificationDetail: vi.fn().mockResolvedValue({ id: 1, title: 'Notice' }),
      markAsRead: vi.fn().mockResolvedValue({ id: 1, is_read: true }),
      markAllAsRead: vi.fn().mockResolvedValue(undefined),
      broadcast: vi.fn().mockResolvedValue({ id: 10, title: 'Broadcast' }),
      listBroadcasts: vi.fn().mockResolvedValue({ data: [], meta: { limit: 20 } }),
      listDevices: vi.fn().mockResolvedValue([{ id: 1, device_token: 'tok' }]),
      registerDevice: vi.fn().mockResolvedValue({ id: 1, device_token: 'tok' }),
      deleteDevice: vi.fn().mockResolvedValue(undefined),
    };

    notifController = new NotificationController(notifService);
    deviceController = new DeviceController(notifService);
  });

  describe('NotificationController', () => {
    it('calls getInbox on listNotifications', async () => {
      const res = await notifController.listNotifications(mockUser, { limit: 20 });
      expect(notifService.getInbox).toHaveBeenCalledWith(mockUser, { limit: 20 });
      expect(res.data).toEqual([]);
    });

    it('calls getNotificationDetail', async () => {
      const res = await notifController.getNotification(mockUser, 1);
      expect(notifService.getNotificationDetail).toHaveBeenCalledWith(mockUser, 1);
      expect(res.id).toBe(1);
    });

    it('calls markAsRead on markNotificationRead', async () => {
      const res = await notifController.markNotificationRead(mockUser, 1);
      expect(notifService.markAsRead).toHaveBeenCalledWith(mockUser, 1);
      expect(res.is_read).toBe(true);
    });

    it('calls markAllAsRead on markAllNotificationsRead', async () => {
      await notifController.markAllNotificationsRead(mockUser);
      expect(notifService.markAllAsRead).toHaveBeenCalledWith(mockUser);
    });

    it('calls broadcast on broadcast', async () => {
      const res = await notifController.broadcast(mockUser, {
        title: 'New Class',
        message: 'A new class is open',
      });
      expect(notifService.broadcast).toHaveBeenCalledWith(
        mockUser,
        expect.objectContaining({ title: 'New Class' }),
      );
      expect(res.id).toBe(10);
    });

    it('calls listBroadcasts', async () => {
      const res = await notifController.listBroadcasts(mockUser, { limit: 20, offset: 0 });
      expect(notifService.listBroadcasts).toHaveBeenCalledWith(mockUser, { limit: 20, offset: 0 });
      expect(res.data).toEqual([]);
    });
  });

  describe('DeviceController', () => {
    it('lists registered devices in expected envelope', async () => {
      const res = await deviceController.listDevices(mockUser);
      expect(notifService.listDevices).toHaveBeenCalledWith(mockUser);
      expect(res.data).toHaveLength(1);
      expect(res.meta).toEqual({ limit: 1, has_more: false });
    });

    it('registers device with token and platform', async () => {
      const res = await deviceController.registerDevice(mockUser, {
        device_token: 'tok',
        device_platform: 'ios',
      });
      expect(notifService.registerDevice).toHaveBeenCalledWith(mockUser, {
        device_token: 'tok',
        device_platform: 'ios',
      });
      expect(res.device_token).toBe('tok');
    });

    it('deletes device by id', async () => {
      await deviceController.deleteDevice(mockUser, 1);
      expect(notifService.deleteDevice).toHaveBeenCalledWith(mockUser, 1);
    });
  });
});
