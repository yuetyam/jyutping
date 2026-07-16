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

## What is in the project

`xcodebuild -project Jyutping.xcodeproj -list` currently reports these Xcode targets:

- `Jyutping`
- `JyutpingTests`
- `JyutpingUITests`
- `Keyboard`
- `InputMethod`
- `InputMethodTests`
- `InputMethodUITests`

It currently exposes these schemes:

- `AboutKit`
- `AppDataSource`
- `CommonExtensions`
- `CoreIME`
- `InputMethod`
- `Jyutping`
- `Keyboard`
- `Linguistics`

Under `Modules/`, the local Swift packages are:

1. `CommonExtensions`: shared Foundation-style helpers and extensions
2. `CoreIME`: the core input engine and bundled SQLite lexicon
3. `Linguistics`: Jyutping/IPA and related language helpers
4. `AppDataSource`: searchable reference datasets used by the app
5. `AboutKit`: about/info UI support
6. `Preparing`: a SwiftPM-only build-time executable that generates data used by other modules

## Build requirements and environments
- Current local environment observed while updating this file: macOS 27.0, Xcode 27.0, Apple Swift 6.4.
- Package manifests use `swift-tools-version: 6.3` and `swiftLanguageModes: [.v6]`.
- Xcode project settings use Swift 6 for the app, keyboard, input method, and project-level settings.
- The `Preparing` package declares macOS 26+ because it is a local database-generation tool.

Targeted platforms:
- iOS/iPadOS 16.0+
- macOS 13+ (Ventura or above)

## First build step: generate databases

Before building the Xcode project, generate the packaged databases:

```bash
cd Modules/Preparing
swift run -c release
```

This is not optional for a clean checkout. The executable entry point is `Modules/Preparing/Sources/Preparing/Preparing.swift`, which runs `AppDataPreparer.prepare()` and `DatabasePreparer.prepare()` concurrently. It generates these packaged SQLite databases:

- `Modules/CoreIME/Sources/CoreIME/Resources/ime.sqlite3`
- `Modules/AppDataSource/Sources/AppDataSource/Resources/app.sqlite3`

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
- The iPad implementation has separate large, medium, and small key/keyboards folders. The keyboard target also includes emoji, editing-panel, speech, image, and shape support.

Useful places:

- `Keyboard/KeyboardViewController.swift`
- `Keyboard/SharedModels/KeyboardInterface.swift`
- `Keyboard/SharedModels/InputMemory.swift`
- `Keyboard/SharedViews/MotherBoard.swift`
- `Keyboard/SharedViews/CandidateBoard.swift`

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

- `Engine.prepare()` opens the packaged SQLite database
- `Engine.suggest(...)` is the main suggestion entry point
- `Engine.nineKeySuggest(...)` handles nine-key combo lookup
- the engine handles anchors, strict matches, tone input, apostrophes, partial matches, segmentation-aware lookup, pinyin, cangjie, quick, stroke, structure, emoji, and text-mark lookup

Closely related files include:

- `Candidate.swift`
- `Lexicon.swift`
- `Segmenter.swift`
- `VirtualInputKey.swift`
- `Pinyin*.swift`, `Cangjie*.swift`, `Quick.swift`, `Stroke*.swift`

### Generated lexicon database

The packaged IME database is assembled by the `Preparing` executable:

- `Modules/Preparing/Sources/Preparing/Preparing.swift`
- `Modules/Preparing/Sources/Preparing/DatabasePreparer.swift`
- `Modules/Preparing/Sources/Preparing/AppDataPreparer.swift`
- `Modules/Preparing/Sources/Preparing/Resources/`

If a task changes lexicon contents, schema, or generated resources, update the generator and rerun `swift run -c release` in `Modules/Preparing`.

### Learned candidate memory

The keyboard and macOS input method keep separate SQLite-backed learning stores:

- iOS keyboard: `Keyboard/SharedModels/InputMemory.swift`
- macOS input method: `InputMethod/Models/InputMemory.swift`

They are similar but not identical. For example, the keyboard memory schema stores extra 9-key fields that are not present in the macOS input memory table. Keep platform-specific differences in mind before copying logic between them.

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
   - `Modules/Linguistics/Tests/LinguisticsTests`
   - `Modules/AppDataSource/Tests/AppDataSourceTests`
   - `Modules/AboutKit/Tests/AboutKitTests`

The existing tests use Swift Testing, and some also import XCTest.

When updating source code in `Modules/CommonExtensions/Sources/CommonExtensions/`, also update the related Swift Testing suites in `Modules/CommonExtensions/Tests/CommonExtensionsTests` so the package retains full coverage of its behavior. Verify the change with `swift test --package-path Modules/CommonExtensions --enable-code-coverage`.

Useful commands:

```bash
xcodebuild -project Jyutping.xcodeproj -scheme Jyutping build
xcodebuild -project Jyutping.xcodeproj -scheme Keyboard build
xcodebuild -project Jyutping.xcodeproj -scheme InputMethod build

swift test --package-path Modules/CommonExtensions
swift test --package-path Modules/CoreIME
swift test --package-path Modules/Linguistics
swift test --package-path Modules/AppDataSource
swift test --package-path Modules/AboutKit
```

## Where to start for common tasks

### Change candidate generation or ranking

Start with:

- `Modules/CoreIME/Sources/CoreIME/Engine.swift`
- `Modules/CoreIME/Sources/CoreIME/Lexicon.swift`
- `Modules/CoreIME/Sources/CoreIME/Segmenter.swift`

Then inspect the platform-specific display layer:

- `Keyboard/SharedViews/CandidateBoard.swift`
- `InputMethod/CandidateViews/CandidateBoard.swift`

### Change generated data or lexicons

Start with:

- `Modules/Preparing/Sources/Preparing/DatabasePreparer.swift`
- `Modules/Preparing/Sources/Preparing/AppDataPreparer.swift`
- `Modules/Preparing/Sources/Preparing/Resources/`

Regenerate the databases afterward.

### Change learning / personalization

Start with both:

- `Keyboard/SharedModels/InputMemory.swift`
- `InputMethod/Models/InputMemory.swift`

### Change keyboard layouts or key behavior

Start with:

- `Keyboard/KeyboardViewController.swift`
- `Keyboard/SharedModels/`
- `Keyboard/SharedViews/`
- `Keyboard/iPhone/`
- `Keyboard/iPad/`
- `Keyboard/NineKey/`
- `Keyboard/SpecialLayouts/`
- `Keyboard/EditingPanel/`
- `Keyboard/Emoji/`

### Change app reference/search screens

Start with:

- `Jyutping/iOS/Search/`
- `Jyutping/macOS/Search/`
- `Jyutping/SharedModels/AppMaster.swift`
- `Modules/AppDataSource/Sources/AppDataSource/`

## Agent tips

- Prefer searching the relevant package or target first; the repo is split cleanly by responsibility.
- Do not assume the iOS keyboard and macOS input method share identical persistence or UI behavior.
- If a change touches generated resources, regenerate them before concluding the work.
- If a change belongs to shared logic, look in `Modules/` before editing app-target code.
