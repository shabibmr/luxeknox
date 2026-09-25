import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import type { NewTrainerAvailability, TrainerAvailability } from '../platform/db/schema/scheduling';
import { BadRequestError, NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { TrainerRepository } from '../people/trainer.repository';
import type { TrainerAvailabilityWriteDto } from './trainer-availability.dto';
import { TrainerAvailabilityRepository } from './trainer-availability.repository';

function normalizeTime(time: string): string {
  return time.length === 5 ? `${time}:00` : time;
}

@Injectable()
export class TrainerAvailabilityService {
  constructor(
    private readonly repository: TrainerAvailabilityRepository,
    private readonly trainerRepository: TrainerRepository,
    private readonly auditService: AuditService,
  ) {}

  async listForTrainer(trainerId: number): Promise<PaginatedResponse<TrainerAvailability>> {
    const trainer = await this.trainerRepository.findById(trainerId);
    if (!trainer) {
      throw new NotFoundError('Trainer not found');
    }

    const rows = await this.repository.findByTrainerId(trainerId);
    return createPaginatedResponse({
      items: rows,
      limit: rows.length || 1,
      offset: 0,
      total: rows.length,
    });
  }

  async replaceForTrainer(
    trainerId: number,
    dto: TrainerAvailabilityWriteDto,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<TrainerAvailability>> {
    const trainer = await this.trainerRepository.findById(trainerId);
    if (!trainer) {
      throw new NotFoundError('Trainer not found');
    }

    const now = new Date();
    const slots: NewTrainerAvailability[] = dto.slots.map((slot) => {
      const isRecurring = slot.is_recurring ?? slot.override_date == null;
      if (isRecurring && slot.day_of_week == null) {
        throw new BadRequestError('day_of_week is required for recurring availability slots');
      }
      if (!isRecurring && !slot.override_date) {
        throw new BadRequestError('override_date is required for non-recurring availability slots');
      }
      if (!slot.start_time || !slot.end_time) {
        throw new BadRequestError('start_time and end_time are required for availability slots');
      }

      return {
        trainer_id: trainerId,
        day_of_week: isRecurring ? slot.day_of_week ?? null : null,
        start_time: normalizeTime(slot.start_time),
        end_time: normalizeTime(slot.end_time),
        is_recurring: isRecurring,
        override_date: slot.override_date ?? null,
        is_available: slot.is_available,
        created_at: now,
        updated_at: null,
      };
    });

    const before = await this.repository.findByTrainerId(trainerId);
    const after = await this.repository.replaceForTrainer(trainerId, slots);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'trainer_availability.replaced',
      entityName: 'trainer_availabilities',
      entityId: trainerId,
      beforeState: before,
      afterState: after,
    });

    return createPaginatedResponse({
      items: after,
      limit: after.length || 1,
      offset: 0,
      total: after.length,
    });
  }
}
