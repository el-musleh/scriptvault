# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-05-21

### Added
- Added instructions for updating the globally installed npm package.
- Updated README to include an “Updating from npm” section.



### Added

- Initial release of `scriptvault`
- Interactive script launcher with menu (supports `fzf` fuzzy search and bash `select` fallback)
- Script vault organization with categories (one-level subdirectories)
- Runtime auto-detection: bash, python3, node, and direct executable support
- Script metadata convention (`# DESC:` on line 2)
- Full script lifecycle management:
  - `scriptvault list` — list all scripts grouped by category with descriptions
  - `scriptvault add <file> [category]` — add scripts to vault
  - `scriptvault new <name> [category]` — create new script from template
  - `scriptvault edit <name>` — edit existing script
  - `scriptvault remove <name>` — remove script with confirmation
- Interactive terminal launching via `gnome-terminal` (runs in caller's working directory)
- Config file support (`~/.config/scriptvault/config`) for custom vault location
- XDG-compliant default vault location (`~/.local/share/scriptvault/scripts/`)
- Install script (`install.sh`) with:
  - Automatic PATH configuration
  - Existing scripts detection and migration options
  - Example scripts installation
- Uninstall script (`uninstall.sh`) that preserves vault scripts
- Three example scripts (hello-world, git-clean, backup-home)
- Complete documentation (README.md)
- MIT License
- Added non‑interactive `--yes` flag to `install.sh` for fully automated installs.
- Installer now automatically adds `~/bin` to `$PATH` when run non‑interactively.
- New npm script `scriptvault` with a `postinstall` hook that runs the installer automatically.
- Updated README to reflect npm installation instructions.
