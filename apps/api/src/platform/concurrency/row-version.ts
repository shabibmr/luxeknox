import { ConflictError } from '../errors/app-error';

/**
 * Verifies that the expected row version matches the actual row version retrieved from the database.
 * Throws a ConflictError (HTTP 409) if there is a mismatch, preventing lost updates (optimistic locking).
 *
 * @param expected The version expected by the caller/request
 * @param actual The current version in the database
 */
export function verifyRowVersion(expected: number, actual: number): void {
  if (expected !== actual) {
    throw new ConflictError(
      `Row version mismatch: expected ${expected}, but found ${actual}. The resource was modified concurrently.`,
    );
  }
}
