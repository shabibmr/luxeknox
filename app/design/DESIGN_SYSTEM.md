# LuxeKnox design system: Eccentric Pulse

Status: **draft, mock-validated, not yet in Flutter.** The values below come from the reference mock at `design/mockups/eccentric-pulse/`, which is the source of truth until `lib/core/theme/` catches up. Intent and screen plans live in `app-redesign.md`. This file is the spec.

Last reviewed: 2026-10-11

---

## 1. Principles

1. **One accent.** Oxblood `#5A0000` (from `assets/logo/luxeknox_logo.png`) is the only brand hue. Every neutral is tinted toward it, and no second accent exists. Status colors are muted, so they never compete with the brand.
2. **Numbers carry the hierarchy.** Each screen has one hero figure in Fraunces, such as the membership days left or a day's set count. Everything else is quieter Outfit text.
3. **Nia marks the hero.** A small breathing ring sits on the edge of each screen's one most important surface. If a screen has no hero, it has no Nia.
4. **Sparse text.** Sentence case, no exclamation marks, no filler. Lead with the noun, keep verbs on buttons.
5. **Edit in place.** Prefer inline edits and bottom sheets to new routes and dialogs. A destructive action happens immediately and offers Undo, rather than asking first.
6. **Calm motion.** Animate only transform and opacity. Reduced motion freezes everything, including Nia.

---

## 2. Color tokens

Each token has a light value and a dark value. In CSS the dark set applies under `prefers-color-scheme: dark` (unless `data-theme="light"`) and under `[data-theme="dark"]`.

### 2.1 Brand

| Token | Light | Dark | Use |
|---|---|---|---|
| `brand` | `#5A0000` | `#D2665D` | Nia ring, focus ring, meter fill, selected pick outline |
| `brand-btn` | `#5A0000` | `#7E1C17` | Filled button, selected day tab, switch on |
| `brand-btn-hover` | `#741010` | `#8F251F` | Filled button hover |
| `brand-ink` | `#6E0C0C` | `#E88F85` | Brand-colored text and icons: text buttons, ordinals, selected nav icon |
| `on-brand` | `#FFF4F1` | `#FFF1EE` | Text on `brand-btn` |
| `brand-soft` | `rgba(90,0,0,.09)` → **proposed .14** | `rgba(210,102,93,.17)` | Tonal button, selected nav pill, selected pick |
| `brand-soft-hover` | `rgba(90,0,0,.14)` | — | Tonal hover (becomes .19 if brand-soft moves to .14) |
| `brand-wash` | `rgba(90,0,0,.055)` | — | Radial wash in the hero corner |
| `brand-shadow` | `rgba(90,0,0,.55)` | `rgba(0,0,0,.7)` | Glow under the selected day tab |

> The dark `brand` is lifted to `#D2665D` because `#5A0000` on near-black is 1.3:1. Dark buttons stay deep (`#7E1C17`) so they read as oxblood rather than tomato.

### 2.2 Neutrals (warm, red-hued)

| Token | Light | Dark | Use |
|---|---|---|---|
| `paper` | `#F4EEEB` | `#161110` | Scaffold background |
| `surface` | `#FBF8F6` | `#201918` | Cards, lists, sheets, nav bar |
| `surface-2` | `#ECE3DF` | `#2C2321` | Field fill, row lead tiles, skeleton, meter track |
| `line` | `#E2D6D1` | `#382D2B` | Hairline dividers |
| `line-strong` | `#CDBDB7` | `#4D3F3C` | Outline button, dashed add, switch track (off) |
| `ink` | `#2A1C1A` | `#F3E9E6` | Primary text |
| `ink-2` | `#6B5753` | `#BCA8A3` | Secondary text, labels |
| `ink-3` | `#98837E` → **fix `#7A6661`** | `#88746F` → **fix `#96827D`** | Tertiary text, trailing chevrons, placeholder |
| `hover` | `rgba(90,20,15,.05)` | `rgba(245,215,208,.05)` | Hover overlay |
| `press` | `rgba(90,20,15,.09)` | `rgba(245,215,208,.09)` | Pressed overlay |
| `inverse` | `#2D201E` | `#EFE4E0` | Toast background |
| `on-inverse` | `#F5ECE9` | `#201918` | Toast text |
| `brand-on-inverse` | `#F0A196` | — | Toast action (Undo) |

### 2.3 Status

The status palette is muted and warm. Each status has a foreground (`x`) and a background (`x-bg`), always used as a pair.

| Status | Meaning | Light fg / bg | Dark fg / bg |
|---|---|---|---|
| `ok` | Active, paid, done | `#56743F` → **fix `#4C6936`** / `#E2E6D2` | `#A2BC8A` / `#28301F` |
| `due` | Expiring soon, balance owed, caution note | `#93682A` → **fix `#7F5A1C`** / `#F2E6CF` | `#D9AD62` / `#352A17` |
| `bad` | Expired, error, destructive | `#A23A2C` / `#F4DCD5` | `#E59A6F` / `#3C211C` |
| `draft` | Draft, not started, inactive | `#5E6C72` → **fix `#525F65`** / `#E3E2DF` | `#A2B1B7` / `#262B2C` |

Rules:
- Status color never appears without a text label. The 6px square dot in a chip is decoration, not the signal.
- `bad` doubles as `ColorScheme.error`. In dark mode it shifts toward orange so it can't be mistaken for brand text.

### 2.4 Elevation (tinted shadows)

| Token | Light | Dark |
|---|---|---|
| `shadow-sm` | `0 1px 2px rgba(70,18,12,.07), 0 2px 8px -4px rgba(70,18,12,.14)` | `0 1px 2px rgba(0,0,0,.35)` |
| `shadow` | `0 1px 2px rgba(70,18,12,.08), 0 12px 28px -14px rgba(70,18,12,.32)` | `0 1px 2px rgba(0,0,0,.4), 0 12px 28px -14px rgba(0,0,0,.7)` |

There are only two levels. `shadow-sm` is for resting surfaces, and `shadow` is for the hero and an opened exercise card. Sheets and toasts carry their own heavier shadow (see components). In Flutter, set `elevation: 0` and use a `BoxShadow` list from the extension. Don't use M3 tonal elevation, because `surfaceTint` would wash the cards pink.

---

## 3. Typography

There are two families, bundled under `assets/fonts/`:
- **Fraunces** (variable, `opsz` 9–144, weight 400–700) is for **numbers and display headlines only**. Always use tabular, lining figures.
- **Outfit** (variable, weight 300–700) is for all other text.

| Role | Family | Size / line height | Weight | Tracking | Example |
|---|---|---|---|---|---|
| Hero figure | Fraunces, opsz 144 | 76 / 0.82 | 600 | −0.045em | `23` days left |
| Day figure | Fraunces, opsz 144 | 64 / 0.82 | 600 | −0.045em | `18` sets |
| Stat number | Fraunces | 25 / 1.1 | 600 | −0.02em | `₹2,450` |
| State headline | Fraunces | 24 / 1.15 | 600 | −0.015em | "Couldn't load member" |
| Inline number | Fraunces | 22 / 1 | 600 | — | `8` weeks |
| Ordinal | Fraunces | 17 / 1 | 600 | — | Exercise `3` |
| Identity name | Outfit | 22 / 1.2, max 2 lines | 600 | −0.015em | Member name |
| Sheet title | Outfit | 18 | 600 | −0.01em | "Add exercise" |
| Section heading | Outfit | 16 | 600 | −0.005em | "Personal training" |
| Body / row title / button | Outfit | 15 | 500 (row), 600 (button) | — | |
| Body small | Outfit | 14 | 400–500 | — | Facts, note, toast |
| Secondary | Outfit | 13 | 400–500 | — | Row subtitle, field label |
| Chip / stat label | Outfit | 12.5 | 600 / 400 | +0.01em | `Active` |
| Nav label / day count | Outfit | 12 | 500 | — | |

Tidy-up for Flutter: the mock also uses 13.5 and 14.5. Fold 13.5 into 13 and 14.5 into 15, which leaves seven Outfit sizes.

### 3.1 Flutter `TextTheme` mapping

| `TextTheme` slot | Role |
|---|---|
| `displayLarge` | Hero figure, Fraunces 76 |
| `displayMedium` | Day figure, Fraunces 64 |
| `headlineSmall` | State headline, Fraunces 24 |
| `titleLarge` | Identity name, Outfit 22 |
| `titleMedium` | Sheet title, Outfit 18 |
| `titleSmall` | Section heading, Outfit 16 |
| `bodyLarge` | Body and row title, Outfit 15 |
| `bodyMedium` | Body small, Outfit 14 |
| `bodySmall` | Secondary, Outfit 13 |
| `labelLarge` | Button, Outfit 15 / 600 |
| `labelMedium` | Chip, Outfit 12.5 / 600 |
| `labelSmall` | Nav label, Outfit 12 / 500 |

The stat (25), inline (22) and ordinal (17) numbers go in an `AppNumerals` `ThemeExtension`, not in `TextTheme`. Every Fraunces style sets `fontFeatures: [FontFeature.tabularFigures(), FontFeature.liningFigures()]` and `fontVariations: [FontVariation('opsz', …)]`.

---

## 4. Spacing, radius, layout

### 4.1 Spacing (4pt base)

| Token | Value | Use |
|---|---|---|
| `space-1` | 4 | Icon-to-label gap |
| `space-2` | 8 | Chip gaps, exercise list gap, button icon gap |
| `space-3` | 12 | Row gap, hero inner gaps |
| `space-3.5` | 14 | **Inner surface padding** (card, sheet body, note) |
| `space-4` | 16 | **Screen gutter**, sheet side padding |
| `space-7` | 28 | **Block gap** between sections |

Odd values in the mock (6, 9, 10, 18) are optical nudges inside components. They aren't tokens, so don't reuse them for layout.

### 4.2 Radius

| Token | Value | Use |
|---|---|---|
| `r-chip` | 8 | Status chip |
| `r-tile` | 11 | Row lead tile, small button |
| `r-field` | 12 | Input, nav item hit area |
| `r-control` | 14 | Button, note, day tab, toast |
| `r-surface` | 16 | Card, list, exercise card |
| `r-hero` | 20 | Hero, empty state |
| `r-sheet` | 26 (top corners) | Bottom sheet |
| `r-full` | 999 | Switch, nav pill, pick chip |

`r-tile` and `r-control` are present in the mock but missing from `app-redesign.md`. Add them there.

### 4.3 Layout

- **Phone baseline is 360dp. 320dp is the overflow test width**, and every screen must survive it without clipping primary actions.
- Breakpoints follow `AdaptiveShell`: compact under 600, medium from 600 to 1239, expanded at 1240 and above. This spec covers compact. On medium and expanded the same components sit in a max-width 560 column.
- Touch targets are 44×44 minimum, 48 for primary buttons and fields.
- The bottom nav is 80 tall (including 18 of safe-area padding), with a 56×30 pill around the icon. Labels come from `ShellStrings` and ellipsize. They never wrap.

---

## 5. Motion

| Token | Value | Use |
|---|---|---|
| `dur-press` | 120ms | Press scale to 0.98 (stepper 0.94, pick 0.97) |
| `dur-state` | 200ms | Background and color changes |
| `dur-enter` | 240ms | Entry rise of 8px plus fade, toast, chevron rotate |
| `stagger` | 40ms × index | Entry stagger, capped at 8 items |
| `dur-sheet` | 320ms | Sheet slide |
| `ease-out` | `cubic-bezier(.2,.75,.25,1)` | Entries |
| `ease-sheet` | `cubic-bezier(.2,.85,.2,1)` | Sheets |
| `nia-breathe` | 4s ease-in-out, scale .94 ↔ 1 | Nia at rest |
| `nia-tight` | 3s, stroke 3 → 3.8 | Nia in attention states |
| `skeleton` | 1.4s shimmer | Loading |

Flutter: `Cubic(0.2, 0.75, 0.25, 1)` and `Cubic(0.2, 0.85, 0.2, 1)`. Gate every animation on `MediaQuery.disableAnimationsOf(context)`. When it is true, use a duration of zero, keep Nia static at scale 1, and replace the skeleton shimmer with a flat `surface-2` block.

Only transform and opacity animate. The one exception is a background-color crossfade on state changes, which is cheap and needs no layout.

---

## 6. Nia

Nia is the brand's presence mark: an unfilled ring that "breathes."

| Property | Value |
|---|---|
| Size | 28dp box, circle r=10, stroke 3 |
| Color | `brand` |
| Placement | Top-left of the hero, overlapping its top edge by 8dp, inset 18dp from the left |
| Rest | `nia-breathe`, a 4s cycle between scale 0.94 and 1.0 |
| Tight | `nia-tight`, a 3s cycle with stroke 3.8 and r 9.5. Use it for error, unsaved-changes and expiring states. |
| Reduced motion | Static at scale 1 |
| Semantics | Decorative (`ExcludeSemantics`), or a label naming the hero's state if the hero has none |

Rules: at most one Nia per screen, never in lists, and never as a loading spinner. Use `AppLoading` for loading.

Open question: should Nia become the dot in the logo? See §11.

---

## 7. Components

Each entry gives the anatomy, variants, states, accessibility, and the Flutter mapping. "Mock" refers to the class in `styles.css`.

### 7.1 Button (mock `.btn`)

- **Variants:**
  - filled: `brand-btn` background with `on-brand` text. Use **one per screen**.
  - tonal: `brand-soft` background with `brand-ink` text.
  - outline: transparent, 1.5 `line-strong` inset, `ink` text.
  - text: `brand-ink`, with a `.danger` form in `bad`.
- **Sizes:** default 48 tall with 20 padding and 15/600 text. Small is 40 tall with 14 padding and 14 text. Block is full width.
- **States:** hover overlay; press scale .98 over 120ms; disabled at opacity .45 with no pointer; loading swaps the label for a 18dp spinner and keeps the width.
- **Accessibility:** minimum target 48×64. An icon-only button has a tooltip and `Semantics(label:)`.
- **Do:** label with a verb ("Start session", "Renew").
- **Don't:**
  - Put two filled buttons on one screen.
  - Use brand fill for destructive actions. Use a `bad` text button, followed by an Undo toast.
- **Flutter:** `FilledButton`, `FilledButton.tonal`, `OutlinedButton` and `TextButton`, themed via `filledButtonTheme` and its siblings with `StadiumBorder` replaced by `RoundedRectangleBorder(14)`.

### 7.2 Status chip (mock `.chip`, Flutter `AppStatusChip`)

- **Anatomy:** 26 tall, padding 9, radius 8, a 6×6 dot with radius 2 in `currentColor`, label 12.5/600.
- **Variants:** `ok`, `due`, `bad`, `draft`, and `plain` (no dot, `surface-2` / `ink-2`).
- **Rules:** non-interactive and never wraps. It ellipsizes inside summaries.
- **Flutter change:** `AppStatusChip` currently tints the background with `color.withValues(alpha: .15)`. Change it to take a `StatusTone` enum and read `fg` and `bg` from `AppStatusColors`, because alpha tints fail contrast on warm paper.

### 7.3 Field (mock `.field`, `.input`)

- **Anatomy:** label 13/500 `ink-2` above the field with a 6 gap. The field is filled `surface-2`, radius 12, min height 48, padding 12/14, text 15. The `big` variant has 20/600 text for titles.
- **States:**
  - focus: `surface` fill with a 2px `brand` inset ring.
  - error: 2px `bad` ring, with the message below in 13 `bad`.
  - disabled: opacity .45.
  - placeholder: uses `ink-3`.
- **Accessibility:** the label is always visible, never placeholder-only. The error is announced through `errorText`.
- **Flutter:** `inputDecorationTheme` with `filled: true`, `fillColor: surfaceContainerHighest`, `border: OutlineInputBorder(borderSide: none, radius 12)` and `focusedBorder` set to 2 `primary`. The label goes outside the field (`labelText: null`, wrapped in a `Column`).

### 7.4 Segmented control (mock `.segm`)

- `surface-2` track with 3 padding. The selected segment gets `surface`, `shadow-sm` and weight 600. Use it for 2 to 4 mutually exclusive options, such as gender or units.
- **Flutter:** `SegmentedButton` restyled, or a small custom widget, because M3's outlined look doesn't match.

### 7.5 Stepper (mock `.stepper`)

- 46 tall `surface-2` pill, with 44×44 − and + buttons and a centered tabular value. A button at its bound is disabled (opacity .35).
- It's used for sets, reps, load and weeks. Long-press repeats.
- **Accessibility:** wrap it in `Semantics(value:, increasedValue:, decreasedValue:, onIncrease:, onDecrease:)` so it behaves as an adjustable control.

### 7.6 Switch (mock `.tog`)

- On: `brand-btn` track with an `on-brand` knob scaled to 1.5. Off: `surface-2` track with a `line-strong` outline.
- **Fails non-text contrast when off** (1.72:1). See §10.
- **Flutter:** `switchTheme`. Always pair the switch with a `ListTile`-style text label.

### 7.7 Pick chip (mock `.pick`)

- Rounded-full, outlined filter chip. When selected it gets `brand-soft`, a 1.5 `brand` inset and `brand-ink` 600 text. It has `aria-pressed` semantics.
- Used for muscle filters and rest-time presets. It scrolls horizontally, bleeding to the screen edge.
- **Flutter:** `FilterChip` with `chipTheme`.

### 7.8 List and row (mock `.list`, `.row`)

- **List:** `surface` with radius 16 and `shadow-sm`, clipped. Rows are separated by a 1px `line` hairline.
- **Row:**
  - Min height 62. Lead tile 38×38 with radius 11 on `surface-2`.
  - Title 15/500 and subtitle 13 `ink-2`, both single-line and ellipsized.
  - Trailing chevron in `ink-3`.
- **States:** hover and press overlays.
- **Flutter:** `ListTile` inside a `Card` with `listTileTheme`. `minVerticalPadding` gets the row to 62.

### 7.9 Surface, Hero and under-count (mock `.surface`, `.hero`, `.under`)

- **Surface:** a card with no border, `surface` fill and `shadow-sm`.
- **Hero:**
  - Radius 20 and `shadow`, with a radial `brand-wash` from the top-left.
  - Padding 30/18/16, leaving top room for Nia.
  - Contents: the hero figure, a unit line (15/500 `ink-2`), an optional chip top-right and an optional next line.
- **Under-count:** a 2-column grid of stats below a hairline, each a stat number over a stat label. Use exactly two or none, never three, because three ellipsize at 320.
- **Rule:** one hero per screen.

### 7.10 Note (mock `.note`)

- A caution callout with a `due-bg` fill, `ink` text 14/1.4, a `due` icon and radius 14.
- Use it for safety-relevant facts surfaced from deeper data, such as an injury note. Don't use it for marketing or tips.

### 7.11 Day tabs (mock `.days`, `.day`)

- A horizontal scroller that bleeds to the screen edge with scroll snap.
- **Each tab:** min width 84 and radius 14, with "Day N" at 14.5/600 and a set count at 12 tabular.
- **Selected tab:** `brand-btn` fill, `on-brand` text and a `brand-shadow` glow. Semantics is a `tab` with `selected`.
- **Trailing "+ Day":** an outline tab in `brand-ink`.
- Labels stay "Day N" because the API has no day name.

### 7.12 Exercise card (mock `.ex`)

- **Collapsed:**
  - The ordinal in Fraunces 17 `brand-ink`.
  - The name 15/600.
  - A summary line "4 × 8 · 60 kg · 90s rest" in 13 tabular `ink-2`.
  - A grip icon.
- **Expanded:** the card gets `shadow`. Below a hairline sit 2-column steppers, rest pick chips, and an action row with Up, Down and Move as icon buttons, plus a `bad` Remove pushed right.
- Newly added cards flash a ring for 1.2s, which is skipped under reduced motion.
- **Add exercise:** a 56-tall dashed `line-strong` tile in `brand-ink` that turns to a `brand` border on hover.

### 7.13 Bottom navigation (mock `.nav`)

- `surface` fill with a top hairline. Each item has a 56×30 pill and a 12/500 label.
- The active item gets weight 600 `ink`, with the pill in `brand-soft` and the icon in `brand-ink`.
- **Flutter:** `navigationBarTheme` with `indicatorColor: brandSoft`, height 80, and labels always shown.

### 7.14 Bottom sheet (mock `.sheet`)

- **Shape:** top radius 26, `surface`, max height 88%, a 36×4 grab handle in `line-strong`, and a `rgba(28,16,8,.4)` scrim. It slides up over 320ms with `ease-sheet`.
- **Contents:**
  - A header with an 18/600 title and a close icon button.
  - Optional tools: search and pick chips.
  - A scrolling body and stacked actions, with the filled button on top.
- **Uses:** pickers, confirmations (discard, renew) and moving an item to another day. Replaces `AlertDialog`.
- **Flutter:** `showModalBottomSheet(useSafeArea: true, showDragHandle: true, isScrollControlled: true)` with `bottomSheetTheme`. Focus moves into the sheet and returns to the trigger when it closes.

### 7.15 Toast (mock `.toast`)

- `inverse` fill, `on-inverse` 14/500 text, radius 14 and min height 48. It floats 92 above the bottom, clearing the nav.
- The optional action is a text button in `brand-on-inverse`. It rises in over 240ms.
- Duration is 4s, or 6s with an action. It sits in a polite live region.
- **Flutter:** `SnackBar(behavior: floating)` with `snackBarTheme`.

### 7.16 Skeleton (mock `.sk`)

- `surface-2` blocks with radius 10 and a 1.4s shimmer. Its shape mirrors the loaded layout (identity, hero, rows).
- Use it for first load only. A refresh keeps the old content and shows a top progress bar.
- **Accessibility:** a single `Semantics(label: 'Loading')` covers the whole skeleton.

### 7.17 Empty and error states (Flutter `AppEmptyView`, `AppErrorView`)

- Left-aligned and vertically centered: a 52×52 icon tile with radius 16, a Fraunces 24 headline, an `ink-2` body capped at 32ch, then one button.
- **Error:** the tile is `bad-bg` / `bad`, the action is "Retry", and Nia goes tight if the screen has a hero slot.
- **Empty inline:** inside lists, use the `.empty` card (radius 20, `surface`) with a tonal call to action.

---

## 8. Patterns

| Pattern | Rule |
|---|---|
| **Identity header** | 56 avatar, name (Outfit 22, max 2 lines), ID and trainer in 13.5 `ink-2`, and an overflow menu. Names never truncate to one line. |
| **Hero with under-count** | §7.9. The hero answers "what matters now?" and the under-count answers "what's next?" |
| **Role-gated actions** | Trainers see one filled button ("Start workout session"). Admins see sell, renew and change. Hide what a role can't do rather than disabling it. |
| **Inline edit** | "Edit" swaps the list for fields in place, and the app bar shows Cancel and Save. Unsaved changes go through `UnsavedChangesScope`, which raises a discard sheet. |
| **Picker sheet** | Search plus filter chips, then rows. Tapping a row adds it, closes the sheet, scrolls to the new card and flashes it. |
| **Destructive with Undo** | Remove immediately, then show the toast "Removed Squat · Undo" for 6s. Confirm first only when the action is irreversible server-side. |
| **Required-field save** | Save stays enabled. On tap, focus the first invalid field and show the inline error. Never use a toast for validation. |
| **Loading, error, empty** | Skeleton on first load, `AppErrorView` with Retry, `AppEmptyView` with one action. All three render inside the same scaffold, so navigation stays live. |

---

## 9. Content and voice

- **Sentence case** everywhere, including buttons.
- **Numbers first:** "23 days left", not "Days remaining: 23". Use ₹ with Indian digit grouping (`₹2,450`, `₹1,24,000`).
- **Dates:** "3 Nov 2026". Times: "7:00 AM", with a non-breaking space so "AM" can't wrap alone.
- **Verbs on buttons:** "Renew", "Start session", "Add exercise". Never "OK" or "Submit".
- **Errors:** say what happened and what to do: "Couldn't load member. Check your connection and retry." No codes and no blame.
- **No exclamation marks** and no emoji.
- All copy lives in feature `*_strings.dart` classes (for example `PeopleStrings`). There are no literals in widgets.

---

## 10. Accessibility audit (WCAG 2.2 AA)

Ratios were computed with the WCAG relative-luminance formula on the token hex values.

### 10.1 Passing pairs

| Pair | Light | Dark |
|---|---|---|
| `ink` on `paper` | 14.28 | 15.70 |
| `ink-2` on `surface` | 6.38 | 7.64 |
| `on-brand` on `brand-btn` | 13.57 | 9.23 |
| `brand-ink` on `paper` | 10.62 | 7.75 |
| `brand` (ring, focus) on `paper` | 12.74 | 5.17 |
| `bad` on `bad-bg` | 5.05 | 6.44 |
| Dark status chips (ok / due / draft) | — | 6.59 / 6.76 / 6.49 |
| `ink` on `due-bg` (note) | 13.28 | — |
| Toast text / action | 13.51 / 7.66 | 13.88 |
| `brand-ink` on the nav pill | 9.62 (at .09) / 8.58 (at .14) | 5.77 |

### 10.2 Failures and fixes

| # | Issue | Now | Fix | After |
|---|---|---|---|---|
| A1 | Light `ink-3` used for small text (hero foot, section counts, placeholder) | 3.38 on surface, 3.11 on paper | `#7A6661` | 5.09 / 4.69 |
| A2 | Dark `ink-3` | 3.93 on surface | `#96827D` | 4.77 |
| A3 | Light `ok` chip at 12.5px | 4.16 | `#4C6936` | 4.87 |
| A4 | Light `due` chip at 12.5px | 3.99 | `#7F5A1C` | 5.03 (and 5.87 as the stat color on surface) |
| A5 | Light `draft` chip at 12.5px | 4.20 | `#525F65` | 5.09 |
| A6 | Switch off-state outline (`line-strong` on surface), WCAG 1.4.11 needs 3:1 | 1.72 | Off track outline and knob in `ink-3` (fixed) | ≥ 4.6 |
| A7 | Light `brand-soft` at 9% (`#EDE2E0`) is visually identical to `surface-2` (`#ECE3DF`), so the selected nav pill doesn't read as selected | — | Raise to 14% (`#E4D5D4`) | Icon still 8.58 |
| A8 | Field boundary: `surface-2` fill on `paper` is 1.1:1 | Passes only because every field has a visible label | Keep labels mandatory. Optionally add a 1px `line-strong` bottom indicator. | — |

### 10.3 Other requirements

- **Focus:** a 2px `brand` ring offset by 2 on every interactive element. Never remove it.
- **Targets:** 44×44 minimum, which every component above meets.
- **Text scale:** layouts must hold at 200% (`TextScaler`). The hero figure caps at 1.3× scaling, and rows grow in height and never clip.
- **Semantics:**
  - Day tabs use `tab` and `selected`.
  - Steppers are adjustable.
  - Chips are read as "Status: Active".
  - Nia is excluded from semantics.
- **Motion:** honour `disableAnimations` (§5).
- **Color is never the only signal**: status always has a label, and errors always have text.

---

## 11. Flutter implementation map

```
lib/core/theme/
  app_colors.dart        // raw tokens (light/dark) — §2
  app_theme.dart         // ThemeData from tokens (replace 0xFF1B1B1B seed)
  app_status_colors.dart // ThemeExtension<AppStatusColors> ok/due/bad/draft + bg
  app_numerals.dart      // ThemeExtension<AppNumerals> stat/inline/ordinal styles
  app_shadows.dart       // ThemeExtension<AppShadows> sm / md
  app_motion.dart        // durations + curves, reduced-motion helper
lib/core/widgets/
  nia.dart               // §6
  app_status_chip.dart   // switch to StatusTone enum
  app_hero.dart, app_stepper.dart, app_day_tabs.dart, app_sheet.dart
```

`ColorScheme`, built by hand with **no `fromSeed`**:

| Slot | Light | Dark |
|---|---|---|
| `primary` | `brand` `#5A0000` | `#D2665D` |
| `onPrimary` | `on-brand` | `on-brand` |
| `primaryContainer` | `brand-soft` (solid `#E4D5D4`) | `#3E2624` |
| `onPrimaryContainer` | `brand-ink` | `brand-ink` |
| `surface` | `paper` | `paper` |
| `surfaceContainerLow` | `surface` (cards) | `surface` |
| `surfaceContainerHighest` | `surface-2` | `surface-2` |
| `onSurface` / `onSurfaceVariant` | `ink` / `ink-2` | `ink` / `ink-2` |
| `outlineVariant` / `outline` | `line` / `line-strong` | same |
| `error` / `onError` / `errorContainer` | `bad` / white / `bad-bg` | `bad` / `paper` / `bad-bg` |
| `inverseSurface` / `onInverseSurface` / `inversePrimary` | `inverse` / `on-inverse` / `brand-on-inverse` | same |
| `surfaceTint` | `transparent` | `transparent` |

In dark mode, filled buttons use `brand-btn` (`#7E1C17`) through `filledButtonTheme`, not `primary`, because `primary` is the lifted `#D2665D` meant for rings and accents.

---

## 12. Open questions

1. **Brand-soft at 14%?** Fixing A7 is recommended. It also deepens tonal buttons and pick chips.
2. **Should Nia become the logo's dot?** That would tie the mark to the brand, but it needs a logo redraw.
3. **`app-redesign.md` still specifies copper.** Update its color section to these oxblood tokens so the plan and spec agree.
4. **At 320dp, the "Memberships" nav label ellipsizes.** Either shorten it in `ShellStrings` to "Plans" or accept the ellipsis.
5. **The builder app bar is crowded** at 320 with Back, title, Preview and Save. Consider moving Preview into the overflow menu.
6. **Font size tidy-up:** dropping 13.5 and 14.5 (§3) needs a quick visual pass in the mock.

---

## Changelog

| Date | Change |
|---|---|
| 2026-10-11 | First version, documented from the Eccentric Pulse mock (oxblood revision) and including the contrast audit. |
