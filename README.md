# README

# scriptvault

**scriptvault** is a zero‑dependency Bash CLI tool for managing a personal
collection of shell scripts. It lets you launch scripts interactively from
any directory, organize them into categories, and provides a small set of
commands to add, edit, and remove scripts.

## Features

- **Interactive launcher** – type `scriptvault` and choose from a menu
- **fzf fuzzy search** (falls back to bash `select`)
- **Site‑wide launch** – runs scripts in a new `gnome-terminal` window
  with the *currently working directory* as the cwd
- **Vault** – scripts live in `~/.local/share/scriptvault/scripts/`
  (XDG‑compliant); subdirectories are categories
- **Metadata** – add a `# DESC:` comment on line 2 of scripts; shown in menus
- **Script lifecycle** – `list`, `add`, `new`, `edit`, `remove`
- **Portable** – no extra dependencies apart from bash, gnome-terminal, and optional fzf
- **Install script** – `install.sh` copies to `~/bin` and handles config
- **Uninstall script** – `uninstall.sh` removes binary and libs but keeps your
  vault untouched
- **Example scripts** – `hello-world`, `git-clean`, `backup-home`
- **CI linting** – GitHub Actions run `shellcheck` on every push

## Installation

```bash
# Assuming you have git and bash
git clone https://github.com/el-musleh/scriptvault
cd scriptvault
bash install.sh
```

`install.sh` will:

1. Copy `lib/` to `~/.local/lib/scriptvault`
2. Rewrite the binary's `LIB_DIR` to that absolute path
3. Install the executable to `~/bin`
4. Offer to add `~/bin` to your `$PATH`
5. Detect existing scripts in common locations (`~/dev/agents/scripts`) and let you use them as your vault
6. Optionally copy example scripts into a fresh vault

After installation, reload your shell or `source ~/.bashrc` to add the new `scriptvault` command.

## Global Install via npm

You can also install the tool globally using npm:

```bash
npm i -g scriptvault
```

The post‑install hook runs `bash install.sh --yes`, so the tool is installed non‑interactively and automatically updates your `PATH`.

---
## Usage

```bash
# Interactive launcher (default)
scriptvault

# List all scripts grouped by category
scriptvault list

# Add a script from the filesystem
scriptvault add /path/to/myscript.sh [category]

# Create a new script from a template
scriptvault new myscript [category]

# Edit an existing script in $EDITOR
scriptvault edit myscript

# Remove a script
scriptvault remove myscript

# Show help / version
scriptvault --help
scriptvault --version
```

### Example

Running `scriptvault` from any directory will open a menu.
Pick `hello-world.sh`; a new *gnome-terminal* window opens with that script
executed in the current directory. After the script finishes, press **Enter** to close the window.

## Contributing

See the [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

[MIT License](LICENSE)

## Code of Conduct

All contributors are expected to follow the [Contributor Covenant](CODE_OF_CONDUCT.md).

## Security

See [SECURITY.md](SECURITY.md) for guidance.
