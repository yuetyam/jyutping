# AGENTS.md

This file provides guidance to AI Agents (Codex, Claude Code, etc.) when working with code in this repository.

## Project Overview

Jyutping is a Cantonese input method for iOS, iPadOS, and macOS using the Hong Kong Linguistic Society's Jyutping romanization scheme. The project consists of three main executable targets plus several shared Swift Package Manager (SPM) modules.

## How to Build

### Build Requirements

- macOS 26.0+
- Xcode 26.0+

Targeted platforms: iOS/iPadOS 16.0+, macOS 13+ (Ventura or above)

### Database Preparation (REQUIRED FIRST STEP)

Before building in Xcode, you MUST generate the lexicon database:
```bash
cd ./Modules/Preparing/
swift run -c release
```

This creates `imedb.sqlite3` in `Modules/CoreIME/Sources/CoreIME/Resources/` containing all lexicon tables (Jyutping, Pinyin, Cangjie, stroke data, etc.).

### Build Targets

- **Jyutping** - iOS & macOS app
- **Keyboard** - iOS Keyboard Extension
- **InputMethod** - macOS Input Method (NEVER Run directly, only Build or Archive)

## Architecture Overview

### Three Main Targets

1. **Jyutping** (`/Jyutping/`) - Multi-platform SwiftUI app
   - macOS: Reference tables, MTR maps, character search, settings
   - iOS: Similar content optimized for mobile

2. **Keyboard** (`/Keyboard/`) - iOS Keyboard Extension
   - Entry: `KeyboardViewController.swift` (extends `UIInputViewController`)
   - Integrates with `UITextDocumentProxy`
   - Supports multiple layouts: 26-key, 10-key, 14-key, 15-key, 18-key, 19-key, 21-key
   - Device-aware: iPhone/iPad, portrait/landscape, floating

3. **InputMethod** (`/InputMethod/`) - macOS Input Method Kit (IMK) implementation
   - Entry: `JyutpingInputController.swift` (extends `IMKInputController`)
   - Handles system keyboard events via InputMethodKit framework
   - State: `AppContext` (@EnvironmentObject) for candidate display
   - User learning: `InputMemory.swift` with SQLite

### Shared Modules (SPM Packages in `/Modules/`)

**Dependency chain**: CommonExtensions → CoreIME/Linguistics/AppDataSource → Platform targets

1. **CommonExtensions** - Foundation utilities (String, Array, Character extensions)

2. **CoreIME** - Core Input Method Engine
   - `Engine.swift`: Main suggestion algorithm, queries SQLite database
   - `VirtualInputKey.swift`: Keyboard input representation (a-z, 0-9, apostrophe)
   - `Candidate.swift`: Character match with metadata (text, romanization, ranking)
   - Input methods: Jyutping (primary), Pinyin, Cangjie (3/5), Quick (3/5), Stroke
   - `Converter+*.swift`: Character standard conversions (Traditional, Simplified, PRC, Taiwan, etc.)

3. **Linguistics** - Linguistic analysis
   - Jyutping syllable validation
   - Jyutping to IPA conversion
   - Old Cantonese data

4. **AppDataSource** - Application lexicon management
   - `CantoneseLexicon.swift`: Main lookup interface for pronunciations
   - `DataMaster.swift`: Centralized data coordinator
   - Variant data: FanWan, YingWaa, ChoHok, GwongWan

5. **Preparing** - Database generation tool (executable, build-time only)
   - `DatabasePreparer.swift`: Creates in-memory SQLite with 20+ tables
   - Processes `.txt` files from `Resources/` into compiled `imedb.sqlite3`
   - Tables: core_lexicon, pinyin_lexicon, cangjie_table, quick_table, stroke_table, symbol_table, emoji_*, mark_table, variant_*

6. **AboutKit** - About/info panel functionality

### Input Processing Pipeline

```
User types → KeyboardViewController/JyutpingInputController
  → VirtualInputKey sequence
  → Engine.suggest() queries imedb.sqlite3
  → Candidate list (ranked by frequency)
  → DisplayCandidate (formatted for UI)
  → AppContext/State update
  → UI renders candidates
  → User selects → InputMemory records → Next cycle shows learned candidates higher
```

### Database Architecture

**Build-time** (Preparing module):
- Source: `.txt` files in `Modules/Preparing/Sources/Preparing/Resources/`
- Output: `Modules/CoreIME/Sources/CoreIME/Resources/imedb.sqlite3`

**Runtime**:
- macOS: Loads imedb.sqlite3 into memory
- iOS: Reads imedb.sqlite3 from bundle

### Keyboard Layout System

iOS Keyboard supports multiple layouts based on device and input method:
- **TenKey/** - 10-key phone keypad style
- **SpecialLayouts/** - 14-key, 15-key, 18-key, 19-key, 21-key variants
- **iPad/** - iPad-specific layouts
- **iPhone/** - iPhone-specific layouts

Layout selection via `KeyboardInterface` enum: `.phonePortrait`, `.phoneLandscape`, `.padPortrait*`, `.padLandscape*`, `.padFloating`

## Key File Locations for Common Tasks

### Modifying Character Suggestion Logic
- Start: `Modules/CoreIME/Sources/CoreIME/Engine.swift` → `suggest()` method
- Database schema: `Modules/Preparing/Sources/Preparing/DatabasePreparer.swift`
- Display formatting: `InputMethod/DisplayCandidate.swift` (macOS) or `Keyboard/SharedViews/CandidateBoard.swift` (iOS)

### Adding Lexicon Data
1. Add/modify `.txt` files in `Modules/Preparing/Sources/Preparing/Resources/`
2. Update `DatabasePreparer.swift` to process new data
3. Rebuild database: `cd Modules/Preparing/ && swift run -c release`

### User Learning System
- macOS: `InputMethod/InputMemory.swift`
- iOS: `Keyboard/SharedModels/InputMemory.swift`
- Selection handling in respective controllers

### UI/Layout Changes
- macOS: `InputMethod/CandidateViews/MotherBoard.swift` + `JyutpingInputController.swift`
- iOS: `Keyboard/SharedViews/MotherBoard.swift` + `KeyboardViewController.swift`

### Settings/Preferences
- macOS: `InputMethod/Preferences/`
- iOS: `Keyboard/SharedViews/SettingsView.swift`

## Important Constraints

### macOS InputMethod Target
- **NEVER** use "Run" in Xcode - it will fail
- **ONLY** use "Build" or "Archive"
- Must be installed to `/Library/Input Methods/` for testing
- Requires system restart or logout/login to activate changes
