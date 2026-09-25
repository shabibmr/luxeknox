import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gt, isNull } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  passwordResetTokens,
  type NewPasswordResetToken,
  type PasswordResetToken,
} from '../platform/db/schema/password-reset-tokens';

@Injectable()
export class PasswordResetTokenRepository extends BaseRepository<
  typeof passwordResetTokens,
  PasswordResetToken,
  NewPasswordResetToken
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, passwordResetTokens);
  }

  /** Finds an unused, unexpired reset token by its SHA-256 hash. */
  async findActiveByTokenHash(tokenHash: string, now: Date = new Date()): Promise<PasswordResetToken | null> {
    return this.findOne(
      and(
        eq(passwordResetTokens.token_hash, tokenHash),
        isNull(passwordResetTokens.used_at),
        gt(passwordResetTokens.expires_at, now),
      )!,
    );
  }

  async markUsed(id: number, usedAt: Date = new Date()): Promise<void> {
    await this.update(eq(passwordResetTokens.id, id), { used_at: usedAt });
  }
}
