# Task: Firebase Auth with Google Sign-In

## Done
- [x] Add firebase_auth & google_sign_in dependencies to app/pubspec.yaml
- [x] Implement FirebaseAuthService (single GoogleSignIn instance so sign-out clears the same session)
- [x] Implement SessionRepository.loginWithGoogle (signs out of Firebase when the backend exchange fails) and LoginWithGoogleUseCase
- [x] Update SessionCubit / LoginCubit / LoginState for Google sign-in
- [x] Neutral error copy for Google sign-in (no account-existence or status leak, FR-AUTH-002)
- [x] Create GoogleSignInButton widget; show on web, Android, and iOS only
- [x] Backend: `POST /v1/auth/firebase` verifies the Firebase ID token and requires a verified email matching an active account (apps/api/src/auth)
- [x] Backend unit tests for loginWithFirebase (apps/api: auth.service.spec.ts)
- [x] Flutter unit tests for FirebaseAuthService, SessionRepository.loginWithGoogle, LoginCubit

## Open: needs Firebase console access
- [ ] iOS: confirm `GIDClientID` in ios/Runner/Info.plist matches the iOS OAuth client (value derived from the existing URL scheme; GoogleService-Info.plist has no CLIENT_ID)
- [ ] Android: re-download app/android/app/google-services.json from the Firebase console. The current file is hand-edited and its mobilesdk_app_id belongs to the old package com.algo.luxeknox.
- [ ] Android: register the debug and release SHA-1 fingerprints and confirm an Android OAuth client (client_type 1) exists
- [ ] Backend env: set FIREBASE_PROJECT_ID in each deployed environment (local value in .env.example)
- [ ] Manual sign-in test on a device for each platform. Unit tests do not cover the native Google flow.

## Known, out of scope
- `flutter test test/core/router/app_router_test.dart` fails on clean HEAD as well; not caused by this branch.
- `pnpm openapi:check` reports `GET /v1/media/{}` missing from the live dump; not caused by this branch.
