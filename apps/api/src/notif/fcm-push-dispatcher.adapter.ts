import { Injectable, Logger } from '@nestjs/common';
import { cert, getApps, initializeApp } from 'firebase-admin/app';
import { getMessaging, type Messaging } from 'firebase-admin/messaging';
import type {
  PushDispatchResult,
  PushDispatcherAdapter,
  PushMessagePayload,
} from './push-dispatcher.adapter';

export interface FcmCredentials {
  projectId: string;
  clientEmail: string;
  privateKey: string;
}

function readFirebaseErrorCode(err: unknown): string | undefined {
  if (err && typeof err === 'object' && 'code' in err) {
    const code = (err as { code?: unknown }).code;
    return typeof code === 'string' ? code : undefined;
  }
  return undefined;
}

@Injectable()
export class FcmPushDispatcherAdapter implements PushDispatcherAdapter {
  private readonly logger = new Logger(FcmPushDispatcherAdapter.name);
  private readonly messaging: Messaging;

  constructor(credentials: FcmCredentials) {
    const appName = 'fcm-push';
    const existing = getApps().find((app) => app.name === appName);
    const app =
      existing ??
      initializeApp(
        {
          credential: cert({
            projectId: credentials.projectId,
            clientEmail: credentials.clientEmail,
            privateKey: credentials.privateKey,
          }),
        },
        appName,
      );
    this.messaging = getMessaging(app);
  }

  async send(payload: PushMessagePayload): Promise<PushDispatchResult> {
    const data: Record<string, string> = {};
    for (const [key, value] of Object.entries(payload.data ?? {})) {
      if (value == null) continue;
      data[key] = typeof value === 'string' ? value : String(value);
    }

    try {
      const messageId = await this.messaging.send({
        token: payload.deviceToken,
        notification: { title: payload.title, body: payload.body },
        data,
        android: {
          priority: 'high',
          notification: { channelId: 'luxeknox_push' },
        },
        apns: { payload: { aps: { sound: 'default' } } },
      });
      return { success: true, messageId };
    } catch (err) {
      const code = readFirebaseErrorCode(err);
      const invalidToken =
        code === 'messaging/registration-token-not-registered' ||
        code === 'messaging/invalid-registration-token';

      this.logger.warn(
        `FCM send failed for ${payload.platform} device (invalidToken=${invalidToken}, code=${code ?? 'unknown'})`,
      );

      return {
        success: false,
        invalidToken,
        errorMessage: invalidToken ? 'Invalid device token' : 'Push send failed',
      };
    }
  }
}
