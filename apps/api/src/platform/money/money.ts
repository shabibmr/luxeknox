/**
 * Rounds a money amount string or number to 2 decimal places using half-up rounding.
 * E.g., 1.225 -> "1.23", 1.224 -> "1.22", -1.225 -> "-1.23".
 *
 * Implemented using integer scaling / string arithmetic to prevent IEEE-754 binary floating point inaccuracy.
 */
export function roundMoney(amount: number | string): string {
  if (amount === '' || amount === null || amount === undefined) {
    throw new Error('Amount must be a valid number or string representation of a number');
  }

  const str = typeof amount === 'number' ? amount.toString() : amount.trim();

  // Validate number format (optional sign, integer part, optional dot and fractional part)
  if (!/^-?\d+(\.\d+)?$/.test(str)) {
    throw new Error(`Invalid money amount: "${amount}"`);
  }

  const isNegative = str.startsWith('-');
  const unsignedStr = isNegative ? str.slice(1) : str;

  const [intPart, fracPart = ''] = unsignedStr.split('.');

  // We need 2 decimal places. Look at the 3rd decimal digit to round half-up.
  const d1 = fracPart[0] ?? '0';
  const d2 = fracPart[1] ?? '0';
  const d3 = fracPart[2] ?? '0';

  // Base integer value in cents
  let cents = BigInt(intPart) * 100n + BigInt(d1) * 10n + BigInt(d2);

  // Half-up: if the next digit is >= 5, round away from zero
  if (parseInt(d3, 10) >= 5) {
    cents += 1n;
  }

  const centsStr = cents.toString().padStart(3, '0');
  const whole = centsStr.slice(0, -2);
  const frac = centsStr.slice(-2);

  const formatted = `${whole}.${frac}`;
  return isNegative && cents > 0n ? `-${formatted}` : formatted;
}

/** Convert a rounded money string to integer cents (BigInt). */
export function toCents(amount: number | string): bigint {
  const rounded = roundMoney(amount);
  const negative = rounded.startsWith('-');
  const unsigned = negative ? rounded.slice(1) : rounded;
  const [whole, frac = '00'] = unsigned.split('.');
  const cents = BigInt(whole) * 100n + BigInt(frac.padEnd(2, '0').slice(0, 2));
  return negative ? -cents : cents;
}

/** Format integer cents as a Money string. */
export function fromCents(cents: bigint): string {
  const negative = cents < 0n;
  const abs = negative ? -cents : cents;
  const whole = abs / 100n;
  const frac = (abs % 100n).toString().padStart(2, '0');
  return `${negative ? '-' : ''}${whole.toString()}.${frac}`;
}

export function addMoney(a: number | string, b: number | string): string {
  return fromCents(toCents(a) + toCents(b));
}

export function subMoney(a: number | string, b: number | string): string {
  return fromCents(toCents(a) - toCents(b));
}

/** Compare money amounts: -1 if a<b, 0 if equal, 1 if a>b. */
export function cmpMoney(a: number | string, b: number | string): -1 | 0 | 1 {
  const diff = toCents(a) - toCents(b);
  if (diff < 0n) return -1;
  if (diff > 0n) return 1;
  return 0;
}

/**
 * Multiply a money amount by a percent (e.g. 18.00 → 18%) with half-up to cents.
 */
export function mulMoneyPercent(amount: number | string, percent: number | string): string {
  const amountCents = toCents(amount);
  const pct = roundMoney(percent);
  const [pWhole, pFrac = ''] = pct.replace(/^-/, '').split('.');
  // percent in basis points of 0.01% → scale by 10000 for two decimal percent
  const pctBp = BigInt(pWhole) * 100n + BigInt((pFrac + '00').slice(0, 2));
  // amountCents * pctBp / 10000, half-up
  const raw = amountCents * pctBp;
  const denom = 10000n;
  const half = denom / 2n;
  const quot = raw >= 0n ? (raw + half) / denom : (raw - half) / denom;
  return fromCents(quot);
}
