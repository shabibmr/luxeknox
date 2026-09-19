export const IDEMPOTENCY_KEY_HEADER = 'idempotency-key' as const;
export type IdempotencyKey = string;

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

/**
 * Formats a money amount with currency symbol or code.
 * E.g., formatMoney('100.5', 'INR') -> "INR 100.50" or "₹100.50".
 * Uses Intl.NumberFormat when supported or standard currency prefix.
 */
export function formatMoney(amount: number | string, currency = 'INR'): string {
  const rounded = roundMoney(amount);
  const num = parseFloat(rounded);

  try {
    return new Intl.NumberFormat('en-IN', {
      style: 'currency',
      currency,
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(num);
  } catch {
    return `${currency} ${rounded}`;
  }
}
