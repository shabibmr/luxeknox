import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { SettingsService } from '../sys/settings.service';
import { signAttendancePass } from './qr-token';

export interface AttendancePassDto {
  user_id: number;
  payload: string;
  expires_at: string;
}

/**
 * ATT-002: mints a short-lived, signed digital attendance pass for the
 * authenticated user. The `payload` is an opaque signed QR/barcode value
 * (see `qr-token.ts`); the client re-fetches this endpoint once it nears
 * `expires_at` rather than caching the pass indefinitely.
 */
@Injectable()
export class AttendancePassService {
  constructor(private readonly settingsService: SettingsService) {}

  async getPass(actor: AuthenticatedUser): Promise<AttendancePassDto> {
    const ttlMinutes = await this.settingsService.getAttendancePassTtlMinutes();
    const { payload, expires_at } = signAttendancePass(actor.id, ttlMinutes * 60);
    return { user_id: actor.id, payload, expires_at };
  }
}
