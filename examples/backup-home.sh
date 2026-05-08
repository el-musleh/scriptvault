#!/bin/bash
# DESC: Create a timestamped tar.gz backup of a directory

set -euo pipefail

TARGET="${1:-$HOME}"
DEST="${2:-$HOME/backups}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE="$DEST/backup_$(basename "$TARGET")_$TIMESTAMP.tar.gz"

mkdir -p "$DEST"

echo "Backing up: $TARGET"
echo "Destination: $ARCHIVE"
echo ""

tar -czf "$ARCHIVE" --exclude="$DEST" "$TARGET"

SIZE="$(du -sh "$ARCHIVE" | cut -f1)"
echo "Done. Archive size: $SIZE"
