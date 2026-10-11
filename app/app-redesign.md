# Eccentric Pulse — LuxeKnox redesign

## Goal

Give LuxeKnox one living character and one visual system, inherited by member, trainer, and admin, without changing routes, blocs, or the API.

## Character

**Nia** is the count between reps. She is not a mascot and not a chat bubble. She is a 28dp copper ring that breathes, a short voice in empty states, and a press on every tappable surface.

Three postures, one mark:

- **Member.** The ring is personal. It sits on Home beside days left on the membership and today's session. Idle breath is slow (4s).
- **Trainer.** The ring tightens when someone on the roster has a session today. Empty voice: "No one on your list yet."
- **Admin.** The ring is the floor. Its breath speeds with live occupancy on the dashboard. Empty voice: "The floor is steady."

She never says "elevate", "seamless", or "unleash". She uses counts, names, and one plain sentence.

## Movement — Eccentric Pulse

The eccentric is the lowering phase of a lift: the controlled return, the breath, the pause that makes the next rep possible. People who train will feel it. Everyone else gets a warm, paced gym floor.

**Space and form.** Phone layout stays a single column. The hero number sits left, large, with the next fact tucked under it, not a row of three equal cards. Nia's ring overlaps the top of the first surface by 8dp, the way a hand rests on a bar before the rep. Inner chips use a 8dp radius. The day's hero uses 20dp. Containers stay softer than the controls inside them.

**Color and material.** One brand accent: oxidized copper `#C46A45` (saturation kept moderate). Light surfaces are warm paper `#F4EFE8`. Dark surfaces are warm charcoal `#161311`, never pure black. Every gray is tinted with that same copper-brown. Shadows use the surface hue, light from the upper left. Status (active, due, frozen) keeps a meaning but shifts warm and dull so it belongs to the same stone. No second brand color. No purple gradient.

**Scale and rhythm.** Fraunces draws the big count (days, kg, rupees, people on the floor). Outfit draws labels and body. Numbers use `FontFeature.tabularFigures()`. Display type is tight and heavy. Labels are small, sentence case, with a little positive tracking. Motion is a four-count: 120ms press to scale 0.98, 240ms surface entry (8dp translate plus fade, staggered 40ms), 4s idle breath on Nia. Only `transform` and `opacity`. `MediaQuery.disableAnimations` freezes Nia on the expanded frame.

**Composition and balance.** Member Home reads as a session: one number, the trainer's name, then the agenda. Trainer Home puts one person in the light (the next session) and lets the rest of the roster sit quieter beneath. Admin Home is denser but uses the same copper and the same ring; occupancy is the hero, dues and alerts are the under-count. Asymmetry is the offset ring and the left-weighted number, not a broken grid that fights the `AdaptiveShell`.

**Hierarchy.** Scale carries rank. A 40sp Fraunces figure outranks a `titleMedium` card title. Navigation labels stay the existing `ShellStrings` (`Home`, `Membership`, `Schedule`, `Progress`, `Profile` for members; `Members`, `Plans` for trainers; `Dashboard`, `Memberships`, `Payments`, `More` for admin). The selected destination is a copper pill, not a second icon family.

**Craft.** Optical alignment on the rail and the bar. 320dp-wide phones must not grow yellow overflow stripes. Long exercise names, food names, and member names ellipsize inside `Flexible` or `Expanded`. This is master-level execution: every constraint negotiated, every baseline checked at phone, tablet, and expanded rail.

Text stays sparse. The number is the sentence. The label only anchors it.

## What stays

Material 3, `ThemeData` in `lib/core/theme/app_theme.dart`, `AdaptiveShell` (bottom `NavigationBar` under 600dp, compact rail to 1240dp, extended rail after), `go_router` shells, `flutter_bloc`, `AppEmptyView` / `AppErrorView` / `AppLoading`, `fl_chart`. Bundle Fraunces and Outfit under `assets/fonts/` (gym floors are often offline). Do not add `google_fonts`. Do not restyle 86 screens by hand. Theme, shell, login, splash, and the three dashboard sections carry the character. Feature screens inherit type, color, buttons, and chips.

`FilledButton` keeps `minimumSize: Size(64, 48)`. A shrink-wrapped `Row` (Stepper controls) must not see an infinite width.

## Diagnosis (current)

- Seed is `#1B1B1B`. `ColorScheme.fromSeed` produces a gray Material app with outline inputs and default Roboto.
- Homes are equal `Card` stacks (`DashboardMemberSection` is a title plus status text). No display figure, no motion, no role-specific voice.
- Shell destinations are Material icons. Five labels on a phone bar. `Membership` and `Memberships` are the overflow risk at 320dp.
- Empty and error widgets exist and most list screens use them. Their voice is a gray inbox icon and a sentence. Detail screens that still spin should keep using those shared widgets, not a new third pattern.
- `test/layout/layout_overflow_audit_test.dart` already guards exercise rows, food rows, and the filter sheet at 320×640. Dashboards, the shell, and login are not in that audit.

## Layout rules (apply on every task)

- A `ListView`, `GridView`, or `CustomScrollView` inside a `Column` gets an `Expanded`, or the column itself scrolls and the inner list uses `shrinkWrap` only for a short, bounded child.
- A `TextField` or `TextFormField` inside a `Row` gets an `Expanded`.
- A `Row` or `Column` that overflows gets `Expanded` or `Flexible` on the long child, plus `maxLines` and `TextOverflow.ellipsis`.
- `Expanded` and `Flexible` stay direct children of `Row`, `Column`, or `Flex`. `Positioned` stays a direct child of `Stack`.
- Ignore cascading "RenderBox was not laid out". Fix the first unbounded-height or overflow line.
- After each UI edit, hot-reload a debug run. Confirm the red error screen and the yellow-black stripes are gone at 320dp wide.

## Tasks

- [ ] **Tokens.** In `app_theme.dart`, replace the gray seed with copper `#C46A45`, warm paper and warm charcoal surfaces, a Fraunces `displayLarge`/`headlineLarge` and Outfit body, tabular figures on numeric styles, 200ms button animation, pressed overlay. Register both fonts in `pubspec.yaml`. Verify: a widget test pumps `AppTheme.light` and `AppTheme.dark` and expects `colorScheme.primary` copper and `textTheme.displayLarge?.fontFamily` Fraunces.

- [ ] **Nia.** Add `lib/core/widgets/nia_mark.dart`. A ring, 4s `AnimationController` repeat, scale 0.94 to 1.0, `Curves.easeInOut`. If `MediaQuery.disableAnimationsOf(context)` is true, paint the expanded frame and do not tick. Verify: widget test with animations disabled finds `NiaMark` and throws no exception. Place her in the `DashboardScreen` app bar.

- [ ] **Shell.** In `adaptive_shell.dart`, tint the selected `NavigationBar` and `NavigationRail` destination with the copper pill from the theme. Keep the 600 and 1240 breakpoints. Verify: pump `AdaptiveShell` with the member's five destinations at 320×640, 800×600, and 1280×800. `tester.takeException()` is null. If `Membership` stripes, set `NavigationDestinationLabelBehavior.alwaysHide` is not the fix. Shorten only the overflowing label in `ShellStrings` and re-pump.

- [ ] **Member Home.** Rebuild `dashboard_member_section.dart` as one hero: Fraunces days-remaining, status as `AppStatusChip`, assigned trainer name under it, Nia overlapping the top-left by 8dp. Agenda stays in the existing `ListView` in `dashboard_screen.dart`. Do not nest a second vertical `ListView`. Verify: pump the section at 320dp with a long trainer name. No exception. Days figure uses the display style.

- [ ] **Trainer Home.** In `dashboard_trainer_section.dart`, one next-session block in the light (member name, time) and the rest as compact rows. Long names go in `Flexible` with ellipsis. Nia uses the tighter posture when today's count is above zero. Verify: pump at 320dp with a 60-character member name. No `RenderFlex` overflow.

- [ ] **Admin Home.** In `dashboard_admin_section.dart`, occupancy is the Fraunces hero and drives Nia's duration (slower when the floor is empty, faster when it is busy, still between 2s and 4s). Dues and alerts sit in a `Row` of `Expanded` children, not an unbounded row of `Text`. Verify: pump at 320dp with large currency and alert counts. No overflow. Each stat is inside `Expanded`.

- [ ] **Login and splash.** `splash_screen.dart` shows Nia breathing until `SessionCubit` redirects. `login_screen.dart` places Nia top-left and the form beneath, full-width fields (not a `TextField` in an open `Row`). Copy stays the existing auth strings. Verify: login pump at 320×640, keyboard inset simulated with a short view height 480. No unbounded-width input. No overflow.

- [ ] **Shared voice and press.** `AppEmptyView` takes an optional Nia line and uses sentence-case copy passed by the caller (`Rest day. The floor is quiet.` on an empty member agenda). Theme buttons already animate from task 1. `AppLoading` stays the shared spinner. `DashboardSkeleton` keeps its card shapes and adopts paper and copper. Verify: existing `app_empty_view` and dashboard tests pass. Empty agenda shows the new sentence.

- [ ] **Layout audit, last.** Extend `test/layout/layout_overflow_audit_test.dart` to the member, trainer, and admin dashboard sections, `AdaptiveShell` (all three destination sets), and the login form at 320×640. Fix whatever throws using the layout rules above. Run `flutter test test/layout/layout_overflow_audit_test.dart` and `dart analyze lib/core/theme lib/core/widgets lib/features/dashboard lib/features/auth`. Both clean.

## Done when

- [ ] Member, trainer, and admin Home each show Nia and one Fraunces hero, on warm paper (light) and warm charcoal (dark).
- [ ] 320dp width shows no overflow stripes on those homes, the shell, or login.
- [ ] Disabling animations freezes the ring.
- [ ] Routes, cubits, and API calls are unchanged.
- [ ] `flutter test test/layout/layout_overflow_audit_test.dart` passes.

## Notes

- One plan, one system. A second pass can carry Nia into the active-workout screen and the attendance scanner. Do not start that here.
- Semantic status colors stay. They are meaning, not a second brand.
- Five destinations on a phone bar is already the product. The work is making `Membership` fit, not inventing a new information architecture.
