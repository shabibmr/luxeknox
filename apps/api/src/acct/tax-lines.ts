import type { TaxCode } from '../platform/db/schema/accounting';
import { addMoney, cmpMoney, fromCents, toCents } from '../platform/money/money';
import type { PostJournalLineInput } from './accounting-posting.service';
import type { AccountsRepository } from './accounts.repository';
import type { TaxCodesRepository } from './tax-codes.repository';

export interface TaxLineDeps {
  taxCodesRepository: Pick<TaxCodesRepository, 'listComponents'>;
  accountsRepository: Pick<AccountsRepository, 'findByName'>;
}

export interface TaxLineParams {
  /** Tax code whose components the tax is split across. Null/undefined yields no lines. */
  taxCode: Pick<TaxCode, 'id'> | null | undefined;
  /** Total tax to split, as a Money string. */
  taxAmount: string;
  /** Side the component accounts are posted on. */
  side: 'debit' | 'credit';
  memoPrefix: string;
  memberId?: number | null;
}

/**
 * Splits a tax amount across a tax code's output components, proportional to their rates
 * (half-up per component). Any cents left over (or over-allocated) go to `5950 Rounding off`,
 * when that account exists, on the matching side. Looked up by name "Rounding off".
 *
 * Purchase bills post input tax through the control account path, not this helper.
 */
export async function buildTaxComponentLines(
  deps: TaxLineDeps,
  params: TaxLineParams,
): Promise<PostJournalLineInput[]> {
  const { taxCode, taxAmount, side, memoPrefix } = params;
  const lines: PostJournalLineInput[] = [];
  if (cmpMoney(taxAmount, '0') <= 0 || !taxCode) {
    return lines;
  }

  const components = await deps.taxCodesRepository.listComponents(taxCode.id);
  if (components.length === 0) {
    return lines;
  }

  const party = {
    ...(params.memberId !== undefined ? { memberId: params.memberId } : {}),
  };

  const taxAmountCents = toCents(taxAmount);
  const sumRates = components.reduce((sum, c) => addMoney(sum, c.rate_percent), '0.00');
  const sumRatesCents = toCents(sumRates);

  let compTaxSumCents = 0n;
  for (const comp of components) {
    const cTaxCents =
      sumRatesCents > 0n
        ? (taxAmountCents * toCents(comp.rate_percent) + sumRatesCents / 2n) / sumRatesCents
        : 0n;
    compTaxSumCents += cTaxCents;
    const compTax = fromCents(cTaxCents);
    if (cmpMoney(compTax, '0') > 0) {
      lines.push({
        accountId: comp.output_account_id,
        ...(side === 'debit' ? { debit: compTax } : { credit: compTax }),
        ...party,
        memo: `${memoPrefix} (${comp.name})`,
      });
    }
  }

  const taxGapCents = taxAmountCents - compTaxSumCents;
  if (taxGapCents !== 0n) {
    const roundingAccount = await deps.accountsRepository.findByName('Rounding off');
    if (roundingAccount) {
      const gap = fromCents(taxGapCents > 0n ? taxGapCents : -taxGapCents);
      const gapSide = taxGapCents > 0n ? side : side === 'debit' ? 'credit' : 'debit';
      lines.push({
        accountId: roundingAccount.id,
        ...(gapSide === 'debit' ? { debit: gap } : { credit: gap }),
        memo: `${memoPrefix} (Rounding off)`,
      });
    }
  }

  return lines;
}
