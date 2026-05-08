#!/bin/bash
# Interactive menu: fzf if available, bash select fallback

# Scan vault and emit lines: "CATEGORY\tNAME\tDESC\tFULL_PATH"
collect_scripts() {
  local vault="$VAULT_DIR"
  [[ -d "$vault" ]] || { echo "Vault directory not found: $vault" >&2; exit 1; }

  # Top-level scripts (uncategorized → "General")
  while IFS= read -r -d '' script; do
    local name desc
    name="$(basename "$script")"
    desc="$(read_description "$script")"
    printf 'General\t%s\t%s\t%s\n' "$name" "$desc" "$script"
  done < <(find "$vault" -maxdepth 1 -type f \( -name "*.sh" -o -name "*.py" -o -name "*.js" -o -perm /111 \) -print0 | sort -z)

  # One level of subdirectories (categories)
  while IFS= read -r -d '' dir; do
    local category
    category="$(basename "$dir")"
    while IFS= read -r -d '' script; do
      local name desc
      name="$(basename "$script")"
      desc="$(read_description "$script")"
      printf '%s\t%s\t%s\t%s\n' "$category" "$name" "$desc" "$script"
    done < <(find "$dir" -maxdepth 1 -type f \( -name "*.sh" -o -name "*.py" -o -name "*.js" -o -perm /111 \) -print0 | sort -z)
  done < <(find "$vault" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
}

launch_script() {
  local script_path="$1"
  local cwd="$2"
  local runner

  runner="$(detect_runner "$script_path")"

  local run_cmd
  if [[ "$runner" == "direct" ]]; then
    run_cmd="\"$script_path\""
  else
    run_cmd="$runner \"$script_path\""
  fi

  /usr/bin/gnome-terminal \
    --working-directory="$cwd" \
    -- bash -c "$run_cmd; echo; echo '--- Done. Press Enter to close ---'; read"
}

cmd_menu() {
  local cwd="$PWD"
  local -a scripts=()
  local -a labels=()

  # Read all scripts into arrays
  while IFS=$'\t' read -r category name desc path; do
    scripts+=("$path")
    if [[ -n "$desc" ]]; then
      labels+=("[$category] $name — $desc")
    else
      labels+=("[$category] $name")
    fi
  done < <(collect_scripts)

  if [[ ${#scripts[@]} -eq 0 ]]; then
    echo "No scripts found in vault: $VAULT_DIR"
    echo "Use 'scriptvault add <file>' or 'scriptvault new <name>' to add scripts."
    exit 0
  fi

  local chosen_label chosen_index chosen_path

  if command -v fzf &>/dev/null; then
    # fzf path: print labels, capture selection
    chosen_label=$(printf '%s\n' "${labels[@]}" | fzf --prompt="Select script > " --height=40% --border --ansi)
    [[ -z "$chosen_label" ]] && exit 0  # user cancelled

    # Find index by matching label
    for i in "${!labels[@]}"; do
      if [[ "${labels[$i]}" == "$chosen_label" ]]; then
        chosen_index=$i
        break
      fi
    done
  else
    # bash select fallback
    echo "Select a script to run:"
    select chosen_label in "${labels[@]}" "Cancel"; do
      if [[ "$chosen_label" == "Cancel" || -z "$chosen_label" ]]; then
        exit 0
      fi
      for i in "${!labels[@]}"; do
        if [[ "${labels[$i]}" == "$chosen_label" ]]; then
          chosen_index=$i
          break
        fi
      done
      break
    done
  fi

  chosen_path="${scripts[$chosen_index]}"
  echo "Launching: $(basename "$chosen_path")"
  launch_script "$chosen_path" "$cwd"
}
