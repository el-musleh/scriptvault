#!/bin/bash
# Detect the runner for a script based on shebang or extension

detect_runner() {
  local script="$1"
  local shebang runner ext

  # Read shebang line
  shebang=$(head -1 "$script" 2>/dev/null || true)

  case "$shebang" in
    "#!/usr/bin/env python3"*|"#!/usr/bin/python3"*)  echo "python3"; return ;;
    "#!/usr/bin/env python"*|"#!/usr/bin/python"*)    echo "python3"; return ;;
    "#!/usr/bin/env node"*|"#!/usr/bin/node"*)        echo "node"; return ;;
    "#!/bin/bash"*|"#!/usr/bin/bash"*|"#!/usr/bin/env bash"*) echo "bash"; return ;;
    "#!/bin/sh"*|"#!/usr/bin/sh"*)                   echo "sh"; return ;;
  esac

  # Fall back to extension
  ext="${script##*.}"
  case "$ext" in
    sh)  echo "bash"; return ;;
    py)  echo "python3"; return ;;
    js)  echo "node"; return ;;
  esac

  # Executable with no recognized type — run directly
  if [[ -x "$script" ]]; then
    echo "direct"; return
  fi

  echo "bash"  # safe default
}

read_description() {
  local script="$1"
  # Line 2 convention: # DESC: short description
  local line2
  line2=$(sed -n '2p' "$script" 2>/dev/null || true)
  if [[ "$line2" =~ ^#[[:space:]]*DESC:[[:space:]]*(.+) ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    echo ""
  fi
}
