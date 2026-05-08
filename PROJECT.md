# scriptvault Project Documentation

## Overview

`scriptvault` is a **zero‑dependency Bash CLI tool** for managing and executing a personal collection of shell scripts. It provides:

- An **interactive menu** that lists existing scripts (organized by category) and launches a chosen script in a new `gnome-terminal` window while preserving the caller's working directory.
- **Script metadata** using a `# DESC:` comment on line 2 that is shown in menus and when listing.
- **Convenient sub‑commands** (`add`, `new`, `edit`, `remove`, `list`) to keep your vault organized.
- A **portable installation** via `install.sh` that copies binaries, sets path, offers migration from common script directories and installs example scripts.
- A simple, **XDG‑compliant vault** located at `~/.local/share/scriptvault/scripts/` – the default is automatically created.
- A **visual terminal** experience: the script is launched in a fresh window, and the window stays open until you press **Enter**.


## Architecture

```
scriptvault/
├── bin/scriptvault               # dispatcher entry point
├── lib/                          # modular logic
│   ├── config.sh                # load config, credentials
│   ├── runtime.sh               # discover herbang, describe
│   ├── menu.sh                  # interactive menu, fzf/SELECT
│   └── subcommands.sh           # list, add, new, edit, remove
├── examples/                     # curated demo scripts
├── install.sh                    # copy libraries, patch binary, install in $PATH
├── uninstall.sh                  # remove executables, libs, config
├── README.md                     # project overview & usage
├── CHANGELOG.md                  # release history (Keep a Changelog)
├── CONTRIBUTING.md               # contribution workflow
├── CODE_OF_CONDUCT.md             # community standards
├── LICENSE                        # MIT
├── SECURITY.md                    # how to report vulnerabilities
├── .gitignore                     # simple ignore patterns
└── .github/                       # issue templates, PR template, CI
    ├── ISSUE_TEMPLATE/
    │   ├── bug_report.md
    │   └── feature_request.md
    ├── pull_request_template.md
    └── workflows/
        └── shellcheck.yml
```

All scripts source the library modules at runtime, so the package can be updated by simply overwriting the `bin/scriptvault` binary and the `lib/` files.

## Usage

```bash
# Interactive launcher (default) – shows menu
scriptvault

# List all scripts grouped by category
scriptvault list

# Add an existing script file to the vault
scriptvault add /path/to/myscript.sh [category]

# Create a brand‑new script from template
scriptvault new myscript [category]

# Edit an existing script in $EDITOR
scriptvault edit myscript

# Remove a script from the vault
scriptvault remove myscript

# Get help
scriptvault --help
scriptvault --version
```

### Example
When run from any directory, `scriptvault` opens a menu (fzf or simple SELECT). Selecting `backup-home.sh` opens `gnome-terminal`, runs the script, displays output, and keeps the window open until you press **Enter**.

## Installation

```bash
git clone https://github.com/el-musleh/scriptvault
cd scriptvault
bash install.sh   # copies to ~/bin, configures $PATH, migrates scripts
```

The installer automatically generates a demo vault if none exists, and offers migration from the existing `~/dev/agents/scripts` directory.

## Contributing

See the [CONTRIBUTING.md](CONTRIBUTING.md) file for details on how to contribute. We welcome issue reports, feature requests, pull requests, and documentation improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Additional Resources

- **Issue Templates** – Bug reports and feature requests are formatted using GitHub issue templates.
- **Pull Request Template** – Every PR should include a checklist: style, docs, tests, `CHANGELOG.md` update, etc.
- **Continuous Integration** – GitHub Actions run `shellcheck` on all Bash scripts to enforce code quality.
