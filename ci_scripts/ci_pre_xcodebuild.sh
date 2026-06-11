#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

swift run --package-path "$REPO_ROOT/Modules/Preparing" -c release
