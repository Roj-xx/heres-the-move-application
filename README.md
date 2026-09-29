# Here's the Move

A relationship-support app for men who want practical ways to support their
partner.

The product question the whole app answers is **"What should I do today?"**.

Native Android and iOS. No web target.

---

## App identifiers

These are settled. Changing them after a store submission means a new app in the
store, so treat them as fixed.

| Platform | Identifier | Source of truth |
| --- | --- | --- |
| Android | `com.roj.heres_the_move` | `android/app/build.gradle.kts` (`namespace` + `applicationId`) |
| iOS | `com.roj.heresTheMove` | `ios/Runner.xcodeproj` (`PRODUCT_BUNDLE_IDENTIFIER`) |

Conventions worth keeping:

- Android uses an underscore because Java package segments cannot contain a
  hyphen. iOS has no such restriction, so it uses the camel-case form.
- The Kotlin `MainActivity` lives at
  `android/app/src/main/kotlin/com/roj/heres_the_move/` and its `package`
  declaration must match the Gradle `namespace`.
- The iOS test bundle is `com.roj.heresTheMove.RunnerTests`.
- The user-facing name lives only in the platform config —
  `android:label` and `CFBundleDisplayName` are both `Here’s the Move`. Do not
  hardcode it in Dart.
- Release signing is not configured. The release build type still uses the
  debug key, and no keystore belongs in the repository.

---

## Status

| Milestone | Scope | State |
| --- | --- | --- |
| 0 | Flutter project initialisation | Done |
| 1 | Application foundation | Done |
| 2 | Firebase foundation | In progress — see [Firebase](#firebase) |
| 3+ | Auth, onboarding, cycle, moves, missions, profile | Not started |

**Milestone 1 is a foundation only.** There is no authentication, no Firebase,
no cycle tracking, no moves and no partner data yet. The app launches into an
intentionally minimal shell that exists to prove the design system works.

**Milestone 2 adds infrastructure, not features.** Firebase is initialised and
Firestore rules are deployed, but there is still no sign-in, no user data and no
product UI. The visible app is unchanged from Milestone 1.

---

## Firebase

### What exists

| Piece | State |
| --- | --- |
| Firebase project | `heres-the-move` (number `1048485800134`) |
| Android Firebase app | `com.roj.heres_the_move` |
| iOS Firebase app | `com.roj.heresTheMove` |
| Cloud Firestore API | Enabled |
| `firestore.rules` | Deployed, deny by default |
| `firestore.indexes.json` | Deployed (empty — no collection queries exist yet) |
| Default database | **Not created** — needs billing enabled (see below) |
| App Check | Dependency present, providers unregistered, enforcement **off** |

### Architecture

```text
main()
  └─ FirebaseBootstrap.initialize()   ← once, before any widget exists
  └─ runApp(ProviderScope(child: HereIsTheMoveApp()))
       └─ MaterialApp.router
```

`FirebaseBootstrap` (in `lib/core/firebase/`) owns initialisation. It runs
before `runApp`, so no provider or screen can observe a half-initialised
backend. It is idempotent, and it never swallows a failure: a broken backend
raises an `AppException` whose `message` is user-safe and whose `cause` keeps
the real error for logs.

`firestoreProvider` (in `lib/core/firebase/firebase_providers.dart`) is the only
way to reach `FirebaseFirestore.instance`. Widgets must not call it directly;
later milestones inject it into repositories, which makes those repositories
testable with a fake.

### Regenerating configuration

```sh
flutterfire configure --project=heres-the-move \
  --platforms=android,ios \
  --android-package-name=com.roj.heres_the_move \
  --ios-bundle-id=com.roj.heresTheMove
```

### Security posture

`firestore.rules` is `rules_version = '2'` and **deny by default**. A root
`match /{document=**} { allow read, write: if false; }` catch-all backstops
every path, and each V1 collection is additionally declared with an explicit
`if false` so Milestone 3 only has to flip a condition rather than invent
structure. `test/firebase_test.dart` asserts this posture and fails the build if
any rule is loosened.

Global content (`moves`, `missions`, `messageSuggestions`, `appConfig`) is
intended to stay read-only for clients and is written only by trusted server
code, which bypasses Security Rules.

### Outstanding manual steps

These require the Firebase console or a billing account and **have not been
done**:

1. **Enable billing** on `heres-the-move`, then create the default database in
   `asia-southeast2` (Singapore). The API is enabled and the rules are
   deployed, but `firestore:databases:create` is refused with
   `requires billing to be enabled`. Nothing reads or writes Firestore until
   this is done.
2. **Register the App Check providers** in the console: Play Integrity for
   Android, DeviceCheck (or App Attest) for iOS. Enforce on neither until
   Milestone 3 — enforcement is currently off, so no debug token is needed and
   no build is locked out.
3. **On macOS**, add `ios/Runner/GoogleService-Info.plist` to the Runner target
   in Xcode. Core Firebase does not need it, because initialisation reads
   `DefaultFirebaseOptions` in Dart, but native features (App Check,
   Crashlytics) expect it in the app bundle. The file is committed and correct;
   it is simply not yet a build resource.
4. **Run a real `flutter build ios`** on macOS. This milestone was developed on
   Windows, so iOS is verified statically only.

### Emulator

The Firestore emulator needs a JDK, which this machine does not have, so rules
are validated by deploying them to the real project (the server accepted them)
and by static assertions in `test/firebase_test.dart`. To validate against a
local emulator later, install a JDK and run:

```sh
firebase emulators:start --only firestore
```

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

`test/firebase_test.dart` additionally pins the Firebase wiring: that the
generated options point at `heres-the-move` with the settled Android and iOS
identifiers, that unsupported platforms refuse to start, that a backend failure
becomes a user-safe `AppException`, and that the deployed security rules stay
deny-by-default.

```sh
flutter test
```

---

## License

Application code is proprietary. The bundled Geist typeface is licensed under
the SIL Open Font License 1.1 — see `assets/fonts/Geist-OFL.txt`.
