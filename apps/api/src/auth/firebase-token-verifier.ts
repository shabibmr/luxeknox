import { Injectable } from '@nestjs/common';
import { getApps, initializeApp, type App } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';

export interface VerifiedFirebaseIdentity {
  /** Lower-cased email from the Firebase ID token. */
  email: string;
  /** Whether Firebase/Google has verified ownership of [email]. */
  emailVerified: boolean;
}

/**
 * Verifies Firebase ID tokens issued to the Flutter client.
 *
 * Signature checks use Google's public certificates, so only the Firebase
 * project id is required (`FIREBASE_PROJECT_ID`), not a service account key.
 */
@Injectable()
export class FirebaseTokenVerifier {
  /**
   * Returns the decoded identity, or `null` when the token is invalid, expired,
   * or belongs to another project. Throws when the project id is not configured,
   * because that is a deployment error rather than a client error.
   */
  async verify(idToken: string): Promise<VerifiedFirebaseIdentity | null> {
    const auth = getAuth(this.app());

    try {
      const decoded = await auth.verifyIdToken(idToken);
      if (!decoded.email) {
        return null;
      }
      return {
        email: decoded.email.toLowerCase(),
        emailVerified: decoded.email_verified === true,
      };
    } catch {
      return null;
    }
  }

  private app(): App {
    const existing = getApps()[0];
    if (existing) {
      return existing;
    }

    const projectId = process.env.FIREBASE_PROJECT_ID;
    if (!projectId) {
      throw new Error('FIREBASE_PROJECT_ID must be set to verify Firebase ID tokens');
    }
    return initializeApp({ projectId });
  }
}
