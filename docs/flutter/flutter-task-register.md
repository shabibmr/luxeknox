# LuxeKnox Flutter — Master Task Register

This file is the single executable register. Each vertical below is also maintained as a separate file.

<!-- ==================== FILE: 00-foundation.md ==================== -->
# FILE: 00-foundation.md
## Foundation
- [x] Architecture audit
- [x] DI/injectable stabilization
- [x] Dio/base URL/timeouts
- [x] 401 refresh concurrency
- [x] typed error mapping
- [x] pagination primitives
- [x] common loading/error/empty widgets
- [x] Material 3 theme
- [x] localization infrastructure
- [x] form validation
- [x] test fixtures
- [x] environment configuration
- [x] architecture CI checks

<!-- ==================== FILE: 01-auth-session.md ==================== -->
# FILE: 01-auth-session.md
## Auth & Session
- [x] login email/phone
- [x] session restore
- [x] refresh/logout
- [x] password change/reset
- [x] GET /me principal
- [x] capabilities hydration
- [x] suspended-user handling
- [x] auth redirects
- [x] concurrent refresh tests

<!-- ==================== FILE: 02-navigation-shell.md ==================== -->
# FILE: 02-navigation-shell.md
## Navigation & Shell
- [x] StatefulShellRoute five branches
- [x] member shell
- [x] trainer shell
- [x] admin shell
- [x] responsive navigation
- [x] deep links
- [x] capability redirects
- [x] nested-stack preservation
- [x] unknown routes
- [x] unsaved-form guards

<!-- ==================== FILE: 03-people-profile.md ==================== -->
# FILE: 03-people-profile.md
## People & Profile
- [x] member directory
- [x] member dossier
- [x] trainer directory
- [x] employee directory
- [x] profile edit
- [x] trainer assignment
- [x] health
- [x] medical history
- [x] emergency contacts
- [x] documents
- [x] photos/avatar
- [x] role-specific visibility
- [x] upload retry/cancel
- [x] role-variant tests

<!-- ==================== FILE: 04-membership.md ==================== -->
# FILE: 04-membership.md
## Membership
- [x] membership card / detail / history
- [x] packages catalogue + product CRUD
- [x] memberships directory
- [x] freeze request / approve / reject / extension
- [x] renew / upgrade / cancel
- [x] row-version conflicts
- [x] role pricing visibility
- [x] create-membership sales UI
- [x] shell / router wiring
- [x] directory cubit refactor
- [ ] remaining screen cubit refactors (detail/card/form)
- [ ] broader widget/integration tests
<!-- ==================== FILE: 05-scheduling.md ==================== -->
# FILE: 05-scheduling.md
## Scheduling
- [x] calendar queries
- [x] schedule detail/roster
- [x] schedule types
- [x] facilities
- [x] trainer availability
- [ ] open slots
- [x] PT booking
- [x] class booking
- [ ] recurring series
- [x] cancel/reschedule (cancel done; reschedule UI open)
- [x] waitlist
- [x] trainer start/complete
- [x] double-submit protection
<!-- ==================== FILE: 06-attendance.md ==================== -->
# FILE: 06-attendance.md
## Attendance
- [x] digital pass
- [x] QR presentation
- [x] check-in/out
- [x] history
- [x] summary/streak/heatmap
- [x] session attendance
- [x] admin live feed
- [x] manual override
- [x] idempotency keys
- [x] camera/permission errors

<!-- ==================== FILE: 07-payments.md ==================== -->
# FILE: 07-payments.md
## Payments & POS
- [x] member ledger
- [x] admin ledger
- [x] outstanding dues
- [x] payment detail
- [x] payment methods
- [ ] POS
- [ ] discounts
- [ ] split tender
- [ ] refund/adjustment
- [ ] receipt
- [ ] financial integration tests

<!-- ==================== FILE: 08-workout.md ==================== -->
# FILE: 08-workout.md
## Workout
- [x] plan list/detail
- [x] plan builder
- [x] exercise picker
- [x] ordering
- [x] publish/archive
- [x] template copy
- [x] versions
- [x] live session
- [x] set logging
- [x] rest timer
- [x] completion
- [x] history
- [x] volume/PR
- [x] role variants

<!-- ==================== FILE: 09-diet.md ==================== -->
# FILE: 09-diet.md
## Diet
- [x] plan list/detail
- [x] builder
- [x] meal builder
- [x] food picker
- [x] macro display
- [x] versions/templates
- [x] assignment
- [x] daily log
- [x] adherence
- [x] water
- [x] trainer review
- [x] verified-food visibility

<!-- ==================== FILE: 10-goals-progress.md ==================== -->
# FILE: 10-goals-progress.md
## Goals & Progress
- [x] metrics
- [x] goals
- [x] check-ins
- [x] measurements
- [x] charts
- [x] mandatory metrics
- [x] progress photos
- [x] comparison
- [x] privacy
- [x] notes
- [x] trainer assessments
- [x] server-derived achievement

<!-- ==================== FILE: 11-notifications.md ==================== -->
# FILE: 11-notifications.md
## Notifications
- [x] inbox
- [x] detail/deep links
- [x] unread
- [x] read actions
- [x] device registration
- [x] token rotation
- [x] logout unregister
- [x] push handling
- [x] admin broadcast
- [x] trainer broadcast
- [x] history

FCM client scaffolded (`firebase_messaging`); enable with `flutterfire configure` — see `docs/flutter/fcm-setup.md`.

<!-- ==================== FILE: 12-dashboard.md ==================== -->
# FILE: 12-dashboard.md
## Dashboard
> `lib/features/dashboard/` calls the backend's `GET /dashboard` (already implemented — see
> `apps/api/todo/backend-task-register.md` Vertical 14). Session/attendance/schedule/revenue
> sub-widgets from the FRD are out of scope here because the backend itself doesn't return
> them yet (no attendance/scheduling/payment tables); the client renders whatever the server
> sends and omits the rest, which is exactly the DSH-005 contract.
- [x] adaptive shell — `DashboardScreen` slots into the existing `AdaptiveShell`-based member/trainer/admin `StatefulShellRoute`s (`lib/core/router/{member,trainer,admin}_routes.dart`, home route).
- [x] member widgets — `DashboardMemberSection` (membership status/days-remaining, assigned trainer).
- [x] trainer widgets — `DashboardTrainerSection` (assigned-member count + preview list).
- [x] admin widgets — `DashboardAdminSection` (member/trainer/employee totals, membership-status breakdown, expiring-soon).
- [x] section loading — `DashboardStatus.loading` (first fetch, empty) vs `refreshing` (reload with prior data already shown) in `dashboard_cubit.dart`.
- [x] permission omission — `DashboardSnapshot.member/trainer/admin` are nullable; `dashboard_model.dart` maps a missing/malformed section to `null` instead of throwing, and the screen renders only present sections (`dashboard_model_test.dart`, `dashboard_cubit_test.dart`).
- [x] skeletons — `DashboardSkeleton` shown only on the initial empty-state load.
- [x] refresh — `RefreshIndicator` + retry button call `DashboardCubit.refresh()`.
- [x] cache-last-successful where useful — `DashboardState.snapshot` is retained across a failed refresh so the UI keeps showing the last good data behind a stale-data banner (`dashboard_cubit_test.dart` "cache-last-successful").
- [x] rebuild optimization — `Equatable` state + one `BlocSelector` per section widget in `dashboard_screen.dart`, so a change to one section never rebuilds the others.

<!-- ==================== FILE: 13-reports.md ==================== -->
# FILE: 13-reports.md
## Reports
- [x] report navigation
- [x] filters
- [x] date ranges
- [ ] member report
- [ ] membership report
- [ ] attendance report
- [ ] payments report
- [ ] trainer report
- [ ] workout report
- [ ] diet report
- [ ] progress report
- [ ] trainer own slice
- [ ] export handling
- [ ] large-result pagination

<!-- ==================== FILE: 14-settings-rbac.md ==================== -->
# FILE: 14-settings-rbac.md
## Settings & RBAC
- [ ] settings categories
- [ ] public settings
- [ ] roles
- [ ] permission matrix
- [ ] employee role/status
- [ ] audit log
- [ ] capability-aware actions
- [ ] concurrent admin edit conflicts

<!-- ==================== FILE: 15-media.md ==================== -->
# FILE: 15-media.md
## Media
- [x] signed upload
- [x] upload progress
- [x] retry/cancel
- [x] signed download
- [x] parent access checks
- [x] MIME/size handling
- [x] image compression/thumbnails
- [x] document preview
- [x] expired URL recovery

<!-- ==================== FILE: 16-api-client-contract.md ==================== -->
# FILE: 16-api-client-contract.md
## API Client Contract
- [ ] OpenAPI regeneration
- [ ] generator pinning
- [ ] drift CI
- [ ] repository adapters
- [ ] DTO-to-domain mapping
- [ ] date/decimal/enum serialization
- [ ] pagination metadata
- [ ] idempotency headers
- [ ] error contract tests

<!-- ==================== FILE: 17-testing-quality.md ==================== -->
# FILE: 17-testing-quality.md
## Testing & Quality
- [ ] entity tests
- [ ] use cases
- [ ] repositories
- [ ] Blocs/Cubits
- [ ] role variants
- [ ] widget tests
- [ ] goldens
- [ ] router tests
- [ ] integration journeys
- [ ] accessibility
- [ ] localization
- [ ] architecture CI
- [ ] flaky-test elimination

<!-- ==================== FILE: 18-production-readiness.md ==================== -->
# FILE: 18-production-readiness.md
## Production Readiness
- [ ] dev/staging/prod config
- [ ] secure storage
- [ ] crash reporting
- [ ] network policy
- [ ] app resume
- [ ] push config (Flutter FCM scaffold done; finish per-env flutterfire configure — see fcm-setup.md)
- [ ] camera/photo permissions
- [ ] deep links
- [ ] platform builds
- [ ] performance profiling
- [ ] accessibility
- [ ] security review
- [ ] release and rollback

<!-- ==================== FILE: 99-master-checklist.md ==================== -->
# FILE: 99-master-checklist.md
## Master Completion Checklist
- [x] Foundation
- [x] Auth
- [ ] Navigation
- [x] People
- [x] Membership
- [x] Scheduling (core; see phase3-status-report)
- [ ] Attendance
- [x] Workout (plans + sessions + history/volume/PR + role variants — see phase6-status-report)
- [x] Diet (plans + versions/templates + assignment + daily log + adherence/water + trainer review + verified foods — see phase7-status-report)
- [ ] Goals/Progress
- [x] Notifications
- [ ] Dashboard
- [ ] Reports (navigation + filters + date ranges — see phase8-status-report; remaining types/export later)
- [ ] Settings/RBAC
- [x] Media
- [ ] API contract
- [ ] role-variant tests
- [ ] integration tests
- [ ] release builds
