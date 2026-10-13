# macOS Input Memory Export Roadmap

Status: approved implementation plan; preferences controls and localization exist, but export and import actions remain TODOs. Updated against the codebase on 2026-10-14.

## Goal

Allow users to export the macOS input method's learned entries to one portable SQLite file at a user-selected location. The file must preserve a consistent snapshot of the stored words, romanizations, frequencies, and timestamps, and remain usable independently of the live memory database.

The first release covers export from `InputMethod`. Import and export from other platforms can follow using the same versioned format.

## Current integration points

- `InputMethod/InputMemory/InputMemory.swift` manages `memory2608` in `URL.libraryDirectory.appending(path: "memory.sqlite3", directoryHint: .notDirectory)`. Its private, lazily opened connection uses `SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX`.
- `InputMethod/InputMemory/MemoryLexicon.swift` defines the stored values. `latest` is Unix time in milliseconds, and `frequency` and `latest` use `Int64`. The macOS table also stores `id`, `char_count`, `letter_count`, `complexity`, `anchors`, and `spell` for internal use.
- `InputMethod/Preferences/InputMemorySettingsView.swift` contains the input-memory toggle, Export and Import buttons with TODO actions, and Clear with confirmation and a simulated one-second progress display. Clear currently calls the synchronous, nonthrowing `InputMemory.deleteAll()` immediately after confirmation.
- `InputMethod/Preferences/SettingsContentView.swift` routes the `.memory` sidebar selection to `InputMemorySettingsView`; these controls are no longer in `GeneralSettingsView`.
- `SettingsWindow.shared`, defined in `InputMethod/CandidateWindow.swift`, is the preferences `NSPanel` and can serve as the parent of the save sheet.
- `InputMethod/Localizable.xcstrings` already contains the `InputMemorySettingsView.ExportInputMemory.ButtonTitle` and `InputMemorySettingsView.ImportInputMemory.ButtonTitle` keys, along with the toggle, Clear, and page-title strings.
- `Jyutping.xcodeproj/project.xcproj` already sets `ENABLE_APP_SANDBOX = YES` and `ENABLE_USER_SELECTED_FILES = readwrite` for `InputMethod`, with `InputMethod/InputMethod.entitlements` as its entitlement source. Verify the resulting signed entitlements rather than adding duplicate configuration.

Memory preparation currently begins when `JyutpingInputController.bufferEvents` transitions from empty to nonempty. `@MainActor InputMemory.prepare()` ensures the table and indexes, then starts an unretained migration task when needed; it does not await completion or report failures. The private `nonisolated(unsafe) isMigrating` flag gates learning, suggestions, forgetting, and clearing during migration. Opening preferences before typing must still allow a complete export.

Migration uses the `Migration2608` key with completion value `2608`. Until complete, `InputMemoryMigration2026 == 2026` selects `core_memory` as the legacy source; otherwise it selects `memory`. Progress is persisted by frequency band: first `frequency > 20 AND frequency <= 100000`, then the remaining positive frequencies down to 1. Successful completion removes obsolete migration keys and attempts to remove `userlexicon.sqlite3`. Preserve this selection, resume, and frequency policy when exposing readiness.

## Export contract

Suggested filename: `memory-${formatted-date}.sqlite3`, for example `memory-20261014-153045.sqlite3`.

Use the date pattern `yyyyMMdd-HHmmss`, a fixed Gregorian calendar, `en_US_POSIX` locale, and the current local time zone. The save panel lets the user change the filename and location; ordinary overwrite confirmation handles filename collisions.

```sql
CREATE TABLE input_memory (
    word TEXT NOT NULL,
    romanization TEXT NOT NULL,
    frequency INTEGER NOT NULL,
    latest INTEGER NOT NULL,
    UNIQUE (word, romanization)
);
PRAGMA user_version = 1;
```

Export every row from `memory2608`, preserving the four values exactly. Preserve Unicode text, tone digits, romanization spacing, and 64-bit integers. Internal IDs, derived lookup fields, legacy tables, and settings are outside the export format. Future importers can reconstruct the derived fields.

An empty memory produces a valid version-1 database containing an empty `input_memory` table. Disabling learning does not disable export of existing entries. Snapshot time describes when the committed source state was captured; it does not change any entry's `latest` value.

## Implementation sequence

### 1. Expose memory readiness

Add a narrow asynchronous readiness API to `InputMemory` that prepares the store, awaits any migration already in progress, and reports initialization or migration failures. Concurrent callers should share the same preparation work, with readiness state synchronized explicitly.

Centralize the live database URL in `InputMemory` so preparation, export, and destination protection use the same source location. Keep the controller's existing preparation entry point compatible with the shared readiness work. Export must await readiness even when learning is disabled.

The current database open, table/index creation, legacy reads, and migration writes return silently or ignore some SQLite results. Make these preparation and migration paths report errors before using them as an export prerequisite. Distinguish an absent or empty legacy table from a failed query; only persist a frequency-band checkpoint after its transaction commits, and only mark migration complete and perform cleanup after all required work succeeds. Clear the in-progress state on failure and retain enough state for a later retry.

Export must not read a partially migrated table or mistake a failed database open for an empty store. Preserve the existing migration guards and normal learning behavior; polling `isMigrating` or checking the saved completion marker alone is insufficient to establish successful readiness.

### 2. Build a testable SQLite exporter

Add `InputMethod/InputMemory/InputMemoryExporter.swift`, accepting the source database URL exposed by `InputMemory` and a private output URL, and returning the exported row count. Keep save-panel presentation, localized messages, and final publication outside this component.

Run SQLite work off the main actor with connections owned by the export operation. After readiness completes, open a separate read-only source connection without `SQLITE_OPEN_CREATE` and use SQLite's backup API to create a private, consistent snapshot. A missing source must fail rather than become a new empty database. Copy in bounded steps, allowing other work between steps, and bound busy retries and total wait time so ongoing writes cannot leave export waiting indefinitely.

Stream `word`, `romanization`, `frequency`, and `latest` from the completed snapshot into a fresh export database using one destination transaction and a reusable prepared insert statement. Use bound values and 64-bit integer APIs. Row streaming keeps memory usage bounded; the private snapshot avoids sharing transaction state with the live connection.

Check SQLite return values, distinguish end-of-query from read errors, roll back failed transactions, finalize statements, and close connections before publication. Produce a standalone database that requires no WAL or journal sidecars. Validate its schema, version, row count, and `PRAGMA integrity_check` before reporting it ready.

### 3. Select the destination and publish safely

Present an asynchronous `NSSavePanel` sheet attached to `SettingsWindow.shared`, with the suggested filename and a SQLite content type supporting `.sqlite3`.

Use the existing User Selected File Read/Write configuration for `InputMethod`, and verify `com.apple.security.app-sandbox` and `com.apple.security.files.user-selected.read-write` in the resulting signed product. Keep any required security-scoped access active through publication, releasing it afterward. This export does not require a persistent bookmark.

Build and validate the export in private temporary storage before modifying the selected destination. Use a Foundation replacement workflow that supports the selected file's sandbox authorization and preserves an existing destination if publication fails. Do not assume that selecting one file grants arbitrary access to sibling files; verify staging and replacement under the actual sandbox before finalizing this implementation.

Reject destinations referring to the live source database, including symlink or file-identity aliases, and protect its SQLite sidecars. Clean up private snapshots and temporary exports on success, failure, or cancellation. Success means the validated file has been published, not merely that SQLite insertion has completed.

### 4. Integrate preferences and feedback

Implement the existing Export button's TODO action in `InputMemorySettingsView`, reusing its label and `InputMemorySettingsView.ExportInputMemory.ButtonTitle` key. Keep Import as a separate, pending feature.

The operation follows this sequence:

```text
Select destination → Await readiness → Capture snapshot → Build and validate export → Publish → Report success
```

Treat save-panel cancellation as a normal exit. While export is active, disable duplicate exports and Clear, and show an indeterminate progress indicator tied to the real operation. Guard the Clear confirmation action as well so an already-presented dialog cannot clear memory during export. Coordinate with the existing `isPerformingClearInputMemory` state to prevent overlapping operations. The current Clear progress timer does not establish database readiness or export completion. Restore controls after every completion path. Once readiness completes, typing and learning remain available; the snapshot determines which committed entries are included.

Report successful export with the row count. Present actionable errors for preparation, SQLite, validation, and destination-write failures without exposing learned contents in diagnostic logs. Keep operation ownership explicit across sidebar navigation and preferences dismissal: `SettingsContentView` can replace `InputMemorySettingsView` while work is active. Either retain the operation outside the transient view or cancel and await cleanup when the view disappears; neither path should leave unmanaged work or temporary files.

Reuse the existing export string and add strings to `InputMethod/Localizable.xcstrings` for progress, success with row count, and errors, following the `InputMemorySettingsView` key prefix. The catalog currently declares `sourceLanguage: en`; preserve that configuration and existing translations. Follow the repository's localization rules: use Cantonese (`yue`) as the reference for `zh-*` values and Traditional Chinese for `zh-Hans` and `zh-Hans-CN`.

### 5. Validate and release

Use an unhosted test harness for the SQLite exporter and publication logic. The current `InputMethodTests` target uses `InputMethod` as its test host; do not launch it as part of these checks. The repository requires the input method to be archived and installed by the developer rather than run directly.

Automated coverage should verify:

- Exact preservation of Unicode words, tone digits, spacing, frequencies, and millisecond timestamps, including values beyond 32-bit range.
- Empty memory, schema version, uniqueness, row counts, integrity, and reopening the final file without sidecars.
- Readiness before typing and with learning disabled, concurrent readiness callers, migration in progress, and initialization or migration failure without advancing failed checkpoints or performing completion cleanup.
- Legacy-source selection, resumed frequency-band migration, and the existing migration ceiling of 100000; export itself must preserve every current `memory2608` row without that legacy frequency filter.
- A consistent snapshot during concurrent learning, plus bounded failure for an unavailable or persistently locked source.
- Cancellation, sidebar navigation or preferences dismissal, validation failure, destination-write failure, and replacement failure, preserving existing destination contents and cleaning temporary files.
- Rejection of the live source database and file-identity aliases.

Build the affected macOS target without running it:

```bash
xcodebuild -project Jyutping.xcodeproj -scheme InputMethod -configuration Debug -destination 'platform=macOS' -derivedDataPath /tmp/Jyutping-InputMethod-DerivedData CODE_SIGNING_ALLOWED=NO build
```

Reuse generated databases for source-only work, generating them first if absent. Run `git diff --check` for implementation changes. Compilation without signing does not verify sandbox permissions.

Separately verify the feature using the developer-installed, signed input method: preferences opened before typing, save-sheet focus and presentation, cancellation, overwrite confirmation, arbitrary user-selected locations, learning disabled, migration feedback, empty memory, and typing during export. Verify the signed entitlement and sandbox-safe publication on supported macOS versions, including the macOS 13 baseline. Report compilation, automated tests, and installed runtime checks separately.

## Completion criteria

- Export produces one portable version-1 `.sqlite3` file at the selected location.
- The file contains an exact, consistent snapshot of all four exported columns and works independently of the source database.
- Preparation, migration, and export failures are distinguishable from a valid empty memory.
- Typing remains responsive, repeated operations are controlled, and temporary resources are cleaned up.
- Existing destination files remain intact on failure, and the live memory database cannot be overwritten by export.
- File selection and publication work with the signed application's sandbox permissions.
- Automated checks and installed runtime validation substantiate these behaviors.
