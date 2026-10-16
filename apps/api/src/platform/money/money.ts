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

  const str = typeof amount === 'number' ? amount.toString() : String(amount).trim();

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

/** Parse a decimal string with at most `scale` fraction digits into scaled integer units. */
function toScaled(value: number | string, scale: number, label: string): bigint {
  const str = typeof value === 'number' ? value.toString() : String(value).trim();
  const match = /^(-?)(\d+)(?:\.(\d+))?$/.exec(str);
  if (!match) {
    throw new Error(`Invalid ${label}: "${value}"`);
  }
  const [, sign, intPart, fracPart = ''] = match;
  if (fracPart.length > scale) {
    throw new Error(`Invalid ${label}: "${value}" has more than ${scale} decimal places`);
  }
  const units = BigInt(intPart) * 10n ** BigInt(scale) + BigInt(fracPart.padEnd(scale, '0') || '0');
  return sign === '-' ? -units : units;
}

/**
 * Multiply a quantity (up to 3 decimals) by a rate (up to 2 decimals) and round
 * half-up (away from zero on ties) to cents. Integer maths only.
 * E.g. mulQtyRate('1.500', '0.01') -> "0.02", mulQtyRate('0.333', '10.00') -> "3.33".
 */
export function mulQtyRate(quantity: number | string, rate: number | string): string {
  const raw = toScaled(quantity, 3, 'quantity') * toScaled(rate, 2, 'rate');
  const denom = 1000n;
  const half = denom / 2n;
  const quot = raw >= 0n ? (raw + half) / denom : (raw - half) / denom;
  return fromCents(quot);
}

/** Format a 4-decimal unit-cost scaled integer as a string. */
function fromUnitCost4(units: bigint): string {
  const negative = units < 0n;
  const abs = negative ? -units : units;
  const whole = abs / 10000n;
  const frac = (abs % 10000n).toString().padStart(4, '0');
  return `${negative ? '-' : ''}${whole.toString()}.${frac}`;
}

/** Format quantity milli-units as a 3-decimal string. */
function fromQtyMilli(units: bigint): string {
  const negative = units < 0n;
  const abs = negative ? -units : units;
  const whole = abs / 1000n;
  const frac = (abs % 1000n).toString().padStart(3, '0');
  return `${negative ? '-' : ''}${whole.toString()}.${frac}`;
}

/**
 * Half-up to 3 decimal places for quantities / reorder levels.
 * Extra fraction digits beyond 3 are used only for rounding.
 */
export function roundQty3(amount: number | string): string {
  const str = String(amount).trim();
  if (!/^\d+(\.\d+)?$/.test(str)) {
    throw new Error(`Invalid quantity: "${amount}"`);
  }
  const [intPart, fracPart = ''] = str.split('.');
  const digits = `${fracPart}0000`;
  let scaled =
    BigInt(intPart) * 1000n +
    BigInt(digits[0]) * 100n +
    BigInt(digits[1]) * 10n +
    BigInt(digits[2]);
  if (digits[3] >= '5') scaled += 1n;
  return fromQtyMilli(scaled);
}

/**
 * Moving-average unit cost: money value ÷ quantity, half-up to 4 decimals.
 * E.g. divValueByQty('1650.00', '15.000') -> "110.0000".
 */
export function divValueByQty(value: number | string, quantity: number | string): string {
  const qtyMilli = toScaled(quantity, 3, 'quantity');
  if (qtyMilli === 0n) {
    throw new Error('Cannot divide by zero quantity');
  }
  const valueCents = toCents(value);
  // valueCents/100 ÷ qtyMilli/1000 → 4dp units: (valueCents * 100000) / qtyMilli
  const numer = valueCents * 100000n;
  const absQty = qtyMilli < 0n ? -qtyMilli : qtyMilli;
  const absNumer = numer < 0n ? -numer : numer;
  const absQuot = (absNumer + absQty / 2n) / absQty;
  const signed = numer < 0n !== qtyMilli < 0n ? -absQuot : absQuot;
  return fromUnitCost4(signed);
}

/**
 * Multiply quantity (≤3dp) by unit cost (≤4dp), half-up to money cents.
 * E.g. mulQtyUnitCost('2.000', '110.0000') -> "220.00".
 */
export function mulQtyUnitCost(quantity: number | string, unitCost: number | string): string {
  const qtyMilli = toScaled(quantity, 3, 'quantity');
  const cost4 = toScaled(unitCost, 4, 'unit cost');
  const raw = qtyMilli * cost4;
  const denom = 100000n; // 10^3 * 10^4 / 10^2 → cents
  const half = denom / 2n;
  const quot = raw >= 0n ? (raw + half) / denom : (raw - half) / denom;
  return fromCents(quot);
}

/**
 * Parse a non-negative percentage setting into a 2dp string (half-up), or null
 * when it is not a valid non-negative decimal. E.g. "18" -> "18.00".
 */
export function parseRatePercent(value: number | string): string | null {
  const str = String(value).trim();
  if (!/^\d+(\.\d+)?$/.test(str)) return null;
  return roundMoney(str);
}

function toWholeBigInt(value: number | bigint, label: string): bigint {
  if (typeof value === 'bigint') return value;
  if (!Number.isSafeInteger(value)) {
    throw new Error(`Invalid ${label}: ${value} is not a whole number`);
  }
  return BigInt(value);
}

/**
 * Prorate a money amount: amount × numerator ÷ denominator, half-up (away from
 * zero on ties) to cents. Integer maths only; numerator and denominator are
 * whole numbers (e.g. days). E.g. prorate('100.00', 1, 3) -> "33.33".
 */
export function prorate(
  amount: number | string,
  numerator: number | bigint,
  denominator: number | bigint,
): string {
  const num = toWholeBigInt(numerator, 'numerator');
  const den = toWholeBigInt(denominator, 'denominator');
  if (den <= 0n) {
    throw new Error('Denominator must be positive');
  }
  const raw = toCents(amount) * num;
  const half = den / 2n;
  const quot = raw >= 0n ? (raw + half) / den : (raw - half) / den;
  return fromCents(quot);
}

/**
 * Split a money amount across weights using largest-remainder so the parts sum
 * to the amount exactly. Ties on the remainder go to the earlier weight.
 * E.g. allocate('100.00', [1, 1, 1]) -> ["33.34", "33.33", "33.33"].
 */
export function allocate(amount: number | string, weights: Array<number | bigint>): string[] {
  if (weights.length === 0) {
    throw new Error('Weights must not be empty');
  }
  const ws = weights.map((w) => toWholeBigInt(w, 'weight'));
  if (ws.some((w) => w < 0n)) {
    throw new Error('Weights must not be negative');
  }
  const totalWeight = ws.reduce((sum, w) => sum + w, 0n);
  if (totalWeight === 0n) {
    throw new Error('Weights must not all be zero');
  }

  const total = toCents(amount);
  const negative = total < 0n;
  const abs = negative ? -total : total;

  const shares = ws.map((w) => (abs * w) / totalWeight);
  const remainders = ws.map((w, i) => ({ i, rem: (abs * w) % totalWeight }));
  let leftover = abs - shares.reduce((sum, s) => sum + s, 0n);

  remainders.sort((a, b) => (a.rem === b.rem ? a.i - b.i : a.rem > b.rem ? -1 : 1));
  for (const { i } of remainders) {
    if (leftover === 0n) break;
    shares[i] += 1n;
    leftover -= 1n;
  }

  return shares.map((s) => fromCents(negative ? -s : s));
}

/** Compare quantities at 3 decimal places: -1 / 0 / 1. */
export function cmpQty(a: number | string, b: number | string): -1 | 0 | 1 {
  const diff = toScaled(a, 3, 'quantity') - toScaled(b, 3, 'quantity');
  if (diff < 0n) return -1;
  if (diff > 0n) return 1;
  return 0;
}

export function addQty(a: number | string, b: number | string): string {
  return fromQtyMilli(toScaled(a, 3, 'quantity') + toScaled(b, 3, 'quantity'));
}

export function subQty(a: number | string, b: number | string): string {
  return fromQtyMilli(toScaled(a, 3, 'quantity') - toScaled(b, 3, 'quantity'));
}
