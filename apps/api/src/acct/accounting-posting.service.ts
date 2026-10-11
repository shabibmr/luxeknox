import { Injectable } from '@nestjs/common';
import { AccountingRepository } from './accounting.repository';

/**
 * Posts balanced journals into the general ledger.
 * SQL lives in {@link AccountingRepository}. Callers wrap work in `runInTransaction`
 * so source writes and journal inserts share one transaction (ACC-021+).
 */
@Injectable()
export class AccountingPostingService {
  // Repository retained for DI wiring; posting methods arrive in ACC-021.
  constructor(private readonly accountingRepository: AccountingRepository) {
    void this.accountingRepository;
  }
}
