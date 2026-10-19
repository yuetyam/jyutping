# AGENTS.md

Guidance for AI Agents working in this repository.

## Scope

This is a mixed Xcode + SwiftPM project for a Cantonese input method adopting the Jyutping romanization scheme:

- `Jyutping/`: the SwiftUI reference app for iOS, macOS, and visionOS
- `Keyboard/`: the iOS/iPadOS keyboard extension
- `InputMethod/`: the macOS InputMethodKit input method
- `Modules/`: local Swift packages shared by the app and input targets
- `tests/`: standalone input-memory export/import tests for the macOS input method
- `planning/`: numbered roadmap/design documents for larger changes
- `packaging/`: macOS installer resources and scripts
- `ci_scripts/` and `.github/workflows/`: CI support

## Editing rules

Read `.editorconfig` before editing. It sets UTF-8 and LF for all files; Swift files use spaces with indent size 8 and tab width 8, trim trailing whitespace, and insert a final newline.

- Make narrow, surgical edits and follow the surrounding style instead of reformatting files wholesale.
- Do not wrap long single-line code unless necessary.
- Preserve unrelated worktree changes.
- Do not commit, revert, or push changes unless the user explicitly asks.

## Localization and translation rules

1. Use Traditional Chinese characters for the `zh-Hans` and `zh-Hans-CN` locales.
2. All `zh-*` locales should generally align their values with the base locale, `yue`.
3. Cantonese (`yue`) is not Hong Kong written Chinese (`zh-Hant-HK`), and it is not limited to the colloquial register.

## Code review rules

- Changes under `Modules/Preparing/Sources/Preparing/Resources/` should usually be excluded from code review unless the user specifically asks to review those resource files.
- Code-signing settings in `Jyutping.xcodeproj/project.xcproj` are temporarily configured for local development. Do not report those settings as a review finding by themselves unless the user specifically asks about them or they cause a concrete issue within the requested scope.

## Toolchain and platforms

- Local environment verified on 2026-10-19: macOS 27.2, Xcode 27.2 (beta, at `/Applications/Xcode-beta.app`), Apple Swift 6.4.2. Check `swift --version` and `xcodebuild -version` when diagnosing toolchain differences.
- The Xcode project is stored in the JSON-style `Jyutping.xcodeproj/project.xcproj` format, not `project.pbxproj`. Shared schemes live in `Jyutping.xcodeproj/xcshareddata/xcschemes/`.
- Package manifests use `swift-tools-version: 6.4` and `swiftLanguageModes: [.v6]`. `SQLiteWrapper` also enables the `ApproachableConcurrency` upcoming feature.
- All Xcode targets use `SWIFT_VERSION` 6.0.

Deployment targets:

- iOS/iPadOS 17.0+ (app and keyboard)
- macOS 14.0+ (app and input method)
- visionOS 1.0+ (app only)
- Library packages declare `.iOS(.v17), .macOS(.v14)`. `Preparing` declares macOS 27+ because it is a local database-generation tool.

The keyboard chooses its UI at runtime: `GlassMotherBoard` on iOS 26+ and `LegacyMotherBoard` otherwise, so availability checks for iOS 26 are expected and intentional.

## Xcode project

Targets: `Jyutping`, `JyutpingTests`, `JyutpingUITests`, `Keyboard`, `InputMethod`, `InputMethodTests`, `InputMethodUITests`.

The project references every local package except `Preparing`, so `xcodebuild -project Jyutping.xcodeproj -list` shows the shared target schemes (`InputMethod`, `Jyutping`, `Keyboard`) alongside the package schemes (`AboutKit`, `AppDataSource`, `CommonExtensions`, `CoreIME`, `CoreIMEBenchmarks`, `Linguistics`, `SQLiteWrapper`). Use SwiftPM commands (`--package-path`) for package builds and tests.

Package products linked by each target:

| Target | Local packages | Other |
| --- | --- | --- |
| `Jyutping` | `AboutKit`, `AppDataSource`, `CommonExtensions`, `Linguistics` | |
| `Keyboard` | `CommonExtensions`, `CoreIME`, `SQLiteWrapper` | |
| `InputMethod` | `AboutKit`, `CommonExtensions`, `CoreIME`, `SQLiteWrapper` | `Sparkle.framework` (embedded, repo root) |

## Local packages (`Modules/`)

| Package | Depends on | Purpose |
| --- | --- | --- |
| `CommonExtensions` | — | Shared Foundation/SwiftUI-style helpers and extensions; fully covered by `CommonExtensionsTests` |
| `SQLiteWrapper` | — | Thin, dependency-free wrapper over system SQLite3 (`SQLiteDatabase`, `SQLiteStatement`, `SQLiteBindable`, `SQLiteError`) with tests |
| `AboutKit` | — | About/info UI support |
| `CoreIME` | `CommonExtensions` | Core input engine, platform database resource targets, tests, and the `CoreIMEBenchmarks` executable |
| `Linguistics` | `CommonExtensions` | Jyutping syllable checks, IPA conversion, Old Cantonese helpers |
| `AppDataSource` | `CommonExtensions` | Searchable reference datasets for the app, backed by `app.sqlite3` |
| `Preparing` | `CommonExtensions` | SwiftPM-only build-time executable that generates the packaged databases |

When a change belongs in a reusable module, prefer editing the package instead of duplicating logic in an app target.

## First build step: generate databases

On a clean checkout, generate the packaged databases before building the Xcode project or building/testing the data-dependent packages (`CoreIME` and `AppDataSource`):

```bash
cd Modules/Preparing
swift run -c release
```

Run this from `Modules/Preparing`: the app database output uses a relative path. The entry point `Modules/Preparing/Sources/Preparing/Preparing.swift` runs `AppDataPreparer.prepare()` and `DatabasePreparer.prepare()` concurrently and generates:

- `Modules/CoreIME/Sources/CoreIMEMobileData/Resources/mobile.sqlite3`
- `Modules/CoreIME/Sources/CoreIMEDesktopData/Resources/desktop.sqlite3`
- `Modules/AppDataSource/Sources/AppDataSource/Resources/app.sqlite3`

Generated SQLite files are ignored by Git. The mobile CoreIME database contains the complete schema; the desktop database is copied from it and then stripped of nine-key-specific tables, columns, and indexes.

`Modules/CoreIME/Package.swift` links `CoreIMEMobileData` on iOS and `CoreIMEDesktopData` on macOS. `Engine.prepare()` opens the platform's bundled database; `Engine.prepare(databaseURL:includesNineKeyData:)` opens an explicit one, which tests and benchmarks use to load the mobile database on macOS.

For lexicon or schema changes, edit the source resources/generator in `Modules/Preparing/Sources/Preparing/`, regenerate the databases, and validate the affected schema and contents as well as SQLite integrity. Existing generated files can be reused for unrelated source-only changes.

## Core input engine (`Modules/CoreIME/Sources/CoreIME/`)

- `Engine.swift`: `Engine.prepare()`, and `Engine.suggest(_:segmentation:deepSearch:)`, the main suggestion entry point. Handles anchors, strict/partial matches, tone input, apostrophes, and segmentation-aware lookup.
- `NineKeyEngine.swift`: nine-key (T9) suggestion via `NineKeyEngine.suggest(combos:segmentation:)`, using `Combo.swift`.
- Segmentation: `Segmenter.swift`, `NineKeySegmenter.swift`, `PinyinSegmenter.swift`, `PinyinNineKeySegmenter.swift`.
- Input model: `VirtualInputKey.swift`, `BasicInputEvent.swift`, `AmbiguousInputEvent.swift`, `KeyboardCase.swift`, `StrokeVirtualKey.swift`.
- Results: `Candidate.swift`, `Lexicon.swift`, `ExtraEntry.swift`.
- Reverse lookup and other schemes: `Pinyin.swift`, `Cangjie.swift` + `CangjieVariant.swift` (Cangjie and Quick/Sucheng), `Stroke.swift`, `Structure.swift`, `Lookup.swift`, `Emoji.swift`, `PlainText.swift`, `ShapeLexicon.swift`.
- Character conversion: `Converter.swift` and its `Converter+*.swift` extensions, `CharacterStandard.swift`, `StringCompatibleTransform.swift`.

CoreIME and AppDataSource call the SQLite3 C API directly; they do not use `SQLiteWrapper`.

## App target (`Jyutping/`)

- Entry point: `Jyutping/JyutpingApp.swift`; shared state in `Jyutping/SharedModels/AppMaster.swift`.
- Platform trees: `Jyutping/iOS/` (`About`, `Cantonese`, `Components`, `Home`, `Romanization`, `Search`, `IOSContentView.swift`) and `Jyutping/macOS/` (`MacContentView.swift`, `Metro/`, `Search/`, and the `Mac*View.swift` pages).
- Shared code: `CantoneseMaterials/`, `SharedViews/`, `SharedModels/`, `Speech/`, `Extensions/`.

## iOS keyboard extension (`Keyboard/`)

- Entry point: `Keyboard/KeyboardViewController.swift`. It calls `InputMemory.prepare()` and `Engine.prepare()`, then hosts `GlassMotherBoard` (iOS 26+) or `LegacyMotherBoard`.
- `SharedModels/`: keyboard state, layouts, and behavior enums (`KeyboardInterface.swift`, `KeyboardLayout.swift`, `Options.swift`, `UserSettingsKey.swift`, `AppearanceStyle.swift`, …) and input memory.
- `SharedViews/`: mother boards, candidate bar/board, toolbar, settings, and `PressButtonStyle.swift`, which synchronizes a key's touch state and runs its action on press-down. Follow the relevant sibling key when changing press, repeat, or long-press behavior.
- `iPhone/`: `GlassKeyboards/` + `GlassKeys/` (iOS 26+) and `LegacyKeyboards/` + `LegacyKeys/`.
- `iPad/`: shared keys in `Keys/`; size-specific `LargePadKeyboards/` + `LargePadKeys/`, `MediumPadKeyboards/` + `MediumPadKeys/`, and `SmallPadKeyboards/`.
- `NineKey/`: nine-key keyboard, sidebar, and the tailored numeric keyboard.
- `SpecialLayouts/`: T14, T15, T18, T19, and T21 layouts.
- `Stroke/`: tailored stroke reverse-lookup keyboards (Glass and Legacy).
- Also: `EditingPanel/`, `Emoji/`, `Shapes/`, `Speech/`, `Extensions/`.

Many layouts exist in both Glass and Legacy variants. For changes that affect all keyboard variants, inspect iPhone Glass and Legacy, all iPad sizes, nine-key, special layouts, stroke, editing-panel, and emoji surfaces.

## macOS input method (`InputMethod/`)

**Never run the `InputMethod` target.** It is an InputMethodKit program that the developer archives and installs. Building it to check for compile errors is fine.

- SwiftUI app entry point: `InputMethodApp.swift`; IMK server setup and Sparkle updates: `AppDelegate.swift`.
- Main controller: `JyutpingInputController.swift`. It activates the IME server, prepares `InputMemory` and `Engine`, manages the candidate window, and reacts to selection/highlight notifications. Related: `InputContext.swift`, `Options.swift`, `OptionsView.swift`.
- Candidate UI: `CandidateViews/`, `CandidateWindow.swift`, `MotherBoard.swift`, `IndicatorBar.swift`.
- `InputMemory/`: learning store, preparation/migration, and portable export/import.
- `KeyCode/`: key code and punctuation mapping. `Models/`: input stage/form, paging, lexicon types.
- `Preferences/`: settings UI, including `InputMemorySettingsView.swift` and the export/import controllers.

## Learned candidate memory

The keyboard and the input method keep separate SQLite-backed learning stores, both built on `SQLiteWrapper`:

- iOS keyboard: `Keyboard/SharedModels/InputMemory*.swift` and `MemoryLexicon.swift`. Export/import goes through `InputMemoryTransferController.swift`, which uses a folder picker for export because export-mode document pickers fail inside keyboard extensions.
- macOS input method: `InputMethod/InputMemory/` (`InputMemory.swift`, `InputMemoryPreparation.swift`, `InputMemoryExporter.swift`, `InputMemoryImporter.swift`, `MemoryLexicon.swift`).

Both use the `memory2608` table and the `Migration2608` user-defaults key, migrating from the older `memory`/`core_memory` tables. The keyboard schema additionally stores `anchors_9key` and `spell_9key`. The portable export format is a separate `input_memory` table (version 1). Inspect both implementations for learning, migration, or export changes while preserving platform-specific behavior. These writable user databases are separate from the generated, read-only lexicon databases.

## Testing

Swift package suites (Swift Testing), run from the repository root after generating databases where required:

```bash
swift test --package-path Modules/CommonExtensions --enable-code-coverage
swift test --package-path Modules/SQLiteWrapper --enable-code-coverage
swift test --package-path Modules/CoreIME --enable-code-coverage
swift run --package-path Modules/CoreIME -c release CoreIMEBenchmarks
```

- When updating `Modules/CommonExtensions/Sources/CommonExtensions/`, also update `Modules/CommonExtensions/Tests/CommonExtensionsTests` so the package keeps full coverage, and verify with the command above.
- CoreIME tests cover candidates, segmentation (including nine-key and pinyin), reverse lookup, conversion, input events, and packaged database schemas. `TestSupport.swift` loads the generated mobile database explicitly so macOS runs exercise nine-key behavior; `DatabaseTests.swift` checks both mobile and desktop schemas.
- `CoreIMEBenchmarks` supports `--list`, `--filter <text>`, `--iterations <count>`, and `--warmup <count>`, and reports median and p95 timings. Use release builds for performance comparisons.

Input method memory export/import tests:

```bash
python3 tests/test_input_memory_export.py
```

The script copies the real `InputMethod/InputMemory/` sources and `tests/*.swift` into a temporary Swift Testing package that depends on `CommonExtensions` and `SQLiteWrapper`, then runs `swift test` with scratch path `.build/input-memory-export-tests`. It launches no InputMethodKit process and opens no user database.

Xcode test targets: `JyutpingTests` and `InputMethodTests` currently contain placeholder example tests; `JyutpingUITests` and `InputMethodUITests` use XCTest.

Compilation checks — pick the affected target, an explicit destination, and a writable DerivedData directory:

```bash
xcodebuild -project Jyutping.xcodeproj -scheme Keyboard -configuration Debug -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/Jyutping-Keyboard-DerivedData CODE_SIGNING_ALLOWED=NO build
xcodebuild -project Jyutping.xcodeproj -scheme InputMethod -configuration Debug -destination 'platform=macOS' -derivedDataPath /tmp/Jyutping-InputMethod-DerivedData CODE_SIGNING_ALLOWED=NO build
xcodebuild -project Jyutping.xcodeproj -scheme Jyutping -configuration Debug -destination 'platform=macOS' -derivedDataPath /tmp/Jyutping-App-DerivedData CODE_SIGNING_ALLOWED=NO build
xcodebuild -project Jyutping.xcodeproj -scheme Jyutping -configuration Debug -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/Jyutping-iOSApp-DerivedData CODE_SIGNING_ALLOWED=NO build
```

A successful build or package test does not verify keyboard touch behavior or InputMethodKit lifecycle behavior. Report compilation, automated tests, and runtime checks separately, and distinguish environment failures from code failures.

## CI and packaging

- `.github/workflows/ci.yaml` runs on the `xcode-27` runner label. It builds every library package, tests CommonExtensions, SQLiteWrapper, and CoreIME, runs CoreIME benchmarks, and compiles the macOS app, macOS input method, iOS app, and keyboard.
- The `Prepare Databases` job generates the three SQLite files once, verifies they are non-empty, and uploads them as the `prepared-databases` artifact; dependent jobs download it into `Modules/`. Keep artifact paths and consumers aligned when changing generation.
- `ci_scripts/ci_post_clone.sh` runs the generator for Xcode Cloud from `Modules/Preparing`.
- `packaging/` holds the macOS installer (`pack.sh`, `distribution.xml`, `JyutpingComponent.plist`, `scripts/`, localized `resources/`). Packaged apps and archives are ignored by Git.
- Run `actionlint` after editing GitHub Actions workflows and `git diff --check` for changed files.
