#!/usr/bin/env zsh
# Run the real memory storage/export/import sources in an unhosted Swift Testing package.
# Usage: zsh tests/test_input_memory_export.sh
# No InputMethodKit executable is launched and no user memory database is opened.

set -euo pipefail

root=${0:A:h:h}
package=$(mktemp -d "${TMPDIR:-/tmp}/Jyutping-MemoryTests-XXXXXXXX")
trap 'rm -rf -- "$package"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

sources="$package/Sources/InputMemoryExportSupport"
mkdir -p "$sources"
for name in MemoryLexicon InputMemoryPreparation InputMemoryExporter InputMemoryImporter; do
    cp -p "$root/InputMethod/InputMemory/$name.swift" "$sources/"
done

tests="$package/Tests/InputMemoryExportSupportTests"
mkdir -p "$tests"
for name in InputMemoryExportTests InputMemoryImportTests; do
    cp -p "$root/tests/$name.swift" "$tests/"
done

# Escape the repository path for Swift string literals in the generated manifest.
swift_root=${root//\\/\\\\}
swift_root=${swift_root//\"/\\\"}
swift_root=${swift_root//$'\n'/\\n}
swift_root=${swift_root//$'\r'/\\r}
swift_root=${swift_root//$'\t'/\\t}

cat > "$package/Package.swift" <<EOF
// swift-tools-version: 6.4
import PackageDescription
let package = Package(
        name: "InputMemoryExportSupport",
        platforms: [.macOS(.v14)],
        dependencies: [.package(path: "$swift_root/Modules/CommonExtensions"), .package(path: "$swift_root/Modules/SQLiteWrapper")],
        targets: [
                .target(name: "InputMemoryExportSupport", dependencies: [.product(name: "CommonExtensions", package: "CommonExtensions"), .product(name: "SQLiteWrapper", package: "SQLiteWrapper")]),
                .testTarget(name: "InputMemoryExportSupportTests", dependencies: ["InputMemoryExportSupport", .product(name: "SQLiteWrapper", package: "SQLiteWrapper")])
        ],
        swiftLanguageModes: [.v6]
)
EOF

swift test --package-path "$package" --scratch-path "$root/.build/input-memory-export-tests"
