import { Injectable } from '@nestjs/common';
import {
  ATTENDANCE_METHODS,
  type AttendanceMethod,
} from '../platform/db/schema/attendance';
import { BadRequestError, UnauthorizedError } from '../platform/errors/app-error';
import { verifyAttendancePass } from './qr-token';

export interface HardwareIngestInput {
  user_id?: number;
  method?: string;
  gate_identifier?: string | null;
  payload?: string | null;
  /** True when the caller authenticated via X-Device-Key. */
  deviceAuthenticated: boolean;
  /** Authenticated bearer user id when present (staff/manual). */
  actorUserId?: number | null;
}

export interface ResolvedIngestEvent {
  userId: number;
  method: AttendanceMethod;
  gateIdentifier: string | null;
}

/**
 * ATT-005: stable hardware → domain identity boundary.
 * Vendor SDK specifics must stay outside this adapter.
 */
@Injectable()
export class HardwareIngestAdapter {
  resolve(input: HardwareIngestInput): ResolvedIngestEvent {
    const method = this.resolveMethod(input);

    if (method === 'qr_code') {
      if (!input.payload) {
        throw new BadRequestError('payload is required for qr_code check-in');
      }
      const claims = verifyAttendancePass(input.payload);
      if (!claims) {
        throw new UnauthorizedError('Invalid or expired attendance pass payload');
      }
      return {
        userId: claims.user_id,
        method,
        gateIdentifier: input.gate_identifier ?? null,
      };
    }

    if (method === 'rfid' || method === 'biometric') {
      if (!input.deviceAuthenticated) {
        throw new UnauthorizedError('RFID/biometric check-in requires device authentication');
      }
      if (input.user_id == null) {
        throw new BadRequestError('user_id is required for RFID/biometric check-in');
      }
      return {
        userId: input.user_id,
        method,
        gateIdentifier: input.gate_identifier ?? null,
      };
    }

    // manual_override
    if (input.actorUserId == null) {
      throw new UnauthorizedError('Manual check-in requires a staff session');
    }
    if (input.user_id == null) {
      throw new BadRequestError('user_id is required for manual check-in');
    }
    return {
      userId: input.user_id,
      method,
      gateIdentifier: input.gate_identifier ?? null,
    };
  }

  private resolveMethod(input: HardwareIngestInput): AttendanceMethod {
    if (input.method) {
      if (!(ATTENDANCE_METHODS as readonly string[]).includes(input.method)) {
        throw new BadRequestError(`Unsupported attendance method: ${input.method}`);
      }
      return input.method as AttendanceMethod;
    }
    if (input.payload) {
      return 'qr_code';
    }
    if (input.deviceAuthenticated) {
      throw new BadRequestError('method is required when payload is absent');
    }
    return 'manual_override';
  }
}
