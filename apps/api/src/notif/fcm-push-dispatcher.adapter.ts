import { Injectable, Logger } from '@nestjs/common';
import * as admin from 'firebase-admin';
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
  private readonly messaging: admin.messaging.Messaging;

  constructor(credentials: FcmCredentials) {
    if (!admin.apps.length) {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: credentials.projectId,
          clientEmail: credentials.clientEmail,
          privateKey: credentials.privateKey,
        }),
      });
    }
    this.messaging = admin.messaging();
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
        code === 'messaging/invalid-registration-token' ||
        code === 'messaging/invalid-argument';

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
