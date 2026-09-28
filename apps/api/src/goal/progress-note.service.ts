import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { MemberRepository } from '../people/member.repository';
import { assertMemberAccess } from '../people/row-scope';
import { AuditService } from '../platform/audit/audit.service';
import type { NewProgressNote, ProgressNote, ProgressNoteType } from '../platform/db/schema/goals';
import { ForbiddenError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import type { ProgressNoteFilterQueryDto, ProgressNoteWriteDto } from './goal.dto';
import { ProgressNoteRepository } from './progress-note.repository';

@Injectable()
export class ProgressNoteService {
  constructor(
    private readonly repository: ProgressNoteRepository,
    private readonly memberRepo: MemberRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
  ) {}

  async assertCanWriteNote(
    actor: AuthenticatedUser,
    memberId: number,
    noteType: ProgressNoteType,
  ): Promise<void> {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return;
    }
    if (actor.userType === 'member') {
      if (actor.profileId !== memberId) {
        throw new ForbiddenError('Cannot write notes for another member');
      }
      if (noteType !== 'member_note') {
        throw new ForbiddenError('Members may only create member_note entries');
      }
      return;
    }
    if (actor.userType === 'trainer') {
      const member = await this.memberRepo.findById(memberId);
      if (!member || member.assigned_trainer_id !== actor.profileId) {
        throw new ForbiddenError('Trainer may only write assessments for assigned members');
      }
      if (noteType !== 'trainer_assessment') {
        throw new ForbiddenError('Trainers may only create trainer_assessment entries');
      }
      return;
    }
    throw new ForbiddenError('Access denied');
  }

  async listNotes(
    memberId: number,
    rawQuery: Record<string, unknown>,
    _filter: ProgressNoteFilterQueryDto,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<ProgressNote>> {
    await assertMemberAccess(this.memberRepo, actor, memberId);

    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findManyByMemberId(memberId, {
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows,
      total,
      limit: pagination.limit,
      offset,
    });
  }

  async createNote(
    memberId: number,
    dto: ProgressNoteWriteDto,
    actor: AuthenticatedUser,
  ): Promise<ProgressNote> {
    await this.assertCanWriteNote(actor, memberId, dto.note_type);

    const now = new Date();
    const newNote: NewProgressNote = {
      member_id: memberId,
      author_user_id: actor.id,
      note_text: dto.note_text,
      note_type: dto.note_type,
      created_at: now,
    };

    const created = await this.repository.create(newNote);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'create',
      entityName: 'progress_notes',
      entityId: created.id,
      afterState: created,
    });

    return created;
  }
}
