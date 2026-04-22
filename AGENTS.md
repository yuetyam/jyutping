# AGENTS.md

Guidance for AI Agents working in this repository.

## Scope

This is a mixed Xcode + SwiftPM project for a Cantonese input method adpting the Jyutping romanization scheme:

- `Jyutping/`: the main app for iOS and macOS
- `Keyboard/`: the iOS keyboard extension
- `InputMethod/`: the macOS input method target
- `Modules/`: local Swift packages shared by the app and input targets

## Formatting and editing rules

Read `.editorconfig` before editing.

Make narrow, surgical edits and follow the surrounding style instead of reformatting files wholesale.

## What is in the project

`xcodebuild -list -project Jyutping.xcodeproj` reports these main Xcode targets:

- `Jyutping`
- `JyutpingTests`
- `JyutpingUITests`
- `Keyboard`
- `InputMethod`
- `InputMethodTests`
- `InputMethodUITests`

It also exposes local package schemes for:

- `AboutKit`
- `AppDataSource`
- `CommonExtensions`
- `CoreIME`
- `Linguistics`

Under `Modules/`, the local packages are:

1. `CommonExtensions`: shared Foundation-style helpers and extensions
2. `CoreIME`: the core input engine and bundled SQLite lexicon
3. `Linguistics`: Jyutping/IPA and related language helpers
4. `AppDataSource`: searchable reference datasets used by the app
5. `AboutKit`: about/info UI support
6. `Preparing`: a build-time executable that generates data used by other modules

## Build requirements and environments
- macOS 26.2+
- Xcode 26.4+
- Swift 6.3+

Targeted platforms:
- iOS/iPadOS 16.0+
- macOS 13+ (Ventura or above)

## First build step: generate databases

Before building the Xcode project, generate the packaged databases:

```bash
cd Modules/Preparing
swift run -c release
```

This is not optional for a clean checkout. The executable entry point is `Modules/Preparing/Sources/Preparing/Preparing.swift`, and it generated the SQLite databases `Modules/CoreIME/Sources/CoreIME/Resources/imedb.sqlite3` and `Modules/AppDataSource/Sources/AppDataSource/Resources/appdb.sqlite3`.

## Runtime architecture

### App target (`Jyutping/`)

- Entry point: `Jyutping/JyutpingApp.swift`
- The app has separate `iOS/` and `macOS/` trees plus shared views/models.
- Code under `Jyutping/iOS/Search`, `Jyutping/macOS/Search`, and `Jyutping/SharedViews` is the main search/reference UI surface.
- Imports across the app show that it primarily consumes `AppDataSource`, `Linguistics`, `CommonExtensions`, and `AboutKit`.

Useful places:

- `Jyutping/SharedModels/AppMaster.swift`
- `Jyutping/iOS/Search/`
- `Jyutping/macOS/Search/`
- `Jyutping/iOS/Cantonese/`
- `Jyutping/macOS/Metro/`

### iOS keyboard extension (`Keyboard/`)

- Entry point: `Keyboard/KeyboardViewController.swift`
- The controller prepares the keyboard UI, calls `InputMemory.prepare()`, then `Engine.prepare()`, and hosts `MotherBoard`.
- Shared keyboard UI is under `Keyboard/SharedViews/`.
- Keyboard state, layouts, and behavior enums live under `Keyboard/SharedModels/`.
- Device/layout-specific keyboards are split across `iPhone/`, `iPad/`, `NineKey/`, and `SpecialLayouts/`.

Useful places:

- `Keyboard/KeyboardViewController.swift`
- `Keyboard/SharedModels/KeyboardInterface.swift`
- `Keyboard/SharedModels/InputMemory.swift`
- `Keyboard/SharedViews/MotherBoard.swift`
- `Keyboard/SharedViews/CandidateBoard.swift`

### macOS input method (`InputMethod/`)

- Entry point: `InputMethod/main.swift`
- Main controller: `InputMethod/JyutpingInputController.swift`
- The controller activates the IME server, prepares `InputMemory` and `Engine`, manages the candidate window, and reacts to selection/highlight notifications.
- Candidate UI lives in `InputMethod/CandidateViews/`.
- Preferences UI lives in `InputMethod/Preferences/`.

Useful places:

- `InputMethod/JyutpingInputController.swift`
- `InputMethod/InputContext.swift`
- `InputMethod/InputMemory.swift`
- `InputMethod/CandidateViews/MotherBoard.swift`
- `InputMethod/Preferences/`

**Important**: Never *run* the `InputMethod` target directly. It's an InputMethodKit program that must be archived and installed by the developer. You can build it to check for compile errors, but do not run it.

## Shared engine and data flow

### Core input engine

`Modules/CoreIME/Sources/CoreIME/Engine.swift` is the main place to start for input behavior:

- `Engine.prepare()` opens the packaged SQLite database
- `Engine.suggest(...)` is the main suggestion entry point
- the engine handles anchors, strict matches, tone input, apostrophes, partial matches, and segmentation-aware lookup

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
- macOS input method: `InputMethod/InputMemory.swift`

They are similar but not identical. For example, the keyboard memory schema stores extra ten-key fields that are not present in the macOS input memory table. Keep platform-specific differences in mind before copying logic between them.

## How packages are used

From the package manifests and import graph:

- `CommonExtensions` is the lowest-level shared utility package.
- `CoreIME` depends on `CommonExtensions`.
- `Linguistics` depends on `CommonExtensions`.
- `AppDataSource` depends on `CommonExtensions`.
- `Preparing` depends on `CommonExtensions`.
- `Jyutping` primarily uses `AppDataSource`, `Linguistics`, `CommonExtensions`, and `AboutKit`.
- `Keyboard` primarily uses `CoreIME` and `CommonExtensions`.
- `InputMethod` primarily uses `CoreIME`, `CommonExtensions`, and `AboutKit`.

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
- `InputMethod/InputMemory.swift`

### Change keyboard layouts or key behavior

Start with:

- `Keyboard/KeyboardViewController.swift`
- `Keyboard/SharedModels/`
- `Keyboard/SharedViews/`
- `Keyboard/iPhone/`
- `Keyboard/iPad/`
- `Keyboard/NineKey/`
- `Keyboard/SpecialLayouts/`

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
