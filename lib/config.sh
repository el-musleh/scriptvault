#!/bin/bash
# Config loading and vault directory resolution

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/scriptvault/config"
DEFAULT_VAULT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/scriptvault/scripts"

load_config() {
  VAULT_DIR="$DEFAULT_VAULT_DIR"

  if [[ -f "$CONFIG_FILE" ]]; then
    # Parse key=value, skip comments and blank lines
    while IFS='=' read -r key value; do
      [[ "$key" =~ ^[[:space:]]*# ]] && continue
      [[ -z "$key" ]] && continue
      key="${key// /}"
      value="${value%"${value##*[![:space:]]}"}"  # rtrim
      case "$key" in
        VAULT_DIR) VAULT_DIR="$value" ;;
      esac
    done < "$CONFIG_FILE"
  fi

  # Expand ~ manually (config file values aren't expanded by shell)
  VAULT_DIR="${VAULT_DIR/#\~/$HOME}"

  export VAULT_DIR
}

ensure_vault_dir() {
  if [[ ! -d "$VAULT_DIR" ]]; then
    mkdir -p "$VAULT_DIR"
    echo "Created vault directory: $VAULT_DIR"
  fi
}
