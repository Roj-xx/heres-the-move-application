# Here's the Move

A relationship-support app for men who want practical ways to support their
partner.

The product question the whole app answers is **"What should I do today?"**.

Native Android and iOS. No web target.

---

## Status

| Milestone | Scope | State |
| --- | --- | --- |
| 0 | Flutter project initialisation | Done |
| 1 | Application foundation | Done |
| 2+ | Auth, onboarding, cycle, moves, missions, profile | Not started |

**Milestone 1 is a foundation only.** There is no authentication, no Firebase,
no cycle tracking, no moves and no partner data yet. The app launches into an
intentionally minimal shell that exists to prove the design system works.

---

## Getting started

```sh
flutter pub get
flutter run
```

Quality gates:

```sh
dart format .
flutter analyze
flutter test
flutter build apk --debug
```

---

## Architecture

Dependencies flow strictly downwards. A layer never reaches past the one below
it, and business logic never lives in a widget.

```text
Flutter widgets (lib/features/**, lib/shared/**)
  ↓
Presentation state (Riverpod providers)
  ↓
Application / domain
  ↓
Repositories (abstract)
  ↓
Services (concrete, platform-facing)
  ↓
Firebase / Platform
```

Only the layers the current milestone needs exist. Directories that no code
occupies yet are **not** created — an empty folder is a promise the repository
does not keep. `lib/core/services/`, `lib/shared/components/` and
`lib/shared/models/` appear when their first real file lands.

```text
lib/
├── main.dart                     Entry point. Widgets binding, orientation, ProviderScope.
├── app/
│   ├── app.dart                  HereIsTheMoveApp — MaterialApp.router, reads router + theme mode.
│   └── bootstrap.dart            Values needed before any provider or theme exists.
├── router/
│   ├── app_router.dart           The single GoRouter. The seam where auth redirects go in later.
│   └── route_paths.dart          Canonical URL map. Documents the planned V1 surface.
├── theme/
│   ├── app_theme.dart            AppTheme.light / AppTheme.dark.
│   ├── app_theme_mode.dart       The single place ThemeMode is decided (defaults to system).
│   └── tokens/                   All design tokens. See below.
├── core/
│   ├── constants/                App identity.
│   ├── errors/                   AppException — the error type the UI is allowed to see.
│   ├── extensions/               BuildContextTheme.
│   └── utils/                    ResponsiveLayout.
├── shared/
│   └── widgets/                  Feature-agnostic primitives: button, card, scaffold, states.
└── features/
    └── foundation/               The Milestone 1 shell and its design-system preview.
```

### Design tokens

Nothing in the UI invents a colour, radius, spacing value, text style or
shadow. Everything comes from `lib/theme/tokens/`:

| Token | Purpose |
| --- | --- |
| `AppPalette` | Raw brand ramp: coral, gold, clay, warm neutrals, charcoal, status. |
| `AppSpacing` | 4pt-based scale: 4, 8, 12, 16, 20, 24, 32, 40, 48. |
| `AppRadii` | Control 10–12, card 16–20, panel 24, pill for progress only. |
| `AppTypography` | The Material 3 type scale in Geist. |
| `AppGradients` | The single brand gradient, reserved for CTAs and hero moments. |
| `AppShadows` | Soft warm elevation, plus the dark-mode glow. |
| `AppMotion` | Durations and curves. |
| `AppBreakpoints` | Width caps and the compact/medium/expanded thresholds. |
| `AppAccessibility` | The 48pt minimum touch target. |

### Visual direction

Clean, warm, playful, practical. Warm coral primary, gold for reward and XP
surfaces, warm off-white light mode, deep charcoal dark mode. Solid surfaces
with borders and soft shadows by default; gradients only where the design
direction calls for one.

### Typography

**Geist**, bundled under `assets/fonts/` (SIL OFL-1.1) at weights 400, 500,
600 and 700. Bundling rather than fetching at runtime keeps text correct
offline, in tests and on first launch.

---

## Testing

`flutter_test` only. The suite covers the foundation rather than screenshots:
app root, routing, both themes, token values, WCAG contrast floors, the
reusable primitives, and the shell at phone, tablet, short-screen and
large-text sizes.

```sh
flutter test
```

---

## License

Application code is proprietary. The bundled Geist typeface is licensed under
the SIL Open Font License 1.1 — see `assets/fonts/Geist-OFL.txt`.
