## Navigation & Shell

Five top-level destinations per role via `StatefulShellRoute.indexedStack` +
`AdaptiveShell` (NavigationBar &lt; 600dp, compact NavigationRail 600–1239,
extended rail ≥ 1240). See `docs/screens/navigation-architecture.md`.

- [x] StatefulShellRoute five branches — member / trainer / admin each have
  exactly five `StatefulShellBranch`es; covered by
  `test/core/router/app_router_test.dart` “role shells — five destinations”.
- [x] member shell — Home · Membership · Schedule · Progress · Profile;
  profile hub links + health / emergency / documents wired to people screens.
- [x] trainer shell — Home · Members · Schedule · Plans · Profile; members
  directory/dossier/health wired; Plans tab is a `DestinationHubScreen`.
- [x] admin shell — Dashboard · Members · Memberships · Payments · More;
  More hub overlays `/admin/more` without disposing sibling tab stacks.
- [x] responsive navigation — `AdaptiveShell` + `AdaptiveShellBreakpoints`;
  widget tests in `test/core/widgets/adaptive_shell_test.dart`.
- [x] deep links — `Routes.*ById` builders; unauthenticated deep links land on
  `/login?redirect=…`; authenticated `login?redirect=` restores the intended
  path when in-role. Covered in `app_router_test` / `routes_test`.
- [x] capability redirects — `RouteCapabilities` prefix → slug map checked in
  `appRedirectLogic` after role boundaries; missing slug → role home.
- [x] nested-stack preservation — `StatefulShellRoute.indexedStack` +
  `goBranch(initialLocation: sameTab)`; widget test switches Home ↔ Progress
  and keeps `/progress/goal/:id`.
- [x] unknown routes — `GoRouter.errorBuilder` → `NotFoundScreen`.
- [x] unsaved-form guards — reusable `UnsavedChangesScope` (`PopScope` +
  discard dialog) on exercise / food / membership-product forms.
