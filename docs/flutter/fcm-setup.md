# FCM setup (Flutter)

Flutter client scaffolding for Firebase Cloud Messaging is in place. Live tokens
require a real Firebase project.

## What is already wired

- Packages: `firebase_core`, `firebase_messaging`, `flutter_local_notifications`
- `lib/firebase_options.dart` — placeholder; `DefaultFirebaseOptions.isConfigured` is false until keys are replaced
- `FcmPushTokenProvider` + `FcmMessagingService` — init, permission, foreground local notifications, tap → deep link, token sync on login/refresh
- `DeviceTokenService` — prefers FCM token; falls back to stub UUID when not configured
- Android: `google-services` Gradle plugin, placeholder `android/app/google-services.json`, `POST_NOTIFICATIONS`
- iOS: placeholder `ios/Runner/GoogleService-Info.plist`, `UIBackgroundModes` remote-notification, APNs registration in `AppDelegate`
- Bootstrap: `main.dart` calls `getIt<FcmMessagingService>().start()`

## Enable real FCM

1. `firebase login` (interactive terminal).
2. Create or select a Firebase project; enable Cloud Messaging.
3. From `app/`:

```bash
flutterfire configure --project=<project-id> \
  --platforms=android,ios,web \
  --android-package-name=com.luxeknox.app \
  --ios-bundle-id=com.luxeknox.app
```

4. Confirm `lib/firebase_options.dart` no longer uses `REPLACE_ME_*` keys (`isConfigured` becomes true).
5. Replace placeholder `google-services.json` / `GoogleService-Info.plist` if FlutterFire did not.
6. Add `GoogleService-Info.plist` to the Xcode Runner target if it is not already a project resource.
7. iOS: upload an APNs key/certificate in Firebase Console → Project settings → Cloud Messaging.
8. Web (optional): add Firebase JS SDK scripts to `web/index.html` per FlutterFire web docs.

## Verify

- Physical Android/iOS device (emulators often lack reliable push).
- Log in → device should register via NOTIF `registerDevice` once Nest NOTIF is live.
- Send a test message from Firebase Console with data keys `entity_type` + `entity_id` (or `type`/`id`) to exercise deep links.

## Still open

- Nest NOTIF dispatcher (FR-NOTIF-007) must send to registered `device_token` values.
- Production readiness checklist item `push config` tracks finishing this configure step per environment.
