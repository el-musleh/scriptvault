#!/bin/bash
# DESC: Show git status and remove untracked files (with confirmation)

set -euo pipefail

if ! git rev-parse --git-dir &>/dev/null; then
  echo "Not inside a git repository: $PWD"
  exit 1
fi

echo "=== Untracked files ==="
git status --short

echo ""
read -rp "Remove all untracked files and directories? [y/N] " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  git clean -fd
  echo "Done."
else
  echo "Aborted."
fi
