# Phase 10 Notifications — status (2026-09-21)

## Implemented
- Clean Architecture feature `app/lib/features/notifications` (domain / data / presentation)
- **Inbox** — member `/notifications` and trainer `/trainer/notifications`; cursor pagination, all/unread filter, pull-to-refresh, AppBar unread badge, mark-all-read overflow
- **Detail / deep links** — `/notifications/:id`, `/trainer/notifications/:id`; mark-read on open; CTA from `data_payload` via flexible entity type/id keys
- **Unread + read actions** — `unreadCount` helper; mark one + mark all via NOTIFApi
- **Device registration / token rotation** — `DeviceTokenService` prefers live FCM token via `PushTokenProvider`; stub UUID fallback when Firebase options are placeholders; inbox overflow “Register this device” / “Rotate device token”
- **Logout unregister** — `UnregisterDeviceOnLogoutUseCase` hooked into `LogoutUseCase` (best-effort deleteDevice before token clear)
- **Push handling / FCM** — `FcmMessagingService` + `FcmPushTokenProvider` (`firebase_core` / `firebase_messaging` / `flutter_local_notifications`); foreground local notifications; tap / `getInitialMessage` → `NotificationPushHandler` deep links; auto token sync on login + `onTokenRefresh`. See `docs/flutter/fcm-setup.md`.
- **Admin broadcast** — `/admin/notifications/broadcast` compose + history tabs; audiences `all_members` | `assigned_clients` | `role`
- **Trainer broadcast** — `/trainer/notifications/broadcast` locked to `assigned_clients`; inbox campaign action gated by `notifications.send` / `notifications.broadcast`
- **History** — `listBroadcasts` on broadcast screen history tab
- `NOTIFApi` registered in `register_module.dart`

## Architecture
- Domain: entities (`AppNotification`, device, broadcast), helpers (`unread_count`, `deep_link_parser`, `deep_link_resolver`, `notification_push_handler`), repositories (`PushTokenProvider`, `DeviceTokenRegistrar`), usecases
- Data: `NotificationsRemoteDataSource` → NOTIFApi; mappers; repository impl with `Either` + `mapThrownToFailure`; `DeviceTokenLocalStore` + `DeviceTokenService`; `FcmPushTokenProvider` + `FcmMessagingService`
- Presentation: cubits (`@injectable`), screens, widgets, `notification_strings.dart`
- Presentation never imports `api_client` or `data/`; `tool/check_layers.sh` OK

## Routes wired
| Route | Screen |
| --- | --- |
| `/notifications` | `NotificationsInboxScreen` |
| `/notifications/:id` | `NotificationDetailScreen` |
| `/trainer/notifications` | `NotificationsInboxScreen` (+ broadcast entry) |
| `/trainer/notifications/:id` | `NotificationDetailScreen` |
| `/trainer/notifications/broadcast` | `BroadcastScreen(trainerOnlyAssigned: true)` |
| `/admin/notifications/broadcast` | `BroadcastScreen` |

Capability gates: admin + trainer broadcast paths → `notifications.send` (seed slug; OpenAPI names `notifications.broadcast`).

## Tests (`app/test/features/notifications/`)
- `deep_link_parser_test.dart` (parser + resolver + push handler)
- `unread_count_test.dart`
- `notifications_inbox_cubit_test.dart` (load, mark all, failure)
- `broadcast_cubit_test.dart` (validation, trainer lock, submit)

## OPEN / blockers
- **Nest NOTIF backend is not started** (NOT-001+ open). Live `NOTIFApi` calls may **404** until backend lands. Flutter client is forward-compatible against generated OpenAPI models.
- **Firebase project not configured** — placeholder `firebase_options.dart` / `google-services.json` / `GoogleService-Info.plist`. Until `flutterfire configure` replaces `REPLACE_ME_*` keys, `DefaultFirebaseOptions.isConfigured` is false and the app uses stub tokens (no live FCM). Steps: `docs/flutter/fcm-setup.md`.

## Recommended next
- `firebase login` + `flutterfire configure` for a real project, or Nest NOTIF (NOT-001+) so inbox/broadcast/devices work live.
