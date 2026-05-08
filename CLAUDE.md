# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**scriptvault** is a zero-dependency CLI tool for managing a personal collection of shell scripts. It provides an interactive launcher, script management commands (add, new, edit, remove, list), and automatic runtime detection for bash, python, node, and other executables.

The codebase is intentionally simple and uses only bash — no external dependencies beyond `gnome-terminal` and optionally `fzf`.

## Architecture

The project follows a modular design where the main entry point (`bin/scriptvault`) sources four library modules:

- **`lib/config.sh`** — Config loading and vault directory resolution (uses XDG directories)
- **`lib/runtime.sh`** — Script type detection from shebang or file extension; also reads script descriptions from line 2 (# DESC: convention)
- **`lib/menu.sh`** — Interactive menu system: collects all scripts, uses fzf for fuzzy selection (with bash select fallback), launches scripts in gnome-terminal
- **`lib/subcommands.sh`** — Command implementations: list, add, new, edit, remove

The entry point (`bin/scriptvault`) is a simple dispatcher that sources all modules and routes commands to the appropriate handler.

### Script Storage and Organization

Scripts live in a vault directory (default: `~/.local/share/scriptvault/scripts`) organized as:
- Top-level scripts appear under "General" category
- Subdirectories act as categories (one level deep)
- Scripts are discovered by extension (`.sh`, `.py`, `.js`) or executable bit

## Script Metadata

Scripts use a convention on line 2 for descriptions:
```bash
#!/bin/bash
# DESC: Brief description shown in menus
```

The `read_description()` function in `runtime.sh` extracts this for list and menu display.

## Development Commands

- **Test the tool in development:**
  ```bash
  bash bin/scriptvault --help
  bash bin/scriptvault list
  bash bin/scriptvault          # interactive menu (requires gnome-terminal)
  ```

- **Add/create/edit/remove scripts (dev):**
  ```bash
  bash bin/scriptvault add <file> [category]
  bash bin/scriptvault new <name> [category]
  bash bin/scriptvault edit <name>
  bash bin/scriptvault remove <name>
  ```

- **Test installation/uninstall:**
  ```bash
  bash install.sh      # installs to ~/bin and ~/.local/lib/scriptvault
  bash uninstall.sh    # removes installation (not vault scripts)
  ```

## Key Implementation Details

### Config Loading (`config.sh`)

The `load_config()` function:
- Parses `~/.config/scriptvault/config` as key=value pairs (line-by-line, skip comments)
- Defaults to XDG data directory if config not found
- Manually expands `~` in paths (shell expansion doesn't happen in config files)
- Exports `VAULT_DIR` for use by other modules

The installer writes VAULT_DIR to config based on user choices (point to existing scripts or create default).

### Runtime Detection (`runtime.sh`)

`detect_runner()` checks shebang first, then file extension, then executability:
- Python 2/3 → `python3`
- Node.js → `node`
- Various bash shebangs → `bash`
- Executable with no shebang → `direct` (run without interpreter)
- Unknown → defaults to `bash`

### Menu and Launching (`menu.sh`)

`collect_scripts()` emits tab-separated lines: `CATEGORY\tNAME\tDESC\tPATH`
- Uses null-separated find to handle filenames with spaces safely
- Finds top-level scripts and one level of subdirectories (categories)

`cmd_menu()` either uses fzf (if available) or bash select fallback for user interaction.

`launch_script()` invokes `gnome-terminal` with the detected runner and waits for user to press Enter before closing.

### Subcommands (`subcommands.sh`)

All edit/create commands append `.sh` extension if not provided (`new backup` → `backup.sh`).

`cmd_remove()` cleans up empty category directories after deletion.

## Installation & Distribution

The installer (`install.sh`) does:
1. Copy lib files to `~/.local/lib/scriptvault/` (absolute path)
2. Rewrite `LIB_DIR` in the binary to point to the install location (dev relative path → absolute)
3. Optionally add `~/bin` to PATH in `~/.bashrc`
4. Detect existing scripts at common locations and offer migration options
5. Optionally install example scripts into a new vault

The uninstaller removes binary, libraries, and config — but **preserves vault scripts**.

## Testing and Quality

All source files use `set -euo pipefail` for strict bash error handling. 

When modifying code:
- Preserve the separation of concerns between modules (config, runtime, menu, subcommands)
- Use `shellcheck` (or equivalent) to catch bash style issues
- Maintain null-separated find usage for safe filename handling
- When adding new features that affect multiple modules, update the relevant library in isolation, then test via the dispatcher

## Important Notes

- The tool relies on `gnome-terminal` for interactive launching — this is Linux-specific and doesn't currently support macOS
- The menu uses fzf by default (better UX) but falls back to bash select if not installed
- Config and vault paths follow XDG Base Directory Specification for portability
- The codebase is intentionally simple — avoid adding external dependencies or complex abstractions
