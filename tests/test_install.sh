#!/usr/bin/env bash
# Test the non‑interactive installer
set -euo pipefail

# Create a temporary home directory
TMPHOME=$(mktemp -d)
export HOME=$TMPHOME

# Run install with --yes
bash "$SCRIPT_DIR"/install.sh --yes

# Verify script exists
[ -x "$HOME/bin/scriptvault" ] || { echo 'scriptvault binary missing'; exit 1; }
# Verify lib directory
[ -d "$HOME/.local/lib/scriptvault" ] || { echo 'lib dir missing'; exit 1; }
# Verify config
[ -f "$HOME/.config/scriptvault/config" ] && grep -q '^VAULT_DIR=' "$HOME/.config/scriptvault/config" || { echo 'config missing'; exit 1; }
# Verify PATH added to .bashrc
[ -f "$HOME/.bashrc" ] && grep -q "$HOME/bin" "$HOME/.bashrc" || { echo 'PATH not added'; exit 1; }

# Cleanup
rm -rf "$TMPHOME"

echo 'Installation test passed.'
