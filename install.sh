#!/bin/bash
# scriptvault installer
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
VERSION="0.1.0"
INSTALL_BIN="${HOME}/bin"
INSTALL_LIB="${HOME}/.local/lib/scriptvault"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/scriptvault"
DEFAULT_VAULT="${XDG_DATA_HOME:-$HOME/.local/share}/scriptvault/scripts"

echo "=== scriptvault $VERSION installer ==="
echo ""

# 1. Determine install location
echo "Install binary to: $INSTALL_BIN/scriptvault"
echo "Install lib to:    $INSTALL_LIB/"
read -rp "Proceed? [Y/n] " confirm
[[ "$confirm" =~ ^[Nn]$ ]] && { echo "Aborted."; exit 0; }

# 2. Create directories
mkdir -p "$INSTALL_BIN"
mkdir -p "$INSTALL_LIB"
mkdir -p "$CONFIG_DIR"

# 3. Copy lib files
cp -r "$SCRIPT_DIR/lib/"* "$INSTALL_LIB/"

# 4. Install main binary, rewriting LIB_DIR to absolute install path
sed "s|LIB_DIR=\"\$SCRIPT_DIR/../lib\"|LIB_DIR=\"$INSTALL_LIB\"|" \
  "$SCRIPT_DIR/bin/scriptvault" > "$INSTALL_BIN/scriptvault"
chmod +x "$INSTALL_BIN/scriptvault"
echo "Installed: $INSTALL_BIN/scriptvault"

# 5. Check PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_BIN"; then
  echo ""
  echo "WARNING: $INSTALL_BIN is not in your PATH."
  read -rp "Add it to ~/.bashrc? [Y/n] " add_path
  if [[ ! "$add_path" =~ ^[Nn]$ ]]; then
    echo "" >> "$HOME/.bashrc"
    echo "# Added by scriptvault installer" >> "$HOME/.bashrc"
    echo "export PATH=\"$INSTALL_BIN:\$PATH\"" >> "$HOME/.bashrc"
    echo "Added to ~/.bashrc. Run: source ~/.bashrc"
  fi
fi

# 6. Detect existing scripts at common locations
DETECTED_SCRIPTS=""
for candidate in \
  "$HOME/dev/agents/scripts" \
  "$HOME/scripts" \
  "$HOME/bin/scripts" \
  "$HOME/dev/scripts"
do
  if [[ -d "$candidate" ]] && [[ -n "$(ls -A "$candidate" 2>/dev/null)" ]]; then
    DETECTED_SCRIPTS="$candidate"
    break
  fi
done

echo ""
if [[ -n "$DETECTED_SCRIPTS" ]]; then
  echo "Detected existing scripts at: $DETECTED_SCRIPTS"
  echo "Options:"
  echo "  1) Use $DETECTED_SCRIPTS as vault (sets VAULT_DIR in config)"
  echo "  2) Copy scripts into default vault: $DEFAULT_VAULT"
  echo "  3) Use default vault (no migration)"
  read -rp "Choice [1/2/3]: " migration_choice
  case "$migration_choice" in
    1)
      mkdir -p "$CONFIG_DIR"
      echo "VAULT_DIR=$DETECTED_SCRIPTS" > "$CONFIG_DIR/config"
      echo "Config written: VAULT_DIR=$DETECTED_SCRIPTS"
      ;;
    2)
      mkdir -p "$DEFAULT_VAULT"
      cp -n "$DETECTED_SCRIPTS"/*.sh "$DEFAULT_VAULT/" 2>/dev/null || true
      cp -n "$DETECTED_SCRIPTS"/*.py "$DEFAULT_VAULT/" 2>/dev/null || true
      echo "Scripts copied to: $DEFAULT_VAULT"
      echo "VAULT_DIR=$DEFAULT_VAULT" > "$CONFIG_DIR/config"
      ;;
    *)
      mkdir -p "$DEFAULT_VAULT"
      echo "VAULT_DIR=$DEFAULT_VAULT" > "$CONFIG_DIR/config"
      echo "Using default vault: $DEFAULT_VAULT"
      ;;
  esac
else
  mkdir -p "$DEFAULT_VAULT"
  echo "VAULT_DIR=$DEFAULT_VAULT" > "$CONFIG_DIR/config"
  echo "Created vault directory: $DEFAULT_VAULT"
fi

# 7. Install example scripts if vault is new/empty
VAULT_DIR_FINAL=$(grep 'VAULT_DIR' "$CONFIG_DIR/config" | cut -d= -f2)
VAULT_DIR_FINAL="${VAULT_DIR_FINAL/#\~/$HOME}"
if [[ -z "$(ls -A "$VAULT_DIR_FINAL" 2>/dev/null)" ]]; then
  read -rp "Install example scripts into vault? [Y/n] " install_examples
  if [[ ! "$install_examples" =~ ^[Nn]$ ]]; then
    cp -r "$SCRIPT_DIR/examples/"* "$VAULT_DIR_FINAL/"
    chmod +x "$VAULT_DIR_FINAL/"*.sh 2>/dev/null || true
    echo "Example scripts installed."
  fi
fi

echo ""
echo "=== Installation complete ==="
echo "Run 'scriptvault --help' to get started."
