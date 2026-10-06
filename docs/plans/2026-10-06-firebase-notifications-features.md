# Firebase notifications — features after a complete implementation

Current code already stores an inbox, registers device tokens, and listens for FCM on Android and iOS. The API never calls Firebase. After the plan in `2026-10-06-firebase-notifications.md`, these are the features a member or staff user can actually use.

## Member

1. **Booking confirmed.** Push plus inbox row when a class or PT session is booked. Tap opens that session.
2. **Waitlisted.** Push plus inbox when the member is placed on a waitlist. Tap opens that session.
3. **Booking cancelled.** Push plus inbox when a booking is cancelled. Tap opens that session.
4. **Waitlist promoted.** Push plus inbox when a waitlist spot becomes a confirmed booking. Tap opens that session.
5. **Session starting soon.** Hourly job pushes members whose booked session starts within two hours. Tap opens that session. One reminder per session per day.
6. **Membership expiring.** Daily job pushes members whose active membership ends within seven days. Tap opens the membership screen.
7. **Freeze request received.** Push plus inbox when a membership freeze is submitted and still pending. Tap opens the membership screen.
8. **Trainer assigned.** Push plus inbox when a trainer is linked to the member. Tap opens the member’s trainer screen.
9. **Unpaid invoice.** Daily job pushes members who have a payment still in `pending`. Tap opens that payment. The payments table has no due date, so the trigger is unpaid status, not a calendar due date.
10. **Staff broadcast.** Push plus inbox when staff send a message to all members, to a trainer’s assigned clients, or to one role. Tap opens that notification.
11. **Several phones.** Each signed-in Android or iOS install registers its own token. A send goes to every live token for that user.
12. **Token stays current.** Refresh rotates the stored token. Logout removes it. A token Firebase rejects is deleted so later sends skip it.
13. **App in the foreground.** A high-importance local banner uses the existing `luxeknox_push` channel. Tap uses the same route as a background tap.
14. **App in the background or killed.** The system tray shows the FCM notification. Tap opens the matching screen, or the inbox item if the payload has no route.
15. **Inbox without a push.** The in-app list, detail, mark-read, and mark-all-read screens keep working when the phone has no token or the user denied permission.

## Staff

16. **Broadcast composer.** Existing screen sends a real push, not only an inbox row. Audiences stay `all_members`, `assigned_clients`, and `role`.
17. **Broadcast history.** Existing history list still shows what was sent.
18. **Own inbox.** Staff receive the same inbox and push path for notifications addressed to their user.

## Delivery behavior

19. **Real FCM send.** The API uses Firebase Admin Cloud Messaging when service-account env vars are set.
20. **Local and test mode.** With those env vars unset, the API keeps the log-only sender so unit tests and local runs do not call Google.
21. **Per user outcome.** The delivery row is `sent` when Firebase accepts at least one device, or when the user has no devices (inbox only). It is `failed` only when every live device fails.
22. **Retry.** The existing 30-minute job retries `failed` rows up to three times.
23. **No duplicate event pushes.** The existing idempotency key still suppresses a repeated domain event.
24. **Dead tokens.** `registration-token-not-registered` and `invalid-argument` remove that device. Other errors keep the token and fail the delivery.
25. **Tap payload.** Every push `data` map includes string values `notification_id`, `type_code`, `entity_type`, and `entity_id` when a screen exists for that type. The app already maps those keys to routes.

## Platforms

26. **Android.** Permission `POST_NOTIFICATIONS`, Google services plugin, and FCM token registration stay. Sends use the `luxeknox_push` channel id.
27. **iOS.** Alert, badge, and sound permission, plus the existing `remote-notification` background mode. Display uses a notification payload so the tray shows title and body. APNs must be uploaded in the Firebase console for project `luxe-knox-app`. That console step is required for item 27 to reach a real iPhone.
28. **Web.** A service worker registers an FCM web token after permission. Web pushes use the same API sender. Web has no service worker today.
29. **Windows and Linux desktop.** No Firebase push. The app keeps the current stub and the in-app inbox. `firebase_messaging` has no implementation on those targets.

## Explicitly unchanged

30. No new notification types beyond the ten already seeded.
31. No user-level mute or quiet hours.
32. No per-device delivery table. One row per notification per user remains the record.
33. No marketing campaigns, topics, or condition sends. Sends stay targeted at stored device tokens.
