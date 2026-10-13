# macOS Input Memory Export Roadmap

Status: approved implementation plan; feature implementation pending.

## Goal

Allow users to export the macOS input method's learned entries to one portable SQLite file at a user-selected location. The file must preserve a consistent snapshot of the stored words, romanizations, frequencies, and timestamps, and remain usable independently of the live memory database.

The first release covers export from `InputMethod`. Import and export from other platforms can follow using the same versioned format.

## Current integration points

- `InputMethod/Models/InputMemory.swift` manages `memory2608` in `URL.libraryDirectory.appending(path: "memory.sqlite3")` and migration from legacy tables.
- `InputMethod/Models/MemoryLexicon.swift` defines the stored values. `latest` is Unix time in milliseconds, and `frequency` and `latest` use `Int64`.
- `InputMethod/Preferences/GeneralSettingsView.swift` contains the input-memory toggle and Clear control.
- `SettingsWindow.shared` hosts preferences and can serve as the parent of the save sheet.
- `Jyutping.xcodeproj/project.xcproj` enables App Sandbox for `InputMethod`. User-selected file write access must be configured and verified in the signed product.

Memory preparation currently begins lazily when typing starts, and `InputMemory.prepare()` starts migration asynchronously. Opening preferences before typing must still allow a complete export.

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

Export must not read a partially migrated table or mistake a failed database open for an empty store. Retain the existing migration policy and normal learning behavior.

### 2. Build a testable SQLite exporter

Add `InputMethod/Models/InputMemoryExporter.swift`, accepting a source database URL and a private output URL, and returning the exported row count. Keep save-panel presentation, localized messages, and final publication outside this component.

Run SQLite work off the main actor with connections owned by the export operation. After readiness completes, open a separate source connection and use SQLite's backup API to create a private, consistent snapshot. Copy in bounded steps, allowing other work between steps, and bound busy retries and total wait time so ongoing writes cannot leave export waiting indefinitely.

Stream `word`, `romanization`, `frequency`, and `latest` from the completed snapshot into a fresh export database using one destination transaction and a reusable prepared insert statement. Use bound values and 64-bit integer APIs. Row streaming keeps memory usage bounded; the private snapshot avoids sharing transaction state with the live connection.

Check SQLite return values, distinguish end-of-query from read errors, roll back failed transactions, finalize statements, and close connections before publication. Produce a standalone database that requires no WAL or journal sidecars. Validate its schema, version, row count, and `PRAGMA integrity_check` before reporting it ready.

### 3. Select the destination and publish safely

Present an asynchronous `NSSavePanel` sheet attached to `SettingsWindow.shared`, with the suggested filename and a SQLite content type supporting `.sqlite3`.

Configure User Selected File access as Read/Write for `InputMethod`, and verify the resulting signed entitlement. Keep any required security-scoped access active through publication, releasing it afterward. This export does not require a persistent bookmark.

Build and validate the export in private temporary storage before modifying the selected destination. Use a Foundation replacement workflow that supports the selected file's sandbox authorization and preserves an existing destination if publication fails. Do not assume that selecting one file grants arbitrary access to sibling files; verify staging and replacement under the actual sandbox before finalizing this implementation.

Reject destinations referring to the live source database, including symlink or file-identity aliases, and protect its SQLite sidecars. Clean up private snapshots and temporary exports on success, failure, or cancellation. Success means the validated file has been published, not merely that SQLite insertion has completed.

### 4. Integrate preferences and feedback

Add an **Export…** button beside the existing input-memory controls in `GeneralSettingsView`.

The operation follows this sequence:

```text
Select destination → Await readiness → Capture snapshot → Build and validate export → Publish → Report success
```

Treat save-panel cancellation as a normal exit. While export is active, disable duplicate exports and Clear, and show an indeterminate progress indicator tied to the real operation. Restore controls after every completion path. Typing and learning remain available; the snapshot determines which committed entries are included.

Report successful export with the row count. Present actionable errors for preparation, SQLite, validation, and destination-write failures without exposing learned contents in diagnostic logs. Keep operation ownership explicit so dismissing preferences does not leave unmanaged work or temporary files.

Add strings to `InputMethod/Localizable.xcstrings` for export, progress, success, and errors. Follow the repository's localization rules, including Cantonese as the base and Traditional Chinese values for `zh-Hans` and `zh-Hans-CN`.

### 5. Validate and release

Use an unhosted test harness for the SQLite exporter and publication logic. The current `InputMethodTests` target uses `InputMethod` as its test host; do not launch it as part of these checks. The repository requires the input method to be archived and installed by the developer rather than run directly.

Automated coverage should verify:

- Exact preservation of Unicode words, tone digits, spacing, frequencies, and millisecond timestamps, including values beyond 32-bit range.
- Empty memory, schema version, uniqueness, row counts, integrity, and reopening the final file without sidecars.
- Readiness before typing, migration in progress, and initialization or migration failure.
- A consistent snapshot during concurrent learning, plus bounded failure for an unavailable or persistently locked source.
- Cancellation, validation failure, destination-write failure, and replacement failure, preserving existing destination contents and cleaning temporary files.
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
