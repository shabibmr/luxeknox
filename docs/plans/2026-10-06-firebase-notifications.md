# Firebase push delivery Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make the existing inbox and FCM client deliver real Firebase pushes for every notification the API already creates.

**Architecture:** Keep `PushDispatcherAdapter`. Add `FcmPushDispatcherAdapter` that calls `firebase-admin` messaging when `FIREBASE_CLIENT_EMAIL` and `FIREBASE_PRIVATE_KEY` are set, and keep `LoggingPushDispatcherAdapter` when they are not. Fix dispatch payloads so the Flutter deep-link parser can route taps. Finish the two empty producers (freeze pending, unpaid invoices) and stop the reminder jobs from inserting a new row on every cron tick.

**Tech Stack:** NestJS 11, Drizzle, MySQL 8.4 on `localhost:3308`, `firebase-admin`, Flutter `firebase_messaging` 16 / `flutter_local_notifications` 22, Firebase project `luxe-knox-app`.

**Worktree:** `E:\work\gym-checkouts\firebase-notifications` on `feat/firebase-push-delivery` at `3b6a445`.

**Feature list:** `docs/plans/2026-10-06-firebase-notifications-features.md`.

---

## What already exists

Do not rebuild these.

- API module `apps/api/src/notif/`: inbox, detail, mark read, mark all read, broadcast, device register/list/delete.
- `NotificationService.dispatch` writes one notification, one delivery per user, then `sendPushToUser`.
- `NotificationEventConsumer` handles `schedule.booked`, `schedule.waitlisted`, `schedule.booking_cancelled`, `schedule.waitlist_promoted`, `member.trainer_assigned`. `membership.freeze_pending` is registered and empty.
- Cron jobs in `notification-jobs.service.ts`: membership expiry 08:00 UTC, session reminder hourly, payment reminder 09:00 UTC (returns 0), retry every 30 minutes.
- Seeded type codes in `apps/api/src/platform/db/schema/notifications.ts`.
- Flutter `FcmMessagingService` starts from `app/lib/main.dart`. Tokens register after login. Logout unregisters. Foreground banners use channel `luxeknox_push`.
- `NotificationPushHandler` routes only when `data` contains `entity_type` and `entity_id` (or the aliases in `deep_link_parser.dart`). Current API payloads send `schedule_id` and `membership_id`, so taps do not navigate.
- Android already has `POST_NOTIFICATIONS` and the Google services plugin. iOS `Info.plist` already lists `remote-notification`.
- Background handler `fcm_background_handler.dart` only initializes Firebase.

## Gaps this plan closes

1. `notif.module.ts` binds `LoggingPushDispatcherAdapter` only. No `firebase-admin` dependency.
2. FCM `data` values must be strings. Current `dataPayload` is a JSON object of numbers.
3. A token Firebase rejects stays in `user_devices` forever.
4. One success among many devices marks the user `sent`. Keep that. A total failure must stay `failed` and must not count a deleted invalid token as a live failure after removal.
5. Reminder queries have no “already sent today” check, so the daily and hourly jobs create a new notification on every run.
6. Freeze handler does not load the membership or the member.
7. Payment job does not read `payments`.
8. Web has no `firebase-messaging-sw.js`, so web tokens are never issued.
9. iOS delivery still needs an APNs auth key in the Firebase console. Code cannot upload that key.

## Env contract

Add to `apps/api` env parsing (same place other secrets are read; do not invent a second config system):

- `FIREBASE_PROJECT_ID` — default `luxe-knox-app` when the other two are set.
- `FIREBASE_CLIENT_EMAIL` — service account email.
- `FIREBASE_PRIVATE_KEY` — PEM. Accept literal `\n` sequences and turn them into newlines.

When email or key is missing, bind the logging adapter. Never commit a JSON key file.

---

### Task 1: FCM sender adapter

**Files:**

- Modify: `apps/api/package.json` (add `firebase-admin`)
- Create: `apps/api/src/notif/fcm-push-dispatcher.adapter.ts`
- Create: `apps/api/src/notif/fcm-push-dispatcher.adapter.spec.ts`
- Modify: `apps/api/src/notif/push-dispatcher.adapter.ts` (add `invalidToken?: boolean` on `PushDispatchResult`)
- Modify: `apps/api/src/notif/notif.module.ts` (factory chooses adapter)
- Test: `apps/api/src/notif/fcm-push-dispatcher.adapter.spec.ts`

**Step 1: Write the failing test**

Mock `firebase-admin` `getMessaging().send`. Assert:

- `send` is called with `token`, `notification: { title, body }`, `data` where every value is a string, and `android.notification.channelId === 'luxeknox_push'`.
- A thrown error whose code is `messaging/registration-token-not-registered` returns `{ success: false, invalidToken: true }`.
- Any other throw returns `{ success: false, invalidToken: false, errorMessage }` and does not include the raw token in `errorMessage`.

**Step 2: Run the test**

Run: `pnpm --filter api exec vitest run src/notif/fcm-push-dispatcher.adapter.spec.ts`

Expected: FAIL, module not found.

**Step 3: Implement**

```ts
async send(payload: PushMessagePayload): Promise<PushDispatchResult> {
  const data: Record<string, string> = {};
  for (const [key, value] of Object.entries(payload.data ?? {})) {
    if (value == null) continue;
    data[key] = typeof value === 'string' ? value : String(value);
  }
  try {
    const messageId = await this.messaging.send({
      token: payload.deviceToken,
      notification: { title: payload.title, body: payload.body },
      data,
      android: { priority: 'high', notification: { channelId: 'luxeknox_push' } },
      apns: { payload: { aps: { sound: 'default' } } },
    });
    return { success: true, messageId };
  } catch (err) {
    const code = readFirebaseErrorCode(err);
    const invalidToken =
      code === 'messaging/registration-token-not-registered' ||
      code === 'messaging/invalid-registration-token' ||
      code === 'messaging/invalid-argument';
    return {
      success: false,
      invalidToken,
      errorMessage: invalidToken ? 'Invalid device token' : 'Push send failed',
    };
  }
}
```

Initialize the app once with `cert({ projectId, clientEmail, privateKey })`. If `admin.apps` already has an app, reuse it.

Module factory:

```ts
{
  provide: PushDispatcherAdapter,
  useFactory: (config: ConfigService) => {
    const email = config.get<string>('FIREBASE_CLIENT_EMAIL');
    const key = config.get<string>('FIREBASE_PRIVATE_KEY');
    if (!email || !key) return new LoggingPushDispatcherAdapter();
    return new FcmPushDispatcherAdapter({
      projectId: config.get<string>('FIREBASE_PROJECT_ID') ?? 'luxe-knox-app',
      clientEmail: email,
      privateKey: key.replace(/\\n/g, '\n'),
    });
  },
  inject: [ConfigService],
}
```

Use the project’s existing config injection. If `ConfigService` is not global in `NotifModule`, import the module that already provides it. Do not read `process.env` inside the send method.

**Step 4: Re-run the test.** Expected: PASS.

**Step 5: Commit** `feat(notif): send pushes through firebase admin`

---

### Task 2: Drop dead tokens and keep delivery status honest

**Files:**

- Modify: `apps/api/src/notif/notification.repository.ts` (add `deleteDeviceByToken`)
- Modify: `apps/api/src/notif/notification.service.ts` `sendPushToUser`
- Modify: `apps/api/src/notif/notification.service.spec.ts`
- Test: `apps/api/src/notif/notification.service.spec.ts`

**Step 1: Write the failing test**

Case A: two devices, first returns `invalidToken: true`, second returns `success: true`. Expect the first token deleted, delivery status `sent`.

Case B: one device, `success: false`, `invalidToken: false`. Expect the token kept, status `failed`, `retry_count` incremented.

Case C: no devices. Expect status `sent` and `delivered_at` set (inbox only). This matches current behavior.

**Step 2: Run** `pnpm --filter api exec vitest run src/notif/notification.service.spec.ts`

Expected: FAIL on A and B.

**Step 3: Implement**

Inside the device loop, if `result.invalidToken`, call `repository.deleteDeviceByToken(device.device_token)` and do not treat that device as a live failure. `allFailed` stays true only when every remaining attempt failed. If every token was invalid and none succeeded, set `failed` with reason `No valid device tokens`.

**Step 4: Re-run.** Expected: PASS.

**Step 5: Commit** `fix(notif): delete rejected fcm tokens`

---

### Task 3: Put routable keys on every payload

**Files:**

- Create: `apps/api/src/notif/notification-payload.ts`
- Create: `apps/api/src/notif/notification-payload.spec.ts`
- Modify: every `dispatch({...})` call in `notification-event.consumer.ts` and `notification-jobs.service.ts`
- Modify: `apps/api/src/notif/notification.service.ts` `broadcast` path so its `dataPayload` includes `entity_type: 'notification'` and `entity_id` of the new notification id. Set that after insert, inside `dispatch`, when `isBroadcast` is true or when `dataPayload` has no `entity_type`. Always add `notification_id` and `type_code` as strings before `send`.

**Step 1: Write the failing test**

`buildPushData({ typeCode: 'booking_confirmed', dataPayload: { schedule_id: 12 }, notificationId: 9 })` returns:

```ts
{
  notification_id: '9',
  type_code: 'booking_confirmed',
  entity_type: 'schedule',
  entity_id: '12',
}
```

Mapping:

| type_code | entity_type | id field already on the payload |
| --- | --- | --- |
| booking_confirmed, booking_cancelled, session_reminder, session_waitlist_promoted, announcement when `schedule_id` present | schedule | schedule_id |
| membership_expiry, freeze_pending | membership | membership_id |
| payment_due | payment | payment_id |
| trainer_assigned | (none — app route `Routes.memberProfileTrainer` has no id) | omit entity id |
| broadcast | notification | notification id |

`announcement` used by waitlist today must also set `entity_type: schedule` from `schedule_id`. Change that call’s `typeCode` only if a seeded code exists. It does not. Keep `announcement` and still attach the schedule id.

Trainer tap: extend the Flutter resolver in Task 6. Until then the payload may omit `entity_type` and the inbox still opens from the notification list.

**Step 2: Run** `pnpm --filter api exec vitest run src/notif/notification-payload.spec.ts`

**Step 3: Implement `buildPushData` and call it from `sendPushToUser` so every sender path is covered, including broadcasts and future events.**

**Step 4: Re-run.** Expected: PASS.

**Step 5: Commit** `feat(notif): attach deep link keys to push data`

---

### Task 4: Finish freeze and unpaid-invoice producers

**Files:**

- Modify: `apps/api/src/notif/notification-event.consumer.ts` `handleMembershipFreezePending`
- Modify: `apps/api/src/notif/notification-jobs.service.ts` `runPaymentReminders`
- Modify: the matching spec files
- Test: `apps/api/src/notif/notification-event.consumer.spec.ts`, `apps/api/src/notif/notification-jobs.service.spec.ts`

**Step 1: Write failing tests**

Freeze: given a membership id that resolves to a member `user_id`, `dispatch` is called once with `typeCode: 'freeze_pending'` and `dataPayload.membership_id`. If the membership is missing, `dispatch` is not called.

Payment: a `pending` payment whose `amount_paid` is less than `total_amount` for an active user produces one `payment_due` dispatch with `payment_id`, amount, and currency text already used by the seed template (`{{currency}}` is not a column; format `total_amount` as a decimal string and use a fixed `AED` only if the codebase has no currency column — confirm in `payments` schema before writing the string; the schema has no currency column, so say the amount only).

Skip payments that are not `pending`.

**Step 2: Run those two vitest files.** Expected: FAIL.

**Step 3: Implement**

Freeze: load membership by id through `MembershipRepository`, then member, then `dispatch` to `member.user_id`. Copy the title and message style already used by the other handlers. Include start and end dates when the freeze row exposes them.

Payment: query `payments` joined to `members` and `users` where `payments.status = 'pending'` and `users.status = 'active'`. One dispatch per payment.

**Step 4: Re-run.** Expected: PASS.

**Step 5: Commit** `feat(notif): send freeze and unpaid invoice notices`

---

### Task 5: Send each reminder once per day

**Files:**

- Modify: `apps/api/src/notif/notification.repository.ts`
- Modify: `apps/api/src/notif/notification-jobs.service.ts`
- Modify: `apps/api/src/notif/notification-jobs.service.spec.ts`

**Step 1: Write the failing test**

`runSessionReminders` with a participant who already has a `session_reminder` delivery created today does not call `dispatch` again. Same for membership expiry and payment due, keyed by `(user_id, type_code, entity id, UTC date)`.

**Step 2: Run the jobs spec.** Expected: FAIL.

**Step 3: Implement**

Add `hasDeliveryToday(userId, typeCode, entityKey, day)` that looks up today’s notifications for that user and type whose `data_payload` contains the entity id. Call it before `dispatch` in the three jobs. Do not add a table. The entity key is `schedule_id`, `membership_id`, or `payment_id`.

Session job runs hourly, so the same session inside the two-hour window would otherwise notify every hour. The daily check is the guard.

**Step 4: Re-run.** Expected: PASS.

**Step 5: Commit** `fix(notif): remind each event once per day`

---

### Task 6: App routes for trainer assignment and background taps

**Files:**

- Modify: `app/lib/features/notifications/domain/helpers/deep_link_resolver.dart`
- Modify: the existing resolver test if one exists under `app/test/features/notifications/`; otherwise create `app/test/features/notifications/deep_link_resolver_test.dart`
- Modify: `app/lib/features/notifications/data/services/fcm_background_handler.dart` (keep it initializing Firebase only; system tray uses the notification payload from Task 1, so do not build a second local notification here)
- Modify: `app/lib/features/notifications/data/services/fcm_messaging_service.dart` only if a tap with `entity_type` still fails to navigate. Read `_navigateFromMessage` before editing.

**Step 1: Write the failing widget/unit test**

`resolveDeepLinkPath(DeepLinkTarget(entityType: 'trainer', entityId: '1'))` returns `Routes.memberProfileTrainer`.

`schedule` / `15` still returns `Routes.memberScheduleById('15')`.

**Step 2: Run** `cd app && flutter test test/features/notifications/deep_link_resolver_test.dart`

**Step 3: Add the `trainer` arm.** Do not change unrelated routes.

**Step 4: Re-run.** Expected: PASS.

**Step 5: Commit** `feat(app): open trainer screen from push payload`

---

### Task 7: Web push token

**Files:**

- Create: `app/web/firebase-messaging-sw.js`
- Modify: `app/web/index.html` if the app does not already load the Firebase messaging compat scripts required by that worker
- Modify: `app/lib/features/notifications/data/services/fcm_push_token_provider.dart` only if web `getToken` needs a VAPID key

**Step 1:** Confirm `DefaultFirebaseOptions.web` in `app/lib/firebase_options.dart` has a real key for project `luxe-knox-app`. It does today. The worker must use that same `apiKey`, `projectId`, `messagingSenderId`, and `appId`. Do not duplicate a second Firebase project.

**Step 2:** Add the service worker with `importScripts` for `firebase-app-compat` and `firebase-messaging-compat` at a pinned 11.x that matches `firebase_core` in `app/pubspec.yaml`. Call `firebase.initializeApp({...})` and `firebase.messaging().onBackgroundMessage`.

**Step 3:** Web `getToken` requires a VAPID key from Cloud Messaging settings. Read it from `--dart-define=FCM_VAPID_KEY=...`. If the define is empty, web stays non-live and Android/iOS behavior is unchanged. Document the define in `docs/flutter/firebase-luxe-knox-app-setup.md`.

**Step 4:** Manual check, not a unit test: `flutter run -d chrome` with the define, allow notifications, confirm a row in `user_devices` with `device_platform = web`.

**Step 5: Commit** `feat(app): register a web fcm token`

---

### Task 8: Docs and local verification

**Files:**

- Modify: `docs/flutter/firebase-luxe-knox-app-setup.md`
- Modify: API env example if the repo has one (`.env.example` under `apps/api`). Add the three variables with empty values. Do not paste a real key.

Document:

- Service account: Firebase console → project settings → service accounts → generate key. Store email and private key in the API env on the server. Do not commit the file.
- iOS: upload the APNs auth key (.p8) for bundle `com.luxeknox.app` in Cloud Messaging settings.
- Android: SHA-1 is for Google sign-in, not for FCM. FCM needs `google-services.json`, which is already present.
- How to tell the modes apart: API log line `[PushDispatcher]` means the logging adapter. A Firebase message id in logs means the real sender.

**Verify:**

```powershell
pnpm --filter api exec vitest run src/notif/fcm-push-dispatcher.adapter.spec.ts src/notif/notification.service.spec.ts src/notif/notification-payload.spec.ts src/notif/notification-event.consumer.spec.ts src/notif/notification-jobs.service.spec.ts
cd app
flutter test test/features/notifications/deep_link_resolver_test.dart
```

Expected: all PASS.

Manual, with env set and a debug Android build:

1. Sign in. Confirm `POST /devices` stored a token.
2. Book a session. Confirm an FCM message on the device and an inbox row.
3. Force-stop the app and broadcast from the staff screen. Confirm the tray item opens the notification detail.
4. Replace the token in MySQL with `invalid`. Broadcast again. Confirm that device row is gone and the delivery is `failed` when it was the only device.

---

## Out of scope

- Mute preferences, quiet hours, topics, and a per-device delivery table.
- Windows and Linux push.
- Uploading the APNs key. That is a console action, listed in Task 8.
- Changing inbox UI layout.
