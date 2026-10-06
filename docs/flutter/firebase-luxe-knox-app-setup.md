# Firebase project `luxe-knox-app` (Luxe-Knox-App)

## Done

- Project linked at repo root: `.firebaserc` → `luxe-knox-app`
- Firestore `(default)` created in **asia-south1**; closed rules deployed (`firestore.rules`)
- Apps registered:
  - Android `com.luxeknox.app` → `1:27985362758:android:564da5bc6a105afe202f47`
  - iOS `com.luxeknox.app` → `1:27985362758:ios:34f42685e7e64a78202f47`
  - Web → `1:27985362758:web:fca5ce8055ad07ac202f47`
  - Windows (FlutterFire web app) → `1:27985362758:web:7b66c77202365047202f47`
- FlutterFire wired: `app/lib/firebase_options.dart` (android/web/windows/ios/macos), `app/android/app/google-services.json`, `app/ios/Runner/GoogleService-Info.plist`

## Auth (Google Sign-In only)

- Firebase Auth initialized (`subtype: FIREBASE_AUTH`)
- Providers: **Google enabled**; email / phone / anonymous disabled
- For Android Google Sign-In, add debug/release **SHA-1** under Project settings → Android app (OAuth clients appear after SHA-1 is added)

## Remote app config (`API_BASE_URL`)

- Document: `config/app`
- Field: `API_BASE_URL` (string), seeded to `https://api.dev.luxeknox.com`
- Rules: public **read** on `config/app` only; writes denied; all other docs deny
- App flow: SharedPreferences cache → Firestore fetch (refresh cache) → `--dart-define=API_BASE_URL` / default fallback
- Code: `app/lib/core/config/resolve_remote_app_config.dart` (runs in `main` before DI)

## Console

https://console.firebase.google.com/project/luxe-knox-app/overview

## Web push (FCM token)

Web needs a VAPID key and the messaging service worker. Android/iOS are unchanged when the define is omitted.

1. Firebase Console → Project settings → Cloud Messaging → **Web Push certificates** → generate / copy the key pair.
2. Run Chrome with the key:

```powershell
cd app
flutter run -d chrome --dart-define=FCM_VAPID_KEY=<web-push-certificate-key>
```

3. Allow notifications in the browser. After login, `POST /devices` should store a row with `device_platform = web`.
4. Service worker: `app/web/firebase-messaging-sw.js` (served at `/firebase-messaging-sw.js`). It uses the same `apiKey` / `projectId` / `messagingSenderId` / `appId` as `DefaultFirebaseOptions.web` and Firebase JS **12.19.0** (matches `firebase_core_web`).

Without `FCM_VAPID_KEY`, web stays on stub device tokens (`FcmPushTokenProvider.isLive` stays false).
