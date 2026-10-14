/** Normalize login email for storage (trim + lowercase). Empty → null. */
export function normalizeEmail(email: string | null | undefined): string | null {
  if (email == null) return null;
  const trimmed = email.trim().toLowerCase();
  return trimmed.length > 0 ? trimmed : null;
}

/** Normalize login phone for storage (trim). Empty → null. */
export function normalizePhone(phone: string | null | undefined): string | null {
  if (phone == null) return null;
  const trimmed = phone.trim();
  return trimmed.length > 0 ? trimmed : null;
}

/** Zod preprocessor: treat blank/whitespace-only strings as an absent value. */
export function blankToNull(value: unknown): unknown {
  return typeof value === 'string' && value.trim() === '' ? null : value;
}
