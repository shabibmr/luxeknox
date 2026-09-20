import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import type { MemberDocument } from '../platform/db/schema/member-documents';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { purposeFromObjectKey } from '../media/storage.service';
import { MemberRepository } from './member.repository';
import { MemberDocumentRepository } from './member-document.repository';
import type { MemberDocumentWriteDto } from './member-document.dto';
import { requireScopedMember } from './require-scoped-member';

@Injectable()
export class MemberDocumentService {
  constructor(
    private readonly memberRepository: MemberRepository,
    private readonly documentRepository: MemberDocumentRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
  ) {}

  /** BR-HEALTH-001: trainers never see id_proof rows. */
  private hideIdProofFor(actor: AuthenticatedUser): boolean {
    return actor.userType === 'trainer';
  }

  private visibleToActor(doc: MemberDocument, actor: AuthenticatedUser): boolean {
    return !(actor.userType === 'trainer' && doc.document_type === 'id_proof');
  }

  async list(
    memberId: number,
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<MemberDocument>> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.documentRepository.findManyForMember({
      memberId,
      hideIdProof: this.hideIdProofFor(actor),
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows,
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async create(
    memberId: number,
    dto: MemberDocumentWriteDto,
    actor: AuthenticatedUser,
  ): Promise<MemberDocument> {
    await requireScopedMember(this.memberRepository, memberId, actor);

    const purpose = purposeFromObjectKey(dto.file_url);
    if (
      purpose &&
      (purpose === 'id_proof' || purpose === 'waiver' || purpose === 'medical_cert') &&
      purpose !== dto.document_type
    ) {
      throw new BusinessRuleError('Document media key purpose mismatch');
    }

    const now = new Date();
    const id = await this.documentRepository.insertDocument({
      member_id: memberId,
      document_type: dto.document_type,
      title: dto.title ?? null,
      file_url: dto.file_url,
      file_size: dto.file_size ?? null,
      verified_by_user_id: null,
      verified_at: null,
      created_at: now,
      updated_at: null,
    });
    const created = await this.documentRepository.findById(id);
    if (!created) throw new NotFoundError('Document not found after create');

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'member_document.created',
      entityName: 'member_documents',
      entityId: id,
      afterState: created,
    });

    return created;
  }

  async verify(
    memberId: number,
    documentId: number,
    actor: AuthenticatedUser,
  ): Promise<MemberDocument> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const before = await this.documentRepository.findByIdForMember(documentId, memberId);
    if (!before || !this.visibleToActor(before, actor)) {
      throw new NotFoundError('Document not found');
    }

    const now = new Date();
    await this.documentRepository.markVerified(documentId, actor.id, now);

    const after = await this.documentRepository.findById(documentId);
    if (!after) throw new NotFoundError('Document not found after verify');

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'member_document.verified',
      entityName: 'member_documents',
      entityId: documentId,
      beforeState: before,
      afterState: after,
    });

    return after;
  }

  async remove(
    memberId: number,
    documentId: number,
    actor: AuthenticatedUser,
  ): Promise<void> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const before = await this.documentRepository.findByIdForMember(documentId, memberId);
    if (!before || !this.visibleToActor(before, actor)) {
      throw new NotFoundError('Document not found');
    }

    await this.documentRepository.deleteDocument(documentId);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'member_document.deleted',
      entityName: 'member_documents',
      entityId: documentId,
      beforeState: before,
    });
  }
}
