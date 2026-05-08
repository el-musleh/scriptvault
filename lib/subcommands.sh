#!/bin/bash
# Implementations of: list, add, new, edit, remove

cmd_list() {
  local current_cat="" count=0

  while IFS=$'\t' read -r category name desc path; do
    if [[ "$category" != "$current_cat" ]]; then
      [[ -n "$current_cat" ]] && echo ""
      printf '\033[1;34m%s\033[0m\n' "── $category ──"
      current_cat="$category"
    fi
    if [[ -n "$desc" ]]; then
      printf '  %-30s %s\n' "$name" "$desc"
    else
      printf '  %s\n' "$name"
    fi
    (( count++ )) || true
  done < <(collect_scripts)

  echo ""
  echo "$count script(s) in vault: $VAULT_DIR"
}

cmd_add() {
  local src="${1:-}"
  local category="${2:-}"

  [[ -z "$src" ]] && { echo "Usage: scriptvault add <file> [category]" >&2; exit 1; }
  [[ -f "$src" ]] || { echo "File not found: $src" >&2; exit 1; }

  ensure_vault_dir

  local dest_dir="$VAULT_DIR"
  if [[ -n "$category" ]]; then
    dest_dir="$VAULT_DIR/$category"
    mkdir -p "$dest_dir"
  fi

  local basename
  basename="$(basename "$src")"
  local dest="$dest_dir/$basename"

  if [[ -e "$dest" ]]; then
    read -rp "File '$basename' already exists in vault. Overwrite? [y/N] " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }
  fi

  cp "$src" "$dest"
  chmod +x "$dest"
  echo "Added: $dest"
}

cmd_new() {
  local name="${1:-}"
  local category="${2:-}"

  [[ -z "$name" ]] && { echo "Usage: scriptvault new <name> [category]" >&2; exit 1; }

  ensure_vault_dir

  # Append .sh if no extension given
  [[ "$name" != *.* ]] && name="${name}.sh"

  local dest_dir="$VAULT_DIR"
  if [[ -n "$category" ]]; then
    dest_dir="$VAULT_DIR/$category"
    mkdir -p "$dest_dir"
  fi

  local dest="$dest_dir/$name"
  if [[ -e "$dest" ]]; then
    echo "Script already exists: $dest" >&2
    exit 1
  fi

  cat > "$dest" <<'TEMPLATE'
#!/bin/bash
# DESC:
set -euo pipefail

# Your script here

TEMPLATE

  chmod +x "$dest"
  echo "Created: $dest"

  local editor="${EDITOR:-nano}"
  "$editor" "$dest"
}

cmd_edit() {
  local name="${1:-}"
  [[ -z "$name" ]] && { echo "Usage: scriptvault edit <name>" >&2; exit 1; }

  # Search for script by name (with or without extension, any category)
  local found
  found=$(find "$VAULT_DIR" -maxdepth 2 -type f \( -name "$name" -o -name "${name}.sh" -o -name "${name}.py" \) | head -1)

  if [[ -z "$found" ]]; then
    echo "Script not found: $name" >&2
    echo "Use 'scriptvault list' to see available scripts." >&2
    exit 1
  fi

  local editor="${EDITOR:-nano}"
  "$editor" "$found"
}

cmd_remove() {
  local name="${1:-}"
  [[ -z "$name" ]] && { echo "Usage: scriptvault remove <name>" >&2; exit 1; }

  local found
  found=$(find "$VAULT_DIR" -maxdepth 2 -type f \( -name "$name" -o -name "${name}.sh" -o -name "${name}.py" \) | head -1)

  if [[ -z "$found" ]]; then
    echo "Script not found: $name" >&2
    exit 1
  fi

  read -rp "Remove '$found'? [y/N] " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    rm "$found"
    echo "Removed: $found"
    # Clean up empty category dirs
    local dir
    dir="$(dirname "$found")"
    if [[ "$dir" != "$VAULT_DIR" ]] && [[ -z "$(ls -A "$dir")" ]]; then
      rmdir "$dir"
      echo "Removed empty category: $(basename "$dir")"
    fi
  else
    echo "Aborted."
  fi
}
