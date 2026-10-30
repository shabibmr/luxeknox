import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { DomainEvent, DomainEventBus } from '../platform/events/domain-events';
import { IdempotencyRepository } from '../platform/idempotency/idempotency.repository';
import { NotificationService } from './notification.service';
import { MemberRepository } from '../people/member.repository';
import { ScheduleRepository } from '../sched/schedule.repository';
import { MembershipRepository } from '../memb/membership.repository';
import { EmployeeRepository } from '../people/employee.repository';

@Injectable()
export class NotificationEventConsumer implements OnModuleInit {
  private readonly logger = new Logger(NotificationEventConsumer.name);

  constructor(
    private readonly eventBus: DomainEventBus,
    private readonly notificationService: NotificationService,
    private readonly idempotencyRepository: IdempotencyRepository,
    private readonly memberRepository: MemberRepository,
    private readonly scheduleRepository: ScheduleRepository,
    private readonly membershipRepository: MembershipRepository,
    private readonly employeeRepository: EmployeeRepository,
  ) {}

  onModuleInit(): void {
    // 1. Booking confirmed
    this.eventBus.on('schedule.booked', (event: DomainEvent<any>) =>
      this.handleIdempotentEvent(event, 'schedule.booked', (payload) =>
        this.handleScheduleBooked(payload),
      ),
    );

    // 2. Booking waitlisted
    this.eventBus.on('schedule.waitlisted', (event: DomainEvent<any>) =>
      this.handleIdempotentEvent(event, 'schedule.waitlisted', (payload) =>
        this.handleScheduleWaitlisted(payload),
      ),
    );

    // 3. Booking cancelled
    this.eventBus.on('schedule.booking_cancelled', (event: DomainEvent<any>) =>
      this.handleIdempotentEvent(event, 'schedule.booking_cancelled', (payload) =>
        this.handleScheduleBookingCancelled(payload),
      ),
    );

    // 4. Waitlist promoted
    this.eventBus.on('schedule.waitlist_promoted', (event: DomainEvent<any>) =>
      this.handleIdempotentEvent(event, 'schedule.waitlist_promoted', (payload) =>
        this.handleScheduleWaitlistPromoted(payload),
      ),
    );

    // 5. Freeze pending
    this.eventBus.on('membership.freeze_pending', (event: DomainEvent<any>) =>
      this.handleIdempotentEvent(event, 'membership.freeze_pending', (payload) =>
        this.handleMembershipFreezePending(payload),
      ),
    );

    // 6. Trainer assigned
    this.eventBus.on('member.trainer_assigned', (event: DomainEvent<any>) =>
      this.handleIdempotentEvent(event, 'member.trainer_assigned', (payload) =>
        this.handleTrainerAssigned(payload),
      ),
    );

    // 7. Workout safety alert
    this.eventBus.on('workout_session.safety_alert', (event: DomainEvent<any>) =>
      this.handleIdempotentEvent(event, 'workout_session.safety_alert', (payload) =>
        this.handleWorkoutSafetyAlert(payload),
      ),
    );
  }

  /**
   * Enforces idempotency per event so consumers don't process duplicate messages.
   * Leverages idempotencyRepository (`idempotency_keys` table) per FND-010 / NOT-009.
   */
  async handleIdempotentEvent(
    event: DomainEvent<any>,
    eventName: string,
    handler: (payload: any) => Promise<void>,
  ): Promise<void> {
    const payload = event.payload;
    const dedupeKey = `event:${eventName}:${JSON.stringify(payload)}`;
    const now = new Date();

    const existing = await this.idempotencyRepository.findActive(
      {
        idempotencyKey: dedupeKey,
        method: 'EVENT',
        path: eventName,
      },
      now,
    );

    if (existing) {
      this.logger.debug(`Skipping duplicate domain event: ${dedupeKey}`);
      return;
    }

    try {
      await handler(payload);

      // Record 7-day expiration for idempotency key
      const expiresAt = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);
      await this.idempotencyRepository.insert({
        idempotency_key: dedupeKey,
        method: 'EVENT',
        path: eventName,
        request_hash: dedupeKey,
        response_status: 200,
        response_body: JSON.stringify({ processed: true }),
        expires_at: expiresAt,
        created_at: now,
      });
    } catch (err: any) {
      this.logger.error(`Error processing event ${eventName}: ${err.message}`, err.stack);
    }
  }

  private async handleScheduleBooked(payload: {
    scheduleId: number;
    memberId: number;
    participantId: number;
  }): Promise<void> {
    const [member, schedule] = await Promise.all([
      this.memberRepository.findById(payload.memberId),
      this.scheduleRepository.findById(payload.scheduleId),
    ]);

    if (!member || !schedule) return;

    await this.notificationService.dispatch({
      recipientUserIds: [member.user_id],
      title: 'Booking Confirmed',
      message: `Your booking for "${schedule.title}" on ${new Date(schedule.start_time).toISOString()} is confirmed.`,
      typeCode: 'booking_confirmed',
      dataPayload: { schedule_id: schedule.id, participant_id: payload.participantId },
    });
  }

  private async handleScheduleWaitlisted(payload: {
    scheduleId: number;
    memberId: number;
    participantId: number;
  }): Promise<void> {
    const [member, schedule] = await Promise.all([
      this.memberRepository.findById(payload.memberId),
      this.scheduleRepository.findById(payload.scheduleId),
    ]);

    if (!member || !schedule) return;

    await this.notificationService.dispatch({
      recipientUserIds: [member.user_id],
      title: 'Added to Waitlist',
      message: `You are on the waitlist for "${schedule.title}". You will be notified if a spot opens up!`,
      typeCode: 'announcement',
      dataPayload: { schedule_id: schedule.id, participant_id: payload.participantId },
    });
  }

  private async handleScheduleBookingCancelled(payload: {
    scheduleId: number;
    memberId: number;
    participantId: number;
  }): Promise<void> {
    const [member, schedule] = await Promise.all([
      this.memberRepository.findById(payload.memberId),
      this.scheduleRepository.findById(payload.scheduleId),
    ]);

    if (!member || !schedule) return;

    await this.notificationService.dispatch({
      recipientUserIds: [member.user_id],
      title: 'Booking Cancelled',
      message: `Your booking for "${schedule.title}" has been cancelled.`,
      typeCode: 'booking_cancelled',
      dataPayload: { schedule_id: schedule.id, participant_id: payload.participantId },
    });
  }

  private async handleScheduleWaitlistPromoted(payload: {
    scheduleId: number;
    participantId: number;
  }): Promise<void> {
    const schedule = await this.scheduleRepository.findById(payload.scheduleId);
    if (!schedule) return;

    const participant = await this.scheduleRepository.findParticipantById(
      payload.scheduleId,
      payload.participantId,
    );
    if (!participant) return;

    const member = await this.memberRepository.findById(participant.member_id);
    if (!member) return;

    await this.notificationService.dispatch({
      recipientUserIds: [member.user_id],
      title: 'Waitlist Promoted!',
      message: `Great news! A spot opened up for "${schedule.title}" and your booking is now confirmed.`,
      typeCode: 'session_waitlist_promoted',
      dataPayload: { schedule_id: schedule.id, participant_id: participant.id },
    });
  }

  private async handleMembershipFreezePending(payload: {
    membershipId: number;
    freezeId: number;
  }): Promise<void> {
    const membership = await this.membershipRepository.findById(payload.membershipId);
    if (!membership) return;

    const member = await this.memberRepository.findById(membership.member_id);
    if (!member) return;

    const freeze = await this.membershipRepository.findFreezeById(payload.freezeId);
    const startDate = freeze?.start_date;
    const endDate = freeze?.end_date;

    const message =
      startDate && endDate
        ? `Your membership freeze request from ${startDate} to ${endDate} is currently pending approval.`
        : 'Your membership freeze request is currently pending approval.';

    await this.notificationService.dispatch({
      recipientUserIds: [member.user_id],
      title: 'Freeze Request Pending',
      message,
      typeCode: 'freeze_pending',
      dataPayload: {
        membership_id: membership.id,
        freeze_id: payload.freezeId,
        ...(startDate ? { start_date: startDate } : {}),
        ...(endDate ? { end_date: endDate } : {}),
      },
    });
  }

  private async handleWorkoutSafetyAlert(payload: {
    sessionId: number;
    memberId: number;
    painDiscomfortScore: number;
    painNotes: string | null;
    assignedTrainerUserId: number | null;
    sessionTrainerUserId: number | null;
  }): Promise<void> {
    const member = await this.memberRepository.findById(payload.memberId);
    const memberLabel = memberDisplayName(member, payload.memberId);
    const notes = payload.painNotes?.trim() ?? '';
    const score = payload.painDiscomfortScore;
    const staff = await this.employeeRepository.listStaffForSafetyAlert();

    const recipientUserIds: number[] = [];
    const addRecipient = (userId: number | null | undefined) => {
      if (userId == null || userId <= 0 || recipientUserIds.includes(userId)) return;
      recipientUserIds.push(userId);
    };

    addRecipient(payload.assignedTrainerUserId);
    addRecipient(payload.sessionTrainerUserId);
    for (const person of staff) {
      if (isActiveHeadCoach(person.job_title, person.status)) {
        addRecipient(person.user_id);
      }
    }

    if (recipientUserIds.length === 0) return;

    const summary = `${memberLabel}, score ${score}/10. Notes: ${notes}`;
    await this.notificationService.dispatch({
      recipientUserIds,
      title: fitNotificationTitle(`Workout safety alert: ${summary}`),
      message: `${memberLabel} reported a pain score of ${score}/10. Notes: ${notes}.`,
      typeCode: 'workout_safety_alert',
      priority: 'high',
      dataPayload: {
        session_id: payload.sessionId,
        member_id: payload.memberId,
        pain_discomfort_score: score,
        pain_notes: payload.painNotes,
      },
    });
  }

  private async handleTrainerAssigned(payload: {
    memberId: number;
    userId: number;
    trainerId: number;
  }): Promise<void> {
    await this.notificationService.dispatch({
      recipientUserIds: [payload.userId],
      title: 'Personal Trainer Assigned',
      message: 'A trainer has been assigned to your profile. Check your dashboard to get in touch!',
      typeCode: 'trainer_assigned',
      dataPayload: { member_id: payload.memberId, trainer_id: payload.trainerId },
    });
  }
}

const NOTIFICATION_TITLE_MAX = 255;

function fitNotificationTitle(title: string): string {
  if (title.length <= NOTIFICATION_TITLE_MAX) return title;
  return `${title.slice(0, NOTIFICATION_TITLE_MAX - 3)}...`;
}

function isActiveHeadCoach(jobTitle: string | null | undefined, status: string): boolean {
  return status === 'active' && (jobTitle ?? '').trim().toLowerCase() === 'head coach';
}

function memberDisplayName(
  member: { first_name?: string | null; last_name?: string | null } | null,
  memberId: number,
): string {
  const name = [member?.first_name, member?.last_name]
    .map((part) => part?.trim() ?? '')
    .filter((part) => part.length > 0)
    .join(' ');
  return name || `Member #${memberId}`;
}
