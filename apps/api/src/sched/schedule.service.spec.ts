import { describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ConflictError } from '../platform/errors/app-error';
import { ScheduleService } from './schedule.service';

const adminActor: AuthenticatedUser = {
  id: 1,
  email: 'admin@example.com',
  phoneNumber: null,
  roleId: 1,
  userType: 'admin',
  profileId: null,
  sessionId: 1,
};

function at(hour: number, minute = 0): Date {
  return new Date(Date.UTC(2026, 8, 21, hour, minute, 0, 0));
}

function buildService(overrides: Partial<Record<string, unknown>> = {}) {
  const repository = {
    findById: vi.fn(),
    insertSchedule: vi.fn(),
    updateSchedule: vi.fn(),
    insertHistory: vi.fn(),
    listParticipants: vi.fn().mockResolvedValue([]),
    findOverlappingForTrainer: vi.fn().mockResolvedValue([]),
    findOverlappingForFacility: vi.fn().mockResolvedValue([]),
    findFutureBySeriesId: vi.fn().mockResolvedValue([]),
    cancelParticipants: vi.fn(),
    ...overrides,
  };

  const scheduleTypeRepository = {
    findById: vi.fn().mockResolvedValue({
      id: 1,
      name: 'PT',
      requires_trainer: true,
      default_duration_minutes: 60,
      color_code: null,
      created_at: at(0),
      updated_at: null,
    }),
  };

  const facilityRepository = {
    findById: vi.fn().mockResolvedValue({
      id: 2,
      name: 'Studio A',
      capacity: 1,
      location_details: null,
      is_active: true,
      created_at: at(0),
      updated_at: null,
    }),
  };

  const trainerRepository = {
    findById: vi.fn().mockResolvedValue({
      id: 3,
      is_active: true,
    }),
  };

  const auditService = {
    recordAudit: vi.fn(),
  };

  const domainEventBus = { emit: vi.fn(), emitSync: vi.fn(), on: vi.fn() };

  const paginationHelper = {
    normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
    createResponse: vi.fn(),
  };

  const db = {
    transaction: async (fn: (tx: unknown) => Promise<unknown>) => fn(db),
  };

  const service = new ScheduleService(
    repository as any,
    scheduleTypeRepository as any,
    facilityRepository as any,
    trainerRepository as any,
    paginationHelper as any,
    auditService as any,
    domainEventBus as any,
    db as any,
  );

  return {
    service,
    repository,
    scheduleTypeRepository,
    facilityRepository,
    trainerRepository,
    domainEventBus,
    paginationHelper,
  };
}

describe('ScheduleService', () => {
  it('rejects create when trainer has an overlapping schedule', async () => {
    const { service, repository } = buildService({
      findOverlappingForTrainer: vi.fn().mockResolvedValue([
        {
          id: 99,
          trainer_id: 3,
          facility_id: 2,
          start_time: at(9),
          end_time: at(10),
          status: 'scheduled',
        },
      ]),
    });

    await expect(
      service.create(
        {
          schedule_type_id: 1,
          facility_id: 2,
          trainer_id: 3,
          title: 'PT Session',
          start_time: at(9, 30).toISOString(),
          end_time: at(10, 30).toISOString(),
        },
        adminActor,
      ),
    ).rejects.toBeInstanceOf(ConflictError);

    expect(repository.insertSchedule).not.toHaveBeenCalled();
  });

  it('creates a recurring series with a shared series_id', async () => {
    let nextId = 10;
    const { service, repository } = buildService({
      insertSchedule: vi.fn().mockImplementation(async () => {
        const id = nextId;
        nextId += 1;
        return id;
      }),
      findById: vi.fn().mockImplementation(async (id: number) => ({
        id,
        series_id: 10,
        schedule_type_id: 1,
        facility_id: 2,
        trainer_id: 3,
        title: 'Class',
        start_time: at(9),
        end_time: at(10),
        max_capacity: 1,
        status: 'scheduled',
        notes: null,
        row_version: 1,
        created_at: at(0),
        updated_at: null,
      })),
    });

    const created = await service.create(
      {
        schedule_type_id: 1,
        facility_id: 2,
        trainer_id: 3,
        title: 'Class',
        start_time: at(9).toISOString(),
        end_time: at(10).toISOString(),
        recur_until: '2026-10-05',
      },
      adminActor,
    );

    expect(created.series_id).toBe(10);
    expect(repository.insertSchedule).toHaveBeenCalledTimes(3);
    expect(repository.updateSchedule).toHaveBeenCalledWith(10, { series_id: 10 });
  });

  it('cancels all future series occurrences when cancel_series is true', async () => {
    const schedule = {
      id: 20,
      series_id: 100,
      schedule_type_id: 1,
      facility_id: 2,
      trainer_id: 3,
      title: 'Class',
      start_time: at(9),
      end_time: at(10),
      max_capacity: 1,
      status: 'scheduled',
      notes: null,
      row_version: 2,
      created_at: at(0),
      updated_at: null,
    };

    const future = {
      ...schedule,
      id: 21,
      start_time: new Date('2026-09-28T09:00:00.000Z'),
      end_time: new Date('2026-09-28T10:00:00.000Z'),
    };

    const { service, repository } = buildService({
      findById: vi.fn().mockResolvedValue(schedule),
      findFutureBySeriesId: vi.fn().mockResolvedValue([future]),
    });

    await service.cancel(20, { reason: 'Holiday', cancel_series: true }, adminActor);

    expect(repository.updateSchedule).toHaveBeenCalledTimes(2);
    expect(repository.cancelParticipants).toHaveBeenCalledTimes(2);
  });

  it('emits a schedule.created event after a successful create', async () => {
    const { service, domainEventBus } = buildService({
      insertSchedule: vi.fn().mockResolvedValue(30),
      findById: vi.fn().mockResolvedValue({
        id: 30,
        series_id: null,
        schedule_type_id: 1,
        facility_id: 2,
        trainer_id: 3,
        title: 'Class',
        start_time: at(9),
        end_time: at(10),
        max_capacity: 1,
        status: 'scheduled',
        notes: null,
        row_version: 1,
        created_at: at(0),
        updated_at: null,
      }),
    });

    await service.create(
      {
        schedule_type_id: 1,
        facility_id: 2,
        trainer_id: 3,
        title: 'Class',
        start_time: at(9).toISOString(),
        end_time: at(10).toISOString(),
      },
      adminActor,
    );

    expect(domainEventBus.emit).toHaveBeenCalledWith(
      expect.objectContaining({ eventName: 'schedule.created' }),
    );
  });

  describe('start', () => {
    const scheduledRow = {
      id: 40,
      series_id: null,
      schedule_type_id: 1,
      facility_id: null,
      trainer_id: 3,
      title: 'PT',
      start_time: at(9),
      end_time: at(10),
      max_capacity: 1,
      status: 'scheduled',
      notes: null,
      row_version: 1,
      created_at: at(0),
      updated_at: null,
    };

    it('transitions a scheduled schedule to ongoing', async () => {
      const { service, repository, domainEventBus } = buildService({
        findById: vi
          .fn()
          .mockResolvedValueOnce(scheduledRow)
          .mockResolvedValueOnce({ ...scheduledRow, status: 'ongoing', row_version: 2 }),
      });

      await service.start(40, {}, adminActor);

      expect(repository.updateSchedule).toHaveBeenCalledWith(
        40,
        expect.objectContaining({ status: 'ongoing', row_version: 2 }),
      );
      expect(repository.insertHistory).toHaveBeenCalledWith(
        expect.objectContaining({ schedule_id: 40, action: 'started' }),
      );
      expect(domainEventBus.emit).toHaveBeenCalledWith(
        expect.objectContaining({ eventName: 'schedule.started' }),
      );
    });

    it('rejects starting a schedule that is not scheduled', async () => {
      const { service } = buildService({
        findById: vi.fn().mockResolvedValue({ ...scheduledRow, status: 'ongoing' }),
      });

      await expect(service.start(40, {}, adminActor)).rejects.toThrow();
    });

    it('rejects a trainer starting a schedule assigned to someone else', async () => {
      const { service } = buildService({
        findById: vi.fn().mockResolvedValue(scheduledRow),
      });

      const otherTrainer: AuthenticatedUser = {
        id: 5,
        email: 'trainer@example.com',
        phoneNumber: null,
        roleId: 3,
        userType: 'trainer',
        profileId: 99,
        sessionId: 1,
      };

      await expect(service.start(40, {}, otherTrainer)).rejects.toThrow();
    });
  });

  describe('complete', () => {
    it('transitions an ongoing schedule to completed', async () => {
      const ongoingRow = {
        id: 41,
        series_id: null,
        schedule_type_id: 1,
        facility_id: null,
        trainer_id: 3,
        title: 'PT',
        start_time: at(9),
        end_time: at(10),
        max_capacity: 1,
        status: 'ongoing',
        notes: null,
        row_version: 2,
        created_at: at(0),
        updated_at: null,
      };

      const { service, repository, domainEventBus } = buildService({
        findById: vi
          .fn()
          .mockResolvedValueOnce(ongoingRow)
          .mockResolvedValueOnce({ ...ongoingRow, status: 'completed', row_version: 3 }),
      });

      await service.complete(41, {}, adminActor);

      expect(repository.updateSchedule).toHaveBeenCalledWith(
        41,
        expect.objectContaining({ status: 'completed', row_version: 3 }),
      );
      expect(domainEventBus.emit).toHaveBeenCalledWith(
        expect.objectContaining({ eventName: 'schedule.completed' }),
      );
    });

    it('rejects completing a schedule that has not started', async () => {
      const { service } = buildService({
        findById: vi.fn().mockResolvedValue({
          id: 42,
          series_id: null,
          schedule_type_id: 1,
          facility_id: null,
          trainer_id: 3,
          title: 'PT',
          start_time: at(9),
          end_time: at(10),
          max_capacity: 1,
          status: 'scheduled',
          notes: null,
          row_version: 1,
          created_at: at(0),
          updated_at: null,
        }),
      });

      await expect(service.complete(42, {}, adminActor)).rejects.toThrow();
    });
  });

  it('rejects cancelling a completed schedule', async () => {
    const completedRow = {
      id: 43,
      series_id: null,
      schedule_type_id: 1,
      facility_id: null,
      trainer_id: 3,
      title: 'PT',
      start_time: at(9),
      end_time: at(10),
      max_capacity: 1,
      status: 'completed',
      notes: null,
      row_version: 3,
      created_at: at(0),
      updated_at: null,
    };

    const { service } = buildService({
      findById: vi.fn().mockResolvedValue(completedRow),
    });

    await expect(service.cancel(43, {}, adminActor)).rejects.toThrow();
  });

  it('lists append-only schedule history', async () => {
    const row = {
      id: 44,
      series_id: null,
      schedule_type_id: 1,
      facility_id: null,
      trainer_id: 3,
      title: 'PT',
      start_time: at(9),
      end_time: at(10),
      max_capacity: 1,
      status: 'scheduled',
      notes: null,
      row_version: 1,
      created_at: at(0),
      updated_at: null,
    };

    const historyRows = [
      { id: 1, schedule_id: 44, action: 'created', changed_by_user_id: 1, notes: null, timestamp: at(0) },
    ];

    const { service } = buildService({
      findById: vi.fn().mockResolvedValue(row),
      listHistory: vi.fn().mockResolvedValue(historyRows),
    });

    const result = await service.listHistory(44, {}, adminActor);

    expect(result.data).toEqual(historyRows);
  });
});
