# Contributing to scriptvault

Thank you for your interest in contributing to `scriptvault`! This document provides guidelines and instructions for contributing.

## Getting Started

1. **Fork** the repository on GitHub
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/scriptvault
   cd scriptvault
   ```
3. **Test locally** before submitting changes:
   ```bash
   bash install.sh     # Install locally
   scriptvault --help  # Verify installation
   ```

## Adding Example Scripts

Example scripts are stored in `examples/`. When adding a new example:

1. Follow the **DESC convention**: Add a description on line 2
   ```bash
   #!/bin/bash
   # DESC: Brief description of what this script does
   set -euo pipefail

   # Your script...
   ```

2. Start with a proper shebang (`#!/bin/bash`)

3. Include `set -euo pipefail` for safety

4. Keep examples simple and focused on a single task

## Code Style

All shell scripts follow these conventions:

- **Shebang**: Always use `#!/bin/bash` (not `sh`)
- **Error handling**: Always use `set -euo pipefail` at the top of scripts
- **Variables**: Use lowercase for local variables, UPPERCASE for constants
- **Quoting**: Always quote variables: `"$VAR"` not `$VAR`
- **Comments**: Use `#` for inline comments; avoid obvious comments
- **Functions**: Use descriptive names in snake_case
- **Line length**: Keep lines under 100 characters where practical

Example:
```bash
#!/bin/bash
# DESC: Example script following style guidelines
set -euo pipefail

MY_CONSTANT="fixed_value"

my_function() {
  local my_var="$1"
  echo "Processing: $my_var"
}

my_function "input"
```

## Submitting Changes

### Before you start

- Check [open issues](https://github.com/el-musleh/scriptvault/issues) — your idea might already be discussed
- For large changes, open a discussion issue first

### Process

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make your changes** — keep commits atomic and clear

3. **Test your changes**:
   ```bash
   # Lint all bash scripts
   shellcheck bin/scriptvault lib/*.sh examples/*.sh

   # Manual testing
   bash uninstall.sh
   bash install.sh
   scriptvault list
   ```

4. **Update documentation** if your change affects user-facing behavior:
   - Update `README.md` if needed
   - Add entry to `CHANGELOG.md` under unreleased section

5. **Push to your fork**:
   ```bash
   git push origin feature/my-feature
   ```

6. **Open a Pull Request** on GitHub with:
   - Clear title describing the change
   - Description of the problem/feature
   - Any relevant issue numbers (e.g., "Fixes #123")
   - Test results

### PR Checklist

Before submitting, ensure:

- [ ] Code runs without errors (`shellcheck` passes)
- [ ] Changes follow code style guidelines
- [ ] README or docs are updated (if applicable)
- [ ] Example scripts have `# DESC:` comments (if added)
- [ ] Commits have clear messages
- [ ] No unrelated changes in the PR

## Running Tests

### ShellCheck

All bash scripts are linted with `shellcheck`:

```bash
shellcheck bin/scriptvault lib/*.sh examples/*.sh
```

### Manual Testing

1. **Install from your branch**:
   ```bash
   bash install.sh
   source ~/.bashrc
   ```

2. **Test basic commands**:
   ```bash
   scriptvault --version      # Should print 0.1.0
   scriptvault --help         # Should show usage
   scriptvault list           # Should list scripts
   ```

3. **Test interactively**:
   ```bash
   scriptvault                # Should show menu
   # Select a script, verify it launches in new terminal
   ```

4. **Test subcommands**:
   ```bash
   scriptvault add /tmp/test.sh demo
   scriptvault new test-new demo
   scriptvault edit test-new
   scriptvault remove test-new
   ```

## Reporting Bugs

Found a bug? Please use the [bug report template](https://github.com/el-musleh/scriptvault/issues/new?template=bug_report.md).

Include:
- What you were trying to do
- What happened (actual behavior)
- What you expected to happen
- Your environment (OS, bash version, terminal)
- Steps to reproduce

## Reporting Security Issues

**Do not** open a public issue for security vulnerabilities. Instead, email `mohammadmusleh3@gmail.com` with:

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

You will receive a response within 7 days.

## Questions?

Open a [discussion](https://github.com/el-musleh/scriptvault/discussions) or email the maintainer.

## Code of Conduct

This project adheres to the [Contributor Covenant](./CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

---

Thank you for contributing! 🙏
