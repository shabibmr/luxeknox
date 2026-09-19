import * as argon2 from 'argon2';

/**
 * Hashes a plaintext password using Argon2id.
 *
 * @param password The plaintext password to hash
 * @returns Argon2id hash string
 */
export async function hashPassword(password: string): Promise<string> {
  return argon2.hash(password, { type: argon2.argon2id });
}

/**
 * Verifies a plaintext password against an Argon2 hash.
 *
 * @param hash The stored Argon2 hash
 * @param password The candidate plaintext password
 * @returns True if password matches hash, false otherwise
 */
export async function verifyPassword(hash: string, password: string): Promise<boolean> {
  try {
    return await argon2.verify(hash, password);
  } catch {
    return false;
  }
}
