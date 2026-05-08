#!/bin/bash
set -euo pipefail

INSTALL_BIN="${HOME}/bin"
INSTALL_LIB="${HOME}/.local/lib/scriptvault"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/scriptvault"

echo "=== scriptvault uninstaller ==="
echo ""
echo "This will remove:"
echo "  $INSTALL_BIN/scriptvault"
echo "  $INSTALL_LIB/"
echo "  $CONFIG_DIR/ (config only, NOT your vault scripts)"
echo ""
read -rp "Proceed? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

rm -f "$INSTALL_BIN/scriptvault"
[[ -d "$INSTALL_LIB" ]] && rm -rf "$INSTALL_LIB"
[[ -d "$CONFIG_DIR" ]] && rm -rf "$CONFIG_DIR"

# Remove PATH line from .bashrc if installer added it
if grep -q "# Added by scriptvault installer" "$HOME/.bashrc" 2>/dev/null; then
  # Remove the comment line and the export line after it
  sed -i '/# Added by scriptvault installer/{N;d}' "$HOME/.bashrc"
  echo "Removed PATH entry from ~/.bashrc"
fi

echo ""
echo "scriptvault removed. Your vault scripts were not touched."
echo "To also remove vault scripts, delete:"
VAULT_LINE=$(grep 'VAULT_DIR' "$HOME/.config/scriptvault/config" 2>/dev/null || echo "~/.local/share/scriptvault/scripts")
echo "  $VAULT_LINE"
