# Build Prompt: LuxeKnox — Immersive Luxury Gym Website

## Role

You are a senior creative developer, interaction designer, and frontend engineer specializing in premium, cinematic websites.

Build a **high-end, immersive website for "LuxeKnox"**, a luxury gym and private fitness club.

The website must make aggressive use of the capabilities of the installed **ScrollCraft** skill/library:

https://github.com/nateherkai/scroll-craft

Do not treat ScrollCraft as a simple scroll-animation utility.

Use it as the **core interaction and storytelling system** of the website.

The final experience should feel closer to a luxury automotive, fashion, architecture, or premium hospitality website than a conventional gym website.

---

# 1. Core Objective

Create a website where the visitor feels like they are **entering the LuxeKnox world** rather than browsing a gym website.

The experience should communicate:

- Luxury
- Exclusivity
- Precision
- Strength
- Discipline
- Transformation
- Premium facilities
- Personal attention
- Performance
- Confidence
- Privacy

The website should tell a visual story as the user scrolls.

Every major scroll movement should feel intentional.

Avoid generic:

- fade-in animations
- slide-up animations
- card animations
- excessive bouncing
- generic parallax
- template-like sections

Instead, create **cinematic scroll choreography**.

---

# 2. First: Study ScrollCraft Thoroughly

Before implementing the website:

1. Inspect the complete ScrollCraft repository.
2. Understand its architecture.
3. Identify every meaningful capability it provides.
4. Identify:
   - scroll-driven animations
   - timelines
   - pinning
   - transforms
   - interpolation
   - easing
   - sequencing
   - scrub behavior
   - progress-driven animations
   - callbacks
   - nested timelines
   - responsive behavior
   - performance mechanisms
   - lifecycle management
   - cleanup mechanisms
5. Inspect examples and demos in the repository.
6. Determine which capabilities can be combined to create sophisticated storytelling.

Do not invent APIs.

Use the actual ScrollCraft API exposed by the installed version.

If the repository contains examples, use them as the primary reference for implementation patterns.

---

# 3. Design Philosophy

The site should follow this principle:

> **Scroll is the user's timeline through the LuxeKnox experience.**

The visitor should feel that their scroll controls the camera.

Think in terms of:

**Scroll → Camera → Scene → Motion → Transformation → Story**

rather than:

**Scroll → Section → Animation**

---

# 4. Visual Direction

Use a sophisticated luxury aesthetic.

Suggested visual language:

### Base

- Deep black / charcoal
- Warm off-white
- Subtle metallic tones
- Muted bronze/champagne accents
- High contrast typography
- Large negative space

Do not make the site look like a typical "black and gold gym".

The luxury should come from:

- composition
- typography
- photography
- spacing
- motion
- materiality
- restraint

rather than excessive gold gradients.

---

# 5. Typography

Use a premium typography system.

Consider pairing:

### Display font

Elegant high-contrast serif or refined luxury display typeface.

### Supporting font

Modern geometric/swiss-style sans-serif.

Typography should become part of the animation system.

Use:

- oversized headlines
- masked text reveals
- character/word transitions where appropriate
- tracking changes
- opacity transitions
- vertical displacement
- scale transitions
- text moving independently from imagery

Example:

```text
DISCIPLINE
IS
LUXURY.
```

The words should not necessarily appear simultaneously.

They may enter sequentially as the visitor scrolls.

---

# 6. Page Architecture

Build one primary immersive landing page.

Structure it approximately as follows:

```text
01 — Cinematic Opening
02 — Brand Introduction
03 — Philosophy
04 — The Club
05 — Training
06 — Personal Performance
07 — Facilities
08 — Transformation
09 — Membership
10 — Final CTA
```

These are storytelling chapters, not conventional website sections.

---

# 7. HERO — "ENTER LUXEKNOX"

The opening should immediately establish that this is not an ordinary gym.

Create a cinematic hero.

Possible composition:

```text
                 LUXEKNOX

             PRIVATE FITNESS CLUB

                 [ENTER]
```

Behind the typography:

- dark architectural gym environment
- dramatic lighting
- subtle atmospheric movement
- athlete silhouette
- premium equipment
- architectural details

### Scroll behavior

When the visitor begins scrolling:

1. Hero typography begins moving.
2. Logo/brand mark subtly scales.
3. Background environment moves at a different rate.
4. Foreground subject moves independently.
5. Camera appears to move deeper into the environment.
6. Hero typography compresses/disappears.
7. The next scene emerges seamlessly.

The transition should feel like **the camera is physically entering the club**.

Do not simply replace the hero with the next section.

---

# 8. BRAND INTRODUCTION

Reveal:

```text
NOT A GYM.

A PRIVATE STANDARD.
```

Use ScrollCraft to choreograph:

- typography
- background
- imagery
- subtle geometric elements

The statement should appear with dramatic timing.

Potential sequence:

```text
NOT
```

then

```text
A GYM.
```

then

```text
A PRIVATE STANDARD.
```

The animation should be driven by scroll progress.

---

# 9. PHILOSOPHY SECTION

Introduce the LuxeKnox philosophy.

Example messaging:

```text
TRAIN WITH INTENTION.

MOVE WITH PURPOSE.

BECOME SOMETHING MORE.
```

Do not use ordinary stacked cards.

Instead create an immersive visual composition.

For example:

- giant typography occupying the viewport
- photography crossing behind typography
- text pinned while imagery moves
- words changing position as scrolling progresses
- subtle camera movement

Use ScrollCraft pinning/sticky capabilities where appropriate.

---

# 10. THE CLUB

Create a cinematic reveal of the physical club.

Show:

- architecture
- entrance
- training floor
- lighting
- equipment
- recovery area
- private spaces

Treat the imagery as one continuous environment.

Possible effect:

The visitor scrolls and the camera travels through the club.

```text
ENTRANCE
   ↓
TRAINING FLOOR
   ↓
PERFORMANCE
   ↓
RECOVERY
   ↓
PRIVATE SPACE
```

Avoid abrupt image-to-image transitions.

Use overlapping scenes and scroll-driven movement.

---

# 11. TRAINING EXPERIENCE

Create a high-energy but sophisticated sequence.

Headline:

```text
TRAIN HARD.

TRAIN SMART.
```

Introduce different training disciplines:

- Strength
- Conditioning
- Mobility
- Performance
- Recovery

Each discipline should have its own visual identity.

Use scroll progress to transition between them.

For example:

```text
STRENGTH
```

moves away while

```text
PERFORMANCE
```

moves into focus.

Photography can scale, rotate slightly, translate, or clip through masks.

Keep motion controlled and premium.

---

# 12. PERFORMANCE SECTION

Make this one of the most technically impressive sections.

Create an athlete-focused scroll sequence.

Possible composition:

```text
                PERFORMANCE

       01        02        03        04

              ATHLETE IMAGE

        POWER
        SPEED
        CONTROL
```

As the visitor scrolls:

- athlete image moves through the scene
- statistics appear
- typography changes
- numbers animate
- supporting elements move at different speeds
- image cropping changes
- camera framing changes

Example metrics:

```text
98%
CONSISTENCY

4.8X
PERFORMANCE

01:1
COACHING
```

Do not use fake statistics as factual claims.

If real business data is unavailable, use clearly illustrative content or omit numerical claims.

---

# 13. FACILITIES

Showcase premium facilities.

Possible categories:

```text
01 — PERFORMANCE FLOOR
02 — PRIVATE TRAINING
03 — RECOVERY
04 — MOBILITY
05 — LOUNGE
```

Instead of a normal card grid, create a **horizontal or spatial storytelling sequence controlled by vertical scrolling**.

For example:

Vertical scrolling drives:

```text
horizontal camera movement
```

while the page remains pinned.

Each facility enters the viewport like a cinematic shot.

Use ScrollCraft's capabilities wherever appropriate.

---

# 14. IMAGE TRANSITIONS

Create sophisticated image transitions.

Possible techniques:

- clipping
- masking
- scale
- depth movement
- overlapping layers
- controlled blur
- opacity
- perspective
- translation
- image reveal
- image replacement

Do not overuse blur.

Do not use random rotations.

Every transformation should feel intentional.

---

# 15. PARALLAX

Use parallax, but do not make "parallax" the design goal.

The goal is **depth**.

Create multiple visual planes:

```text
BACKGROUND
    ↓
ARCHITECTURE
    ↓
ATMOSPHERE
    ↓
SUBJECT
    ↓
TYPOGRAPHY
    ↓
UI
```

Each plane should respond differently to scroll.

The result should feel like a camera moving through depth.

---

# 16. SCROLL-DRIVEN STORY

Create sections where animation is directly tied to scroll progress.

Conceptually:

```text
0% ─────────────── 100%
```

controls an entire visual sequence.

For example:

```text
0%
Hero visible

20%
Hero moves backward

40%
Typography exits

60%
New image enters

80%
Headline appears

100%
Next chapter established
```

The animation must feel reversible.

If the visitor scrolls upward, the scene should naturally reverse.

Do not create animations that only make sense when moving downward.

---

# 17. PINNED STORYTELLING

Use pinned sections for the most important cinematic sequences.

A section may remain pinned while its internal story progresses.

Example:

```text
┌──────────────────────────────┐
│                              │
│       PERFORMANCE            │
│                              │
│        ATHLETE               │
│                              │
│          01                  │
│                              │
└──────────────────────────────┘
```

While pinned:

```text
01 STRENGTH
     ↓
02 POWER
     ↓
03 SPEED
     ↓
04 RECOVERY
```

The viewport acts as the stage.

---

# 18. TRANSFORMATION SECTION

Create an emotional section about transformation.

Avoid generic before/after gym marketing.

Instead communicate:

```text
THE BODY CHANGES.

THE STANDARD DOESN'T.
```

Use an elegant transition between two visual states.

Potential animation:

- image expands
- typography separates
- image reveals hidden content
- environment changes
- lighting changes
- final statement locks into place

This should be one of the emotional peaks of the website.

---

# 19. MEMBERSHIP

Membership should feel exclusive.

Headline:

```text
ACCESS IS EARNED.

EXCELLENCE IS EXPECTED.
```

Present membership options elegantly.

Possible structure:

### PRIVATE

Personalized coaching and private access.

### SIGNATURE

Full club experience.

### PERFORMANCE

Advanced performance-focused membership.

Do not make the pricing section look like a SaaS pricing table.

Use restrained typography and premium spacing.

---

# 20. FINAL CTA

End with a dramatic visual payoff.

Example:

```text
READY
TO
RAISE
YOUR
STANDARD?
```

As the user reaches the bottom:

- typography becomes dominant
- background becomes minimal
- logo returns
- CTA appears
- navigation simplifies
- visual noise decreases

Final CTA:

```text
REQUEST MEMBERSHIP
```

Secondary:

```text
BOOK A PRIVATE TOUR
```

---

# 21. NAVIGATION

Create a minimal premium navigation.

Desktop:

```text
LUXEKNOX

THE CLUB
TRAINING
PERFORMANCE
MEMBERSHIP

[REQUEST ACCESS]
```

Navigation should remain visually quiet.

Consider:

- transparent navigation over hero
- subtle background transition when scrolling
- navigation color adapting to background
- smooth anchor transitions

Do not let navigation compete with the cinematic content.

---

# 22. Scroll Progress Indicator

Create a subtle scroll indicator.

It could display:

```text
01 / 10
```

or:

```text
01
────
10
```

The indicator should change based on the current storytelling chapter.

Use ScrollCraft progress information if appropriate.

Keep it extremely subtle.

---

# 23. MICRO-INTERACTIONS

Add high-quality micro-interactions.

Examples:

### Buttons

Normal:

```text
REQUEST ACCESS
```

Hover:

- subtle expansion
- arrow movement
- underline transformation
- background transition

### Images

Hover can create:

- slight scale
- controlled image movement
- typography response

### Cursor

If implementing a custom cursor:

- keep it subtle
- do not make it gimmicky
- allow cursor states for interactive elements

---

# 24. Animation Principles

Follow these rules strictly.

### DO

- Use long cinematic transitions where appropriate.
- Use scroll progress to control complex sequences.
- Use easing intelligently.
- Create depth.
- Layer animations.
- Synchronize typography and imagery.
- Use pinning for storytelling.
- Use motion to establish hierarchy.
- Make animations reversible.
- Maintain spatial continuity.

### DON'T

Do not:

- animate every element
- use random bouncing
- use excessive spring effects
- rotate elements without purpose
- make everything fade in
- use excessive blur
- create distracting effects
- make text unreadable
- sacrifice accessibility for animation

---

# 25. Motion Hierarchy

Establish a clear motion hierarchy.

### Level 1 — Camera

Large-scale movement.

### Level 2 — Environment

Architecture and imagery.

### Level 3 — Subject

Athlete / equipment / focal image.

### Level 4 — Typography

Headlines and supporting copy.

### Level 5 — UI

Buttons, navigation, indicators.

The lower levels should never visually overpower the higher levels.

---

# 26. Responsive Design

The desktop experience may be highly cinematic.

However, mobile must be treated as a **first-class experience**, not a compressed desktop version.

Create separate responsive motion strategies.

Desktop:

```text
large viewport
multiple visual layers
complex choreography
pinned scenes
large typography
```

Mobile:

```text
fewer layers
shorter sequences
simpler transforms
reduced pinning where necessary
optimized imagery
touch-friendly interactions
```

Use ScrollCraft responsibly on mobile.

Never allow animation to cause:

- horizontal overflow
- accidental page locking
- scroll jank
- unusable navigation
- content clipping

---

# 27. Accessibility

Respect:

```css
prefers-reduced-motion
```

When reduced motion is enabled:

- disable cinematic scroll choreography
- preserve content hierarchy
- use simple transitions
- ensure every section remains accessible
- never hide essential content inside animation

The website must remain fully usable without animation.

---

# 28. Performance

Performance is a requirement, not an optional optimization.

Pay particular attention to:

- image sizes
- image formats
- lazy loading
- GPU-heavy effects
- unnecessary DOM nodes
- scroll listeners
- layout thrashing
- forced reflows
- excessive transforms
- animation cleanup
- component lifecycle

Prefer transform/opacity-based animation where possible.

Avoid animating expensive layout properties unnecessarily.

Do not attach unnecessary independent scroll listeners when ScrollCraft already provides an appropriate mechanism.

---

# 29. Architecture

Keep the implementation maintainable.

Separate:

```text
components/
sections/
animations/
assets/
styles/
utils/
```

Animation logic should not become scattered throughout components.

Prefer reusable abstractions such as:

```text
ScrollScene
ScrollTextReveal
ScrollImageReveal
PinnedScene
ParallaxLayer
ChapterIndicator
```

Only create abstractions where they genuinely simplify the code.

Do not over-engineer.

---

# 30. Animation Configuration

Where practical, keep animation parameters centralized.

For example:

```js
const motionConfig = {
  hero: {
    duration: ...,
    intensity: ...,
  },

  typography: {
    revealDistance: ...,
    stagger: ...,
  },

  parallax: {
    background: ...,
    foreground: ...,
  },
};
```

Use actual ScrollCraft concepts/API rather than inventing configuration layers unnecessarily.

The important requirement is that animation tuning should be easy.

---

# 31. Asset Strategy

Use high-quality visual assets.

Required asset categories:

### Hero

- architectural gym image
- athlete image
- atmospheric background

### Training

- strength
- conditioning
- performance

### Facilities

- gym interior
- equipment
- recovery
- lounge

### Brand

- LuxeKnox logo
- wordmark
- icons

Prefer WebP/AVIF where appropriate.

Avoid enormous unoptimized images.

---

# 32. Content Tone

Copy should be:

- short
- confident
- sophisticated
- minimal
- premium
- emotionally powerful

Avoid generic fitness marketing language such as:

> Get fit today!

> Join our amazing gym!

> Burn calories and build muscle!

Instead use language like:

```text
A HIGHER STANDARD OF TRAINING.

PRECISION OVER NOISE.

PRIVATE BY DESIGN.

PERFORMANCE WITHOUT COMPROMISE.
```

Do not overuse dramatic slogans.

Luxury requires restraint.

---

# 33. Storyboard Before Coding

Before implementing the final animations, create a conceptual storyboard.

For each chapter define:

```text
Chapter
Purpose
Starting state
Ending state
Scroll range
Pinned?
Primary visual
Typography movement
Image movement
Background movement
Transition to next chapter
```

Example:

```text
CHAPTER: THE CLUB

START:
Dark architectural image.

0–25%:
Image slowly scales.

25–50%:
Headline enters.

50–75%:
Image shifts laterally.

75–100%:
Next facility enters from depth.

END:
Scene transitions into training floor.
```

Use this storyboard to implement the experience.

---

# 34. Avoid Animation Saturation

The site should have moments of stillness.

This is extremely important.

Luxury websites often feel premium because they know when **not** to move.

Use:

```text
motion
→ stillness
→ motion
→ stillness
→ major cinematic sequence
→ silence
→ CTA
```

Do not animate continuously just because ScrollCraft makes it possible.

---

# 35. Technical Quality Requirements

The final implementation must:

- run without console errors
- have no broken assets
- have no broken routes
- work on modern Chrome
- work on Safari
- work on Firefox
- work on mobile browsers
- respond correctly to resize
- handle rapid scrolling
- handle reverse scrolling
- handle page refresh at different scroll positions
- clean up animation instances correctly
- avoid memory leaks

Test:

```text
slow scrolling
fast scrolling
scrolling backwards
scrolling to bottom rapidly
resizing desktop → mobile
resizing mobile → desktop
reduced motion
touch scrolling
```

---

# 36. Do Not Fake Functionality

If backend functionality does not exist:

Do not pretend that forms actually submit.

Use clearly structured placeholders for:

```text
REQUEST ACCESS
BOOK A TOUR
CONTACT
```

Prepare the UI so a backend can be connected later.

---

# 37. SEO

Even though this is an animation-heavy website, maintain proper SEO.

Include:

- semantic HTML
- title
- meta description
- Open Graph metadata
- meaningful headings
- image alt text
- accessible navigation
- crawlable content

Do not put important content exclusively inside canvas/WebGL.

---

# 38. Final Experience Target

The final result should feel like:

**Luxury automotive website + private members club + high-performance training laboratory + architectural portfolio.**

It should NOT feel like:

**WordPress gym template + animations.**

The first 10 seconds should communicate:

> "This place is different."

The first major scroll should communicate:

> "This website is different."

By the end:

> "I want access."

---

# 39. Implementation Process

Work in this order.

### Phase 1 — Investigation

Inspect ScrollCraft thoroughly.

### Phase 2 — Architecture

Create the application structure.

### Phase 3 — Visual Foundation

Implement:

- typography
- colors
- spacing
- navigation
- base layout
- responsive foundations

### Phase 4 — Hero

Build the cinematic hero completely.

### Phase 5 — Scroll System

Implement the shared ScrollCraft architecture.

### Phase 6 — Story Chapters

Implement each chapter one at a time.

### Phase 7 — Transitions

Connect chapters into a continuous experience.

### Phase 8 — Responsive Motion

Create mobile-specific animation behavior.

### Phase 9 — Accessibility

Implement reduced-motion behavior and keyboard accessibility.

### Phase 10 — Performance

Optimize assets and animation workload.

### Phase 11 — QA

Test all scrolling and responsive scenarios.

### Phase 12 — Final Polish

Tune:

- timing
- easing
- spacing
- typography
- image cropping
- transitions
- visual hierarchy

---

# 40. Critical Instruction

Do not rush directly into writing components.

First understand the ScrollCraft library.

Then design the scroll choreography.

Then implement.

The quality of this project depends more on **interaction choreography and visual continuity** than on the number of animations.

Use ScrollCraft to its fullest meaningful capability, but do not add an effect merely because the library supports it.

Every animation must have a reason.

Every transition must contribute to the story.

Every section should feel like part of the same physical world.

The finished site should feel **cinematic, premium, restrained, immersive, and technically exceptional**.