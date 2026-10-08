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
- Field: `API_BASE_URL` (string). Production value must be `https://api.luxeknox.com/v1` (Nest global prefix). Dev example: `https://api.dev.luxeknox.com/v1`.
- Rules: public **read** on `config/app` only; writes denied; all other docs deny
- App flow: SharedPreferences cache → Firestore fetch (refresh cache) → `--dart-define=API_BASE_URL` / default fallback
- The resolver normalizes absolute URLs so a missing `/v1` suffix is appended (guards against mis-seeded Firestore values)
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

## API push delivery (FCM vs logging)

The Nest notif module sends device pushes through `PushDispatcherAdapter`.

- When `FIREBASE_CLIENT_EMAIL` and `FIREBASE_PRIVATE_KEY` are set, the API uses `FcmPushDispatcherAdapter` (`firebase-admin`).
- When either is missing, it uses `LoggingPushDispatcherAdapter` (inbox still works; no real FCM).

Add these to `apps/api/.env` (see `apps/api/.env.example`). Never commit a service-account JSON file.

| Variable | Notes |
| --- | --- |
| `FIREBASE_PROJECT_ID` | Defaults to `luxe-knox-app` when email and key are set |
| `FIREBASE_CLIENT_EMAIL` | Service account email |
| `FIREBASE_PRIVATE_KEY` | PEM; literal `\n` sequences are turned into newlines |

### Service account

1. Firebase Console → Project settings → **Service accounts** → Generate new private key.
2. Put the JSON `client_email` into `FIREBASE_CLIENT_EMAIL`.
3. Put the JSON `private_key` into `FIREBASE_PRIVATE_KEY` (keep `\n` escapes or real newlines).
4. Store the file only on the server or in a secret manager. Do not commit it.

### Tell the modes apart

- Log line containing `[PushDispatcher]` → logging adapter (credentials missing).
- Successful FCM returns a Firebase message id shaped like `projects/.../messages/...`. The logging adapter fabricates ids like `msg_<timestamp>_...`.

### Platform notes

- **iOS:** Upload an APNs auth key (`.p8`) for bundle `com.luxeknox.app` under Firebase Console → Project settings → Cloud Messaging. Code cannot upload that key.
- **Android:** SHA-1 is for Google Sign-In only, not FCM. FCM needs `google-services.json`, which is already present under `app/android/app/`.
- **Web:** See [Web push (FCM token)](#web-push-fcm-token) above for the VAPID define and service worker.

### Local verification (automated)

```powershell
pnpm --filter api exec vitest run src/notif/fcm-push-dispatcher.adapter.spec.ts src/notif/notification.service.spec.ts src/notif/notification-payload.spec.ts src/notif/notification-event.consumer.spec.ts src/notif/notification-jobs.service.spec.ts
cd app
flutter test test/features/notifications/deep_link_resolver_test.dart
```

### Manual check (debug Android + real credentials)

1. Sign in. Confirm `POST /devices` stored a token.
2. Book a session. Confirm an FCM message on the device and an inbox row.
3. Force-stop the app and broadcast from the staff screen. Confirm the tray item opens notification detail.
4. Replace the token in MySQL with `invalid`. Broadcast again. Confirm that device row is removed and the delivery is `failed` when it was the only device.
