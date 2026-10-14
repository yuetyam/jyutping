#!/usr/bin/env python3
"""Run the real memory storage/export sources in an unhosted Swift Testing package.

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
        for name in ["MemorySQLite", "MemoryLexicon", "InputMemoryPreparation", "InputMemoryExporter"]:
            shutil.copy2(root / "InputMethod" / "InputMemory" / (name + ".swift"), sources)
        tests = package / "Tests" / "InputMemoryExportSupportTests"
        tests.mkdir(parents=True)
        shutil.copy2(root / "tests" / "InputMemoryExportTests.swift", tests)
        dependency = json.dumps(str(root / "Modules" / "CommonExtensions"))
        (package / "Package.swift").write_text(f'''// swift-tools-version: 6.4
import PackageDescription
let package = Package(
        name: "InputMemoryExportSupport",
        platforms: [.macOS(.v13)],
        dependencies: [.package(path: {dependency})],
        targets: [
                .target(name: "InputMemoryExportSupport", dependencies: [.product(name: "CommonExtensions", package: "CommonExtensions")]),
                .testTarget(name: "InputMemoryExportSupportTests", dependencies: ["InputMemoryExportSupport"])
        ],
        swiftLanguageModes: [.v6]
)
''')
        subprocess.run(["swift", "test", "--package-path", str(package), "--scratch-path", str(root / ".build" / "input-memory-export-tests")], check=True)


if __name__ == "__main__":
    main()
