import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { AccountingPeriod, FiscalYear } from '../platform/db/schema/accounting';
import { runInTransaction } from '../platform/db/transaction-context';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import { cmpMoney } from '../platform/money/money';
import {
  periodFilterQuerySchema,
  type AccountingPeriodDto,
  type DraftDocumentCountsDto,
  type FiscalYearDto,
  type PeriodFilterQueryDto,
} from './periods.dto';
import { PeriodsRepository } from './periods.repository';

@Injectable()
export class PeriodsService {
  constructor(
    private readonly repository: PeriodsRepository,
    private readonly auditService: AuditService,
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>,
  ) {}

  toFiscalYearDto(year: FiscalYear): FiscalYearDto {
    return {
      id: year.id,
      label: year.label,
      starts_on: year.starts_on,
      ends_on: year.ends_on,
    };
  }

  toPeriodDto(
    period: AccountingPeriod,
    draftCounts?: DraftDocumentCountsDto,
  ): AccountingPeriodDto {
    return {
      id: period.id,
      fiscal_year_id: period.fiscal_year_id,
      starts_on: period.starts_on,
      ends_on: period.ends_on,
      status: period.status,
      closed_at: period.closed_at ?? null,
      closed_by_user_id: period.closed_by_user_id ?? null,
      ...(draftCounts !== undefined ? { draft_document_counts: draftCounts } : {}),
    };
  }

  async listFiscalYears(_actor?: AuthenticatedUser): Promise<FiscalYearDto[]> {
    const years = await this.repository.listFiscalYears();
    return years.map((y) => this.toFiscalYearDto(y));
  }

  async listPeriods(
    rawQuery?: Record<string, unknown> | PeriodFilterQueryDto,
    _actor?: AuthenticatedUser,
  ): Promise<AccountingPeriodDto[]> {
    const filters = periodFilterQuerySchema.parse(rawQuery ?? {});
    const periods = await this.repository.listPeriods(filters);
    return periods.map((p) => this.toPeriodDto(p));
  }

  async lock(id: number, actor: AuthenticatedUser): Promise<AccountingPeriodDto> {
    return runInTransaction(this.db, async () => {
      const period = await this.repository.findPeriodById(id);
      if (!period) {
        throw new NotFoundError(`Accounting period ${id} was not found`);
      }
      if (period.status !== 'open') {
        throw new BusinessRuleError('Period is already locked');
      }

      const { totalDebit, totalCredit } =
        await this.repository.calculateTrialBalanceTotals(period.ends_on);
      if (cmpMoney(totalDebit, totalCredit) !== 0) {
        throw new BusinessRuleError(
          'Cannot lock period: trial balance through period is unbalanced',
        );
      }

      const draftCounts = await this.repository.countDraftDocuments(
        period.starts_on,
        period.ends_on,
      );

      const updated = await this.repository.updatePeriod(period.id, {
        status: 'locked',
        closed_at: new Date(),
        closed_by_user_id: actor.id,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'accounting.period.lock',
        entityName: 'accounting_period',
        entityId: period.id,
        beforeState: { status: 'open' },
        afterState: { status: 'locked' },
      });

      return this.toPeriodDto(updated, draftCounts);
    });
  }

  async unlock(id: number, actor: AuthenticatedUser): Promise<AccountingPeriodDto> {
    return runInTransaction(this.db, async () => {
      const period = await this.repository.findPeriodById(id);
      if (!period) {
        throw new NotFoundError(`Accounting period ${id} was not found`);
      }
      if (period.status !== 'locked') {
        throw new BusinessRuleError('Period is not locked');
      }

      const updated = await this.repository.updatePeriod(period.id, {
        status: 'open',
        closed_at: null,
        closed_by_user_id: null,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'accounting.period.unlock',
        entityName: 'accounting_period',
        entityId: period.id,
        beforeState: { status: 'locked' },
        afterState: { status: 'open' },
      });

      return this.toPeriodDto(updated);
    });
  }
}
