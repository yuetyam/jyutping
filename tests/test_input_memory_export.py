#!/usr/bin/env python3
"""Run the real memory storage/export/import sources in an unhosted Swift Testing package.

Usage: python3 tests/test_input_memory_export.py
No InputMethodKit executable is launched and no user memory database is opened.
"""

import json
from pathlib import Path
import shutil
import subprocess
import tempfile


def main():
    root = Path(__file__).resolve().parent.parent
    with tempfile.TemporaryDirectory(prefix="Jyutping-MemoryTests-") as directory:
        package = Path(directory)
        sources = package / "Sources" / "InputMemoryExportSupport"
        sources.mkdir(parents=True)
        for name in ["MemoryLexicon", "InputMemoryPreparation", "InputMemoryExporter", "InputMemoryImporter"]:
            shutil.copy2(root / "InputMethod" / "InputMemory" / (name + ".swift"), sources)
        tests = package / "Tests" / "InputMemoryExportSupportTests"
        tests.mkdir(parents=True)
        for name in ["InputMemoryExportTests", "InputMemoryImportTests"]:
            shutil.copy2(root / "tests" / (name + ".swift"), tests)
        extensions = json.dumps(str(root / "Modules" / "CommonExtensions"))
        wrapper = json.dumps(str(root / "Modules" / "SQLiteWrapper"))
        (package / "Package.swift").write_text(f'''// swift-tools-version: 6.4
import PackageDescription
let package = Package(
        name: "InputMemoryExportSupport",
        platforms: [.macOS(.v13)],
        dependencies: [.package(path: {extensions}), .package(path: {wrapper})],
        targets: [
                .target(name: "InputMemoryExportSupport", dependencies: [.product(name: "CommonExtensions", package: "CommonExtensions"), .product(name: "SQLiteWrapper", package: "SQLiteWrapper")]),
                .testTarget(name: "InputMemoryExportSupportTests", dependencies: ["InputMemoryExportSupport", .product(name: "SQLiteWrapper", package: "SQLiteWrapper")])
        ],
        swiftLanguageModes: [.v6]
)
''')
        subprocess.run(["swift", "test", "--package-path", str(package), "--scratch-path", str(root / ".build" / "input-memory-export-tests")], check=True)


if __name__ == "__main__":
    main()
