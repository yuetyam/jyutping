# CoreIME

`CoreIME` is the shared input engine used by the Jyutping iOS keyboard and macOS input method. It turns keyboard input into Cantonese lexicon results, supports full-keyboard and nine-key segmentation, provides several reverse-lookup modes, and converts engine results into display-ready candidates.

The package includes a generated, read-only SQLite database containing the Cantonese lexicon, syllable tables, reverse-lookup data, emoji and symbols, text marks, and character-variant mappings.

## Requirements

- Swift tools 6.3 or newer
- Swift 6 language mode
- iOS 17 or newer
- macOS 14 or newer

`CoreIME` is a local package in the Jyutping workspace and depends on the sibling [`CommonExtensions`](../CommonExtensions) package.

## Package Products

- `CoreIME`: the input-engine library
- `CoreIMEBenchmarks`: a command-line benchmark runner for representative engine workloads

The application targets consume the library directly:

- [`Keyboard`](../../Keyboard) uses it for the iOS and iPadOS keyboard extension.
- [`InputMethod`](../../InputMethod) uses it for the macOS input method.

## Getting Started

Call `Engine.prepare()` once during application startup before using segmentation, lookup, conversion, emoji, or text-mark APIs. It opens the packaged database and prepares the in-memory syllable data used by the segmenters.

### Jyutping Suggestions

```swift
import CoreIME

Engine.prepare()

let keys = "neihou".compactMap(VirtualInputKey.matchInputKey(for:))
let segmentation = Segmenter.segment(keys)
let lexicons = Engine.suggest(keys, segmentation: segmentation)
let candidates = lexicons.transformed(
        commentForm: .full,
        charset: .hongkong
)
```

`VirtualInputKey` represents letters, digits, apostrophes, and the grave key using stable internal and hardware key codes. `Segmenter` resolves the input into possible Jyutping syllable schemes, and `Engine.suggest` queries and ranks matching `Lexicon` values.

Set `deepSearch` to `false` when the caller wants to limit prefix and fallback searches:

```swift
let lexicons = Engine.suggest(
        keys,
        segmentation: segmentation,
        deepSearch: false
)
```

### Nine-Key Suggestions

Nine-key input uses `Combo` values for the T9-style digit groups and has a dedicated segmenter and engine:

```swift
let combos = [6, 4, 6].compactMap(Combo.init(rawValue:))
let segmentation = NineKeySegmenter.segment(combos)
let lexicons = await NineKeyEngine.suggest(
        combos: combos,
        segmentation: segmentation
)
```

Nine-key lookup preserves ambiguous digit-to-letter mappings and falls back to serial Jyutping spelling for irregular syllables.

### Pinyin Reverse Lookup

Pinyin reverse lookup returns Cantonese entries for Mandarin Pinyin input:

```swift
let keys = "xianshi".compactMap(VirtualInputKey.matchInputKey(for:))
let segmentation = PinyinSegmenter.segment(keys)
let lexicons = await Engine.pinyinReverseLookup(
        keys,
        segmentation: segmentation
)
```

Use `PinyinNineKeySegmenter.segment(_:)` with `Engine.pinyinNineKeyReverseLookup(combos:segmentation:)` for nine-key Pinyin. Apostrophes can select explicit syllable boundaries, such as `xi'an'shi`.

## Engine Pipeline

The primary suggestion flow has four stages:

1. Convert platform key events into `VirtualInputKey` or `Combo` values.
2. Produce possible syllable schemes with the matching segmenter.
3. Query `Engine` or `NineKeyEngine` for ranked `Lexicon` values.
4. Merge engine results with learned, user-defined, text-mark, and symbol entries through `Converter`, producing display-ready `Candidate` values.

`Lexicon` is the engine-level result model. It retains the candidate text, Jyutping romanization, consumed input, segmentation mark, rank, and candidate type. `Candidate` is the presentation model and applies the selected romanization form and character standard.

The main dispatch API is:

```swift
let candidates = Converter.dispatch(
        memory: learnedLexicons,
        defined: userDefinedLexicons,
        texts: plainTexts,
        symbols: symbols,
        queried: engineLexicons,
        commentForm: .full,
        charset: .preset
)
```

Learned candidate persistence is intentionally owned by the platform targets rather than this package. The keyboard and macOS input method provide their own `InputMemory` implementations and pass the resulting lexicons into `Converter`.

## Features

### Segmentation

- `Segmenter`: full-keyboard Jyutping segmentation, including aliases, prefixes, separators, tone input, and ambiguous key sets
- `NineKeySegmenter`: nine-key Jyutping segmentation with digit collisions and serial spelling metadata
- `PinyinSegmenter`: full-keyboard Pinyin segmentation
- `PinyinNineKeySegmenter`: nine-key Pinyin segmentation

Segmentation results are ordered by covered input length and then syllable count. The engine uses all applicable schemes when looking up exact, anchor, prefix, and partial matches.

### Reverse Lookup

`Engine` exposes specialized APIs that return Cantonese readings from other input systems:

- `pinyinReverseLookup(_:segmentation:)` and `pinyinNineKeyReverseLookup(combos:segmentation:)`
- `cangjieReverseLookup(keys:variant:)` for Cangjie 3, Cangjie 5, Quick 3, and Quick 5
- `strokeReverseLookup(_:)` for stroke input and wildcards
- `structureReverseLookup(_:segmentation:)` for character-component lookup

The reverse-lookup results are ordinary `Lexicon` values and can be transformed or merged through the same candidate pipeline as Jyutping suggestions.

### Text Marks, Emoji, and Symbols

The database-backed supplementary APIs include:

- `Engine.searchPlainTexts(for:)` and `Engine.queryPlainTexts(for:)`
- `Engine.searchSymbols(for:segmentation:)` and `Engine.nineKeySearchSymbols(combos:segmentation:)`
- `Engine.fetchEmojiSequence(category:)`
- `Engine.fetchDefaultFrequentEmojis()`

These results can be passed to `Converter.dispatch` alongside queried and learned lexicons.

### Character Standards

`Converter` supports the character standards defined by `CharacterStandard`, including preset Traditional Chinese, inherited forms, Hong Kong and Taiwan standards, PRC standard forms, and Simplified Chinese. Use either `Converter.convert(_:to:)` for text or `[Lexicon].transformed(commentForm:charset:)` for candidate sequences.

## Source Layout

```text
CoreIME/
├── Package.swift
├── README.md
├── Sources/
│   ├── CoreIME/
│   │   ├── Engine.swift
│   │   ├── Segmenter.swift
│   │   ├── NineKeyEngine.swift
│   │   ├── NineKeySegmenter.swift
│   │   ├── Pinyin*.swift
│   │   ├── Cangjie*.swift
│   │   ├── Stroke*.swift
│   │   ├── Structure.swift
│   │   └── Converter*.swift
│   ├── CoreIMEMobileData/Resources/mobile.sqlite3
│   ├── CoreIMEDesktopData/Resources/desktop.sqlite3
│   └── CoreIMEBenchmarks/
└── Tests/CoreIMETests/
```

Key areas:

- [`Engine.swift`](Sources/CoreIME/Engine.swift) contains database initialization and the primary suggestion flow.
- [`Segmenter.swift`](Sources/CoreIME/Segmenter.swift) and [`NineKeySegmenter.swift`](Sources/CoreIME/NineKeySegmenter.swift) implement Jyutping segmentation.
- [`Pinyin.swift`](Sources/CoreIME/Pinyin.swift) and the Pinyin segmenters implement Pinyin reverse lookup.
- [`Cangjie.swift`](Sources/CoreIME/Cangjie.swift), [`Stroke.swift`](Sources/CoreIME/Stroke.swift), and [`Structure.swift`](Sources/CoreIME/Structure.swift) implement shape and component lookup.
- [`Lexicon.swift`](Sources/CoreIME/Lexicon.swift), [`Candidate.swift`](Sources/CoreIME/Candidate.swift), and [`Converter.swift`](Sources/CoreIME/Converter.swift) define and assemble candidate results.
- [`Emoji.swift`](Sources/CoreIME/Emoji.swift) and [`TextMark.swift`](Sources/CoreIME/TextMark.swift) query supplementary candidate data.

## Generated Database

[`mobile.sqlite3`](Sources/CoreIMEMobileData/Resources/mobile.sqlite3) and [`desktop.sqlite3`](Sources/CoreIMEDesktopData/Resources/desktop.sqlite3) are generated by the workspace's [`Preparing`](../Preparing) package. Do not edit the databases directly. The mobile database contains the complete schema; the desktop database is copied from it and stripped of 9-key-specific tables, columns, and indexes.

From the repository root, regenerate packaged databases with:

```sh
swift run -c release --package-path Modules/Preparing
```

This command regenerates both CoreIME databases and the AppDataSource database. Changes to lexicon data, database tables, character mappings, syllable tables, emoji, symbols, or text marks should be made in `Modules/Preparing` or its resources and followed by regeneration.

## Testing

The test target uses Swift Testing and is organized into source-aligned suites under [`Tests/CoreIMETests`](Tests/CoreIMETests).

Run the package tests from the repository root:

```sh
swift test --package-path Modules/CoreIME
```

Run the same suite with source coverage enabled:

```sh
swift test --package-path Modules/CoreIME --enable-code-coverage
```

When changing engine behavior, add or update the focused suite for that source area. Database-backed engine tests use the complete packaged `mobile.sqlite3` resource, and schema tests verify both database variants.

## Benchmarks

The dependency-free `CoreIMEBenchmarks` executable measures representative segmentation and database-backed lookup paths. Always use an optimized build; debug timings are not meaningful for performance comparisons.

From the repository root, run all benchmarks with:

```sh
swift run -c release --package-path Modules/CoreIME CoreIMEBenchmarks
```

The runner performs warmup iterations and then reports the median and 95th-percentile elapsed time for each workload. A checksum consumes each result so the measured operations remain observable to the optimizer.

Available workloads cover:

- ambiguous full-keyboard Jyutping segmentation
- ambiguous Jyutping key-set segmentation
- nine-key Jyutping segmentation
- full-keyboard and nine-key Pinyin segmentation
- full, partial, and repeated-syllable Jyutping suggestions
- nine-key Jyutping suggestions
- full-keyboard and nine-key Pinyin reverse lookup

List the exact benchmark names without running them:

```sh
swift run -c release --package-path Modules/CoreIME CoreIMEBenchmarks --list
```

Run a subset by case-insensitive name filter:

```sh
swift run -c release --package-path Modules/CoreIME CoreIMEBenchmarks \
        --filter segmentation
```

Configure measured and warmup iteration counts:

```sh
swift run -c release --package-path Modules/CoreIME CoreIMEBenchmarks \
        --iterations 100 \
        --warmup 10
```

Benchmark results are intended for comparing CoreIME changes on the same machine and software environment. They are not stable performance requirements across different hardware, operating systems, or Swift toolchains.

## License

CoreIME is distributed as part of the Jyutping project. See the repository's [`COPYING.txt`](../../COPYING.txt) for license terms.
