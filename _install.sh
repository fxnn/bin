#!/bin/bash
#
# This script installs .sh scripts from this repository into $HOME/bin.

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/bin"

echo "Installing scripts to $TARGET_DIR..."

mkdir -p "$TARGET_DIR"

for SCRIPT_PATH in "$SOURCE_DIR"/*.sh; do
    [ -e "$SCRIPT_PATH" ] || continue # Handle case with no .sh files

    SCRIPT_NAME="$(basename "$SCRIPT_PATH")"

    if [[ "$SCRIPT_NAME" == _* ]]; then
        echo "Skipping: $SCRIPT_NAME"
        continue
    fi

    TARGET_PATH="$TARGET_DIR/$SCRIPT_NAME"

    if [ -e "$TARGET_PATH" ]; then
        echo "Skipping, already exists: $TARGET_PATH"
    else
        echo "Installing: $SCRIPT_NAME"
        ln -s "$SCRIPT_PATH" "$TARGET_PATH"
    fi
done

echo "Done."
