import { z } from 'zod';

export const checkInRequestSchema = z
  .object({
    user_id: z.number().int().positive().optional(),
    method: z.enum(['qr_code', 'rfid', 'biometric', 'manual_override']).optional(),
    gate_identifier: z.string().max(100).optional().nullable(),
    payload: z.string().min(1).optional().nullable(),
  })
  .strict();

export type CheckInRequestDto = z.infer<typeof checkInRequestSchema>;

export const manualOverrideRequestSchema = z
  .object({
    user_id: z.number().int().positive(),
    gate_identifier: z.string().max(100).optional().nullable(),
    reason: z.string().trim().min(3).max(500),
  })
  .strict();

export type ManualOverrideRequestDto = z.infer<typeof manualOverrideRequestSchema>;

export const listAttendancesQuerySchema = z.object({
  user_id: z.coerce.number().int().positive().optional(),
  from: z.string().datetime().optional(),
  to: z.string().datetime().optional(),
  cursor: z.string().optional(),
  limit: z.coerce.number().int().positive().optional(),
});

export type ListAttendancesQueryDto = z.infer<typeof listAttendancesQuerySchema>;

export const attendanceSummaryQuerySchema = z.object({
  member_id: z.coerce.number().int().positive().optional(),
});

export type AttendanceSummaryQueryDto = z.infer<typeof attendanceSummaryQuerySchema>;

export const listAttendanceHistoriesQuerySchema = z.object({
  from: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  to: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  cursor: z.string().optional(),
  limit: z.coerce.number().int().positive().optional(),
});

export type ListAttendanceHistoriesQueryDto = z.infer<typeof listAttendanceHistoriesQuerySchema>;

export interface AttendanceResponseDto {
  id: number;
  user_id: number;
  check_in_time: string;
  check_out_time: string | null;
  method: string;
  gate_identifier: string | null;
  verified_by_user_id: number | null;
}

export interface AttendanceSummaryDto {
  streak_days: number;
  last_check_in: string | null;
  visits_this_month: number;
}

export interface AttendanceHistoryDto {
  id: number;
  date: string;
  total_member_checkins: number;
  total_trainer_checkins: number;
  peak_hour: number | null;
  peak_count: number | null;
}

export interface OccupancyDto {
  checked_in_now: number;
  as_of: string;
  by_gate: Array<{ gate_identifier: string | null; count: number }>;
}
