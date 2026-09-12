# AGENTS.md

Guidance for AI Agents working in this repository.

## Scope

This is a mixed Xcode + SwiftPM project for a Cantonese input method adopting the Jyutping romanization scheme:

- `Jyutping/`: the SwiftUI reference app for iOS, macOS, and visionOS-compatible app builds
- `Keyboard/`: the iOS/iPadOS keyboard extension
- `InputMethod/`: the macOS InputMethodKit target
- `Modules/`: local Swift packages shared by the app and input targets
- `packaging/`: macOS package resources and installer scripts
- `ci_scripts/` and `.github/workflows/`: CI support

## Formatting and editing rules

Read `.editorconfig` before editing.

Current editor settings are UTF-8, LF line endings, and for Swift files: spaces, indent size 8, tab width 8, trim trailing whitespace, and insert a final newline.

Make narrow, surgical edits and follow the surrounding style instead of reformatting files wholesale.

Do not wrap long single-line code unless necessary. Preserve unrelated worktree changes. Do not commit, revert, or push changes unless the user explicitly asks.

## Localization and translation rules

1. Use Traditional Chinese characters for the `zh-Hans` and `zh-Hans-CN` locales.
2. All `zh-*` locales should generally align their values with the base locale, `yue`.

## Code review rules

- Changes under `Modules/Preparing/Sources/Preparing/Resources/` should usually be excluded from code review unless the user specifically asks to review those resource files.
- Code-signing settings in `Jyutping.xcodeproj/project.pbxproj` are temporarily configured for local development. Do not report those settings as a review finding by themselves unless the user specifically asks about them or they cause a concrete issue within the requested scope.

## What is in the project

The Xcode project contains these targets:

- `Jyutping`
- `JyutpingTests`
- `JyutpingUITests`
- `Keyboard`
- `InputMethod`
- `InputMethodTests`
- `InputMethodUITests`

`xcodebuild -project Jyutping.xcodeproj -list` currently exposes these project schemes:

- `InputMethod`
- `Jyutping`
- `Keyboard`

Use SwiftPM commands for individual packages; do not assume their schemes appear in the project listing.

Under `Modules/`, the local Swift packages are:

1. `CommonExtensions`: shared Foundation-style helpers and extensions
2. `CoreIME`: the core input engine, platform-specific SQLite resource targets, tests, and the `CoreIMEBenchmarks` executable
3. `Linguistics`: Jyutping/IPA and related language helpers
4. `AppDataSource`: searchable reference datasets used by the app
5. `AboutKit`: about/info UI support
6. `Preparing`: a SwiftPM-only build-time executable that generates data used by other modules

## Build requirements and environments

- Local environment verified on 2026-09-12: macOS 27.0, Xcode 27.0, Apple Swift 6.4. Check `swift --version` and `xcodebuild -version` when diagnosing toolchain differences.
- Package manifests use `swift-tools-version: 6.4` and `swiftLanguageModes: [.v6]`.
- Xcode project settings use Swift 6 for the app, keyboard, input method, and project-level settings.
- The `Preparing` package declares macOS 27+ because it is a local database-generation tool.

Targeted platforms:

- iOS/iPadOS 16.0+
- macOS 13+ (Ventura or above)
- The reference app also declares visionOS 1.0+ in the Xcode project; the keyboard and macOS input method have separate platform targets.

## First build step: generate databases

On a clean checkout, generate the packaged databases before building the Xcode project or building/testing the data-dependent packages (`CoreIME` and `AppDataSource`):

```bash
cd Modules/Preparing
swift run -c release
```

Run this command from `Modules/Preparing`: the app database output uses a relative path. Generated SQLite files are ignored by Git. The executable entry point is `Modules/Preparing/Sources/Preparing/Preparing.swift`, which runs `AppDataPreparer.prepare()` and `DatabasePreparer.prepare()` concurrently. It generates these packaged SQLite databases:

- `Modules/CoreIME/Sources/CoreIMEMobileData/Resources/mobile.sqlite3`
- `Modules/CoreIME/Sources/CoreIMEDesktopData/Resources/desktop.sqlite3`
- `Modules/AppDataSource/Sources/AppDataSource/Resources/app.sqlite3`

The mobile CoreIME database contains the complete schema. The desktop database is copied from it and then stripped of 9-key-specific tables, columns, and indexes.

`Modules/CoreIME/Package.swift` selects `CoreIMEMobileData` for iOS and `CoreIMEDesktopData` for macOS. `Engine.prepare()` opens the platform's bundled database; `Engine.prepare(databaseURL:includesNineKeyData:)` supports an explicit database, including the mobile database used by tests and benchmarks on macOS.

For lexicon or schema changes, edit the source resources/generator in `Modules/Preparing/Sources/Preparing/`, regenerate the databases, and validate the affected schema and contents as well as SQLite integrity. Existing generated files can be reused for unrelated source-only changes.

## Runtime architecture

### App target (`Jyutping/`)

- Entry point: `Jyutping/JyutpingApp.swift`
- The app has separate `iOS/` and `macOS/` trees plus shared views/models.
- Code under `Jyutping/iOS/Search`, `Jyutping/macOS/Search`, `Jyutping/iOS/Cantonese`, `Jyutping/macOS/Metro`, `Jyutping/CantoneseMaterials`, and `Jyutping/SharedViews` is the main search/reference UI surface.
- Imports across the app show that it primarily consumes `AppDataSource`, `Linguistics`, `CommonExtensions`, and `AboutKit`.

Useful places:

- `Jyutping/SharedModels/AppMaster.swift`
- `Jyutping/iOS/Home/`
- `Jyutping/iOS/Search/`
- `Jyutping/iOS/Romanization/`
- `Jyutping/iOS/Cantonese/`
- `Jyutping/macOS/Search/`
- `Jyutping/macOS/Metro/`

### iOS keyboard extension (`Keyboard/`)

- Entry point: `Keyboard/KeyboardViewController.swift`
- The controller prepares the keyboard UI, calls `InputMemory.prepare()`, then `Engine.prepare()`, and hosts `MotherBoard`.
- Shared keyboard UI is under `Keyboard/SharedViews/`.
- Keyboard state, layouts, and behavior enums live under `Keyboard/SharedModels/`.
- Device/layout-specific keyboards are split across `iPhone/`, `iPad/`, `NineKey/`, and `SpecialLayouts/`.
- The iPad implementation has large, medium, and small keyboard folders, with shared keys under `iPad/Keys/` and size-specific keys under `LargePadKeys/` and `MediumPadKeys/`. The keyboard target also includes emoji, editing-panel, speech, image, and shape support.

Useful places:

- `Keyboard/KeyboardViewController.swift`
- `Keyboard/SharedModels/KeyboardInterface.swift`
- `Keyboard/SharedModels/InputMemory.swift`
- `Keyboard/SharedViews/MotherBoard.swift`
- `Keyboard/SharedViews/CandidateBoard.swift`
- `Keyboard/SharedViews/PressButtonStyle.swift`: synchronizes a key's touch state and runs its action on press-down. Follow the relevant sibling key when changing press, repeat, or long-press behavior.

For changes to all keyboard variants, inspect iPhone, all iPad sizes, nine-key, special layouts, editing-panel, and emoji surfaces.

### macOS input method (`InputMethod/`)

- SwiftUI app entry point: `InputMethod/InputMethodApp.swift`
- App delegate and IMK server setup: `InputMethod/AppDelegate.swift`
- Main controller: `InputMethod/JyutpingInputController.swift`
- The controller activates the IME server, prepares `InputMemory` and `Engine`, manages the candidate window, and reacts to selection/highlight notifications.
- Candidate UI lives in `InputMethod/CandidateViews/`, `InputMethod/CandidateWindow.swift`, and `InputMethod/MotherBoard.swift`.
- Preferences UI lives in `InputMethod/Preferences/`.
- The target also links Sparkle for update support; see `Sparkle.framework` and the app delegate.

Useful places:

- `InputMethod/JyutpingInputController.swift`
- `InputMethod/InputContext.swift`
- `InputMethod/Models/InputMemory.swift`
- `InputMethod/MotherBoard.swift`
- `InputMethod/CandidateViews/`
- `InputMethod/Preferences/`

**Important**: Never *run* the `InputMethod` target directly. It's an InputMethodKit program that must be archived and installed by the developer. You can build it to check for compile errors, but do not run it.

## Shared engine and data flow

### Core input engine

`Modules/CoreIME/Sources/CoreIME/Engine.swift` is the main place to start for input behavior:

- `Engine.prepare()` opens the packaged SQLite database and prepares segmentation data
- `Engine.suggest(...)` is the main suggestion entry point
- `Engine.nineKeySuggest(...)` handles nine-key combo lookup
- the engine handles anchors, strict matches, tone input, apostrophes, partial matches, segmentation-aware lookup, pinyin, cangjie, quick, stroke, structure, emoji, and text-mark lookup

Closely related files include:

- `Candidate.swift`
- `Lexicon.swift`
- `Segmenter.swift`
- `NineKeySegmenter.swift`, `PinyinSegmenter.swift`, `PinyinNineKeySegmenter.swift`
- `VirtualInputKey.swift`
- `Pinyin*.swift`, `Cangjie*.swift`, `Quick.swift`, `Stroke*.swift`

### Learned candidate memory

The keyboard and macOS input method keep separate SQLite-backed learning stores:

- iOS keyboard: `Keyboard/SharedModels/InputMemory.swift`
- macOS input method: `InputMethod/Models/InputMemory.swift`

Both currently use the `memory2608` table and migration key `Migration2608`, with migration from older `memory`/`core_memory` tables. The keyboard schema additionally stores `anchors_9key` and `spell_9key`. Inspect both implementations for learning or migration changes, while preserving platform-specific behavior. These writable user databases are separate from the generated, read-only lexicon databases.

## How packages are used

From the package manifests and import graph:

- `CommonExtensions` is the lowest-level shared utility package.
- `CoreIME` depends on `CommonExtensions`.
- `Linguistics` depends on `CommonExtensions`.
- `AppDataSource` depends on `CommonExtensions`.
- `Preparing` depends on `CommonExtensions`.
- `AboutKit` currently has no local package dependencies.
- `Jyutping` primarily uses `AppDataSource`, `Linguistics`, `CommonExtensions`, and `AboutKit`.
- `Keyboard` primarily uses `CoreIME` and `CommonExtensions`.
- `InputMethod` primarily uses `CoreIME`, `CommonExtensions`, `AboutKit`, and Sparkle-backed update support.

When a change belongs in a reusable module, prefer editing the package instead of duplicating logic in an app target.

## Testing surfaces

There are two test layers in this repo:

1. Xcode target tests:
   - `JyutpingTests`
   - `JyutpingUITests`
   - `InputMethodTests`
   - `InputMethodUITests`

2. Swift package tests:
   - `Modules/CommonExtensions/Tests/CommonExtensionsTests`
   - `Modules/CoreIME/Tests/CoreIMETests`

The package suites use Swift Testing. CoreIME has coverage for candidate generation, segmentation, reverse lookup, nine-key input, conversion, and packaged database schemas. `Tests/CoreIMETests/TestSupport.swift` loads the generated mobile database explicitly, so macOS tests can exercise nine-key behavior; `DatabaseTests.swift` checks both mobile and desktop schemas. The Xcode unit-test files currently contain placeholder example tests; the UI-test targets use XCTest.

When updating source code in `Modules/CommonExtensions/Sources/CommonExtensions/`, also update the related Swift Testing suites in `Modules/CommonExtensions/Tests/CommonExtensionsTests` so the package retains full coverage of its behavior. Verify the change with `swift test --package-path Modules/CommonExtensions --enable-code-coverage`.

Run package checks from the repository root after generating databases where required:

```bash
swift test --package-path Modules/CommonExtensions --enable-code-coverage
swift test --package-path Modules/CoreIME --enable-code-coverage
swift run --package-path Modules/CoreIME -c release CoreIMEBenchmarks
```

The benchmark source is `Modules/CoreIME/Sources/CoreIMEBenchmarks/CoreIMEBenchmarks.swift`. It supports `--list`, `--filter <text>`, `--iterations <count>`, and `--warmup <count>`, and reports median and p95 timings. Use release builds for performance comparisons.

For compilation checks, choose the affected target and an explicit destination, with a writable DerivedData directory:

```bash
xcodebuild -project Jyutping.xcodeproj -scheme Keyboard -configuration Debug -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/Jyutping-Keyboard-DerivedData CODE_SIGNING_ALLOWED=NO build
xcodebuild -project Jyutping.xcodeproj -scheme InputMethod -configuration Debug -destination 'platform=macOS' -derivedDataPath /tmp/Jyutping-InputMethod-DerivedData CODE_SIGNING_ALLOWED=NO build
xcodebuild -project Jyutping.xcodeproj -scheme Jyutping -configuration Debug -destination 'platform=macOS' -derivedDataPath /tmp/Jyutping-App-DerivedData CODE_SIGNING_ALLOWED=NO build
```

For the iOS reference app, use the `Jyutping` scheme with `generic/platform=iOS Simulator`. A successful build or package test does not verify keyboard touch behavior or InputMethodKit lifecycle behavior. Report compilation, automated tests, and runtime checks separately, and distinguish environment failures from code failures.

## CI and packaging

- `.github/workflows/ci.yaml` uses the `xcode-27` runner label. It builds the shared packages, tests CommonExtensions and CoreIME, runs CoreIME benchmarks, and compiles the macOS app, macOS input method, iOS app, and keyboard.
- The database preparation job generates all three SQLite files once and uploads them as `prepared-databases`; dependent jobs download the artifact into `Modules/`. Keep artifact paths and consumers aligned when changing generation.
- `ci_scripts/ci_post_clone.sh` runs the generator for Xcode Cloud after changing to `Modules/Preparing`.
- `packaging/` contains macOS installer resources and scripts; packaged apps and archives are ignored by Git.
- Use `actionlint` when editing GitHub Actions workflows and `git diff --check` for changed files.
