import { beforeEach, describe, expect, it, vi } from 'vitest';

const { sendMock, messagingMock, initializeAppMock, certMock, apps } =
  vi.hoisted(() => {
    const sendMock = vi.fn();
    const messagingMock = vi.fn((_app?: unknown) => ({ send: sendMock }));
    const initializeAppMock = vi.fn((_opts?: unknown, name?: string) => {
      const app = { name: name ?? '[DEFAULT]' };
      apps.push(app);
      return app;
    });
    const certMock = vi.fn((value: unknown) => value);
    const apps: any[] = [];
    return { sendMock, messagingMock, initializeAppMock, certMock, apps };
  });

vi.mock('firebase-admin/app', () => ({
  get getApps() {
    return () => apps;
  },
  initializeApp: initializeAppMock,
  cert: certMock,
}));

vi.mock('firebase-admin/messaging', () => ({
  getMessaging: messagingMock,
}));

import { FcmPushDispatcherAdapter } from './fcm-push-dispatcher.adapter';

describe('FcmPushDispatcherAdapter', () => {
  let adapter: FcmPushDispatcherAdapter;

  beforeEach(() => {
    vi.clearAllMocks();
    apps.length = 0;
    sendMock.mockResolvedValue('projects/luxe-knox-app/messages/abc123');
    adapter = new FcmPushDispatcherAdapter({
      projectId: 'luxe-knox-app',
      clientEmail: 'sa@luxe-knox-app.iam.gserviceaccount.com',
      privateKey: '-----BEGIN PRIVATE KEY-----\nTEST\n-----END PRIVATE KEY-----\n',
    });
  });

  it('sends notification with string data and android channel luxeknox_push', async () => {
    const result = await adapter.send({
      deviceToken: 'device-token-1',
      platform: 'android',
      title: 'Session reminder',
      body: 'Your class starts soon',
      data: {
        schedule_id: 12,
        notification_id: 9,
        type_code: 'session_reminder',
        skip: null,
      },
    });

    expect(result).toEqual({
      success: true,
      messageId: 'projects/luxe-knox-app/messages/abc123',
    });
    expect(sendMock).toHaveBeenCalledTimes(1);
    expect(sendMock).toHaveBeenCalledWith({
      token: 'device-token-1',
      notification: {
        title: 'Session reminder',
        body: 'Your class starts soon',
      },
      data: {
        schedule_id: '12',
        notification_id: '9',
        type_code: 'session_reminder',
      },
      android: {
        priority: 'high',
        notification: { channelId: 'luxeknox_push' },
      },
      apns: { payload: { aps: { sound: 'default' } } },
    });
  });

  it('initializes dedicated fcm-push app even if a default app already exists', () => {
    apps.length = 0;
    apps.push({ name: '[DEFAULT]' }); // Existing credential-less app from verifier

    new FcmPushDispatcherAdapter({
      projectId: 'luxe-knox-app',
      clientEmail: 'sa@luxe-knox-app.iam.gserviceaccount.com',
      privateKey: 'key',
    });

    expect(initializeAppMock).toHaveBeenCalledWith(
      expect.objectContaining({
        credential: expect.anything(),
      }),
      'fcm-push',
    );
  });

  it('marks registration-token-not-registered as invalidToken', async () => {
    sendMock.mockRejectedValue({
      code: 'messaging/registration-token-not-registered',
      message: 'Requested entity was not found.',
    });

    const result = await adapter.send({
      deviceToken: 'dead-token',
      platform: 'ios',
      title: 'Hi',
      body: 'There',
    });

    expect(result).toEqual({
      success: false,
      invalidToken: true,
      errorMessage: 'Invalid device token',
    });
  });

  it('does not treat messaging/invalid-argument as invalidToken', async () => {
    sendMock.mockRejectedValue({
      code: 'messaging/invalid-argument',
      message: 'Invalid argument provided',
    });

    const result = await adapter.send({
      deviceToken: 'token-with-bad-argument',
      platform: 'android',
      title: 'Hi',
      body: 'There',
    });

    expect(result).toEqual({
      success: false,
      invalidToken: false,
      errorMessage: 'Push send failed',
    });
  });

  it('returns generic failure without leaking the token', async () => {
    sendMock.mockRejectedValue({
      code: 'messaging/internal-error',
      message: 'boom for token dead-token-should-not-leak',
    });

    const result = await adapter.send({
      deviceToken: 'dead-token-should-not-leak',
      platform: 'android',
      title: 'Hi',
      body: 'There',
    });

    expect(result.success).toBe(false);
    expect(result.invalidToken).toBe(false);
    expect(result.errorMessage).toBe('Push send failed');
    expect(result.errorMessage).not.toContain('dead-token-should-not-leak');
  });
});
