import { Injectable, Logger } from '@nestjs/common';
import type { DevicePlatform } from '../platform/db/schema/notifications';

export interface PushMessagePayload {
  deviceToken: string;
  platform: DevicePlatform;
  title: string;
  body: string;
  data?: Record<string, unknown> | null;
}

export interface PushDispatchResult {
  success: boolean;
  messageId?: string;
  errorMessage?: string;
}

export abstract class PushDispatcherAdapter {
  abstract send(payload: PushMessagePayload): Promise<PushDispatchResult>;
}

/**
 * Standard log-based mock push dispatcher for testing and development.
 * Simulates real push network dispatch.
 */
@Injectable()
export class LoggingPushDispatcherAdapter implements PushDispatcherAdapter {
  private readonly logger = new Logger(LoggingPushDispatcherAdapter.name);

  async send(payload: PushMessagePayload): Promise<PushDispatchResult> {
    this.logger.debug(
      `[PushDispatcher] Dispatching to ${payload.platform} device ${payload.deviceToken.substring(0, 10)}...: "${payload.title}"`,
    );

    // If token contains 'invalid' or 'fail', simulate push gateway failure
    if (payload.deviceToken.includes('invalid') || payload.deviceToken.includes('fail')) {
      return {
        success: false,
        errorMessage: 'Invalid device registration token or push service unreachable',
      };
    }

    return {
      success: true,
      messageId: `msg_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`,
    };
  }
}
