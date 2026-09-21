# LuxeKnox Flutter — Master Task Register

This file is the single executable register. Each vertical below is also maintained as a separate file.

<!-- ==================== FILE: 00-foundation.md ==================== -->
# FILE: 00-foundation.md
## Foundation
- [ ] Architecture audit
- [ ] DI/injectable stabilization
- [ ] Dio/base URL/timeouts
- [ ] 401 refresh concurrency
- [ ] typed error mapping
- [ ] pagination primitives
- [ ] common loading/error/empty widgets
- [ ] Material 3 theme
- [ ] localization infrastructure
- [ ] form validation
- [ ] test fixtures
- [ ] environment configuration
- [ ] architecture CI checks

<!-- ==================== FILE: 01-auth-session.md ==================== -->
# FILE: 01-auth-session.md
## Auth & Session
- [ ] login email/phone
- [ ] session restore
- [ ] refresh/logout
- [ ] password change/reset
- [ ] GET /me principal
- [ ] capabilities hydration
- [ ] suspended-user handling
- [ ] auth redirects
- [ ] concurrent refresh tests

<!-- ==================== FILE: 02-navigation-shell.md ==================== -->
# FILE: 02-navigation-shell.md
## Navigation & Shell
- [ ] StatefulShellRoute five branches
- [ ] member shell
- [ ] trainer shell
- [ ] admin shell
- [ ] responsive navigation
- [ ] deep links
- [ ] capability redirects
- [ ] nested-stack preservation
- [ ] unknown routes
- [ ] unsaved-form guards

<!-- ==================== FILE: 03-people-profile.md ==================== -->
# FILE: 03-people-profile.md
## People & Profile
- [ ] member directory
- [ ] member dossier
- [ ] trainer directory
- [ ] employee directory
- [ ] profile edit
- [ ] trainer assignment
- [ ] health
- [ ] medical history
- [ ] emergency contacts
- [ ] documents
- [ ] photos/avatar
- [ ] role-specific visibility
- [ ] upload retry/cancel
- [ ] role-variant tests

<!-- ==================== FILE: 04-membership.md ==================== -->
# FILE: 04-membership.md
## Membership
- [ ] membership card/detail/history
- [ ] package catalogue
- [ ] package CRUD
- [ ] membership directory
- [ ] freeze request/history
- [ ] approve/reject
- [ ] extension
- [ ] renew
- [ ] upgrade
- [ ] cancel
- [ ] row-version conflicts
- [ ] role pricing visibility

<!-- ==================== FILE: 05-scheduling.md ==================== -->
# FILE: 05-scheduling.md
## Scheduling
- [ ] calendar queries
- [ ] schedule detail/roster
- [ ] schedule types
- [ ] facilities
- [ ] trainer availability
- [ ] open slots
- [ ] PT booking
- [ ] class booking
- [ ] recurring series
- [ ] cancel/reschedule
- [ ] waitlist
- [ ] trainer start/complete
- [ ] double-submit protection

<!-- ==================== FILE: 06-attendance.md ==================== -->
# FILE: 06-attendance.md
## Attendance
- [ ] digital pass
- [ ] QR presentation
- [ ] check-in/out
- [ ] history
- [ ] summary/streak/heatmap
- [ ] session attendance
- [ ] admin live feed
- [ ] manual override
- [ ] idempotency keys
- [ ] camera/permission errors

<!-- ==================== FILE: 07-payments.md ==================== -->
# FILE: 07-payments.md
## Payments & POS
- [ ] member ledger
- [ ] admin ledger
- [ ] outstanding dues
- [ ] payment detail
- [ ] payment methods
- [ ] POS
- [ ] discounts
- [ ] split tender
- [ ] idempotent submission
- [ ] refund/adjustment
- [ ] receipt
- [ ] financial integration tests

<!-- ==================== FILE: 08-workout.md ==================== -->
# FILE: 08-workout.md
## Workout
- [ ] plan list/detail
- [ ] plan builder
- [ ] exercise picker
- [ ] ordering
- [ ] publish/archive
- [ ] template copy
- [ ] versions
- [ ] live session
- [ ] set logging
- [ ] rest timer
- [ ] completion
- [ ] history
- [ ] volume/PR
- [ ] role variants

<!-- ==================== FILE: 09-diet.md ==================== -->
# FILE: 09-diet.md
## Diet
- [ ] plan list/detail
- [ ] builder
- [ ] meal builder
- [ ] food picker
- [ ] macro display
- [ ] versions/templates
- [ ] assignment
- [ ] daily log
- [ ] adherence
- [ ] water
- [ ] trainer review
- [ ] verified-food visibility

<!-- ==================== FILE: 10-goals-progress.md ==================== -->
# FILE: 10-goals-progress.md
## Goals & Progress
- [ ] metrics
- [ ] goals
- [ ] check-ins
- [ ] measurements
- [ ] charts
- [ ] mandatory metrics
- [ ] progress photos
- [ ] comparison
- [ ] privacy
- [ ] notes
- [ ] trainer assessments
- [ ] server-derived achievement

<!-- ==================== FILE: 11-notifications.md ==================== -->
# FILE: 11-notifications.md
## Notifications
- [ ] inbox
- [ ] detail/deep links
- [ ] unread
- [ ] read actions
- [ ] device registration
- [ ] token rotation
- [ ] logout unregister
- [ ] push handling
- [ ] admin broadcast
- [ ] trainer broadcast
- [ ] history

<!-- ==================== FILE: 12-dashboard.md ==================== -->
# FILE: 12-dashboard.md
## Dashboard
- [ ] adaptive shell
- [ ] member widgets
- [ ] trainer widgets
- [ ] admin widgets
- [ ] section loading
- [ ] permission omission
- [ ] skeletons
- [ ] refresh
- [ ] cache-last-successful where useful
- [ ] rebuild optimization

<!-- ==================== FILE: 13-reports.md ==================== -->
# FILE: 13-reports.md
## Reports
- [ ] report navigation
- [ ] filters
- [ ] date ranges
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
- [ ] signed upload
- [ ] upload progress
- [ ] retry/cancel
- [ ] signed download
- [ ] parent access checks
- [ ] MIME/size handling
- [ ] image compression/thumbnails
- [ ] document preview
- [ ] expired URL recovery

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
- [ ] push config
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
- [ ] Foundation
- [ ] Auth
- [ ] Navigation
- [ ] People
- [ ] Membership
- [ ] Scheduling
- [ ] Attendance
- [ ] Payments
- [ ] Workout
- [ ] Diet
- [ ] Goals/Progress
- [ ] Notifications
- [ ] Dashboard
- [ ] Reports
- [ ] Settings/RBAC
- [ ] Media
- [ ] API contract
- [ ] role-variant tests
- [ ] integration tests
- [ ] release builds
